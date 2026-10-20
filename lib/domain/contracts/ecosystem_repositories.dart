import 'package:athletes_application/domain/ecosystem/sport_code.dart';

/// Verified result attested by a tournament, academy, or federation.
class VerifiedTournamentResult {
  const VerifiedTournamentResult({
    required this.id,
    required this.eventName,
    required this.placement,
    required this.verifiedBy,
    required this.verifiedAt,
    required this.sport,
    required this.countryCode,
  });

  final String id;
  final String eventName;
  final String placement;
  final String verifiedBy;
  final DateTime verifiedAt;
  final SportCode sport;
  final String countryCode;
}

class OfficialRanking {
  const OfficialRanking({
    required this.system,
    required this.value,
    required this.asOf,
    required this.sport,
  });

  final String system;
  final String value;
  final DateTime asOf;
  final SportCode sport;
}

class CoachReport {
  const CoachReport({
    required this.id,
    required this.coachName,
    required this.sessionDate,
    required this.summary,
    required this.focusAreas,
  });

  final String id;
  final String coachName;
  final DateTime sessionDate;
  final String summary;
  final List<String> focusAreas;
}

class DevelopmentSnapshot {
  const DevelopmentSnapshot({
    required this.metric,
    required this.current,
    required this.target,
    required this.recordedAt,
  });

  final String metric;
  final double current;
  final double target;
  final DateTime recordedAt;
}

class SponsorshipOpportunity {
  const SponsorshipOpportunity({
    required this.id,
    required this.sponsorName,
    required this.sport,
    required this.region,
    required this.tier,
  });

  final String id;
  final String sponsorName;
  final SportCode sport;
  final String region;
  final String tier;
}

class TalentSearchCriteria {
  const TalentSearchCriteria({
    this.sport,
    this.countryCode,
    this.minAge,
    this.maxAge,
    this.seekingSponsorOnly = false,
    this.query,
  });

  final SportCode? sport;
  final String? countryCode;
  final int? minAge;
  final int? maxAge;
  final bool seekingSponsorOnly;
  final String? query;
}

class TalentSearchHit {
  const TalentSearchHit({
    required this.athleteId,
    required this.displayName,
    required this.sport,
    required this.region,
    required this.publicSlug,
  });

  final String athleteId;
  final String displayName;
  final SportCode sport;
  final String region;
  final String publicSlug;
}

/// Repository contracts — implement with API/Firebase per module.
abstract interface class VerifiedResultsRepository {
  Future<List<VerifiedTournamentResult>> fetchForAthlete(String athleteId);
}

abstract interface class RankingsRepository {
  Future<List<OfficialRanking>> fetchForAthlete(String athleteId);
}

abstract interface class DevelopmentTrackingRepository {
  Future<List<DevelopmentSnapshot>> fetchTimeline(String athleteId);
}

abstract interface class CoachReportsRepository {
  Future<List<CoachReport>> fetchForAthlete(String athleteId);
}

abstract interface class SponsorshipRepository {
  Future<List<SponsorshipOpportunity>> listOpportunities({SportCode? sport});
}

abstract interface class TalentDiscoveryRepository {
  Future<List<TalentSearchHit>> search(TalentSearchCriteria criteria);
}
