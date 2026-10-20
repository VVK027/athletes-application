import 'package:flutter/material.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/athlete_passport_screen.dart';
import 'package:athletes_application/features/athlete_passport/passport_notifier.dart';
import 'package:athletes_application/features/athlete_passport/passport_scope.dart';

class PassportApp extends StatefulWidget {
  const PassportApp({super.key, this.notifier});

  final PassportNotifier? notifier;

  @override
  State<PassportApp> createState() => _PassportAppState();
}

class _PassportAppState extends State<PassportApp> {
  late final PassportNotifier _notifier;
  late final bool _ownsNotifier;

  @override
  void initState() {
    super.initState();
    _ownsNotifier = widget.notifier == null;
    _notifier = widget.notifier ?? PassportNotifier();
    _notifier.initialize();
  }

  @override
  void dispose() {
    if (_ownsNotifier) {
      _notifier.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athlete Ecosystem',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: PassportScope(
        notifier: _notifier,
        child: ListenableBuilder(
          listenable: _notifier,
          builder: (context, _) {
            if (_notifier.isLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (_notifier.error != null) {
              return Scaffold(
                body: Center(child: Text('Error: ${_notifier.error}')),
              );
            }
            final data = _notifier.data;
            if (data == null) {
              return const Scaffold(
                body: Center(child: Text('No passport data')),
              );
            }
            return AthletePassportScreen(
              data: data,
              viewRole: _notifier.viewRole,
              isProfilePublic: _notifier.isProfilePublic,
            );
          },
        ),
      ),
    );
  }
}
