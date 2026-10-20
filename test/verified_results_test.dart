import 'package:flutter_test/flutter_test.dart';
import 'package:athletes_application/data/mock_athlete_data.dart';
import 'package:athletes_application/data/repositories/mock_verified_results_repository.dart';
import 'package:athletes_application/data/repositories/mock_talent_discovery_repository.dart';
import 'package:athletes_application/domain/contracts/ecosystem_repositories.dart';
import 'package:athletes_application/domain/ecosystem/sport_code.dart';

void main() {
  test('mock verified results for primary athlete', () async {
    final repo = MockVerifiedResultsRepository();
    final results = await repo.fetchForAthlete(mockAthletePassport.profile.id);
    expect(results, isNotEmpty);
    expect(results.first.verifiedBy, contains('Pacific'));
  });

  test('talent search filters by sport', () async {
    final repo = MockTalentDiscoveryRepository();
    final golf = await repo.search(TalentSearchCriteria(sport: SportRegistry.golf));
    final tennis = await repo.search(TalentSearchCriteria(sport: SportRegistry.tennis));
    expect(golf.every((h) => h.sport.id == 'golf'), isTrue);
    expect(tennis.every((h) => h.sport.id == 'tennis'), isTrue);
  });
}
