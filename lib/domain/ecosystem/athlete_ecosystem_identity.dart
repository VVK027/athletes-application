import 'package:athletes_application/domain/ecosystem/international_context.dart';
import 'package:athletes_application/domain/ecosystem/sport_code.dart';

/// Athlete-centric identity spanning sports, regions, and the global network.
class AthleteEcosystemIdentity {
  const AthleteEcosystemIdentity({
    required this.athleteId,
    required this.displayName,
    required this.primarySport,
    required this.passportId,
    required this.publicSlug,
    required this.international,
    this.secondarySports = const [],
    this.seekingOpportunities = false,
  });

  final String athleteId;
  final String displayName;
  final SportCode primarySport;
  final List<SportCode> secondarySports;
  final String passportId;
  final String publicSlug;
  final InternationalContext international;
  final bool seekingOpportunities;

  List<SportCode> get allSports => [primarySport, ...secondarySports];
}
