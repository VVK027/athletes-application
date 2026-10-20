import 'dart:convert';

import 'package:athletes_application/core/config/sync_config.dart';
import 'package:athletes_application/data/remote/passport_remote_data_source.dart';
import 'package:athletes_application/data/sync/passport_sync_envelope.dart';
import 'package:http/http.dart' as http;

/// REST client for passport sync. Falls back to an in-memory store when the
/// API is unreachable (useful for UI development without the mock server).
class PassportApiRemoteDataSource implements PassportRemoteDataSource {
  PassportApiRemoteDataSource({String? baseUrl})
      : baseUrl = baseUrl ?? SyncConfig.apiBaseUrl;

  final String baseUrl;

  static final Map<String, PassportSyncEnvelope> _memoryFallback = {};

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  @override
  Future<bool> isAvailable() async {
    try {
      final response = await http
          .get(_uri('/health'))
          .timeout(SyncConfig.httpTimeout);
      return response.statusCode == 200;
    } catch (_) {
      return _memoryFallback.isNotEmpty;
    }
  }

  @override
  Future<PassportSyncEnvelope?> fetch(String athleteId) async {
    try {
      final response = await http
          .get(_uri('/passports/$athleteId'))
          .timeout(SyncConfig.httpTimeout);
      if (response.statusCode == 404) return _memoryFallback[athleteId];
      if (response.statusCode != 200) {
        throw Exception('Fetch failed (${response.statusCode})');
      }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final envelope = PassportSyncEnvelope.fromJson(json);
      _memoryFallback[athleteId] = envelope;
      return envelope;
    } catch (_) {
      return _memoryFallback[athleteId];
    }
  }

  @override
  Future<void> push(PassportSyncEnvelope envelope) async {
    try {
      final response = await http
          .put(
            _uri('/passports/${envelope.athleteId}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(envelope.toJson()),
          )
          .timeout(SyncConfig.httpTimeout);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _memoryFallback[envelope.athleteId] = envelope;
        return;
      }
      throw Exception('Push failed (${response.statusCode})');
    } catch (_) {
      _memoryFallback[envelope.athleteId] = envelope;
    }
  }
}
