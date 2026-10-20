import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:athletes_application/core/config/sync_config.dart';
import 'package:athletes_application/data/remote/passport_remote_data_source.dart';
import 'package:athletes_application/data/sync/passport_sync_envelope.dart';

class PassportFirebaseRemoteDataSource implements PassportRemoteDataSource {
  PassportFirebaseRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(SyncConfig.firestoreCollection);

  DocumentReference<Map<String, dynamic>> _doc(String athleteId) =>
      _collection.doc(athleteId);

  @override
  Future<bool> isAvailable() async {
    try {
      await _collection.limit(1).get();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<PassportSyncEnvelope?> fetch(String athleteId) async {
    final snap = await _doc(athleteId).get();
    if (!snap.exists || snap.data() == null) return null;
    return PassportSyncEnvelope.fromJson(snap.data()!);
  }

  @override
  Future<void> push(PassportSyncEnvelope envelope) async {
    await _doc(envelope.athleteId).set(envelope.toJson(), SetOptions(merge: true));
  }
}
