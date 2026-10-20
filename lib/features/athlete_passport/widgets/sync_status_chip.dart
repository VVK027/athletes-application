import 'package:flutter/material.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/data/sync/sync_status.dart';
import 'package:athletes_application/features/athlete_passport/passport_scope.dart';

class SyncStatusChip extends StatelessWidget {
  const SyncStatusChip({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = PassportScope.of(context);
    final status = notifier.syncStatus;

    return ActionChip(
      avatar: Icon(_icon(status.state), size: 16, color: _color(status.state)),
      label: Text(
        _label(status),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
      onPressed: notifier.isSyncing ? null : () => notifier.syncNow(),
      backgroundColor: Colors.white.withValues(alpha: 0.12),
      labelStyle: const TextStyle(color: Colors.white),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.25)),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }

  IconData _icon(SyncState state) => switch (state) {
        SyncState.syncing => Icons.cloud_sync,
        SyncState.synced => Icons.cloud_done,
        SyncState.offline => Icons.cloud_off,
        SyncState.error => Icons.error_outline,
        SyncState.idle => Icons.cloud_outlined,
      };

  Color _color(SyncState state) => switch (state) {
        SyncState.synced => AppTheme.teal,
        SyncState.error => Colors.orangeAccent,
        SyncState.offline => Colors.white54,
        _ => Colors.white,
      };

  String _label(PassportSyncStatus status) {
    if (status.state == SyncState.syncing) return 'Syncing…';
    if (status.pendingPush) return 'Pending';
    return status.backendLabel;
  }
}
