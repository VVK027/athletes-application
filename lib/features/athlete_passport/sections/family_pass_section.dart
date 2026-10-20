import 'package:flutter/material.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/passport_scope.dart';
import 'package:athletes_application/features/athlete_passport/widgets/family_athlete_switcher.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';
import 'package:athletes_application/models/athlete_models.dart';

class FamilyPassSection extends StatelessWidget {
  const FamilyPassSection({
    super.key,
    required this.familyPass,
    required this.activeAthleteId,
    required this.data,
  });

  final FamilyPassAccount familyPass;
  final String activeAthleteId;
  final AthletePassportData data;

  @override
  Widget build(BuildContext context) {
    final notifier = PassportScope.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        PassportSectionCard(
          title: familyPass.planLabel,
          subtitle: 'One parent account · multiple athlete passports',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(label: 'Account holder', value: familyPass.parentName),
              _InfoRow(label: 'Account ID', value: familyPass.accountId),
              _InfoRow(
                label: 'Athletes linked',
                value: '${familyPass.athletes.length} of ${familyPass.maxAthletes}',
              ),
              const SizedBox(height: 12),
              FamilyAthleteSwitcher(
                familyPass: familyPass,
                activeAthleteId: activeAthleteId,
              ),
            ],
          ),
        ),
        PassportSectionCard(
          title: 'Active passport',
          subtitle: data.profile.passportId,
          child: Column(
            children: [
              for (final athlete in familyPass.athletes)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.teal.withValues(alpha: 0.15),
                    child: Text(
                      athlete.avatarInitials,
                      style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.navy),
                    ),
                  ),
                  title: Text(
                    athlete.fullName,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.navy),
                  ),
                  subtitle: Text('${athlete.sport} · Age ${athlete.age} · ${athlete.passportId}'),
                  trailing: athlete.athleteId == activeAthleteId
                      ? const Chip(
                          label: Text('Active'),
                          backgroundColor: AppTheme.teal,
                          labelStyle: TextStyle(color: Colors.white, fontSize: 11),
                        )
                      : TextButton(
                          onPressed: () => notifier.switchFamilyAthlete(athlete.athleteId),
                          child: const Text('Open'),
                        ),
                ),
            ],
          ),
        ),
        PassportSectionCard(
          title: 'What Family Pass includes',
          subtitle: 'Shared billing and centralized control',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _benefit(Icons.switch_account, 'Switch between linked athletes instantly'),
              _benefit(Icons.calendar_month, 'Unified family calendar across sports'),
              _benefit(Icons.perm_media, 'Separate memory albums per athlete'),
              _benefit(Icons.admin_panel_settings, 'Parent-managed privacy and public profiles'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _benefit(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.teal),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.navy),
            ),
          ),
        ],
      ),
    );
  }
}
