import 'package:flutter/material.dart';
import 'package:athletes_application/core/layout/responsive_layout.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';
import 'package:athletes_application/features/athlete_passport/widgets/world_map_canvas.dart';
import 'package:athletes_application/models/athlete_models.dart';

class WorldMapSection extends StatefulWidget {
  const WorldMapSection({super.key, required this.data});

  final AthletePassportData data;

  @override
  State<WorldMapSection> createState() => _WorldMapSectionState();
}

class _WorldMapSectionState extends State<WorldMapSection> {
  String? _selectedPinId;

  @override
  Widget build(BuildContext context) {
    final pins = widget.data.mapPins;
    final selected = pins.where((p) => p.id == _selectedPinId).firstOrNull;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        PassportSectionCard(
          title: 'World map',
          subtitle: 'Tournaments and achievements across the globe',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WorldMapCanvas(
                pins: pins,
                selectedPinId: _selectedPinId,
                onPinSelected: (pin) => setState(() => _selectedPinId = pin.id),
              ),
              const SizedBox(height: 12),
              ResponsiveWrapGrid(
                compactColumns: 3,
                mediumColumns: 3,
                expandedColumns: 3,
                children: [
                  StatChip(
                    label: 'Tournaments',
                    value: '${countPinsByKind(pins, MapPinKind.tournament)}',
                  ),
                  StatChip(
                    label: 'Achievements',
                    value: '${countPinsByKind(pins, MapPinKind.achievement)}',
                  ),
                  StatChip(
                    label: 'Training',
                    value: '${countPinsByKind(pins, MapPinKind.trainingCamp)}',
                  ),
                ],
              ),
              if (selected != null) ...[
                const SizedBox(height: 14),
                _PinDetailCard(pin: selected),
              ],
            ],
          ),
        ),
        PassportSectionCard(
          title: 'Locations',
          subtitle: 'Tap a pin on the map or choose below',
          child: Column(
            children: pins.map((pin) {
              final isSelected = pin.id == _selectedPinId;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                color: isSelected ? AppTheme.teal.withValues(alpha: 0.08) : null,
                child: ListTile(
                  leading: Icon(
                    switch (pin.kind) {
                      MapPinKind.tournament => Icons.emoji_events_outlined,
                      MapPinKind.achievement => Icons.star_outline,
                      MapPinKind.trainingCamp => Icons.fitness_center_outlined,
                    },
                    color: AppTheme.teal,
                  ),
                  title: Text(
                    pin.label,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.navy),
                  ),
                  subtitle: Text('${pin.location} · ${pin.detail}'),
                  onTap: () => setState(() => _selectedPinId = pin.id),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _PinDetailCard extends StatelessWidget {
  const _PinDetailCard({required this.pin});

  final MapPin pin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.navy.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.teal.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pin.label,
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.navy),
          ),
          const SizedBox(height: 4),
          Text(
            '${mapPinKindLabel(pin.kind)} · ${pin.location}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 4),
          Text(pin.detail, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            pin.date.toString().split(' ').first,
            style: const TextStyle(fontSize: 11, color: AppTheme.teal),
          ),
        ],
      ),
    );
  }
}
