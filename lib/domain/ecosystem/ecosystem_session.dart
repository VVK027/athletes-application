import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';

class EcosystemSession {
  const EcosystemSession({
    required this.userId,
    required this.email,
    required this.displayName,
    this.stakeholderKind,
    this.organizationName,
    this.onboardingComplete = false,
  });

  final String userId;
  final String email;
  final String displayName;
  final StakeholderKind? stakeholderKind;
  final String? organizationName;
  final bool onboardingComplete;

  bool get needsOnboarding => !onboardingComplete || stakeholderKind == null;

  EcosystemSession copyWith({
    String? userId,
    String? email,
    String? displayName,
    StakeholderKind? stakeholderKind,
    String? organizationName,
    bool? onboardingComplete,
  }) {
    return EcosystemSession(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      stakeholderKind: stakeholderKind ?? this.stakeholderKind,
      organizationName: organizationName ?? this.organizationName,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }
}

/// Demo accounts for local auth (replace with Firebase Auth later).
class DemoAccount {
  const DemoAccount({
    required this.email,
    required this.password,
    required this.displayName,
    required this.suggestedStakeholder,
    this.organizationName,
  });

  final String email;
  final String password;
  final String displayName;
  final StakeholderKind suggestedStakeholder;
  final String? organizationName;
}

abstract final class DemoAccounts {
  static const all = [
    DemoAccount(
      email: 'maya@athlete.demo',
      password: 'demo',
      displayName: 'Maya Chen',
      suggestedStakeholder: StakeholderKind.athlete,
    ),
    DemoAccount(
      email: 'parent@family.demo',
      password: 'demo',
      displayName: 'Lisa Chen',
      suggestedStakeholder: StakeholderKind.parent,
    ),
    DemoAccount(
      email: 'coach@academy.demo',
      password: 'demo',
      displayName: 'Coach David Park',
      suggestedStakeholder: StakeholderKind.coach,
      organizationName: 'Riverside Golf Academy',
    ),
    DemoAccount(
      email: 'sponsor@brand.demo',
      password: 'demo',
      displayName: 'Alex Rivera',
      suggestedStakeholder: StakeholderKind.sponsor,
      organizationName: 'GreenDrive Sports',
    ),
    DemoAccount(
      email: 'scout@university.demo',
      password: 'demo',
      displayName: 'Jordan Blake',
      suggestedStakeholder: StakeholderKind.scout,
      organizationName: 'Pacific University Athletics',
    ),
    DemoAccount(
      email: 'federation@official.demo',
      password: 'demo',
      displayName: 'US Junior Golf',
      suggestedStakeholder: StakeholderKind.federation,
      organizationName: 'US Junior Golf Association',
    ),
  ];

  static DemoAccount? match(String email, String password) {
    final normalized = email.trim().toLowerCase();
    for (final account in all) {
      if (account.email == normalized && account.password == password) {
        return account;
      }
    }
    return null;
  }
}
