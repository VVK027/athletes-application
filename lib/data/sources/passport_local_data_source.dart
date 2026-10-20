import 'package:athletes_application/data/athlete_passport_serializer.dart';
import 'package:athletes_application/data/mock_athlete_data.dart';
import 'package:athletes_application/models/athlete_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassportLocalDataSource {
  PassportLocalDataSource({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;

  static const _dataKey = 'athlete_passport_data_v1';
  static const _roleKey = 'athlete_passport_view_role';
  static const _publicKey = 'athlete_passport_is_public';
  static const _updatedAtKey = 'athlete_passport_updated_at';
  static const _lastSyncedKey = 'athlete_passport_last_synced_at';
  static const _pendingPushKey = 'athlete_passport_pending_push';

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<AthletePassportData> loadData() async {
    await init();
    final raw = _prefs!.getString(_dataKey);
    if (raw == null) {
      await saveData(mockAthletePassport, DateTime.now());
      return mockAthletePassport;
    }
    return AthletePassportSerializer.decode(raw);
  }

  Future<void> saveData(AthletePassportData data, DateTime updatedAt) async {
    await init();
    await _prefs!.setString(_dataKey, AthletePassportSerializer.encode(data));
    await _prefs!.setString(_updatedAtKey, updatedAt.toUtc().toIso8601String());
  }

  Future<DateTime?> loadUpdatedAt() async {
    await init();
    final raw = _prefs!.getString(_updatedAtKey);
    return raw == null ? null : DateTime.parse(raw);
  }

  Future<AccessRole> loadViewRole() async {
    await init();
    final name = _prefs!.getString(_roleKey);
    if (name == null) return AccessRole.athlete;
    return AccessRole.values.byName(name);
  }

  Future<void> saveViewRole(AccessRole role) async {
    await init();
    await _prefs!.setString(_roleKey, role.name);
  }

  Future<bool> loadIsProfilePublic() async {
    await init();
    return _prefs!.getBool(_publicKey) ?? true;
  }

  Future<void> saveIsProfilePublic(bool value) async {
    await init();
    await _prefs!.setBool(_publicKey, value);
  }

  Future<DateTime?> loadLastSyncedAt() async {
    await init();
    final raw = _prefs!.getString(_lastSyncedKey);
    return raw == null ? null : DateTime.parse(raw);
  }

  Future<void> saveLastSyncedAt(DateTime at) async {
    await init();
    await _prefs!.setString(_lastSyncedKey, at.toUtc().toIso8601String());
  }

  Future<bool> loadPendingPush() async {
    await init();
    return _prefs!.getBool(_pendingPushKey) ?? false;
  }

  Future<void> savePendingPush(bool value) async {
    await init();
    await _prefs!.setBool(_pendingPushKey, value);
  }
}
