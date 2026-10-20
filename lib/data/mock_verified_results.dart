import 'package:athletes_application/domain/contracts/ecosystem_repositories.dart';
import 'package:athletes_application/domain/ecosystem/sport_code.dart';

List<VerifiedTournamentResult> mockVerifiedResultsFor(String athleteId) {
  if (athleteId == 'ath_2847') {
    return [
      VerifiedTournamentResult(
        id: 'vr_1',
        eventName: 'Pacific Junior Open',
        placement: '2nd',
        verifiedBy: 'Pacific Junior Tour · Official Scorer',
        verifiedAt: DateTime(2026, 4, 13),
        sport: SportRegistry.golf,
        countryCode: 'US',
      ),
      VerifiedTournamentResult(
        id: 'vr_2',
        eventName: 'Winter Invitational',
        placement: '1st',
        verifiedBy: 'Arizona Junior Golf Federation',
        verifiedAt: DateTime(2025, 12, 3),
        sport: SportRegistry.golf,
        countryCode: 'US',
      ),
    ];
  }
  if (athleteId == 'ath_2848') {
    return [
      VerifiedTournamentResult(
        id: 'vr_leo_1',
        eventName: 'Rose City Open',
        placement: '1st',
        verifiedBy: 'USTA Pacific Northwest',
        verifiedAt: DateTime(2026, 5, 11),
        sport: SportRegistry.tennis,
        countryCode: 'US',
      ),
    ];
  }
  if (athleteId == 'ath_2849') {
    return [
      VerifiedTournamentResult(
        id: 'vr_ava_1',
        eventName: 'Spring Splash Meet',
        placement: '3rd',
        verifiedBy: 'USA Swimming · Meet Referee',
        verifiedAt: DateTime(2026, 4, 21),
        sport: SportRegistry.swimming,
        countryCode: 'US',
      ),
    ];
  }
  return const [];
}
