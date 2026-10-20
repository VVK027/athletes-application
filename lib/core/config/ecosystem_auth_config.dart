/// Authentication mode for the  athletes ecosystem.
abstract final class EcosystemAuthConfig {
  /// Demo accounts (`*@*.demo` / password `demo`) — no Firebase Console setup required.
  static const useDemoAuth = true;

  /// Firebase Auth — **disabled**. Do not enable until you have run
  /// `flutterfire configure`, enabled Email/Password in Firebase Console, and
  /// uncommented the blocks marked `FIREBASE AUTH` in:
  ///
  /// - `lib/main.dart`
  /// - `lib/data/auth/ecosystem_auth_repository.dart`
  /// - `lib/data/auth/firebase_ecosystem_auth_service.dart`
  /// - `pubspec.yaml` (`firebase_auth` dependency)
  ///
  /// When enabling, set [useDemoAuth] to `false` and [useFirebaseAuth] to `true`.
  static const useFirebaseAuth = false;
}
