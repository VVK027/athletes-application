import 'package:flutter/foundation.dart';
import 'package:athletes_application/core/config/sync_config.dart';
import 'package:athletes_application/data/mock_family_pass_data.dart';
import 'package:athletes_application/data/repositories/mock_talent_discovery_repository.dart';
import 'package:athletes_application/data/repositories/mock_verified_results_repository.dart';
import 'package:athletes_application/data/sync/passport_sync_repository.dart';
import 'package:athletes_application/data/sync/sync_status.dart';
import 'package:athletes_application/domain/contracts/ecosystem_repositories.dart';
import 'package:athletes_application/domain/ecosystem/ecosystem_session.dart';
import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';
import 'package:athletes_application/features/athlete_passport/media/media_storage_service.dart';
import 'package:athletes_application/models/athlete_models.dart';

class PassportNotifier extends ChangeNotifier {
  PassportNotifier({
    PassportSyncRepository? syncRepository,
    MediaStorageService? mediaStorage,
    VerifiedResultsRepository? verifiedResults,
    TalentDiscoveryRepository? talentDiscovery,
    bool skipCloudSync = false,
  })  : _sync = syncRepository,
        _mediaStorage = mediaStorage ?? MediaStorageService(),
        _verifiedResults = verifiedResults ?? MockVerifiedResultsRepository(),
        _talentDiscovery = talentDiscovery ?? MockTalentDiscoveryRepository(),
        _skipCloudSync = skipCloudSync;

  PassportNotifier.preview(AthletePassportData seed)
      : _sync = PassportSyncRepository.localOnly(),
        _mediaStorage = MediaStorageService(),
        _verifiedResults = MockVerifiedResultsRepository(),
        _talentDiscovery = MockTalentDiscoveryRepository(),
        _skipCloudSync = true {
    data = seed;
    isLoading = false;
    syncStatus = const PassportSyncStatus(backendLabel: 'Preview');
    _bootstrapFamilyPass(seed.profile.id);
  }

  PassportSyncRepository? _sync;
  final MediaStorageService _mediaStorage;
  final VerifiedResultsRepository _verifiedResults;
  final TalentDiscoveryRepository _talentDiscovery;
  final bool _skipCloudSync;

  bool isLoading = true;
  bool isSyncing = false;
  AthletePassportData? data;
  AccessRole viewRole = AccessRole.athlete;
  bool isProfilePublic = true;
  PassportSyncStatus syncStatus = const PassportSyncStatus();
  String? error;
  FamilyPassAccount? familyPass;
  List<MarketplaceAthlete> marketplaceAthletes = mockSponsorMarketplace;
  String activeAthleteId = mockFamilyPass.activeAthleteId;
  List<VerifiedTournamentResult> verifiedResults = const [];
  List<TalentSearchHit> talentSearchResults = const [];
  bool isSearchingTalent = false;
  EcosystemSession? ecosystemSession;

  Future<void> initialize() async {
    if (_skipCloudSync && data != null) {
      isLoading = false;
      await _loadVerifiedResults();
      notifyListeners();
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _sync ??= await PassportSyncRepository.create(
        backend: _skipCloudSync ? SyncBackend.local : null,
      );
      await _mediaStorage.ensureReady();
      final result = await _sync!.loadAll();
      data = result.data;
      viewRole = result.viewRole;
      isProfilePublic = result.isProfilePublic;
      syncStatus = result.syncStatus;
      _bootstrapFamilyPass(result.data.profile.id);
      await _loadVerifiedResults();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> syncNow() async {
    final sync = _sync;
    if (sync == null || isSyncing) return;

    isSyncing = true;
    syncStatus = syncStatus.copyWith(state: SyncState.syncing);
    notifyListeners();

    try {
      syncStatus = await sync.syncNow();
      final reload = await sync.loadAll();
      data = reload.data;
      isProfilePublic = reload.isProfilePublic;
      syncStatus = reload.syncStatus;
    } catch (e) {
      syncStatus = syncStatus.copyWith(
        state: SyncState.error,
        message: e.toString(),
      );
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  void _bootstrapFamilyPass(String athleteId) {
    familyPass = mockFamilyPass;
    activeAthleteId = athleteId;
    familyPass = familyPass!.copyWith(activeAthleteId: athleteId);
  }

  void applyStakeholderSession(EcosystemSession session) {
    ecosystemSession = session;
    final role = session.stakeholderKind?.passportPreviewRole;
    if (role != null) {
      viewRole = role;
      _sync?.saveViewRole(role);
    }
    notifyListeners();
  }

  Future<void> _loadVerifiedResults() async {
    final id = data?.profile.id;
    if (id == null) return;
    verifiedResults = await _verifiedResults.fetchForAthlete(id);
    notifyListeners();
  }

  Future<void> searchTalent(TalentSearchCriteria criteria) async {
    isSearchingTalent = true;
    notifyListeners();
    try {
      talentSearchResults = await _talentDiscovery.search(criteria);
    } finally {
      isSearchingTalent = false;
      notifyListeners();
    }
  }

  Future<void> switchFamilyAthlete(String athleteId) async {
    if (familyPass == null) return;
    if (!familyPass!.athletes.any((a) => a.athleteId == athleteId)) return;

    activeAthleteId = athleteId;
    familyPass = familyPass!.copyWith(activeAthleteId: athleteId);
    data = passportForFamilyAthlete(athleteId);

    final sync = _sync;
    if (sync != null) {
      await sync.savePassport(data!, isProfilePublic: isProfilePublic);
      syncStatus = sync.status;
    }
    await _loadVerifiedResults();
    notifyListeners();
  }

  Future<void> setViewRole(AccessRole role) async {
    viewRole = role;
    await _sync?.saveViewRole(role);
    notifyListeners();
  }

  Future<void> setProfilePublic(bool value) async {
    isProfilePublic = value;
    final current = data;
    if (current != null) {
      await _sync?.saveIsProfilePublic(value);
      syncStatus = _sync?.status ?? syncStatus;
    }
    notifyListeners();
  }

  Future<void> _persistData() async {
    final current = data;
    final sync = _sync;
    if (current == null || sync == null) return;

    await sync.savePassport(current, isProfilePublic: isProfilePublic);
    syncStatus = sync.status;
    notifyListeners();
  }

  Future<void> addMediaFromPicker({
    required String title,
    required MediaType type,
    required String sourcePath,
    String? duration,
  }) async {
    final current = data;
    if (current == null) return;

    final localPath = await _mediaStorage.persistMedia(sourcePath, type);
    final item = MediaItem(
      id: _mediaStorage.newId(),
      title: title,
      type: type,
      date: DateTime.now(),
      duration: duration,
      localPath: localPath,
    );

    data = current.copyWith(media: [item, ...current.media]);
    await _persistData();
  }

  Future<void> removeMedia(String id) async {
    final current = data;
    if (current == null) return;

    final item = current.media.where((m) => m.id == id).firstOrNull;
    if (item?.localPath != null) {
      await _mediaStorage.deleteFile(item!.localPath!);
    }

    data = current.copyWith(
      media: current.media.where((m) => m.id != id).toList(),
    );
    await _persistData();
  }
}
