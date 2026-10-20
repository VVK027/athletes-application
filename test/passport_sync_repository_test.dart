import 'package:flutter_test/flutter_test.dart';
import 'package:athletes_application/data/mock_athlete_data.dart';
import 'package:athletes_application/data/remote/passport_remote_data_source.dart';
import 'package:athletes_application/data/sources/passport_local_data_source.dart';
import 'package:athletes_application/data/sync/passport_sync_envelope.dart';
import 'package:athletes_application/data/sync/passport_sync_repository.dart';
import 'package:athletes_application/data/sync/sync_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeRemote implements PassportRemoteDataSource {
  PassportSyncEnvelope? store;

  @override
  Future<PassportSyncEnvelope?> fetch(String athleteId) async => store;

  @override
  Future<void> push(PassportSyncEnvelope envelope) async {
    store = envelope;
  }

  @override
  Future<bool> isAvailable() async => true;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('pushes local changes to remote on save', () async {
    final local = PassportLocalDataSource();
    final remote = _FakeRemote();
    final repo = PassportSyncRepository(
      local: local,
      remote: remote,
      isOnline: () async => true,
      backendLabel: 'Test',
    );

    await local.saveData(mockAthletePassport, DateTime.now().subtract(const Duration(hours: 1)));
    await repo.savePassport(
      mockAthletePassport.copyWith(
        profile: mockAthletePassport.profile,
      ),
      isProfilePublic: false,
    );

    expect(remote.store, isNotNull);
    expect(remote.store!.isProfilePublic, isFalse);
    expect(await local.loadPendingPush(), isFalse);
  });

  test('pulls newer remote data on load', () async {
    final local = PassportLocalDataSource();
    final remote = _FakeRemote();
    final repo = PassportSyncRepository(
      local: local,
      remote: remote,
      isOnline: () async => true,
      backendLabel: 'Test',
    );

    await local.saveData(mockAthletePassport, DateTime(2020));

    remote.store = PassportSyncEnvelope(
      athleteId: mockAthletePassport.profile.id,
      data: mockAthletePassport,
      isProfilePublic: true,
      updatedAt: DateTime.now(),
    );

    final result = await repo.loadAll();
    expect(result.syncStatus.state, isNot(SyncState.error));
    expect(
      (await local.loadUpdatedAt())!.toUtc(),
      remote.store!.updatedAt.toUtc(),
    );
  });
}
