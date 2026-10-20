import 'package:flutter/material.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/passport_scope.dart';
import 'package:athletes_application/models/athlete_models.dart';

class FamilyAthleteSwitcher extends StatelessWidget {
  const FamilyAthleteSwitcher({
    super.key,
    required this.familyPass,
    required this.activeAthleteId,
  });

  final FamilyPassAccount familyPass;
  final String activeAthleteId;

  @override
  Widget build(BuildContext context) {
    final notifier = PassportScope.of(context);

    return Material(
      color: AppTheme.gold.withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.family_restroom, size: 18, color: AppTheme.gold),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${familyPass.planLabel} · ${familyPass.parentName}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.navy,
                    ),
                  ),
                ),
                Text(
                  '${familyPass.athletes.length}/${familyPass.maxAthletes}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final athlete in familyPass.athletes)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(athlete.fullName),
                        avatar: CircleAvatar(
                          radius: 12,
                          backgroundColor: AppTheme.teal.withValues(alpha: 0.2),
                          child: Text(
                            athlete.avatarInitials,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
                          ),
                        ),
                        selected: athlete.athleteId == activeAthleteId,
                        onSelected: (_) async {
                          if (athlete.athleteId == activeAthleteId) return;
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Switch Family Profile'),
                              content: Text('Switch active athlete passport to ${athlete.fullName}?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Switch'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true && context.mounted) {
                            await notifier.switchFamilyAthlete(athlete.athleteId);
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
