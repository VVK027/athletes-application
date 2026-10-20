import 'package:flutter/material.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/domain/contracts/ecosystem_repositories.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';

class VerifiedResultsSection extends StatelessWidget {
  const VerifiedResultsSection({super.key, required this.results});

  final List<VerifiedTournamentResult> results;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        PassportSectionCard(
          title: 'Verified tournament results',
          subtitle: 'Attested by federations, academies, or official scorers',
          child: results.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text('No verified results yet for this athlete'),
                  ),
                )
              : Column(
                  children: results.map((r) => _VerifiedTile(result: r)).toList(),
                ),
        ),
        PassportSectionCard(
          title: 'Verification standard',
          subtitle: 'Trust layer for global competition',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _trustRow(Icons.verified_user, 'Cryptographic attestation (roadmap)'),
              _trustRow(Icons.account_balance, 'Federation & academy sign-off'),
              _trustRow(Icons.public, 'Cross-border result portability'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _trustRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.teal),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _VerifiedTile extends StatelessWidget {
  const _VerifiedTile({required this.result});

  final VerifiedTournamentResult result;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppTheme.gold,
          child: Icon(Icons.verified, color: Colors.white, size: 20),
        ),
        title: Text(
          result.eventName,
          style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.navy),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${result.placement} · ${result.sport.displayName}'),
            const SizedBox(height: 4),
            Text(
              'Verified by ${result.verifiedBy}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            Text(
              result.verifiedAt.toString().split(' ').first,
              style: const TextStyle(fontSize: 11, color: AppTheme.teal),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
