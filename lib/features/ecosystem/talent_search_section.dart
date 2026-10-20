import 'package:flutter/material.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/domain/contracts/ecosystem_repositories.dart';
import 'package:athletes_application/domain/ecosystem/sport_code.dart';
import 'package:athletes_application/features/athlete_passport/passport_scope.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';

class TalentSearchSection extends StatefulWidget {
  const TalentSearchSection({super.key});

  @override
  State<TalentSearchSection> createState() => _TalentSearchSectionState();
}

class _TalentSearchSectionState extends State<TalentSearchSection> {
  final _query = TextEditingController();
  SportCode? _sport;
  bool _seekingOnly = true;
  int? _minAge;
  int? _maxAge;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final notifier = PassportScope.of(context);
    await notifier.searchTalent(
      TalentSearchCriteria(
        sport: _sport,
        query: _query.text,
        seekingSponsorOnly: _seekingOnly,
        minAge: _minAge,
        maxAge: _maxAge,
        countryCode: 'US',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = PassportScope.of(context);
    final results = notifier.talentSearchResults;
    final searching = notifier.isSearchingTalent;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        PassportSectionCard(
          title: 'Talent discovery',
          subtitle: 'Search athletes for recruiting and sponsorship',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _query,
                decoration: const InputDecoration(
                  labelText: 'Search by name or sport',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('All sports'),
                    selected: _sport == null,
                    onSelected: (_) => setState(() => _sport = null),
                  ),
                  for (final sport in SportRegistry.all)
                    FilterChip(
                      label: Text(sport.displayName),
                      selected: _sport?.id == sport.id,
                      onSelected: (_) => setState(() => _sport = sport),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Seeking sponsor'),
                value: _seekingOnly,
                onChanged: (v) => setState(() => _seekingOnly = v),
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int?>(
                      initialValue: _minAge,
                      decoration: const InputDecoration(
                        labelText: 'Min age',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Any')),
                        for (final a in [12, 14, 16, 18])
                          DropdownMenuItem(value: a, child: Text('$a')),
                      ],
                      onChanged: (v) => setState(() => _minAge = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int?>(
                      initialValue: _maxAge,
                      decoration: const InputDecoration(
                        labelText: 'Max age',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Any')),
                        for (final a in [14, 16, 18, 22])
                          DropdownMenuItem(value: a, child: Text('$a')),
                      ],
                      onChanged: (v) => setState(() => _maxAge = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: searching ? null : _search,
                icon: searching
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.travel_explore),
                label: Text(searching ? 'Searching…' : 'Search athletes'),
              ),
            ],
          ),
        ),
        PassportSectionCard(
          title: 'Results',
          subtitle: '${results.length} athletes found',
          child: results.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Run a search to discover athletes worldwide.'),
                )
              : Column(
                  children: results.map((hit) => _HitTile(hit: hit)).toList(),
                ),
        ),
      ],
    );
  }
}

class _HitTile extends StatelessWidget {
  const _HitTile({required this.hit});

  final TalentSearchHit hit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.teal.withValues(alpha: 0.15),
          child: Text(
            hit.displayName.split(' ').map((w) => w[0]).take(2).join(),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
          ),
        ),
        title: Text(hit.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${hit.sport.displayName} · ${hit.region}'),
        trailing: IconButton(
          icon: const Icon(Icons.bookmark_add_outlined),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Saved ${hit.displayName} to recruiting list')),
            );
          },
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Open public profile: ${hit.publicSlug}')),
          );
        },
      ),
    );
  }
}
