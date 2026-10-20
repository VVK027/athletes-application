import 'package:flutter/material.dart';
import 'package:athletes_application/features/athlete_passport/passport_notifier.dart';
import 'package:athletes_application/models/athlete_models.dart';

class PassportScope extends InheritedNotifier<PassportNotifier> {
  const PassportScope({
    super.key,
    required PassportNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static PassportNotifier of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PassportScope>();
    assert(scope != null, 'PassportScope not found');
    return scope!.notifier!;
  }

  static AthletePassportData requireData(BuildContext context) {
    final data = of(context).data;
    assert(data != null, 'Passport data not loaded');
    return data!;
  }
}
