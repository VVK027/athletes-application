/// Locale and region metadata for international expansion (i18n-ready).
class InternationalContext {
  const InternationalContext({
    required this.countryCode,
    required this.regionCode,
    required this.localeTag,
    required this.timeZoneId,
    this.currencyCode = 'USD',
  });

  /// ISO 3166-1 alpha-2 (e.g. US, GB, JP).
  final String countryCode;

  /// Platform region shard (e.g. americas, emea, apac).
  final String regionCode;

  /// BCP 47 locale (e.g. en-US, es-MX, ja-JP).
  final String localeTag;

  final String timeZoneId;
  final String currencyCode;

  static const defaultUs = InternationalContext(
    countryCode: 'US',
    regionCode: 'americas',
    localeTag: 'en-US',
    timeZoneId: 'America/Los_Angeles',
    currencyCode: 'USD',
  );
}

abstract final class PlatformRegions {
  static const americas = 'americas';
  static const emea = 'emea';
  static const apac = 'apac';
}
