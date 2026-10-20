import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:athletes_application/core/layout/responsive_layout.dart';
import 'package:athletes_application/core/permissions/passport_permissions.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/passport_scope.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';
import 'package:athletes_application/models/athlete_models.dart';

class PublicProfileSection extends StatelessWidget {
  const PublicProfileSection({
    super.key,
    required this.data,
    required this.isProfilePublic,
    required this.viewRole,
  });

  final AthletePassportData data;
  final bool isProfilePublic;
  final AccessRole viewRole;

  @override
  Widget build(BuildContext context) {
    final p = data.profile;
    final publicUrl = 'athletepassport.app/${p.publicSlug}';

    final profileCard = PassportSectionCard(
          title: 'Public athlete profile',
          subtitle: 'Shareable link for scouts & sponsors',
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.navy, Color(0xFF1B3A4B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppTheme.teal.withValues(alpha: 0.3),
                      child: Text(
                        p.avatarInitials,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      p.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${p.sport} · ${p.club}',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _PublicStat(label: 'Events', value: '${data.tournaments.length}'),
                        _PublicStat(label: 'Avg', value: data.stats.first.value),
                        _PublicStat(label: 'Sponsors', value: '${data.sponsors.length}'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.link, size: 18, color: AppTheme.teal),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        publicUrl,
                        style: const TextStyle(fontSize: 12, color: AppTheme.navy),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: publicUrl));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link copied')),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      tooltip: 'Copy link',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text('Preview'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share_outlined, size: 18),
                      label: const Text('Share'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.teal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

    final highlightsCard = PassportSectionCard(
          title: 'Public highlights',
          subtitle: 'Visible on shared profile',
          child: Column(
            children: data.publicHighlights
                .map(
                  (h) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppTheme.teal, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(h, style: const TextStyle(color: AppTheme.navy)),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        ResponsivePair(first: profileCard, second: highlightsCard),
        if (PassportPermissions.canEdit(PassportFeature.publicProfileEdit, viewRole))
          PassportSectionCard(
            title: 'Profile visibility',
            child: SwitchListTile(
              value: isProfilePublic,
              onChanged: (v) => PassportScope.of(context).setProfilePublic(v),
              title: const Text('Profile is public', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Coaches and sponsors can discover you'),
              activeThumbColor: AppTheme.teal,
              contentPadding: EdgeInsets.zero,
            ),
          )
        else if (!isProfilePublic)
          PassportSectionCard(
            title: 'Profile visibility',
            child: const ListTile(
              leading: Icon(Icons.lock_outline, color: Colors.grey),
              title: Text('This profile is private'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
      ],
    );
  }
}

class _PublicStat extends StatelessWidget {
  const _PublicStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.gold,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
        ),
      ],
    );
  }
}
