import 'package:flutter/material.dart';
import 'package:athletes_application/core/layout/responsive_layout.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';
import 'package:athletes_application/models/athlete_models.dart';

class CalendarSection extends StatelessWidget {
  const CalendarSection({super.key, required this.data});

  final AthletePassportData data;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final upcoming = data.calendarEvents
        .where((e) => e.start.isAfter(now.subtract(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    final calendarCard = PassportSectionCard(
          title: 'Sports calendar',
          subtitle: _formatMonthYear(now),
          child: _MonthCalendarStrip(events: data.calendarEvents, focused: now),
        );

    final travelCard = PassportSectionCard(
          title: 'Travel & events',
          subtitle: '${upcoming.length} upcoming',
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.flight_takeoff, color: AppTheme.teal),
            tooltip: 'Plan travel',
          ),
          child: Column(
            children: upcoming.map((e) => _EventTile(event: e)).toList(),
          ),
        );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        ResponsivePair(first: calendarCard, second: travelCard),
      ],
    );
  }

  String _formatMonthYear(DateTime d) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[d.month - 1]} ${d.year}';
  }
}

class _MonthCalendarStrip extends StatelessWidget {
  const _MonthCalendarStrip({required this.events, required this.focused});

  final List<CalendarEvent> events;
  final DateTime focused;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(focused.year, focused.month);
    final eventDays = events
        .where((e) => e.start.year == focused.year && e.start.month == focused.month)
        .map((e) => e.start.day)
        .toSet();

    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: daysInMonth,
        itemBuilder: (context, index) {
          final day = index + 1;
          final hasEvent = eventDays.contains(day);
          final isToday = day == focused.day;

          return Container(
            width: 40,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: isToday
                  ? AppTheme.navy
                  : hasEvent
                      ? AppTheme.teal.withValues(alpha: 0.15)
                      : AppTheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: hasEvent && !isToday
                  ? Border.all(color: AppTheme.teal.withValues(alpha: 0.4))
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: isToday ? Colors.white : AppTheme.navy,
                  ),
                ),
                if (hasEvent)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isToday ? AppTheme.gold : AppTheme.teal,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (event.type) {
      CalendarEventType.tournament => (Icons.emoji_events_outlined, AppTheme.gold),
      CalendarEventType.training => (Icons.fitness_center, AppTheme.teal),
      CalendarEventType.travel => (Icons.luggage_outlined, const Color(0xFF6C63FF)),
      CalendarEventType.meeting => (Icons.groups_outlined, Colors.blueGrey),
    };

    final dateStr =
        '${_month(event.start.month)} ${event.start.day} · ${_time(event.start)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.navy),
                ),
                Text(dateStr, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                Row(
                  children: [
                    Icon(Icons.place_outlined, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
                if (event.travelNote != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.teal.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.directions, size: 14, color: AppTheme.teal),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event.travelNote!,
                            style: const TextStyle(fontSize: 11, color: AppTheme.navy),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _month(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[m - 1];
  }

  String _time(DateTime d) {
    final h = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    final period = d.hour >= 12 ? 'PM' : 'AM';
    final min = d.minute.toString().padLeft(2, '0');
    return '$h:$min $period';
  }
}
