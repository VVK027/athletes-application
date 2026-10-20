import 'package:flutter/material.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/domain/ecosystem/ecosystem_session.dart';
import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';

class OrganizationPlaceholderScreen extends StatelessWidget {
  const OrganizationPlaceholderScreen({
    super.key,
    required this.session,
    required this.onSignOut,
  });

  final EcosystemSession session;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final kind = session.stakeholderKind!;

    return Scaffold(
      appBar: AppBar(
        title: Text(kind.label),
        actions: [
          TextButton(onPressed: onSignOut, child: const Text('Sign out')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${kind.label} portal',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.navy,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Signed in as ${session.displayName}'
              '${session.organizationName != null ? ' · ${session.organizationName}' : ''}',
            ),
            const SizedBox(height: 16),
            const Text(
              'Organization dashboards for academies, universities, and federations are on the roadmap. '
              'You can still verify results and sync official data when those APIs launch.',
            ),
            const SizedBox(height: 24),
            _PlannedTile(
              icon: Icons.verified,
              title: 'Verify tournament results',
              subtitle: 'Attest placements for linked athletes',
            ),
            _PlannedTile(
              icon: Icons.leaderboard,
              title: 'Publish rankings',
              subtitle: 'Handicaps and sport-specific rating systems',
            ),
            _PlannedTile(
              icon: Icons.sync,
              title: 'Federation sync',
              subtitle: 'Connect national and international bodies',
            ),
          ],
        ),
      ),
    );
  }
}

class _PlannedTile extends StatelessWidget {
  const _PlannedTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.teal),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Chip(
          label: const Text('Planned', style: TextStyle(fontSize: 10)),
          backgroundColor: Colors.grey.shade200,
        ),
      ),
    );
  }
}
