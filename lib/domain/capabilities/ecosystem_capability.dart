import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';
import 'package:athletes_application/domain/modules/ecosystem_module.dart';

/// Fine-grained actions the platform will gate per stakeholder (future auth).
enum EcosystemCapability {
  viewPassport,
  editPassport,
  manageFamilyAccounts,
  uploadMedia,
  verifyTournamentResult,
  publishRanking,
  writeCoachReport,
  expressSponsorInterest,
  manageSponsorshipDeal,
  searchTalent,
  viewScoutProfile,
  federatedDataSync,
}

abstract final class EcosystemCapabilityPolicy {
  static bool isGranted(EcosystemCapability capability, StakeholderKind kind) {
    return switch (kind) {
      StakeholderKind.athlete => _athlete(capability),
      StakeholderKind.parent => _parent(capability),
      StakeholderKind.coach => _coach(capability),
      StakeholderKind.sponsor => _sponsor(capability),
      StakeholderKind.scout || StakeholderKind.university => _scout(capability),
      StakeholderKind.academy => _academy(capability),
      StakeholderKind.federation => _federation(capability),
      StakeholderKind.publicViewer => capability == EcosystemCapability.viewScoutProfile,
    };
  }

  static bool _athlete(EcosystemCapability c) => switch (c) {
        EcosystemCapability.manageFamilyAccounts ||
        EcosystemCapability.verifyTournamentResult ||
        EcosystemCapability.publishRanking ||
        EcosystemCapability.federatedDataSync =>
          false,
        _ => true,
      };

  static bool _parent(EcosystemCapability c) => switch (c) {
        EcosystemCapability.viewPassport ||
        EcosystemCapability.manageFamilyAccounts ||
        EcosystemCapability.viewScoutProfile =>
          true,
        EcosystemCapability.editPassport => false,
        _ => false,
      };

  static bool _coach(EcosystemCapability c) => switch (c) {
        EcosystemCapability.viewPassport ||
        EcosystemCapability.uploadMedia ||
        EcosystemCapability.writeCoachReport =>
          true,
        _ => false,
      };

  static bool _sponsor(EcosystemCapability c) => switch (c) {
        EcosystemCapability.viewScoutProfile ||
        EcosystemCapability.expressSponsorInterest ||
        EcosystemCapability.manageSponsorshipDeal ||
        EcosystemCapability.searchTalent =>
          true,
        _ => false,
      };

  static bool _scout(EcosystemCapability c) => switch (c) {
        EcosystemCapability.viewScoutProfile ||
        EcosystemCapability.searchTalent =>
          true,
        _ => false,
      };

  static bool _academy(EcosystemCapability c) => switch (c) {
        EcosystemCapability.viewPassport ||
        EcosystemCapability.verifyTournamentResult ||
        EcosystemCapability.writeCoachReport =>
          true,
        _ => false,
      };

  static bool _federation(EcosystemCapability c) => switch (c) {
        EcosystemCapability.verifyTournamentResult ||
        EcosystemCapability.publishRanking ||
        EcosystemCapability.federatedDataSync =>
          true,
        _ => false,
      };

  /// Modules a stakeholder can access when fully implemented.
  static List<EcosystemModule> modulesFor(StakeholderKind kind) =>
      EcosystemModuleRegistry.all
          .where(
            (m) => m.primaryStakeholders.contains(kind) || kind == StakeholderKind.athlete,
          )
          .toList();
}
