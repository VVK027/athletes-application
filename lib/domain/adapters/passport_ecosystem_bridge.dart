import 'package:athletes_application/domain/ecosystem/athlete_ecosystem_identity.dart';
import 'package:athletes_application/domain/ecosystem/international_context.dart';
import 'package:athletes_application/domain/ecosystem/sport_code.dart';
import 'package:athletes_application/models/athlete_models.dart';

/// Maps the current passport aggregate into the global ecosystem identity model.
abstract final class PassportEcosystemBridge {
  static AthleteEcosystemIdentity identityFromPassport(
    AthletePassportData data, {
    InternationalContext? international,
    List<SportCode> secondarySports = const [],
    bool seekingOpportunities = false,
  }) {
    final profile = data.profile;
    return AthleteEcosystemIdentity(
      athleteId: profile.id,
      displayName: profile.fullName,
      primarySport: SportRegistry.fromLabel(profile.sport),
      secondarySports: secondarySports,
      passportId: profile.passportId,
      publicSlug: profile.publicSlug,
      international: international ?? _inferInternational(profile.nationality),
      seekingOpportunities: seekingOpportunities,
    );
  }

  static InternationalContext _inferInternational(String nationality) {
    final code = switch (nationality.toUpperCase()) {
      'USA' || 'US' => 'US',
      'UK' || 'GB' => 'GB',
      'JP' || 'JAPAN' => 'JP',
      'MX' => 'MX',
      'BR' => 'BR',
      _ => 'US',
    };
    return InternationalContext(
      countryCode: code,
      regionCode: _regionForCountry(code),
      localeTag: 'en-$code',
      timeZoneId: 'UTC',
    );
  }

  static String _regionForCountry(String code) {
    return switch (code) {
      'US' || 'MX' || 'BR' => PlatformRegions.americas,
      'GB' => PlatformRegions.emea,
      'JP' => PlatformRegions.apac,
      _ => PlatformRegions.americas,
    };
  }
}
