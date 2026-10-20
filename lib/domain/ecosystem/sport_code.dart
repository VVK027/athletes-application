/// Multi-sport support: sport-agnostic identifiers used across modules.
enum SportCategory {
  individual,
  team,
  racquet,
  aquatic,
  combat,
  other,
}

class SportCode {
  const SportCode({
    required this.id,
    required this.displayName,
    required this.category,
    this.supportsHandicap = false,
    this.supportsOfficialRanking = false,
  });

  final String id;
  final String displayName;
  final SportCategory category;
  final bool supportsHandicap;
  final bool supportsOfficialRanking;

  @override
  bool operator ==(Object other) =>
      other is SportCode && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Registry of sports the platform is designed to support over time.
abstract final class SportRegistry {
  static const golf = SportCode(
    id: 'golf',
    displayName: 'Golf',
    category: SportCategory.individual,
    supportsHandicap: true,
    supportsOfficialRanking: true,
  );

  static const tennis = SportCode(
    id: 'tennis',
    displayName: 'Tennis',
    category: SportCategory.racquet,
    supportsOfficialRanking: true,
  );

  static const soccer = SportCode(
    id: 'soccer',
    displayName: 'Soccer',
    category: SportCategory.team,
    supportsOfficialRanking: true,
  );

  static const swimming = SportCode(
    id: 'swimming',
    displayName: 'Swimming',
    category: SportCategory.aquatic,
    supportsOfficialRanking: true,
  );

  static const basketball = SportCode(
    id: 'basketball',
    displayName: 'Basketball',
    category: SportCategory.team,
    supportsOfficialRanking: true,
  );

  static const all = [golf, tennis, soccer, swimming, basketball];

  static SportCode? resolve(String sportLabel) {
    final normalized = sportLabel.trim().toLowerCase();
    for (final sport in all) {
      if (sport.id == normalized || sport.displayName.toLowerCase() == normalized) {
        return sport;
      }
    }
    return null;
  }

  static SportCode fromLabel(String sportLabel) =>
      resolve(sportLabel) ??
      SportCode(
        id: sportLabel.toLowerCase().replaceAll(' ', '_'),
        displayName: sportLabel,
        category: SportCategory.other,
      );
}
