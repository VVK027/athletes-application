import 'package:athletes_application/models/athlete_models.dart';

enum PassportFeature {
  profile,
  careerTimeline,
  tournaments,
  stats,
  clubDistances,
  performance,
  media,
  mediaUpload,
  accessManagement,
  sponsors,
  sponsorsEdit,
  calendar,
  publicProfile,
  publicProfileEdit,
  familyPass,
  memoryAlbums,
  worldMap,
  achievements,
  sponsorMarketplace,
  ecosystemPlatform,
  verifiedResults,
  talentSearch,
}

abstract final class PassportPermissions {
  static bool canView(PassportFeature feature, AccessRole role) {
    if (feature == PassportFeature.ecosystemPlatform) {
      return _ecosystemPlatform(role);
    }
    return switch (role) {
      AccessRole.athlete => true,
      AccessRole.coach => _coachView(feature),
      AccessRole.parent => _parentView(feature),
      AccessRole.sponsor => _sponsorView(feature),
      AccessRole.public => _publicView(feature),
    };
  }

  static bool canEdit(PassportFeature feature, AccessRole role) {
    if (role == AccessRole.athlete) return true;
    return switch (role) {
      AccessRole.coach => feature == PassportFeature.mediaUpload,
      AccessRole.parent =>
        feature == PassportFeature.publicProfileEdit ||
            feature == PassportFeature.familyPass,
      _ => false,
    };
  }

  static List<PassportTab> visibleTabs(AccessRole role) {
    return switch (role) {
      AccessRole.athlete => PassportTab.values,
      AccessRole.coach => [
        PassportTab.profile,
        PassportTab.results,
        PassportTab.track,
        PassportTab.media,
        PassportTab.more,
      ],
      AccessRole.parent => [
        PassportTab.profile,
        PassportTab.results,
        PassportTab.media,
        PassportTab.more,
      ],
      AccessRole.sponsor => [PassportTab.more],
      AccessRole.public => [PassportTab.more],
    };
  }

  static bool moreItemVisible(MorePassportItem item, AccessRole role) {
    return switch (item) {
      MorePassportItem.access => canView(PassportFeature.accessManagement, role),
      MorePassportItem.sponsors => canView(PassportFeature.sponsors, role),
      MorePassportItem.calendar => canView(PassportFeature.calendar, role),
      MorePassportItem.publicProfile => canView(PassportFeature.publicProfile, role),
      MorePassportItem.familyPass => canView(PassportFeature.familyPass, role),
      MorePassportItem.memoryAlbums => canView(PassportFeature.memoryAlbums, role),
      MorePassportItem.worldMap => canView(PassportFeature.worldMap, role),
      MorePassportItem.achievements => canView(PassportFeature.achievements, role),
      MorePassportItem.sponsorMarketplace =>
        canView(PassportFeature.sponsorMarketplace, role),
      MorePassportItem.ecosystemPlatform =>
        canView(PassportFeature.ecosystemPlatform, role),
      MorePassportItem.verifiedResults =>
        canView(PassportFeature.verifiedResults, role),
      MorePassportItem.talentSearch => canView(PassportFeature.talentSearch, role),
    };
  }

  static String roleLabel(AccessRole role) => switch (role) {
        AccessRole.athlete => 'Athlete',
        AccessRole.coach => 'Coach',
        AccessRole.parent => 'Parent',
        AccessRole.sponsor => 'Sponsor',
        AccessRole.public => 'Public',
      };

  static bool _ecosystemPlatform(AccessRole role) => switch (role) {
        AccessRole.athlete ||
        AccessRole.parent ||
        AccessRole.coach ||
        AccessRole.sponsor =>
          true,
        _ => false,
      };

  static bool _coachView(PassportFeature f) => switch (f) {
        PassportFeature.ecosystemPlatform || PassportFeature.verifiedResults => true,
        PassportFeature.profile ||
        PassportFeature.careerTimeline ||
        PassportFeature.tournaments ||
        PassportFeature.stats ||
        PassportFeature.clubDistances ||
        PassportFeature.performance ||
        PassportFeature.media ||
        PassportFeature.mediaUpload ||
        PassportFeature.calendar ||
        PassportFeature.memoryAlbums ||
        PassportFeature.worldMap ||
        PassportFeature.achievements =>
          true,
        _ => false,
      };

  static bool _parentView(PassportFeature f) => switch (f) {
        PassportFeature.ecosystemPlatform || PassportFeature.verifiedResults => true,
        PassportFeature.profile ||
        PassportFeature.careerTimeline ||
        PassportFeature.tournaments ||
        PassportFeature.stats ||
        PassportFeature.media ||
        PassportFeature.calendar ||
        PassportFeature.publicProfile ||
        PassportFeature.publicProfileEdit ||
        PassportFeature.familyPass ||
        PassportFeature.memoryAlbums ||
        PassportFeature.worldMap ||
        PassportFeature.achievements =>
          true,
        _ => false,
      };

  static bool _sponsorView(PassportFeature f) => switch (f) {
        PassportFeature.ecosystemPlatform => true,
        PassportFeature.sponsors ||
        PassportFeature.publicProfile ||
        PassportFeature.sponsorMarketplace ||
        PassportFeature.talentSearch =>
          true,
        _ => false,
      };

  static bool _publicView(PassportFeature f) => switch (f) {
        PassportFeature.publicProfile || PassportFeature.talentSearch => true,
        _ => false,
      };
}

enum PassportTab { profile, results, track, media, more }

enum MorePassportItem {
  talentSearch,
  verifiedResults,
  ecosystemPlatform,
  familyPass,
  memoryAlbums,
  worldMap,
  achievements,
  access,
  sponsors,
  calendar,
  publicProfile,
  sponsorMarketplace,
}
