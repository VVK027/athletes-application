import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:athletes_application/core/config/sync_config.dart';
import 'package:athletes_application/data/mock_athlete_data.dart';
import 'package:athletes_application/data/remote/passport_api_remote_data_source.dart';
import 'package:athletes_application/data/remote/passport_firebase_remote_data_source.dart';
import 'package:athletes_application/data/remote/passport_remote_data_source.dart';
import 'package:athletes_application/data/sources/passport_local_data_source.dart';
import 'package:athletes_application/data/sync/firebase_bootstrap.dart';
import 'package:athletes_application/data/sync/passport_sync_envelope.dart';
import 'package:athletes_application/data/sync/sync_status.dart';
import 'package:athletes_application/models/athlete_models.dart';

class PassportLoadResult {
  const PassportLoadResult({
    required this.data,
    required this.viewRole,
    required this.isProfilePublic,
    required this.syncStatus,
  });

  final AthletePassportData data;
  final AccessRole viewRole;
  final bool isProfilePublic;
  final PassportSyncStatus syncStatus;
}

class PassportSyncRepository {
  PassportSyncRepository({
    required PassportLocalDataSource local,
    PassportRemoteDataSource? remote,
    Connectivity? connectivity,
    Future<bool> Function()? isOnline,
    String backendLabel = 'Local',
  })  : _local = local,
        _remote = remote,
        _isOnline = isOnline ?? _defaultOnlineChecker(connectivity ?? Connectivity()),
        _backendLabel = backendLabel;

  static Future<bool> Function() _defaultOnlineChecker(Connectivity connectivity) {
    return () async {
      final result = await connectivity.checkConnectivity();
      return !result.contains(ConnectivityResult.none);
    };
  }

  static Future<PassportSyncRepository> create({
    PassportLocalDataSource? local,
    PassportRemoteDataSource? remote,
    SyncBackend? backend,
  }) async {
    final mode = backend ?? SyncConfig.backend;
    final localSource = local ?? PassportLocalDataSource();

    switch (mode) {
      case SyncBackend.local:
        return PassportSyncRepository(
          local: localSource,
          backendLabel: 'Local only',
        );
      case SyncBackend.api:
        return PassportSyncRepository(
          local: localSource,
          remote: remote ?? PassportApiRemoteDataSource(),
          backendLabel: 'REST API',
        );
      case SyncBackend.firebase:
        await FirebaseBootstrap.ensureInitialized();
        return PassportSyncRepository(
          local: localSource,
          remote: remote ?? PassportFirebaseRemoteDataSource(),
          backendLabel: 'Firebase',
        );
    }
  }

  /// Local-only repository for widget tests.
  factory PassportSyncRepository.localOnly({PassportLocalDataSource? local}) {
    return PassportSyncRepository(
      local: local ?? PassportLocalDataSource(),
      backendLabel: 'Test',
    );
  }

  final PassportLocalDataSource _local;
  final PassportRemoteDataSource? _remote;
  final Future<bool> Function() _isOnline;
  final String _backendLabel;

  PassportSyncStatus _status = const PassportSyncStatus();

  PassportSyncStatus get status => _status;


  Future<PassportLoadResult> loadAll() async {
    var data = await _local.loadData();
    var isPublic = await _local.loadIsProfilePublic();
    final role = await _local.loadViewRole();
    final lastSynced = await _local.loadLastSyncedAt();
    final pending = await _local.loadPendingPush();
    final online = await _isOnline();

    _status = PassportSyncStatus(
      backendLabel: _backendLabel,
      lastSyncedAt: lastSynced,
      pendingPush: pending,
      state: online ? SyncState.idle : SyncState.offline,
    );

    final remote = _remote;
    if (remote != null && online) {
      try {
        final pulled = await remote.fetch(data.profile.id);
        final localUpdated = await _local.loadUpdatedAt() ?? DateTime.fromMillisecondsSinceEpoch(0);

        if (pulled != null && pulled.updatedAt.isAfter(localUpdated)) {
          data = pulled.data;
          isPublic = pulled.isProfilePublic;
          await _local.saveData(data, pulled.updatedAt);
          await _local.saveIsProfilePublic(isPublic);
          await _local.saveLastSyncedAt(DateTime.now());
          await _local.savePendingPush(false);
          _status = _status.copyWith(
            state: SyncState.synced,
            lastSyncedAt: DateTime.now(),
            pendingPush: false,
            message: 'Pulled from cloud',
          );
        }
      } catch (e) {
        _status = _status.copyWith(
          state: SyncState.error,
          message: 'Pull failed: $e',
        );
      }
    }

    return PassportLoadResult(
      data: data,
      viewRole: role,
      isProfilePublic: isPublic,
      syncStatus: _status,
    );
  }

  Future<void> savePassport(AthletePassportData data, {required bool isProfilePublic}) async {
    final updatedAt = DateTime.now();
    await _local.saveData(data, updatedAt);
    await _local.saveIsProfilePublic(isProfilePublic);
    await _local.savePendingPush(true);
    _status = _status.copyWith(pendingPush: true, state: SyncState.idle);

    if (await _tryPush(data, isProfilePublic, updatedAt)) {
      await _local.savePendingPush(false);
      await _local.saveLastSyncedAt(DateTime.now());
      _status = _status.copyWith(
        pendingPush: false,
        state: SyncState.synced,
        lastSyncedAt: DateTime.now(),
        message: 'Saved to cloud',
      );
    }
  }

  Future<void> saveViewRole(AccessRole role) => _local.saveViewRole(role);

  Future<void> saveIsProfilePublic(bool value) async {
    await _local.saveIsProfilePublic(value);
    final data = await _local.loadData();
    final updatedAt = DateTime.now();
    await _local.saveData(data, updatedAt);
    await _local.savePendingPush(true);
    await _tryPush(data, value, updatedAt);
  }

  Future<PassportSyncStatus> syncNow() async {
    final online = await _isOnline();
    if (!online) {
      _status = _status.copyWith(
        state: SyncState.offline,
        message: 'No network connection',
      );
      return _status;
    }

    final remote = _remote;
    if (remote == null) {
      _status = _status.copyWith(state: SyncState.idle, message: 'Local only');
      return _status;
    }

    _status = _status.copyWith(state: SyncState.syncing, message: 'Syncing…');
    final data = await _local.loadData();
    final isPublic = await _local.loadIsProfilePublic();
    final athleteId = data.profile.id;

    try {
      final remoteEnvelope = await remote.fetch(athleteId);
      final localUpdated = await _local.loadUpdatedAt() ?? DateTime.fromMillisecondsSinceEpoch(0);
      var merged = data;
      var mergedPublic = isPublic;
      var mergedUpdated = localUpdated;

      if (remoteEnvelope != null && remoteEnvelope.updatedAt.isAfter(localUpdated)) {
        merged = remoteEnvelope.data;
        mergedPublic = remoteEnvelope.isProfilePublic;
        mergedUpdated = remoteEnvelope.updatedAt;
      } else {
        final pending = await _local.loadPendingPush();
        if (pending || remoteEnvelope == null) {
          mergedUpdated = DateTime.now();
          final envelope = PassportSyncEnvelope(
            athleteId: athleteId,
            data: data,
            isProfilePublic: isPublic,
            updatedAt: mergedUpdated,
          );
          await remote.push(envelope);
        }
      }

      await _local.saveData(merged, mergedUpdated);
      await _local.saveIsProfilePublic(mergedPublic);
      await _local.savePendingPush(false);
      await _local.saveLastSyncedAt(DateTime.now());

      _status = PassportSyncStatus(
        state: SyncState.synced,
        lastSyncedAt: DateTime.now(),
        pendingPush: false,
        backendLabel: _backendLabel,
        message: 'Sync complete',
      );
    } catch (e) {
      _status = _status.copyWith(
        state: SyncState.error,
        message: 'Sync failed: $e',
      );
    }

    return _status;
  }

  Future<bool> _tryPush(
    AthletePassportData data,
    bool isProfilePublic,
    DateTime updatedAt,
  ) async {
    final remote = _remote;
    if (remote == null || !await _isOnline()) return false;

    try {
      await remote.push(
        PassportSyncEnvelope(
          athleteId: data.profile.id,
          data: data,
          isProfilePublic: isProfilePublic,
          updatedAt: updatedAt,
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> seedIfEmpty() async {
    final data = await _local.loadData();
    if (data.profile.id == mockAthletePassport.profile.id) {
      final updated = await _local.loadUpdatedAt();
      if (updated == null) {
        await _local.saveData(mockAthletePassport, DateTime.now());
      }
    }
  }
}
