/// Reference implementation for Firebase Auth — **not active** while
/// [EcosystemAuthConfig.useFirebaseAuth] is `false`.
///
/// To enable, uncomment the sections below and add to `pubspec.yaml`:
/// ```yaml
/// firebase_auth: ^6.1.0
/// ```
abstract final class FirebaseEcosystemAuthService {
  FirebaseEcosystemAuthService._();

  // ---------------------------------------------------------------------------
  // FIREBASE AUTH — uncomment this entire block when enabling production auth
  // ---------------------------------------------------------------------------
  //
  // import 'package:cloud_firestore/cloud_firestore.dart';
  // import 'package:firebase_auth/firebase_auth.dart';
  // import 'package:athletes_application/data/sync/firebase_bootstrap.dart';
  // import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';
  //
  // static FirebaseAuth get _auth => FirebaseAuth.instance;
  // static FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  //
  // static Future<void> ensureInitialized() => FirebaseBootstrap.ensureInitialized();
  //
  // /// Restores session from Firebase user + Firestore profile doc.
  // static Future<EcosystemSession?> restoreSession() async {
  //   await ensureInitialized();
  //   final user = _auth.currentUser;
  //   if (user == null) return null;
  //   return _sessionFromFirestore(user);
  // }
  //
  // static Future<EcosystemSession> signInWithEmailAndPassword({
  //   required String email,
  //   required String password,
  // }) async {
  //   await ensureInitialized();
  //   final credential = await _auth.signInWithEmailAndPassword(
  //     email: email.trim(),
  //     password: password,
  //   );
  //   final user = credential.user;
  //   if (user == null) throw FirebaseAuthException(code: 'user-null');
  //   return _sessionFromFirestore(user);
  // }
  //
  // static Future<EcosystemSession> registerWithEmailAndPassword({
  //   required String email,
  //   required String password,
  //   required String displayName,
  // }) async {
  //   await ensureInitialized();
  //   final credential = await _auth.createUserWithEmailAndPassword(
  //     email: email.trim(),
  //     password: password,
  //   );
  //   final user = credential.user!;
  //   await user.updateDisplayName(displayName);
  //   await _firestore.collection('users').doc(user.uid).set({
  //     'email': email.trim().toLowerCase(),
  //     'displayName': displayName,
  //     'onboardingComplete': false,
  //     'createdAt': FieldValue.serverTimestamp(),
  //   });
  //   return EcosystemSession(
  //     userId: user.uid,
  //     email: user.email ?? email,
  //     displayName: displayName,
  //     onboardingComplete: false,
  //   );
  // }
  //
  // static Future<EcosystemSession> saveOnboarding({
  //   required EcosystemSession session,
  //   required StakeholderKind kind,
  //     String? organizationName,
  // }) async {
  //   await ensureInitialized();
  //   await _firestore.collection('users').doc(session.userId).set({
  //     'stakeholderKind': kind.name,
  //     'organizationName': organizationName,
  //     'onboardingComplete': true,
  //     'updatedAt': FieldValue.serverTimestamp(),
  //   }, SetOptions(merge: true));
  //   return session.copyWith(
  //     stakeholderKind: kind,
  //     organizationName: organizationName ?? session.organizationName,
  //     onboardingComplete: true,
  //   );
  // }
  //
  // static Future<void> signOut() async {
  //   await ensureInitialized();
  //   await _auth.signOut();
  // }
  //
  // static Future<EcosystemSession> _sessionFromFirestore(User user) async {
  //   final doc = await _firestore.collection('users').doc(user.uid).get();
  //   final data = doc.data() ?? {};
  //   final kindName = data['stakeholderKind'] as String?;
  //   return EcosystemSession(
  //     userId: user.uid,
  //     email: user.email ?? '',
  //     displayName: user.displayName ?? data['displayName'] as String? ?? 'User',
  //     stakeholderKind: kindName == null
  //         ? null
  //         : StakeholderKind.values.byName(kindName),
  //     organizationName: data['organizationName'] as String?,
  //     onboardingComplete: data['onboardingComplete'] as bool? ?? false,
  //   );
  // }
  // ---------------------------------------------------------------------------
}
