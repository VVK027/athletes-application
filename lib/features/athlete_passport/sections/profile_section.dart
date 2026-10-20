import 'package:flutter/material.dart';
import 'package:athletes_application/core/layout/responsive_layout.dart';
import 'package:athletes_application/core/permissions/passport_permissions.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/sections/achievements_section.dart';
import 'package:athletes_application/features/athlete_passport/widgets/badge_icon.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';
import 'package:athletes_application/models/athlete_models.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, required this.data, required this.viewRole});

  final AthletePassportData data;
  final AccessRole viewRole;

  @override
  Widget build(BuildContext context) {
    final p = data.profile;
    final age = DateTime.now().year - p.dateOfBirth.year;

    final profileCard = PassportSectionCard(
      title: 'Player profile',
      subtitle: 'Verified digital identity',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(p.bio, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          ResponsiveWrapGrid(
            compactColumns: 2,
            mediumColumns: 3,
            expandedColumns: 5,
            children: [
              StatChip(label: 'Age', value: '$age'),
              StatChip(label: 'Height', value: '${p.heightCm}', unit: 'cm'),
              StatChip(label: 'Weight', value: '${p.weightKg}', unit: 'kg'),
              StatChip(label: 'Hand', value: p.dominantSide),
              StatChip(label: 'Nation', value: p.nationality),
            ],
          ),
        ],
      ),
    );

    final timelineCard = PassportPermissions.canView(PassportFeature.careerTimeline, viewRole)
        ? PassportSectionCard(
            title: 'Career timeline',
            subtitle: 'Milestones and progression',
            child: Column(
              children: data.careerTimeline.map((e) => _TimelineTile(event: e)).toList(),
            ),
          )
        : null;

    final badgesCard = PassportPermissions.canView(PassportFeature.achievements, viewRole) &&
            data.badges.isNotEmpty
        ? PassportSectionCard(
            title: 'Recent badges',
            subtitle:
                '${data.badges.where((b) => b.isUnlocked).length} of ${data.badges.length} earned',
            trailing: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => AchievementsSection(data: data),
                  ),
                );
              },
              child: const Text('View all'),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final badge in data.badges.where((b) => b.isUnlocked).take(5))
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor:
                                badgeColorForCategory(badge.category).withValues(alpha: 0.15),
                            child: Icon(
                              badgeIconForKey(badge.iconKey),
                              color: badgeColorForCategory(badge.category),
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 72,
                            child: Text(
                              badge.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          )
        : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        if (timelineCard != null)
          ResponsivePair(first: profileCard, second: timelineCard)
        else
          profileCard,
        ?badgesCard,
      ],
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.event});

  final CareerEvent event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 48,
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: event.isHighlight
                          ? AppTheme.gold.withValues(alpha: 0.25)
                          : AppTheme.teal.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${event.year}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: event.isHighlight ? AppTheme.navy : AppTheme.teal,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.navy,
                          ),
                        ),
                      ),
                      if (event.isHighlight)
                        const Icon(Icons.star_rounded, size: 18, color: AppTheme.gold),
                    ],
                  ),
                  Text(
                    event.subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(event.description, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
