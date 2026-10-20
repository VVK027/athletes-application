import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';

enum ModuleLifecycle {
  live,
  beta,
  planned,
}

/// Platform capabilities — passport today, global ecosystem tomorrow.
enum EcosystemModule {
  digitalPassport,
  familyPass,
  memoryAlbums,
  worldMap,
  digitalBadges,
  sponsorMarketplace,
  verifiedResults,
  officialRankings,
  developmentTracking,
  coachReports,
  sponsorshipManagement,
  publicDiscovery,
  talentSearch,
  multiSportProfiles,
  federationIntegration,
}

extension EcosystemModuleMeta on EcosystemModule {
  String get title => switch (this) {
        EcosystemModule.digitalPassport => 'Digital Athlete Passport',
        EcosystemModule.familyPass => 'Family Pass',
        EcosystemModule.memoryAlbums => 'Memory Albums',
        EcosystemModule.worldMap => 'World Map',
        EcosystemModule.digitalBadges => 'Digital Badges',
        EcosystemModule.sponsorMarketplace => 'Sponsor Marketplace',
        EcosystemModule.verifiedResults => 'Verified Tournament Results',
        EcosystemModule.officialRankings => 'Official Rankings & Handicaps',
        EcosystemModule.developmentTracking => 'Athlete Development Tracking',
        EcosystemModule.coachReports => 'Coach Reports & Training History',
        EcosystemModule.sponsorshipManagement => 'Sponsorship Management',
        EcosystemModule.publicDiscovery => 'Public Profiles for Scouts',
        EcosystemModule.talentSearch => 'Talent Discovery & Search',
        EcosystemModule.multiSportProfiles => 'Multi-Sport Profiles',
        EcosystemModule.federationIntegration => 'Federation Integration',
      };

  String get summary => switch (this) {
        EcosystemModule.digitalPassport =>
          'Verified identity, career timeline, and shareable passport.',
        EcosystemModule.familyPass =>
          'One parent account managing multiple athlete passports.',
        EcosystemModule.memoryAlbums =>
          'Photos and videos grouped by season and events.',
        EcosystemModule.worldMap =>
          'Global map of tournaments, achievements, and training bases.',
        EcosystemModule.digitalBadges =>
          'Milestone badges with progress toward next achievements.',
        EcosystemModule.sponsorMarketplace =>
          'Sponsors discover athletes open to partnerships.',
        EcosystemModule.verifiedResults =>
          'Results signed by tournaments, academies, or federations.',
        EcosystemModule.officialRankings =>
          'Handicaps, world rankings, and sport-specific rating systems.',
        EcosystemModule.developmentTracking =>
          'Long-term skill progression across seasons and sports.',
        EcosystemModule.coachReports =>
          'Structured coach feedback linked to sessions and events.',
        EcosystemModule.sponsorshipManagement =>
          'Pipeline from interest to signed sponsor agreements.',
        EcosystemModule.publicDiscovery =>
          'Scout-ready profiles with privacy controls per field.',
        EcosystemModule.talentSearch =>
          'Filter athletes by sport, region, age, ranking, and goals.',
        EcosystemModule.multiSportProfiles =>
          'One athlete identity across multiple sports and passports.',
        EcosystemModule.federationIntegration =>
          'Sync with national and international governing bodies.',
      };

  ModuleLifecycle get lifecycle => switch (this) {
        EcosystemModule.digitalPassport ||
        EcosystemModule.familyPass ||
        EcosystemModule.memoryAlbums ||
        EcosystemModule.worldMap ||
        EcosystemModule.digitalBadges ||
        EcosystemModule.sponsorMarketplace =>
          ModuleLifecycle.live,
        EcosystemModule.publicDiscovery ||
        EcosystemModule.verifiedResults =>
          ModuleLifecycle.beta,
        _ => ModuleLifecycle.planned,
      };

  List<StakeholderKind> get primaryStakeholders => switch (this) {
        EcosystemModule.digitalPassport => [StakeholderKind.athlete],
        EcosystemModule.familyPass => [StakeholderKind.parent, StakeholderKind.athlete],
        EcosystemModule.memoryAlbums ||
        EcosystemModule.worldMap ||
        EcosystemModule.digitalBadges =>
          [StakeholderKind.athlete, StakeholderKind.parent],
        EcosystemModule.sponsorMarketplace ||
        EcosystemModule.sponsorshipManagement =>
          [StakeholderKind.sponsor, StakeholderKind.athlete],
        EcosystemModule.verifiedResults ||
        EcosystemModule.officialRankings ||
        EcosystemModule.federationIntegration =>
          [StakeholderKind.federation, StakeholderKind.academy],
        EcosystemModule.coachReports ||
        EcosystemModule.developmentTracking =>
          [StakeholderKind.coach, StakeholderKind.academy],
        EcosystemModule.publicDiscovery ||
        EcosystemModule.talentSearch =>
          [StakeholderKind.scout, StakeholderKind.university],
        EcosystemModule.multiSportProfiles => [StakeholderKind.athlete],
      };
}

abstract final class EcosystemModuleRegistry {
  static List<EcosystemModule> get all => EcosystemModule.values;

  static List<EcosystemModule> byLifecycle(ModuleLifecycle lifecycle) =>
      all.where((m) => m.lifecycle == lifecycle).toList();

  static List<EcosystemModule> forStakeholder(StakeholderKind kind) =>
      all.where((m) => m.primaryStakeholders.contains(kind)).toList();
}
