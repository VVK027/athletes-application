import 'package:flutter/material.dart';
import 'package:athletes_application/core/layout/responsive_layout.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/widgets/badge_icon.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';
import 'package:athletes_application/models/athlete_models.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key, required this.data});

  final AthletePassportData data;

  @override
  Widget build(BuildContext context) {
    final unlocked = data.badges.where((b) => b.isUnlocked).length;
    final total = data.badges.length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        PassportSectionCard(
          title: 'Digital badges',
          subtitle: '$unlocked of $total earned',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = context.gridColumns(compact: 2, medium: 3, expanded: 4);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: data.badges.length,
                itemBuilder: (context, index) => _BadgeTile(badge: data.badges[index]),
              );
            },
          ),
        ),
        if (data.badges.any((b) => !b.isUnlocked))
          PassportSectionCard(
            title: 'In progress',
            subtitle: 'Keep competing to unlock',
            child: Column(
              children: [
                for (final badge in data.badges.where((b) => !b.isUnlocked))
                  _InProgressBadgeRow(badge: badge),
              ],
            ),
          ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge});

  final AchievementBadge badge;

  @override
  Widget build(BuildContext context) {
    final color = badgeColorForCategory(badge.category);
    final dimmed = !badge.isUnlocked;

    return Opacity(
      opacity: dimmed ? 0.45 : 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(badgeIconForKey(badge.iconKey), size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              badge.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.navy,
              ),
            ),
            if (badge.isUnlocked && badge.earnedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  badge.earnedAt!.toString().split(' ').first,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InProgressBadgeRow extends StatelessWidget {
  const _InProgressBadgeRow({required this.badge});

  final AchievementBadge badge;

  @override
  Widget build(BuildContext context) {
    final progress = badge.progress ?? 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(badgeIconForKey(badge.iconKey), color: AppTheme.teal, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      badge.title,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.navy),
                    ),
                    Text(
                      badge.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Text('${(progress * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: AppTheme.teal.withValues(alpha: 0.15),
            color: AppTheme.teal,
          ),
        ],
      ),
    );
  }
}
