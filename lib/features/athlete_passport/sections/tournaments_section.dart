import 'package:flutter/material.dart';
import 'package:athletes_application/core/layout/responsive_layout.dart';
import 'package:athletes_application/core/permissions/passport_permissions.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';
import 'package:athletes_application/models/athlete_models.dart';

class TournamentsSection extends StatelessWidget {
  const TournamentsSection({super.key, required this.data, required this.viewRole});

  final AthletePassportData data;
  final AccessRole viewRole;

  @override
  Widget build(BuildContext context) {
    final showStats = PassportPermissions.canView(PassportFeature.stats, viewRole);
    final showTournaments = PassportPermissions.canView(PassportFeature.tournaments, viewRole);

    if (!showStats && !showTournaments) {
      return const Center(child: Text('No results available'));
    }

    final statsCard = showStats
        ? PassportSectionCard(
            title: 'Season statistics',
            subtitle: 'Rolling 12-month performance',
            child: _SeasonStatsGrid(stats: data.stats),
          )
        : null;

    final resultsCard = showTournaments
        ? PassportSectionCard(
            title: 'Tournament results',
            subtitle: '${data.tournaments.length} recent events',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: data.tournaments.map((t) => _ResultTile(result: t)).toList(),
            ),
          )
        : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        if (statsCard != null && resultsCard != null)
          ResponsivePair(first: statsCard, second: resultsCard)
        else ...[
          ?statsCard,
          ?resultsCard,
        ],
      ],
    );
  }
}

class _SeasonStatsGrid extends StatelessWidget {
  const _SeasonStatsGrid({required this.stats});

  final List<StatMetric> stats;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 8.0;
        final columns = constraints.maxWidth < 220 ? 1 : 2;
        final totalSpacing = spacing * (columns - 1);
        final cellWidth = (constraints.maxWidth - totalSpacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.start,
          children: [
            for (final metric in stats)
              SizedBox(
                width: cellWidth,
                child: _StatTile(metric: metric),
              ),
          ],
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.metric});

  final StatMetric metric;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tightHeight = constraints.hasBoundedHeight &&
            constraints.maxHeight < 72 &&
            constraints.maxHeight != double.infinity;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: tightHeight ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      metric.label,
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TrendBadge(trend: metric.trend),
                ],
              ),
              SizedBox(height: tightHeight ? 2 : 4),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: metric.value,
                      style: TextStyle(
                        fontSize: tightHeight ? 16 : 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.navy,
                      ),
                    ),
                    TextSpan(
                      text: metric.unit.isEmpty ? '' : ' ${metric.unit}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!tightHeight) ...[
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: metric.progress,
                    minHeight: 3,
                    backgroundColor: Colors.grey.shade200,
                    color: AppTheme.teal,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.result});

  final TournamentResult result;

  @override
  Widget build(BuildContext context) {
    final date =
        '${_month(result.date.month)} ${result.date.day}, ${result.date.year}';
    final isWin = result.placement == '1st';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWin ? AppTheme.gold.withValues(alpha: 0.5) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isWin
                  ? AppTheme.gold.withValues(alpha: 0.2)
                  : AppTheme.teal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              result.placement,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: isWin ? AppTheme.navy : AppTheme.teal,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.navy),
                ),
                Text(
                  '$date · ${result.location}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                Text(
                  '${result.category} · ${result.score}',
                  style: TextStyle(fontSize: 12, color: AppTheme.teal, fontWeight: FontWeight.w500),
                ),
              ],
            ),
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
