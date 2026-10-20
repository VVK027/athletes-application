import 'package:flutter/material.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/models/athlete_models.dart';

class WorldMapCanvas extends StatelessWidget {
  const WorldMapCanvas({
    super.key,
    required this.pins,
    this.selectedPinId,
    this.onPinSelected,
  });

  final List<MapPin> pins;
  final String? selectedPinId;
  final ValueChanged<MapPin>? onPinSelected;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTapUp: (details) {
              final pin = _pinAtOffset(details.localPosition, constraints.biggest);
              if (pin != null) {
                onPinSelected?.call(pin);
              }
            },
            child: CustomPaint(
              size: constraints.biggest,
              painter: _WorldMapPainter(
                pins: pins,
                selectedPinId: selectedPinId,
              ),
            ),
          );
        },
      ),
    );
  }

  MapPin? _pinAtOffset(Offset offset, Size size) {
    const hitRadius = 18.0;
    for (final pin in pins) {
      final pos = _WorldMapPainter.latLngToOffset(pin.latitude, pin.longitude, size);
      if ((pos - offset).distance <= hitRadius) {
        return pin;
      }
    }
    return null;
  }
}

class _WorldMapPainter extends CustomPainter {
  _WorldMapPainter({required this.pins, this.selectedPinId});

  final List<MapPin> pins;
  final String? selectedPinId;

  static Offset latLngToOffset(double lat, double lng, Size size) {
    final x = (lng + 180) / 360 * size.width;
    final y = (90 - lat) / 180 * size.height;
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFE8F4F8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16)),
      bg,
    );

    final grid = Paint()
      ..color = const Color(0xFFB8D4E3)
      ..strokeWidth = 0.8;
    for (var i = 1; i < 6; i++) {
      final y = size.height * i / 6;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    for (var i = 1; i < 12; i++) {
      final x = size.width * i / 12;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }

    final land = Paint()..color = const Color(0xFFCAE3D8);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.22, size.height * 0.38),
        width: size.width * 0.28,
        height: size.height * 0.55,
      ),
      land,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.52, size.height * 0.35),
        width: size.width * 0.22,
        height: size.height * 0.48,
      ),
      land,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.78, size.height * 0.42),
        width: size.width * 0.32,
        height: size.height * 0.5,
      ),
      land,
    );

    for (final pin in pins) {
      final pos = latLngToOffset(pin.latitude, pin.longitude, size);
      final selected = pin.id == selectedPinId;
      final color = switch (pin.kind) {
        MapPinKind.tournament => AppTheme.teal,
        MapPinKind.achievement => AppTheme.gold,
        MapPinKind.trainingCamp => AppTheme.navy,
      };

      final glow = Paint()
        ..color = color.withValues(alpha: selected ? 0.35 : 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(pos, selected ? 14 : 10, glow);

      final dot = Paint()..color = color;
      canvas.drawCircle(pos, selected ? 8 : 6, dot);
      if (selected) {
        canvas.drawCircle(
          pos,
          11,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WorldMapPainter oldDelegate) {
    return oldDelegate.pins != pins || oldDelegate.selectedPinId != selectedPinId;
  }
}

String mapPinKindLabel(MapPinKind kind) {
  return switch (kind) {
    MapPinKind.tournament => 'Tournament',
    MapPinKind.achievement => 'Achievement',
    MapPinKind.trainingCamp => 'Training base',
  };
}

int countPinsByKind(List<MapPin> pins, MapPinKind kind) =>
    pins.where((p) => p.kind == kind).length;
