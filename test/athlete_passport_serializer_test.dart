import 'package:flutter_test/flutter_test.dart';
import 'package:athletes_application/data/athlete_passport_serializer.dart';
import 'package:athletes_application/data/mock_athlete_data.dart';

void main() {
  test('round-trips passport data including new features', () {
    final encoded = AthletePassportSerializer.encode(mockAthletePassport);
    final decoded = AthletePassportSerializer.decode(encoded);

    expect(decoded.memoryAlbums.length, mockAthletePassport.memoryAlbums.length);
    expect(decoded.badges.length, mockAthletePassport.badges.length);
    expect(decoded.mapPins.length, mockAthletePassport.mapPins.length);
    expect(decoded.tournaments.first.latitude, mockAthletePassport.tournaments.first.latitude);
  });

  test('decodes legacy JSON without new fields', () {
    final legacy = AthletePassportSerializer.encode(mockAthletePassport);
    final map = AthletePassportSerializer.decode(legacy);
    final stripped = AthletePassportSerializer.encode(
      map.copyWith(memoryAlbums: const [], badges: const [], mapPins: const []),
    );
    final decoded = AthletePassportSerializer.decode(stripped);
    expect(decoded.memoryAlbums, isEmpty);
    expect(decoded.badges, isEmpty);
    expect(decoded.mapPins, isEmpty);
  });
}
