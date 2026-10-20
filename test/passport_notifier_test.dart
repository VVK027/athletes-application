import 'package:flutter_test/flutter_test.dart';
import 'package:athletes_application/data/mock_athlete_data.dart';
import 'package:athletes_application/features/athlete_passport/passport_notifier.dart';
import 'package:athletes_application/models/athlete_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('PassportNotifier preview initialization and role switching', () async {
    final notifier = PassportNotifier.preview(mockAthletePassport);
    expect(notifier.isLoading, false);
    expect(notifier.data, mockAthletePassport);
    expect(notifier.viewRole, AccessRole.athlete);

    await notifier.setViewRole(AccessRole.coach);
    expect(notifier.viewRole, AccessRole.coach);

    await notifier.setViewRole(AccessRole.sponsor);
    expect(notifier.viewRole, AccessRole.sponsor);
  });

  test('PassportNotifier family athlete switching updates active athlete', () async {
    final notifier = PassportNotifier.preview(mockAthletePassport);
    expect(notifier.activeAthleteId, mockAthletePassport.profile.id);

    await notifier.switchFamilyAthlete('ath_2849');
    expect(notifier.activeAthleteId, 'ath_2849');
    expect(notifier.data?.profile.id, 'ath_2849');
  });
}
