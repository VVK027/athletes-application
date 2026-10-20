import 'package:flutter/material.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';
import 'package:athletes_application/models/athlete_models.dart';

class SponsorMarketplaceSection extends StatefulWidget {
  const SponsorMarketplaceSection({super.key, required this.athletes});

  final List<MarketplaceAthlete> athletes;

  @override
  State<SponsorMarketplaceSection> createState() => _SponsorMarketplaceSectionState();
}

class _SponsorMarketplaceSectionState extends State<SponsorMarketplaceSection> {
  String? _sportFilter;
  bool _seekingOnly = true;

  @override
  Widget build(BuildContext context) {
    final sports = widget.athletes.map((a) => a.sport).toSet().toList()..sort();
    var list = widget.athletes;
    if (_sportFilter != null) {
      list = list.where((a) => a.sport == _sportFilter).toList();
    }
    if (_seekingOnly) {
      list = list.where((a) => a.seekingSponsor).toList();
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        PassportSectionCard(
          title: 'Sponsor marketplace',
          subtitle: 'Discover athletes open to partnerships',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text('All sports'),
                    selected: _sportFilter == null,
                    onSelected: (_) => setState(() => _sportFilter = null),
                  ),
                  for (final sport in sports)
                    FilterChip(
                      label: Text(sport),
                      selected: _sportFilter == sport,
                      onSelected: (_) => setState(() => _sportFilter = sport),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Seeking sponsor only'),
                value: _seekingOnly,
                onChanged: (v) => setState(() => _seekingOnly = v),
              ),
            ],
          ),
        ),
        if (list.isEmpty)
          const PassportSectionCard(
            title: 'No matches',
            subtitle: 'Try adjusting filters',
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No athletes match your filters.'),
            ),
          )
        else
          for (final athlete in list) _AthleteListingCard(athlete: athlete),
      ],
    );
  }
}

class _AthleteListingCard extends StatelessWidget {
  const _AthleteListingCard({required this.athlete});

  final MarketplaceAthlete athlete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.teal.withValues(alpha: 0.15),
                  child: Text(
                    athlete.avatarInitials,
                    style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.navy),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        athlete.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.navy,
                        ),
                      ),
                      Text(
                        '${athlete.sport} · Age ${athlete.age} · ${athlete.region}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                if (athlete.seekingSponsor)
                  const Chip(
                    label: Text('Open'),
                    backgroundColor: AppTheme.teal,
                    labelStyle: TextStyle(color: Colors.white, fontSize: 11),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.leaderboard, size: 16, color: AppTheme.gold),
                const SizedBox(width: 6),
                Text(
                  '${athlete.rankingPoints} ranking pts',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  athlete.publicSlug,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...athlete.highlights.map(
              (h) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 14, color: AppTheme.teal),
                    const SizedBox(width: 6),
                    Expanded(child: Text(h, style: const TextStyle(fontSize: 12))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('View public profile'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Interest sent to ${athlete.fullName}')),
                    );
                  },
                  child: const Text('Express interest'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
