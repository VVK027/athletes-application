import 'package:athletes_application/domain/ecosystem/international_context.dart';
import 'package:athletes_application/domain/modules/ecosystem_module.dart';

/// Global platform configuration (environment / feature flags).
class EcosystemPlatformConfig {
  const EcosystemPlatformConfig({
    this.defaultInternational = InternationalContext.defaultUs,
    this.enabledModules = const [
      EcosystemModule.digitalPassport,
      EcosystemModule.familyPass,
      EcosystemModule.memoryAlbums,
      EcosystemModule.worldMap,
      EcosystemModule.digitalBadges,
      EcosystemModule.sponsorMarketplace,
      EcosystemModule.publicDiscovery,
      EcosystemModule.verifiedResults,
      EcosystemModule.talentSearch,
    ],
    this.platformName = 'Athletes Ecosystem',
    this.platformTagline =
        'Athlete-centered careers, verified results, and worldwide discovery',
  });

  final InternationalContext defaultInternational;
  final List<EcosystemModule> enabledModules;
  final String platformName;
  final String platformTagline;

  static const current = EcosystemPlatformConfig();

  bool isModuleEnabled(EcosystemModule module) => enabledModules.contains(module);
}
