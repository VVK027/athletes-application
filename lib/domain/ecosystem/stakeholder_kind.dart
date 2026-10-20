import 'package:athletes_application/models/athlete_models.dart';

/// Every participant type in the global athlete network.
enum StakeholderKind {
  athlete,
  parent,
  coach,
  sponsor,
  academy,
  university,
  scout,
  federation,
  publicViewer,
}

extension StakeholderKindLabels on StakeholderKind {
  String get label => switch (this) {
        StakeholderKind.athlete => 'Athlete',
        StakeholderKind.parent => 'Parent',
        StakeholderKind.coach => 'Coach',
        StakeholderKind.sponsor => 'Sponsor',
        StakeholderKind.academy => 'Academy',
        StakeholderKind.university => 'University',
        StakeholderKind.scout => 'Scout / Recruiter',
        StakeholderKind.federation => 'Sports Federation',
        StakeholderKind.publicViewer => 'Public',
      };

  String get description => switch (this) {
        StakeholderKind.athlete => 'Career owner · passport & development',
        StakeholderKind.parent => 'Family accounts · consent & visibility',
        StakeholderKind.coach => 'Training plans · reports & media',
        StakeholderKind.sponsor => 'Partnerships · marketplace discovery',
        StakeholderKind.academy => 'Programs · rosters · verified events',
        StakeholderKind.university => 'Recruiting · eligibility & visits',
        StakeholderKind.scout => 'Talent search · public profiles',
        StakeholderKind.federation => 'Official results · rankings & rules',
        StakeholderKind.publicViewer => 'Limited public athlete profile',
      };

  /// Maps to the passport app’s preview roles until dedicated auth exists.
  AccessRole? get passportPreviewRole => switch (this) {
        StakeholderKind.athlete => AccessRole.athlete,
        StakeholderKind.parent => AccessRole.parent,
        StakeholderKind.coach => AccessRole.coach,
        StakeholderKind.sponsor => AccessRole.sponsor,
        StakeholderKind.scout || StakeholderKind.publicViewer => AccessRole.public,
        StakeholderKind.academy ||
        StakeholderKind.university ||
        StakeholderKind.federation =>
          null,
      };
}

/// Network participants orbiting the athlete (for roadmap / onboarding UI).
const athleteCentricNetwork = [
  StakeholderKind.parent,
  StakeholderKind.coach,
  StakeholderKind.sponsor,
  StakeholderKind.academy,
  StakeholderKind.university,
  StakeholderKind.scout,
  StakeholderKind.federation,
];
