import 'package:athletes_application/data/mock_verified_results.dart';
import 'package:athletes_application/domain/contracts/ecosystem_repositories.dart';

class MockVerifiedResultsRepository implements VerifiedResultsRepository {
  @override
  Future<List<VerifiedTournamentResult>> fetchForAthlete(String athleteId) async {
    return mockVerifiedResultsFor(athleteId);
  }
}
