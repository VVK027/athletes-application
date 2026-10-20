import 'dart:convert';

import 'package:athletes_application/domain/ecosystem/ecosystem_session.dart';
import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcosystemAuthLocalDataSource {
  EcosystemAuthLocalDataSource({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;
  static const _sessionKey = 'ecosystem_session_v1';

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<EcosystemSession?> loadSession() async {
    await init();
    final raw = _prefs!.getString(_sessionKey);
    if (raw == null) return null;
    return _sessionFromMap(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveSession(EcosystemSession session) async {
    await init();
    await _prefs!.setString(_sessionKey, jsonEncode(_sessionToMap(session)));
  }

  Future<void> clearSession() async {
    await init();
    await _prefs!.remove(_sessionKey);
  }

  static Map<String, dynamic> _sessionToMap(EcosystemSession s) => {
        'userId': s.userId,
        'email': s.email,
        'displayName': s.displayName,
        'stakeholderKind': s.stakeholderKind?.name,
        'organizationName': s.organizationName,
        'onboardingComplete': s.onboardingComplete,
      };

  static EcosystemSession _sessionFromMap(Map<String, dynamic> m) => EcosystemSession(
        userId: m['userId'] as String,
        email: m['email'] as String,
        displayName: m['displayName'] as String,
        stakeholderKind: m['stakeholderKind'] == null
            ? null
            : StakeholderKind.values.byName(m['stakeholderKind'] as String),
        organizationName: m['organizationName'] as String?,
        onboardingComplete: m['onboardingComplete'] as bool? ?? false,
      );
}
