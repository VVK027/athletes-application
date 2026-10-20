import 'package:flutter/material.dart';
import 'package:athletes_application/features/auth/ecosystem_root.dart';

// FIREBASE AUTH — uncomment when enabling Firebase (see ecosystem_auth_config.dart):
// import 'package:athletes_application/data/sync/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FIREBASE AUTH — uncomment after `flutterfire configure`:
  // await FirebaseBootstrap.ensureInitialized();

  runApp(const EcosystemRoot());
}
