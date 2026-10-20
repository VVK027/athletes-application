import 'package:flutter_test/flutter_test.dart';
import 'package:athletes_application/data/athlete_passport_serializer.dart';
import 'package:athletes_application/data/mock_athlete_data.dart';

void main() {
  test('serializes and deserializes passport data', () {
    final json = AthletePassportSerializer.encode(mockAthletePassport);
    final restored = AthletePassportSerializer.decode(json);

    expect(restored.profile.fullName, mockAthletePassport.profile.fullName);
    expect(restored.media.length, mockAthletePassport.media.length);
    expect(restored.media.first.remoteUrl, isNotNull);
    expect(restored.calendarEvents.length, mockAthletePassport.calendarEvents.length);
  });
}
