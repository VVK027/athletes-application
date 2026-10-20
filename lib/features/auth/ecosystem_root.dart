import 'package:flutter/material.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/domain/contracts/ecosystem_repositories.dart';
import 'package:athletes_application/domain/ecosystem/ecosystem_session.dart';
import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';
import 'package:athletes_application/models/athlete_models.dart';
import 'package:athletes_application/features/athlete_passport/athlete_passport_screen.dart';
import 'package:athletes_application/features/athlete_passport/passport_notifier.dart';
import 'package:athletes_application/features/athlete_passport/passport_scope.dart';
import 'package:athletes_application/features/auth/ecosystem_auth_notifier.dart';
import 'package:athletes_application/features/auth/stakeholder_onboarding_screen.dart';
import 'package:athletes_application/features/auth/welcome_screen.dart';
import 'package:athletes_application/features/ecosystem/organization_placeholder_screen.dart';

class EcosystemRoot extends StatefulWidget {
  const EcosystemRoot({
    super.key,
    this.passportNotifier,
    this.authNotifier,
    this.skipAuth = false,
  });

  final PassportNotifier? passportNotifier;
  final EcosystemAuthNotifier? authNotifier;
  final bool skipAuth;

  @override
  State<EcosystemRoot> createState() => _EcosystemRootState();
}

class _EcosystemRootState extends State<EcosystemRoot> {
  late final EcosystemAuthNotifier _auth;
  late final PassportNotifier _passport;
  late final bool _ownsAuth;
  late final bool _ownsPassport;
  bool _passportBootstrapped = false;
  bool _passportInitializing = false;

  @override
  void initState() {
    super.initState();
    _ownsAuth = widget.authNotifier == null && !widget.skipAuth;
    _ownsPassport = widget.passportNotifier == null;
    _auth = widget.authNotifier ?? EcosystemAuthNotifier();
    _passport = widget.passportNotifier ?? PassportNotifier();

    _passport.addListener(_onPassportChanged);

    if (widget.skipAuth || widget.passportNotifier != null) {
      _passport.initialize();
    } else {
      _auth.addListener(_onAuthChanged);
      if (_auth.isLoading) {
        _auth.initialize().then((_) => _onAuthChanged());
      } else {
        _onAuthChanged();
      }
    }
  }

  void _onAuthChanged() {
    final session = _auth.session;
    if (session == null) {
      _passportBootstrapped = false;
      _passportInitializing = false;
    } else if (!session.needsOnboarding &&
        session.stakeholderKind?.passportPreviewRole != null) {
      _ensurePassportForSession(session);
    }
    if (mounted) setState(() {});
  }

  void _onPassportChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _ensurePassportForSession(EcosystemSession session) async {
    if (_passportBootstrapped && _passport.data != null) {
      _passport.applyStakeholderSession(session);
      if (mounted) setState(() {});
      return;
    }
    if (_passportInitializing) return;

    _passportInitializing = true;
    if (mounted) setState(() {});

    try {
      await _passport.initialize();
      _passport.applyStakeholderSession(session);
      _passportBootstrapped = true;
      if (session.stakeholderKind?.passportPreviewRole == AccessRole.public) {
        await _passport.searchTalent(const TalentSearchCriteria(seekingSponsorOnly: true));
      }
    } finally {
      _passportInitializing = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _passport.removeListener(_onPassportChanged);
    if (_ownsAuth) {
      _auth.removeListener(_onAuthChanged);
      _auth.dispose();
    }
    if (_ownsPassport) _passport.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athletes Ecosystem',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    if (widget.skipAuth || widget.passportNotifier != null) {
      return _buildPassportShell(session: null, onSignOut: null);
    }

    if (_auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final session = _auth.session;
    if (session == null) {
      return WelcomeScreen(auth: _auth);
    }

    if (session.needsOnboarding) {
      return StakeholderOnboardingScreen(auth: _auth);
    }

    final kind = session.stakeholderKind!;
    if (kind.passportPreviewRole == null) {
      return OrganizationPlaceholderScreen(
        session: session,
        onSignOut: _auth.signOut,
      );
    }

    if (_passportInitializing || (!_passportBootstrapped && _passport.data == null)) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _buildPassportShell(session: session, onSignOut: _auth.signOut);
  }

  Widget _buildPassportShell({
    required EcosystemSession? session,
    required Future<void> Function()? onSignOut,
  }) {
    return PassportScope(
      notifier: _passport,
      child: ListenableBuilder(
        listenable: _passport,
        builder: (context, _) {
          if (_passport.isLoading && _passport.data == null) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (_passport.error != null) {
            return Scaffold(body: Center(child: Text('Error: ${_passport.error}')));
          }
          final data = _passport.data;
          if (data == null) {
            return const Scaffold(body: Center(child: Text('No passport data')));
          }
          return AthletePassportScreen(
            data: data,
            viewRole: _passport.viewRole,
            isProfilePublic: _passport.isProfilePublic,
            session: session,
            onSignOut: onSignOut,
          );
        },
      ),
    );
  }
}
