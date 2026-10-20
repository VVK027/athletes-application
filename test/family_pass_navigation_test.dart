import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:athletes_application/data/mock_athlete_data.dart';
import 'package:athletes_application/features/athlete_passport/passport_app.dart';
import 'package:athletes_application/features/athlete_passport/passport_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Family Pass screen has PassportScope when pushed from More', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      PassportApp(notifier: PassportNotifier.preview(mockAthletePassport)),
    );
    await tester.pump();

    await tester.tap(find.text('More'));
    await tester.pump();
    await tester.tap(find.text('Family Pass'));
    await tester.pumpAndSettle();

    expect(find.text('Active passport'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Track tab handles athlete with empty performance data', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final notifier = PassportNotifier.preview(mockAthletePassport);
    await tester.pumpWidget(PassportApp(notifier: notifier));
    await tester.pump();

    await notifier.switchFamilyAthlete('ath_2848');
    await tester.pump();

    await tester.tap(find.text('Track'));
    await tester.pumpAndSettle();

    expect(find.text('Club distances'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
