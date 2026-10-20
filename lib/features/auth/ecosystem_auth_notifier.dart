import 'package:flutter/foundation.dart';
import 'package:athletes_application/data/auth/ecosystem_auth_repository.dart';
import 'package:athletes_application/domain/ecosystem/ecosystem_session.dart';
import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';

class EcosystemAuthNotifier extends ChangeNotifier {
  EcosystemAuthNotifier({EcosystemAuthRepository? repository})
      : _repository = repository ?? EcosystemAuthRepository();

  final EcosystemAuthRepository _repository;

  bool isLoading = true;
  EcosystemSession? session;
  String? error;

  Future<void> initialize() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      session = await _repository.currentSession();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    error = null;
    notifyListeners();
    try {
      session = await _repository.signIn(email: email, password: password);
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      error = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<void> completeOnboarding({
    required StakeholderKind kind,
    String? organizationName,
  }) async {
    final current = session;
    if (current == null) return;

    session = await _repository.completeOnboarding(
      session: current,
      kind: kind,
      organizationName: organizationName,
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    await _repository.signOut();
    session = null;
    notifyListeners();
  }
}
