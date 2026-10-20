import 'package:athletes_application/data/sync/passport_sync_envelope.dart';

abstract class PassportRemoteDataSource {
  Future<PassportSyncEnvelope?> fetch(String athleteId);

  Future<void> push(PassportSyncEnvelope envelope);

  Future<bool> isAvailable();
}
