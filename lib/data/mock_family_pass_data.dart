import 'package:athletes_application/data/mock_athlete_data.dart';
import 'package:athletes_application/models/athlete_models.dart';

final mockFamilyPass = FamilyPassAccount(
  accountId: 'fam_chen_01',
  parentName: 'Lisa Chen',
  planLabel: 'Family Pass',
  maxAthletes: 4,
  activeAthleteId: mockAthletePassport.profile.id,
  athletes: const [
    FamilyAthleteSummary(
      athleteId: 'ath_2847',
      fullName: 'Maya Chen',
      sport: 'Golf',
      avatarInitials: 'MC',
      passportId: 'DAP-2026-2847',
      age: 18,
    ),
    FamilyAthleteSummary(
      athleteId: 'ath_2848',
      fullName: 'Leo Chen',
      sport: 'Tennis',
      avatarInitials: 'LC',
      passportId: 'DAP-2026-2848',
      age: 15,
    ),
    FamilyAthleteSummary(
      athleteId: 'ath_2849',
      fullName: 'Ava Chen',
      sport: 'Swimming',
      avatarInitials: 'AC',
      passportId: 'DAP-2026-2849',
      age: 12,
    ),
  ],
);

final mockSponsorMarketplace = <MarketplaceAthlete>[
  MarketplaceAthlete(
    athleteId: mockAthletePassport.profile.id,
    fullName: 'Maya Chen',
    sport: 'Golf',
    region: 'Pacific Northwest, USA',
    age: 18,
    rankingPoints: 1240,
    seekingSponsor: true,
    highlights: const [
      'State Junior Top 5',
      'Scoring avg 72.4',
      'Regional qualifier winner',
    ],
    publicSlug: 'maya-chen-golf',
    avatarInitials: 'MC',
  ),
  const MarketplaceAthlete(
    athleteId: 'ath_3102',
    fullName: 'Jordan Blake',
    sport: 'Basketball',
    region: 'Texas, USA',
    age: 17,
    rankingPoints: 980,
    seekingSponsor: true,
    highlights: ['District MVP', 'AAU Nationals semifinalist'],
    publicSlug: 'jordan-blake-bball',
    avatarInitials: 'JB',
  ),
  const MarketplaceAthlete(
    athleteId: 'ath_2911',
    fullName: 'Sofia Ruiz',
    sport: 'Soccer',
    region: 'California, USA',
    age: 16,
    rankingPoints: 1105,
    seekingSponsor: false,
    highlights: ['ECNL starter', 'National team camp invite'],
    publicSlug: 'sofia-ruiz-soccer',
    avatarInitials: 'SR',
  ),
  const MarketplaceAthlete(
    athleteId: 'ath_2848',
    fullName: 'Leo Chen',
    sport: 'Tennis',
    region: 'Oregon, USA',
    age: 15,
    rankingPoints: 720,
    seekingSponsor: true,
    highlights: ['USTA L3 champion', 'Doubles specialist'],
    publicSlug: 'leo-chen-tennis',
    avatarInitials: 'LC',
  ),
];

AthletePassportData passportForFamilyAthlete(String athleteId) {
  if (athleteId == mockAthletePassport.profile.id) {
    return mockAthletePassport;
  }
  if (athleteId == 'ath_2848') {
    return _leoChenPassport;
  }
  if (athleteId == 'ath_2849') {
    return _avaChenPassport;
  }
  return mockAthletePassport;
}

final _leoChenPassport = AthletePassportData(
  profile: AthleteProfile(
    id: 'ath_2848',
    fullName: 'Leo Chen',
    sport: 'Tennis',
    position: 'Junior · U16',
    club: 'Portland Tennis Center',
    nationality: 'USA',
    dateOfBirth: DateTime(2011, 7, 22),
    heightCm: 172,
    weightKg: 62,
    dominantSide: 'Right',
    bio: 'Aggressive baseliner with strong doubles results on regional circuits.',
    passportId: 'DAP-2026-2848',
    publicSlug: 'leo-chen-tennis',
    avatarInitials: 'LC',
    jerseyNumber: 12,
  ),
  careerTimeline: const [
    CareerEvent(
      year: 2026,
      title: 'USTA L3 Champion',
      subtitle: 'Portland Tennis Center',
      description: 'Won singles draw without dropping a set.',
      isHighlight: true,
    ),
  ],
  tournaments: [
    TournamentResult(
      name: 'Rose City Open',
      location: 'Portland, OR',
      date: DateTime(2026, 5, 10),
      placement: '1st',
      score: '6-2, 6-4',
      category: 'Boys U16',
      latitude: 45.52,
      longitude: -122.67,
    ),
  ],
  stats: const [
    StatMetric(
      label: 'Win rate',
      value: '78',
      unit: '%',
      trend: 4.2,
      progress: 0.78,
    ),
  ],
  clubDistances: const [],
  performance: const [],
  media: [
    MediaItem(
      id: 'leo_media_1',
      title: 'Match point ace',
      type: MediaType.video,
      date: DateTime(2026, 5, 10),
      duration: '0:42',
      thumbnailColor: 0xFF2D6A4F,
    ),
  ],
  accessContacts: const [],
  sponsors: const [],
  calendarEvents: const [],
  publicHighlights: const ['USTA L3 Champion 2026'],
  memoryAlbums: [
    MemoryAlbum(
      id: 'leo_album_1',
      title: 'Rose City Open',
      season: '2026 Spring',
      eventName: 'Rose City Open',
      coverColor: 0xFF2D6A4F,
      mediaIds: ['leo_media_1'],
      startDate: DateTime(2026, 5, 9),
      endDate: DateTime(2026, 5, 11),
      summary: 'Championship weekend highlights.',
    ),
  ],
  badges: [
    AchievementBadge(
      id: 'leo_b1',
      title: 'Ace Machine',
      description: '10+ aces in a tournament match.',
      iconKey: 'sports_tennis',
      category: BadgeCategory.tournament,
      earnedAt: DateTime(2026, 5, 10),
      isUnlocked: true,
    ),
  ],
  mapPins: [
    MapPin(
      id: 'leo_pin_1',
      label: 'Rose City Open win',
      location: 'Portland, OR',
      latitude: 45.52,
      longitude: -122.67,
      date: DateTime(2026, 5, 10),
      kind: MapPinKind.tournament,
      detail: 'Boys U16 champion',
    ),
  ],
);

final _avaChenPassport = AthletePassportData(
  profile: AthleteProfile(
    id: 'ath_2849',
    fullName: 'Ava Chen',
    sport: 'Swimming',
    position: 'Freestyle · IM',
    club: 'Riverside Swim Club',
    nationality: 'USA',
    dateOfBirth: DateTime(2014, 1, 8),
    heightCm: 155,
    weightKg: 45,
    dominantSide: 'Right',
    bio: 'Butterfly and freestyle specialist with state qualifying times.',
    passportId: 'DAP-2026-2849',
    publicSlug: 'ava-chen-swim',
    avatarInitials: 'AC',
    jerseyNumber: 3,
  ),
  careerTimeline: const [
    CareerEvent(
      year: 2026,
      title: 'State Age-Group Qualifier',
      subtitle: 'Riverside Swim Club',
      description: 'Qualified in 100m free and 200m IM.',
      isHighlight: true,
    ),
  ],
  tournaments: [
    TournamentResult(
      name: 'Spring Splash Meet',
      location: 'Eugene, OR',
      date: DateTime(2026, 4, 20),
      placement: '3rd',
      score: '1:02.14 100m free',
      category: 'Girls 11-12',
      latitude: 44.05,
      longitude: -123.09,
    ),
  ],
  stats: const [
    StatMetric(
      label: '100m Free PB',
      value: '1:02.1',
      unit: 'sec',
      trend: -0.4,
      progress: 0.85,
    ),
  ],
  clubDistances: const [],
  performance: const [],
  media: [
    MediaItem(
      id: 'ava_media_1',
      title: 'Start block focus',
      type: MediaType.photo,
      date: DateTime(2026, 4, 20),
      thumbnailColor: 0xFF5C4D7D,
      remoteUrl: 'https://picsum.photos/seed/swim/600/600',
    ),
  ],
  accessContacts: const [],
  sponsors: const [],
  calendarEvents: const [],
  publicHighlights: const ['State qualifier — 100m free'],
  memoryAlbums: [
    MemoryAlbum(
      id: 'ava_album_1',
      title: 'Spring Splash',
      season: '2026 Spring',
      eventName: 'Spring Splash Meet',
      coverColor: 0xFF5C4D7D,
      mediaIds: ['ava_media_1'],
      startDate: DateTime(2026, 4, 19),
      endDate: DateTime(2026, 4, 21),
      summary: 'First podium at a regional meet.',
    ),
  ],
  badges: [
    AchievementBadge(
      id: 'ava_b1',
      title: 'Early Bird',
      description: 'Logged 20 morning practices.',
      iconKey: 'wb_sunny',
      category: BadgeCategory.training,
      earnedAt: DateTime(2026, 3, 1),
      isUnlocked: true,
    ),
    AchievementBadge(
      id: 'ava_b2',
      title: 'Podium Finisher',
      description: 'Top-3 at a sanctioned meet.',
      iconKey: 'emoji_events',
      category: BadgeCategory.tournament,
      earnedAt: null,
      isUnlocked: false,
      progress: 0.66,
    ),
  ],
  mapPins: [
    MapPin(
      id: 'ava_pin_1',
      label: 'Spring Splash podium',
      location: 'Eugene, OR',
      latitude: 44.05,
      longitude: -123.09,
      date: DateTime(2026, 4, 20),
      kind: MapPinKind.tournament,
      detail: '3rd — 100m free',
    ),
  ],
);
