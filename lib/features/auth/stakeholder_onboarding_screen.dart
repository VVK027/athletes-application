import 'package:flutter/material.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';
import 'package:athletes_application/features/auth/ecosystem_auth_notifier.dart';

class StakeholderOnboardingScreen extends StatefulWidget {
  const StakeholderOnboardingScreen({super.key, required this.auth});

  final EcosystemAuthNotifier auth;

  @override
  State<StakeholderOnboardingScreen> createState() => _StakeholderOnboardingScreenState();
}

class _StakeholderOnboardingScreenState extends State<StakeholderOnboardingScreen> {
  StakeholderKind? _selected;
  final _organization = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = widget.auth.session?.stakeholderKind;
    _organization.text = widget.auth.session?.organizationName ?? '';
  }

  @override
  void dispose() {
    _organization.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.auth.session!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join the ecosystem'),
        actions: [
          TextButton(
            onPressed: () => widget.auth.signOut(),
            child: const Text('Sign out'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Welcome, ${session.displayName}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.navy,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose how you participate in the global athlete network. You can connect with athletes, opportunities, and verified results based on your role.',
          ),
          const SizedBox(height: 20),
          ...StakeholderKind.values.map((kind) {
            final selected = _selected == kind;
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: selected ? AppTheme.teal.withValues(alpha: 0.08) : null,
              child: ListTile(
                title: Text(kind.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(kind.description, style: const TextStyle(fontSize: 12)),
                trailing: selected ? const Icon(Icons.check_circle, color: AppTheme.teal) : null,
                onTap: () => setState(() => _selected = kind),
              ),
            );
          }),
          const SizedBox(height: 12),
          TextField(
            controller: _organization,
            decoration: const InputDecoration(
              labelText: 'Organization (optional)',
              border: OutlineInputBorder(),
              hintText: 'Academy, university, sponsor, or federation',
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _selected == null
                ? null
                : () async {
                    await widget.auth.completeOnboarding(
                      kind: _selected!,
                      organizationName:
                          _organization.text.trim().isEmpty ? null : _organization.text.trim(),
                    );
                  },
            child: const Text('Continue to platform'),
          ),
        ],
      ),
    );
  }
}
