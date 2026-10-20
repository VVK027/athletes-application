/// Cloud sync configuration.
///
/// [SyncBackend.api] — REST API (default). Run the mock server:
/// `dart run tool/passport_api_server.dart`
///
/// [SyncBackend.firebase] — Firestore. Requires `flutterfire configure`
/// and valid `lib/firebase_options.dart`.
///
/// [SyncBackend.local] — Device storage only (no cloud).
enum SyncBackend { local, api, firebase }

abstract final class SyncConfig {
  /// Use [SyncBackend.local] for offline/dev without the mock API server.
  /// Use [SyncBackend.api] when `dart run tool/passport_api_server.dart` is running.
  static const SyncBackend backend = SyncBackend.local;

  /// REST base URL. Use `10.0.2.2` for Android emulator → host machine.
  static const String apiBaseUrl = 'http://127.0.0.1:8080';

  static const Duration httpTimeout = Duration(seconds: 8);

  /// Firestore collection for passport documents.
  static const String firestoreCollection = 'athlete_passports';
}
