import 'package:athletes_application/data/sources/passport_local_data_source.dart';
import 'package:athletes_application/models/athlete_models.dart';

/// Legacy facade — prefer [PassportSyncRepository] for cloud sync.
class AthletePassportRepository {
  AthletePassportRepository({PassportLocalDataSource? local})
      : _local = local ?? PassportLocalDataSource();

  final PassportLocalDataSource _local;

  Future<AthletePassportData> loadData() => _local.loadData();

  Future<void> saveData(AthletePassportData data) =>
      _local.saveData(data, DateTime.now());

  Future<AccessRole> loadViewRole() => _local.loadViewRole();

  Future<void> saveViewRole(AccessRole role) => _local.saveViewRole(role);

  Future<bool> loadIsProfilePublic() => _local.loadIsProfilePublic();

  Future<void> saveIsProfilePublic(bool value) => _local.saveIsProfilePublic(value);
}
