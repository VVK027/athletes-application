import 'package:flutter/material.dart';
import 'package:athletes_application/core/layout/responsive_layout.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';
import 'package:athletes_application/models/athlete_models.dart';

class PerformanceSection extends StatelessWidget {
  const PerformanceSection({super.key, required this.data});

  final AthletePassportData data;

  @override
  Widget build(BuildContext context) {
    final hasClubs = data.clubDistances.isNotEmpty;
    final maxCarry = hasClubs
        ? data.clubDistances
            .map((c) => c.carryYards)
            .reduce((a, b) => a > b ? a : b)
            .toDouble()
        : 1.0;

    final clubCard = PassportSectionCard(
      title: 'Club distances',
      subtitle: hasClubs
          ? 'Average carry · session tracking'
          : 'No club distance data for this athlete',
      child: hasClubs
          ? Column(
              children: data.clubDistances.map((club) {
                final ratio = club.carryYards / maxCarry;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 88,
                            child: Text(
                              club.clubName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.navy,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: ratio,
                                minHeight: 10,
                                backgroundColor: Colors.grey.shade200,
                                color: AppTheme.teal,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${club.carryYards} yd',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: AppTheme.navy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const SizedBox(width: 88),
                          Text(
                            '${club.accuracyPercent.toStringAsFixed(0)}% accuracy',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                          const Spacer(),
                          Text(
                            '${club.sessionsLogged} sessions',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          : const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: Text('Tracking will appear after practice sessions')),
            ),
    );

    final hasPerformance = data.performance.isNotEmpty;
    final trackingCard = PassportSectionCard(
      title: 'Performance tracking',
      subtitle: hasPerformance ? 'Progress vs targets' : 'No performance metrics yet',
      child: hasPerformance
          ? Column(
              children: data.performance.map((r) => _PerformanceRow(record: r)).toList(),
            )
          : const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: Text('Metrics will appear once targets are set')),
            ),
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        ResponsivePair(first: clubCard, second: trackingCard),
      ],
    );
  }
}

class _PerformanceRow extends StatelessWidget {
  const _PerformanceRow({required this.record});

  final PerformanceRecord record;

  @override
  Widget build(BuildContext context) {
    final pct = (record.current / record.target).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.label,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.navy),
                ),
                const SizedBox(height: 4),
                Text(
                  '${record.current.toStringAsFixed(record.unit == '%' ? 0 : 0)} / ${record.target.toStringAsFixed(0)} ${record.unit}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    color: pct >= 0.95 ? AppTheme.gold : AppTheme.teal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          MiniSparkline(values: record.history),
        ],
      ),
    );
  }
}
