enum AccessRole { athlete, coach, parent, sponsor, public }

class AthleteProfile {
  const AthleteProfile({
    required this.id,
    required this.fullName,
    required this.sport,
    required this.position,
    required this.club,
    required this.nationality,
    required this.dateOfBirth,
    required this.heightCm,
    required this.weightKg,
    required this.dominantSide,
    required this.bio,
    required this.passportId,
    required this.publicSlug,
    required this.avatarInitials,
    required this.jerseyNumber,
  });

  final String id;
  final String fullName;
  final String sport;
  final String position;
  final String club;
  final String nationality;
  final DateTime dateOfBirth;
  final int heightCm;
  final int weightKg;
  final String dominantSide;
  final String bio;
  final String passportId;
  final String publicSlug;
  final String avatarInitials;
  final int jerseyNumber;
}

class CareerEvent {
  const CareerEvent({
    required this.year,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.isHighlight,
  });

  final int year;
  final String title;
  final String subtitle;
  final String description;
  final bool isHighlight;
}

class TournamentResult {
  const TournamentResult({
    required this.name,
    required this.location,
    required this.date,
    required this.placement,
    required this.score,
    required this.category,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final String location;
  final DateTime date;
  final String placement;
  final String score;
  final String category;
  final double latitude;
  final double longitude;
}

class StatMetric {
  const StatMetric({
    required this.label,
    required this.value,
    required this.unit,
    required this.trend,
    required this.progress,
  });

  final String label;
  final String value;
  final String unit;
  final double trend;
  final double progress;
}

class ClubDistance {
  const ClubDistance({
    required this.clubName,
    required this.carryYards,
    required this.accuracyPercent,
    required this.sessionsLogged,
  });

  final String clubName;
  final int carryYards;
  final double accuracyPercent;
  final int sessionsLogged;
}

class PerformanceRecord {
  const PerformanceRecord({
    required this.label,
    required this.current,
    required this.target,
    required this.unit,
    required this.history,
  });

  final String label;
  final double current;
  final double target;
  final String unit;
  final List<double> history;
}

class MediaItem {
  const MediaItem({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    this.duration,
    this.thumbnailColor = 0xFF1B4965,
    this.localPath,
    this.remoteUrl,
  });

  final String id;
  final String title;
  final MediaType type;
  final DateTime date;
  final String? duration;
  final int thumbnailColor;
  final String? localPath;
  final String? remoteUrl;

  bool get hasFile => localPath != null && localPath!.isNotEmpty;
  bool get hasRemote => remoteUrl != null && remoteUrl!.isNotEmpty;

  MediaItem copyWith({
    String? id,
    String? title,
    MediaType? type,
    DateTime? date,
    String? duration,
    int? thumbnailColor,
    String? localPath,
    String? remoteUrl,
  }) {
    return MediaItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      thumbnailColor: thumbnailColor ?? this.thumbnailColor,
      localPath: localPath ?? this.localPath,
      remoteUrl: remoteUrl ?? this.remoteUrl,
    );
  }
}

enum MediaType { photo, video }

class AccessContact {
  const AccessContact({
    required this.name,
    required this.role,
    required this.email,
    required this.permissions,
    required this.lastActive,
  });

  final String name;
  final AccessRole role;
  final String email;
  final List<String> permissions;
  final DateTime lastActive;
}

class Sponsor {
  const Sponsor({
    required this.name,
    required this.tier,
    required this.since,
    required this.benefits,
    required this.contactName,
  });

  final String name;
  final String tier;
  final DateTime since;
  final List<String> benefits;
  final String contactName;
}

class CalendarEvent {
  const CalendarEvent({
    required this.title,
    required this.start,
    required this.end,
    required this.location,
    required this.type,
    required this.travelNote,
  });

  final String title;
  final DateTime start;
  final DateTime end;
  final String location;
  final CalendarEventType type;
  final String? travelNote;
}

enum CalendarEventType { tournament, training, travel, meeting }

class MemoryAlbum {
  const MemoryAlbum({
    required this.id,
    required this.title,
    required this.season,
    required this.eventName,
    required this.coverColor,
    required this.mediaIds,
    required this.startDate,
    required this.endDate,
    required this.summary,
  });

  final String id;
  final String title;
  final String season;
  final String eventName;
  final int coverColor;
  final List<String> mediaIds;
  final DateTime startDate;
  final DateTime endDate;
  final String summary;
}

enum BadgeCategory { tournament, training, milestone, community }

class AchievementBadge {
  const AchievementBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.category,
    required this.earnedAt,
    required this.isUnlocked,
    this.progress,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final BadgeCategory category;
  final DateTime? earnedAt;
  final bool isUnlocked;
  final double? progress;
}

class MapPin {
  const MapPin({
    required this.id,
    required this.label,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.kind,
    required this.detail,
  });

  final String id;
  final String label;
  final String location;
  final double latitude;
  final double longitude;
  final DateTime date;
  final MapPinKind kind;
  final String detail;
}

enum MapPinKind { tournament, achievement, trainingCamp }

class FamilyAthleteSummary {
  const FamilyAthleteSummary({
    required this.athleteId,
    required this.fullName,
    required this.sport,
    required this.avatarInitials,
    required this.passportId,
    required this.age,
  });

  final String athleteId;
  final String fullName;
  final String sport;
  final String avatarInitials;
  final String passportId;
  final int age;
}

class FamilyPassAccount {
  const FamilyPassAccount({
    required this.accountId,
    required this.parentName,
    required this.planLabel,
    required this.maxAthletes,
    required this.athletes,
    required this.activeAthleteId,
  });

  final String accountId;
  final String parentName;
  final String planLabel;
  final int maxAthletes;
  final List<FamilyAthleteSummary> athletes;
  final String activeAthleteId;

  FamilyPassAccount copyWith({
    String? accountId,
    String? parentName,
    String? planLabel,
    int? maxAthletes,
    List<FamilyAthleteSummary>? athletes,
    String? activeAthleteId,
  }) {
    return FamilyPassAccount(
      accountId: accountId ?? this.accountId,
      parentName: parentName ?? this.parentName,
      planLabel: planLabel ?? this.planLabel,
      maxAthletes: maxAthletes ?? this.maxAthletes,
      athletes: athletes ?? this.athletes,
      activeAthleteId: activeAthleteId ?? this.activeAthleteId,
    );
  }
}

class MarketplaceAthlete {
  const MarketplaceAthlete({
    required this.athleteId,
    required this.fullName,
    required this.sport,
    required this.region,
    required this.age,
    required this.rankingPoints,
    required this.seekingSponsor,
    required this.highlights,
    required this.publicSlug,
    required this.avatarInitials,
  });

  final String athleteId;
  final String fullName;
  final String sport;
  final String region;
  final int age;
  final int rankingPoints;
  final bool seekingSponsor;
  final List<String> highlights;
  final String publicSlug;
  final String avatarInitials;
}

class AthletePassportData {
  const AthletePassportData({
    required this.profile,
    required this.careerTimeline,
    required this.tournaments,
    required this.stats,
    required this.clubDistances,
    required this.performance,
    required this.media,
    required this.accessContacts,
    required this.sponsors,
    required this.calendarEvents,
    required this.publicHighlights,
    required this.memoryAlbums,
    required this.badges,
    required this.mapPins,
  });

  final AthleteProfile profile;
  final List<CareerEvent> careerTimeline;
  final List<TournamentResult> tournaments;
  final List<StatMetric> stats;
  final List<ClubDistance> clubDistances;
  final List<PerformanceRecord> performance;
  final List<MediaItem> media;
  final List<AccessContact> accessContacts;
  final List<Sponsor> sponsors;
  final List<CalendarEvent> calendarEvents;
  final List<String> publicHighlights;
  final List<MemoryAlbum> memoryAlbums;
  final List<AchievementBadge> badges;
  final List<MapPin> mapPins;

  AthletePassportData copyWith({
    AthleteProfile? profile,
    List<CareerEvent>? careerTimeline,
    List<TournamentResult>? tournaments,
    List<StatMetric>? stats,
    List<ClubDistance>? clubDistances,
    List<PerformanceRecord>? performance,
    List<MediaItem>? media,
    List<AccessContact>? accessContacts,
    List<Sponsor>? sponsors,
    List<CalendarEvent>? calendarEvents,
    List<String>? publicHighlights,
    List<MemoryAlbum>? memoryAlbums,
    List<AchievementBadge>? badges,
    List<MapPin>? mapPins,
  }) {
    return AthletePassportData(
      profile: profile ?? this.profile,
      careerTimeline: careerTimeline ?? this.careerTimeline,
      tournaments: tournaments ?? this.tournaments,
      stats: stats ?? this.stats,
      clubDistances: clubDistances ?? this.clubDistances,
      performance: performance ?? this.performance,
      media: media ?? this.media,
      accessContacts: accessContacts ?? this.accessContacts,
      sponsors: sponsors ?? this.sponsors,
      calendarEvents: calendarEvents ?? this.calendarEvents,
      publicHighlights: publicHighlights ?? this.publicHighlights,
      memoryAlbums: memoryAlbums ?? this.memoryAlbums,
      badges: badges ?? this.badges,
      mapPins: mapPins ?? this.mapPins,
    );
  }
}
