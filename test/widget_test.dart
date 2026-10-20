import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:athletes_application/data/mock_athlete_data.dart';
import 'package:athletes_application/features/athlete_passport/passport_app.dart';
import 'package:athletes_application/features/athlete_passport/passport_notifier.dart';
import 'package:athletes_application/models/athlete_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Athlete passport loads with profile', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      PassportApp(notifier: PassportNotifier.preview(mockAthletePassport)),
    );
    await tester.pump();

    expect(find.text('Athletes Ecosystem'), findsOneWidget);
    expect(find.text('Maya Chen'), findsNWidgets(2));
    expect(find.textContaining('Family Pass'), findsOneWidget);
    expect(find.text('DAP-2026-2847'), findsOneWidget);
  });

  testWidgets('Navigation shows tournament results', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      PassportApp(notifier: PassportNotifier.preview(mockAthletePassport)),
    );
    await tester.pump();

    await tester.tap(find.text('Results'));
    await tester.pump();

    expect(find.text('Season statistics'), findsOneWidget);
    expect(find.text('Pacific Junior Open'), findsOneWidget);
  });

  testWidgets('Public role shows only public profile content', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final notifier = PassportNotifier.preview(mockAthletePassport);
    await tester.pumpWidget(PassportApp(notifier: notifier));
    await tester.pump();

    await notifier.setViewRole(AccessRole.public);
    await tester.pump();

    expect(find.text('Viewing as Public'), findsOneWidget);
    expect(find.text('Public athlete profile'), findsOneWidget);
    expect(find.text('Results'), findsNothing);
  });
}
