import 'package:flutter_test/flutter_test.dart';
import 'package:athletes_application/data/auth/ecosystem_auth_repository.dart';
import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('demo sign in and onboarding completes session', () async {
    final repo = EcosystemAuthRepository();

    final session = await repo.signIn(
      email: 'scout@university.demo',
      password: 'demo',
    );
    expect(session.needsOnboarding, isTrue);

    final completed = await repo.completeOnboarding(
      session: session,
      kind: StakeholderKind.scout,
      organizationName: 'Pacific University',
    );
    expect(completed.onboardingComplete, isTrue);
    expect(completed.stakeholderKind, StakeholderKind.scout);

    final restored = await repo.currentSession();
    expect(restored?.email, 'scout@university.demo');
  });

  test('invalid credentials throw AuthException', () async {
    final repo = EcosystemAuthRepository();
    expect(
      () => repo.signIn(email: 'bad@test.com', password: 'wrong'),
      throwsA(isA<AuthException>()),
    );
  });
}
