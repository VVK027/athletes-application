import 'package:athletes_application/data/athlete_passport_serializer.dart';
import 'package:athletes_application/models/athlete_models.dart';

class PassportSyncEnvelope {
  const PassportSyncEnvelope({
    required this.athleteId,
    required this.data,
    required this.isProfilePublic,
    required this.updatedAt,
  });

  final String athleteId;
  final AthletePassportData data;
  final bool isProfilePublic;
  final DateTime updatedAt;

  factory PassportSyncEnvelope.fromJson(Map<String, dynamic> json) {
    return PassportSyncEnvelope(
      athleteId: json['athleteId'] as String,
      data: AthletePassportSerializer.decode(json['data'] as String),
      isProfilePublic: json['isProfilePublic'] as bool? ?? true,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'athleteId': athleteId,
        'data': AthletePassportSerializer.encode(data),
        'isProfilePublic': isProfilePublic,
        'updatedAt': updatedAt.toUtc().toIso8601String(),
      };

  PassportSyncEnvelope copyWithUpdated(DateTime at) => PassportSyncEnvelope(
        athleteId: athleteId,
        data: data,
        isProfilePublic: isProfilePublic,
        updatedAt: at,
      );
}
