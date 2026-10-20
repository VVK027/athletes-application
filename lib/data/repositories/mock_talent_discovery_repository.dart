import 'package:athletes_application/data/mock_family_pass_data.dart';
import 'package:athletes_application/domain/contracts/ecosystem_repositories.dart';
import 'package:athletes_application/domain/ecosystem/sport_code.dart';

class MockTalentDiscoveryRepository implements TalentDiscoveryRepository {
  @override
  Future<List<TalentSearchHit>> search(TalentSearchCriteria criteria) async {
    var hits = mockSponsorMarketplace
        .map(
          (a) => TalentSearchHit(
            athleteId: a.athleteId,
            displayName: a.fullName,
            sport: SportRegistry.fromLabel(a.sport),
            region: a.region,
            publicSlug: a.publicSlug,
          ),
        )
        .toList();

    if (criteria.sport != null) {
      hits = hits.where((h) => h.sport.id == criteria.sport!.id).toList();
    }
    if (criteria.countryCode != null) {
      hits = hits
          .where((h) => h.region.toUpperCase().contains(criteria.countryCode!.toUpperCase()))
          .toList();
    }
    if (criteria.seekingSponsorOnly) {
      final seeking = mockSponsorMarketplace
          .where((a) => a.seekingSponsor)
          .map((a) => a.athleteId)
          .toSet();
      hits = hits.where((h) => seeking.contains(h.athleteId)).toList();
    }
    if (criteria.query != null && criteria.query!.trim().isNotEmpty) {
      final q = criteria.query!.toLowerCase();
      hits = hits
          .where(
            (h) =>
                h.displayName.toLowerCase().contains(q) ||
                h.publicSlug.toLowerCase().contains(q) ||
                h.sport.displayName.toLowerCase().contains(q),
          )
          .toList();
    }
    if (criteria.minAge != null || criteria.maxAge != null) {
      hits = hits.where((h) {
        final listing = mockSponsorMarketplace
            .where((a) => a.athleteId == h.athleteId)
            .firstOrNull;
        if (listing == null) return true;
        if (criteria.minAge != null && listing.age < criteria.minAge!) return false;
        if (criteria.maxAge != null && listing.age > criteria.maxAge!) return false;
        return true;
      }).toList();
    }

    return hits;
  }
}
