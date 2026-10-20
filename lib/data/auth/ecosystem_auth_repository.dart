import 'package:athletes_application/core/config/ecosystem_auth_config.dart';
import 'package:athletes_application/data/auth/ecosystem_auth_local_data_source.dart';
// FIREBASE AUTH — uncomment when enabling Firebase:
// import 'package:athletes_application/data/auth/firebase_ecosystem_auth_service.dart';
import 'package:athletes_application/domain/ecosystem/ecosystem_session.dart';
import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';
import 'package:uuid/uuid.dart';

class EcosystemAuthRepository {
  EcosystemAuthRepository({EcosystemAuthLocalDataSource? local})
      : _local = local ?? EcosystemAuthLocalDataSource();

  final EcosystemAuthLocalDataSource _local;
  final _uuid = const Uuid();

  Future<EcosystemSession?> currentSession() async {
    // FIREBASE AUTH — uncomment when EcosystemAuthConfig.useFirebaseAuth is true:
    // if (EcosystemAuthConfig.useFirebaseAuth) {
    //   final firebaseSession = await FirebaseEcosystemAuthService.restoreSession();
    //   if (firebaseSession != null) {
    //     await _local.saveSession(firebaseSession);
    //     return firebaseSession;
    //   }
    // }
    return _local.loadSession();
  }

  /// Primary sign-in entry — uses demo auth while Firebase is disabled.
  Future<EcosystemSession> signIn({
    required String email,
    required String password,
  }) async {
    // FIREBASE AUTH — uncomment when EcosystemAuthConfig.useFirebaseAuth is true:
    // if (EcosystemAuthConfig.useFirebaseAuth) {
    //   final session = await FirebaseEcosystemAuthService.signInWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );
    //   await _local.saveSession(session);
    //   return session;
    // }
    return signInWithDemo(email: email, password: password);
  }

  Future<EcosystemSession> signInWithDemo({
    required String email,
    required String password,
  }) async {
    if (!EcosystemAuthConfig.useDemoAuth) {
      throw AuthException('Demo auth is disabled');
    }

    final account = DemoAccounts.match(email, password);
    if (account == null) {
      throw AuthException('Invalid email or password');
    }

    final session = EcosystemSession(
      userId: _uuid.v4(),
      email: account.email,
      displayName: account.displayName,
      stakeholderKind: account.suggestedStakeholder,
      organizationName: account.organizationName,
      onboardingComplete: false,
    );
    await _local.saveSession(session);
    return session;
  }

  Future<EcosystemSession> completeOnboarding({
    required EcosystemSession session,
    required StakeholderKind kind,
    String? organizationName,
  }) async {
    // FIREBASE AUTH — uncomment when EcosystemAuthConfig.useFirebaseAuth is true:
    // if (EcosystemAuthConfig.useFirebaseAuth) {
    //   final updated = await FirebaseEcosystemAuthService.saveOnboarding(
    //     session: session,
    //     kind: kind,
    //     organizationName: organizationName,
    //   );
    //   await _local.saveSession(updated);
    //   return updated;
    // }

    final updated = session.copyWith(
      stakeholderKind: kind,
      organizationName: organizationName ?? session.organizationName,
      onboardingComplete: true,
    );
    await _local.saveSession(updated);
    return updated;
  }

  Future<void> signOut() async {
    // FIREBASE AUTH — uncomment when EcosystemAuthConfig.useFirebaseAuth is true:
    // if (EcosystemAuthConfig.useFirebaseAuth) {
    //   await FirebaseEcosystemAuthService.signOut();
    // }
    await _local.clearSession();
  }
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}
