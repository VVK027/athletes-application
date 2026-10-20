import 'package:firebase_core/firebase_core.dart';
import 'package:athletes_application/firebase_options.dart';

abstract final class FirebaseBootstrap {
  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    _initialized = true;
  }
}
