import 'package:flutter/material.dart';
import 'package:athletes_application/core/layout/responsive_layout.dart';
import 'package:athletes_application/core/permissions/passport_permissions.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';
import 'package:athletes_application/models/athlete_models.dart';

class AccessSection extends StatelessWidget {
  const AccessSection({super.key, required this.data, required this.viewRole});

  final AthletePassportData data;
  final AccessRole viewRole;

  @override
  Widget build(BuildContext context) {
    final accessCard = PassportSectionCard(
          title: 'Coach & parent access',
          subtitle: 'Role-based permissions',
          trailing: PassportPermissions.canEdit(PassportFeature.accessManagement, viewRole)
              ? TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add_outlined, size: 18),
                  label: const Text('Invite'),
                )
              : null,
          child: Column(
            children: data.accessContacts.map((c) => _ContactTile(contact: c)).toList(),
          ),
        );

    final permissionsCard = PassportSectionCard(
          title: 'Permission overview',
          subtitle: 'What each role can view',
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FlexColumnWidth(),
            },
            children: [
              _tableHeader(),
              _tableRow('Stats', coach: true, parent: true, sponsor: false),
              _tableRow('Calendar', coach: true, parent: true, sponsor: false),
              _tableRow('Media', coach: true, parent: false, sponsor: false),
              _tableRow('Public profile', coach: true, parent: true, sponsor: true),
            ],
          ),
        );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        ResponsivePair(first: accessCard, second: permissionsCard),
      ],
    );
  }

  TableRow _tableHeader() {
    return TableRow(
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(8)),
      children: [
        _headerCell('Feature'),
        _headerCell('Coach'),
        _headerCell('Parent'),
        _headerCell('Sponsor'),
      ],
    );
  }

  TableRow _tableRow(
    String feature, {
    required bool coach,
    required bool parent,
    required bool sponsor,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(feature, style: const TextStyle(fontSize: 12, color: AppTheme.navy)),
        ),
        _checkCell(coach),
        _checkCell(parent),
        _checkCell(sponsor),
      ],
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.navy),
      ),
    );
  }

  Widget _checkCell(bool allowed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Icon(
        allowed ? Icons.check_circle : Icons.remove_circle_outline,
        size: 18,
        color: allowed ? AppTheme.teal : Colors.grey.shade400,
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact});

  final AccessContact contact;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (contact.role) {
      AccessRole.coach => ('Coach', AppTheme.teal),
      AccessRole.parent => ('Parent', const Color(0xFF6C63FF)),
      AccessRole.sponsor => ('Sponsor', AppTheme.gold),
      _ => ('Guest', Colors.grey),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withValues(alpha: 0.2),
                child: Text(
                  contact.name.isNotEmpty ? contact.name[0] : '?',
                  style: TextStyle(fontWeight: FontWeight.w700, color: color),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.navy),
                    ),
                    Text(
                      contact.email,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              RoleBadge(label: label, color: color),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: contact.permissions
                .map(
                  (p) => Chip(
                    label: Text(p, style: const TextStyle(fontSize: 10)),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
