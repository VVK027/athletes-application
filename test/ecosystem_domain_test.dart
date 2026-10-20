import 'package:flutter_test/flutter_test.dart';
import 'package:athletes_application/data/mock_athlete_data.dart';
import 'package:athletes_application/domain/adapters/passport_ecosystem_bridge.dart';
import 'package:athletes_application/domain/capabilities/ecosystem_capability.dart';
import 'package:athletes_application/domain/ecosystem/sport_code.dart';
import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';
import 'package:athletes_application/domain/modules/ecosystem_module.dart';
import 'package:athletes_application/core/platform/ecosystem_platform_config.dart';

void main() {
  test('SportRegistry resolves golf from passport label', () {
    expect(SportRegistry.resolve('Golf')?.id, 'golf');
    expect(SportRegistry.fromLabel('Cricket').category, SportCategory.other);
  });

  test('bridge builds athlete-centric identity', () {
    final identity = PassportEcosystemBridge.identityFromPassport(mockAthletePassport);
    expect(identity.athleteId, mockAthletePassport.profile.id);
    expect(identity.primarySport.id, 'golf');
    expect(identity.international.countryCode, 'US');
  });

  test('module registry marks passport features as live', () {
    final live = EcosystemModuleRegistry.byLifecycle(ModuleLifecycle.live);
    expect(live, contains(EcosystemModule.digitalPassport));
    expect(live, contains(EcosystemModule.familyPass));
    expect(EcosystemModule.verifiedResults.lifecycle, ModuleLifecycle.beta);
  });

  test('federation can verify results capability', () {
    expect(
      EcosystemCapabilityPolicy.isGranted(
        EcosystemCapability.verifyTournamentResult,
        StakeholderKind.federation,
      ),
      isTrue,
    );
    expect(
      EcosystemCapabilityPolicy.isGranted(
        EcosystemCapability.verifyTournamentResult,
        StakeholderKind.athlete,
      ),
      isFalse,
    );
  });

  test('platform config enables current live modules', () {
    expect(
      EcosystemPlatformConfig.current.isModuleEnabled(EcosystemModule.worldMap),
      isTrue,
    );
    expect(
      EcosystemPlatformConfig.current.isModuleEnabled(EcosystemModule.verifiedResults),
      isTrue,
    );
    expect(
      EcosystemPlatformConfig.current.isModuleEnabled(EcosystemModule.talentSearch),
      isTrue,
    );
  });
}
