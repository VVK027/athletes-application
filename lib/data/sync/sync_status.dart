enum SyncState { idle, syncing, synced, offline, error }

class PassportSyncStatus {
  const PassportSyncStatus({
    this.state = SyncState.idle,
    this.lastSyncedAt,
    this.pendingPush = false,
    this.message,
    this.backendLabel = 'Local',
  });

  final SyncState state;
  final DateTime? lastSyncedAt;
  final bool pendingPush;
  final String? message;
  final String backendLabel;

  PassportSyncStatus copyWith({
    SyncState? state,
    DateTime? lastSyncedAt,
    bool? pendingPush,
    String? message,
    String? backendLabel,
  }) {
    return PassportSyncStatus(
      state: state ?? this.state,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      pendingPush: pendingPush ?? this.pendingPush,
      message: message ?? this.message,
      backendLabel: backendLabel ?? this.backendLabel,
    );
  }
}
