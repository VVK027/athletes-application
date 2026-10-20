import 'dart:convert';

import 'package:athletes_application/models/athlete_models.dart';

abstract final class AthletePassportSerializer {
  static String encode(AthletePassportData data) =>
      jsonEncode(_dataToMap(data));

  static AthletePassportData decode(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return _dataFromMap(map);
  }

  static Map<String, dynamic> _dataToMap(AthletePassportData d) => {
        'profile': _profileToMap(d.profile),
        'careerTimeline': d.careerTimeline.map(_careerToMap).toList(),
        'tournaments': d.tournaments.map(_tournamentToMap).toList(),
        'stats': d.stats.map(_statToMap).toList(),
        'clubDistances': d.clubDistances.map(_clubToMap).toList(),
        'performance': d.performance.map(_perfToMap).toList(),
        'media': d.media.map(_mediaToMap).toList(),
        'accessContacts': d.accessContacts.map(_contactToMap).toList(),
        'sponsors': d.sponsors.map(_sponsorToMap).toList(),
        'calendarEvents': d.calendarEvents.map(_calendarToMap).toList(),
        'publicHighlights': d.publicHighlights,
        'memoryAlbums': d.memoryAlbums.map(_albumToMap).toList(),
        'badges': d.badges.map(_badgeToMap).toList(),
        'mapPins': d.mapPins.map(_mapPinToMap).toList(),
      };

  static AthletePassportData _dataFromMap(Map<String, dynamic> m) {
    return AthletePassportData(
      profile: _profileFromMap(m['profile'] as Map<String, dynamic>),
      careerTimeline: (m['careerTimeline'] as List)
          .map((e) => _careerFromMap(e as Map<String, dynamic>))
          .toList(),
      tournaments: (m['tournaments'] as List)
          .map((e) => _tournamentFromMap(e as Map<String, dynamic>))
          .toList(),
      stats: (m['stats'] as List)
          .map((e) => _statFromMap(e as Map<String, dynamic>))
          .toList(),
      clubDistances: (m['clubDistances'] as List)
          .map((e) => _clubFromMap(e as Map<String, dynamic>))
          .toList(),
      performance: (m['performance'] as List)
          .map((e) => _perfFromMap(e as Map<String, dynamic>))
          .toList(),
      media: (m['media'] as List)
          .map((e) => _mediaFromMap(e as Map<String, dynamic>))
          .toList(),
      accessContacts: (m['accessContacts'] as List)
          .map((e) => _contactFromMap(e as Map<String, dynamic>))
          .toList(),
      sponsors: (m['sponsors'] as List)
          .map((e) => _sponsorFromMap(e as Map<String, dynamic>))
          .toList(),
      calendarEvents: (m['calendarEvents'] as List)
          .map((e) => _calendarFromMap(e as Map<String, dynamic>))
          .toList(),
      publicHighlights: (m['publicHighlights'] as List).cast<String>(),
      memoryAlbums: _readAlbums(m['memoryAlbums']),
      badges: _readBadges(m['badges']),
      mapPins: _readMapPins(m['mapPins']),
    );
  }

  static List<MemoryAlbum> _readAlbums(Object? raw) {
    if (raw is! List) return const [];
    return raw.map((e) => _albumFromMap(e as Map<String, dynamic>)).toList();
  }

  static List<AchievementBadge> _readBadges(Object? raw) {
    if (raw is! List) return const [];
    return raw.map((e) => _badgeFromMap(e as Map<String, dynamic>)).toList();
  }

  static List<MapPin> _readMapPins(Object? raw) {
    if (raw is! List) return const [];
    return raw.map((e) => _mapPinFromMap(e as Map<String, dynamic>)).toList();
  }

  static Map<String, dynamic> _profileToMap(AthleteProfile p) => {
        'id': p.id,
        'fullName': p.fullName,
        'sport': p.sport,
        'position': p.position,
        'club': p.club,
        'nationality': p.nationality,
        'dateOfBirth': p.dateOfBirth.toIso8601String(),
        'heightCm': p.heightCm,
        'weightKg': p.weightKg,
        'dominantSide': p.dominantSide,
        'bio': p.bio,
        'passportId': p.passportId,
        'publicSlug': p.publicSlug,
        'avatarInitials': p.avatarInitials,
        'jerseyNumber': p.jerseyNumber,
      };

  static AthleteProfile _profileFromMap(Map<String, dynamic> m) => AthleteProfile(
        id: m['id'] as String,
        fullName: m['fullName'] as String,
        sport: m['sport'] as String,
        position: m['position'] as String,
        club: m['club'] as String,
        nationality: m['nationality'] as String,
        dateOfBirth: DateTime.parse(m['dateOfBirth'] as String),
        heightCm: m['heightCm'] as int,
        weightKg: m['weightKg'] as int,
        dominantSide: m['dominantSide'] as String,
        bio: m['bio'] as String,
        passportId: m['passportId'] as String,
        publicSlug: m['publicSlug'] as String,
        avatarInitials: m['avatarInitials'] as String,
        jerseyNumber: m['jerseyNumber'] as int,
      );

  static Map<String, dynamic> _careerToMap(CareerEvent e) => {
        'year': e.year,
        'title': e.title,
        'subtitle': e.subtitle,
        'description': e.description,
        'isHighlight': e.isHighlight,
      };

  static CareerEvent _careerFromMap(Map<String, dynamic> m) => CareerEvent(
        year: m['year'] as int,
        title: m['title'] as String,
        subtitle: m['subtitle'] as String,
        description: m['description'] as String,
        isHighlight: m['isHighlight'] as bool,
      );

  static Map<String, dynamic> _tournamentToMap(TournamentResult t) => {
        'name': t.name,
        'location': t.location,
        'date': t.date.toIso8601String(),
        'placement': t.placement,
        'score': t.score,
        'category': t.category,
        'latitude': t.latitude,
        'longitude': t.longitude,
      };

  static TournamentResult _tournamentFromMap(Map<String, dynamic> m) =>
      TournamentResult(
        name: m['name'] as String,
        location: m['location'] as String,
        date: DateTime.parse(m['date'] as String),
        placement: m['placement'] as String,
        score: m['score'] as String,
        category: m['category'] as String,
        latitude: (m['latitude'] as num?)?.toDouble() ?? 0,
        longitude: (m['longitude'] as num?)?.toDouble() ?? 0,
      );

  static Map<String, dynamic> _statToMap(StatMetric s) => {
        'label': s.label,
        'value': s.value,
        'unit': s.unit,
        'trend': s.trend,
        'progress': s.progress,
      };

  static StatMetric _statFromMap(Map<String, dynamic> m) => StatMetric(
        label: m['label'] as String,
        value: m['value'] as String,
        unit: m['unit'] as String,
        trend: (m['trend'] as num).toDouble(),
        progress: (m['progress'] as num).toDouble(),
      );

  static Map<String, dynamic> _clubToMap(ClubDistance c) => {
        'clubName': c.clubName,
        'carryYards': c.carryYards,
        'accuracyPercent': c.accuracyPercent,
        'sessionsLogged': c.sessionsLogged,
      };

  static ClubDistance _clubFromMap(Map<String, dynamic> m) => ClubDistance(
        clubName: m['clubName'] as String,
        carryYards: m['carryYards'] as int,
        accuracyPercent: (m['accuracyPercent'] as num).toDouble(),
        sessionsLogged: m['sessionsLogged'] as int,
      );

  static Map<String, dynamic> _perfToMap(PerformanceRecord p) => {
        'label': p.label,
        'current': p.current,
        'target': p.target,
        'unit': p.unit,
        'history': p.history,
      };

  static PerformanceRecord _perfFromMap(Map<String, dynamic> m) =>
      PerformanceRecord(
        label: m['label'] as String,
        current: (m['current'] as num).toDouble(),
        target: (m['target'] as num).toDouble(),
        unit: m['unit'] as String,
        history: (m['history'] as List).map((e) => (e as num).toDouble()).toList(),
      );

  static Map<String, dynamic> _mediaToMap(MediaItem m) => {
        'id': m.id,
        'title': m.title,
        'type': m.type.name,
        'date': m.date.toIso8601String(),
        'duration': m.duration,
        'thumbnailColor': m.thumbnailColor,
        'localPath': m.localPath,
        'remoteUrl': m.remoteUrl,
      };

  static MediaItem _mediaFromMap(Map<String, dynamic> m) => MediaItem(
        id: m['id'] as String? ?? m['title'] as String,
        title: m['title'] as String,
        type: MediaType.values.byName(m['type'] as String),
        date: DateTime.parse(m['date'] as String),
        duration: m['duration'] as String?,
        thumbnailColor: m['thumbnailColor'] as int? ?? 0xFF1B4965,
        localPath: m['localPath'] as String?,
        remoteUrl: m['remoteUrl'] as String?,
      );

  static Map<String, dynamic> _contactToMap(AccessContact c) => {
        'name': c.name,
        'role': c.role.name,
        'email': c.email,
        'permissions': c.permissions,
        'lastActive': c.lastActive.toIso8601String(),
      };

  static AccessContact _contactFromMap(Map<String, dynamic> m) => AccessContact(
        name: m['name'] as String,
        role: AccessRole.values.byName(m['role'] as String),
        email: m['email'] as String,
        permissions: (m['permissions'] as List).cast<String>(),
        lastActive: DateTime.parse(m['lastActive'] as String),
      );

  static Map<String, dynamic> _sponsorToMap(Sponsor s) => {
        'name': s.name,
        'tier': s.tier,
        'since': s.since.toIso8601String(),
        'benefits': s.benefits,
        'contactName': s.contactName,
      };

  static Sponsor _sponsorFromMap(Map<String, dynamic> m) => Sponsor(
        name: m['name'] as String,
        tier: m['tier'] as String,
        since: DateTime.parse(m['since'] as String),
        benefits: (m['benefits'] as List).cast<String>(),
        contactName: m['contactName'] as String,
      );

  static Map<String, dynamic> _calendarToMap(CalendarEvent e) => {
        'title': e.title,
        'start': e.start.toIso8601String(),
        'end': e.end.toIso8601String(),
        'location': e.location,
        'type': e.type.name,
        'travelNote': e.travelNote,
      };

  static CalendarEvent _calendarFromMap(Map<String, dynamic> m) => CalendarEvent(
        title: m['title'] as String,
        start: DateTime.parse(m['start'] as String),
        end: DateTime.parse(m['end'] as String),
        location: m['location'] as String,
        type: CalendarEventType.values.byName(m['type'] as String),
        travelNote: m['travelNote'] as String?,
      );

  static Map<String, dynamic> _albumToMap(MemoryAlbum a) => {
        'id': a.id,
        'title': a.title,
        'season': a.season,
        'eventName': a.eventName,
        'coverColor': a.coverColor,
        'mediaIds': a.mediaIds,
        'startDate': a.startDate.toIso8601String(),
        'endDate': a.endDate.toIso8601String(),
        'summary': a.summary,
      };

  static MemoryAlbum _albumFromMap(Map<String, dynamic> m) => MemoryAlbum(
        id: m['id'] as String,
        title: m['title'] as String,
        season: m['season'] as String,
        eventName: m['eventName'] as String,
        coverColor: m['coverColor'] as int? ?? 0xFF1B4965,
        mediaIds: (m['mediaIds'] as List).cast<String>(),
        startDate: DateTime.parse(m['startDate'] as String),
        endDate: DateTime.parse(m['endDate'] as String),
        summary: m['summary'] as String,
      );

  static Map<String, dynamic> _badgeToMap(AchievementBadge b) => {
        'id': b.id,
        'title': b.title,
        'description': b.description,
        'iconKey': b.iconKey,
        'category': b.category.name,
        'earnedAt': b.earnedAt?.toIso8601String(),
        'isUnlocked': b.isUnlocked,
        'progress': b.progress,
      };

  static AchievementBadge _badgeFromMap(Map<String, dynamic> m) => AchievementBadge(
        id: m['id'] as String,
        title: m['title'] as String,
        description: m['description'] as String,
        iconKey: m['iconKey'] as String,
        category: BadgeCategory.values.byName(m['category'] as String),
        earnedAt: m['earnedAt'] == null ? null : DateTime.parse(m['earnedAt'] as String),
        isUnlocked: m['isUnlocked'] as bool? ?? false,
        progress: (m['progress'] as num?)?.toDouble(),
      );

  static Map<String, dynamic> _mapPinToMap(MapPin p) => {
        'id': p.id,
        'label': p.label,
        'location': p.location,
        'latitude': p.latitude,
        'longitude': p.longitude,
        'date': p.date.toIso8601String(),
        'kind': p.kind.name,
        'detail': p.detail,
      };

  static MapPin _mapPinFromMap(Map<String, dynamic> m) => MapPin(
        id: m['id'] as String,
        label: m['label'] as String,
        location: m['location'] as String,
        latitude: (m['latitude'] as num).toDouble(),
        longitude: (m['longitude'] as num).toDouble(),
        date: DateTime.parse(m['date'] as String),
        kind: MapPinKind.values.byName(m['kind'] as String),
        detail: m['detail'] as String,
      );
}
