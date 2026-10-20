import 'package:flutter/material.dart';
import 'package:athletes_application/core/permissions/passport_permissions.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/passport_notifier.dart';
import 'package:athletes_application/models/athlete_models.dart';

Future<void> showRoleSelectorSheet(BuildContext context, PassportNotifier notifier) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              'View as role',
              style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.navy,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Simulates coach, parent, sponsor, or public access',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            ...AccessRole.values.map((role) {
              final selected = notifier.viewRole == role;
              return ListTile(
                leading: Icon(_roleIcon(role), color: selected ? AppTheme.teal : Colors.grey),
                title: Text(PassportPermissions.roleLabel(role)),
                subtitle: Text(_roleDescription(role), style: const TextStyle(fontSize: 11)),
                trailing: selected ? const Icon(Icons.check_circle, color: AppTheme.teal) : null,
                onTap: () async {
                  await notifier.setViewRole(role);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  },
  );
}

IconData _roleIcon(AccessRole role) => switch (role) {
      AccessRole.athlete => Icons.person,
      AccessRole.coach => Icons.sports,
      AccessRole.parent => Icons.family_restroom,
      AccessRole.sponsor => Icons.handshake_outlined,
      AccessRole.public => Icons.public,
    };

String _roleDescription(AccessRole role) => switch (role) {
      AccessRole.athlete => 'Full passport control',
      AccessRole.coach => 'Stats, training, media upload',
      AccessRole.parent => 'Calendar, travel, public profile',
      AccessRole.sponsor => 'Sponsors & public highlights',
      AccessRole.public => 'Public profile only',
    };
