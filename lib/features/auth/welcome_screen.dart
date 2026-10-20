import 'package:flutter/material.dart';
import 'package:athletes_application/core/config/ecosystem_auth_config.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/domain/ecosystem/ecosystem_session.dart';
import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';
import 'package:athletes_application/features/auth/ecosystem_auth_notifier.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.auth});

  final EcosystemAuthNotifier auth;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _email = TextEditingController(text: 'maya@athlete.demo');
  final _password = TextEditingController(text: 'demo');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = widget.auth;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Icon(Icons.hub, size: 48, color: AppTheme.teal),
                const SizedBox(height: 12),
                Text(
                  'Athletes Ecosystem',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.navy,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to connect athletes, families, coaches, sponsors, and scouts worldwide.',
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
                if (EcosystemAuthConfig.useDemoAuth && !EcosystemAuthConfig.useFirebaseAuth) ...[
                  const SizedBox(height: 12),
                  Material(
                    color: AppTheme.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, size: 18, color: AppTheme.navy),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Demo mode — Firebase Auth is disabled. Use demo accounts below.',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _password,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                if (auth.error != null) ...[
                  const SizedBox(height: 12),
                  Text(auth.error!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () async {
                    final ok = await auth.signIn(_email.text, _password.text);
                    if (!ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(auth.error ?? 'Sign in failed')),
                      );
                    }
                  },
                  child: const Text('Sign in'),
                ),
                const SizedBox(height: 24),
                Text(
                  'Demo accounts (password: demo)',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.navy,
                      ),
                ),
                const SizedBox(height: 8),
                ...DemoAccounts.all.map(
                  (account) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      dense: true,
                      title: Text(account.displayName),
                      subtitle: Text('${account.email} · ${account.suggestedStakeholder.label}'),
                      trailing: const Icon(Icons.login, size: 18),
                      onTap: () async {
                        _email.text = account.email;
                        _password.text = account.password;
                        await auth.signIn(account.email, account.password);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
