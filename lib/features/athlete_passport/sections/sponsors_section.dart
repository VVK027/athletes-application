import 'package:flutter/material.dart';
import 'package:athletes_application/core/permissions/passport_permissions.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';
import 'package:athletes_application/models/athlete_models.dart';

class SponsorsSection extends StatelessWidget {
  const SponsorsSection({super.key, required this.data, required this.viewRole});

  final AthletePassportData data;
  final AccessRole viewRole;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        PassportSectionCard(
          title: 'Sponsor management',
          subtitle: '${data.sponsors.length} active partnerships',
          trailing: PassportPermissions.canEdit(PassportFeature.sponsorsEdit, viewRole)
              ? FilledButton.tonal(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.teal.withValues(alpha: 0.15),
                    foregroundColor: AppTheme.navy,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text('Add', style: TextStyle(fontSize: 12)),
                )
              : null,
          child: Column(
            children: data.sponsors.map((s) => _SponsorCard(sponsor: s)).toList(),
          ),
        ),
      ],
    );
  }
}

class _SponsorCard extends StatelessWidget {
  const _SponsorCard({required this.sponsor});

  final Sponsor sponsor;

  @override
  Widget build(BuildContext context) {
    final tierColor = switch (sponsor.tier.toLowerCase()) {
      'gold' => AppTheme.gold,
      'silver' => Colors.grey.shade500,
      _ => AppTheme.teal,
    };
    final since = '${_month(sponsor.since.month)} ${sponsor.since.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tierColor.withValues(alpha: 0.12),
            AppTheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tierColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.handshake_outlined, color: tierColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sponsor.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppTheme.navy,
                      ),
                    ),
                    Text(
                      'Partner since $since · ${sponsor.contactName}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              RoleBadge(label: sponsor.tier, color: tierColor),
            ],
          ),
          const SizedBox(height: 12),
          Text('Benefits', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: sponsor.benefits
                .map(
                  (b) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(b, style: const TextStyle(fontSize: 12, color: AppTheme.navy)),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  String _month(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[m - 1];
  }
}
