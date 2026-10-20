import 'package:flutter/material.dart';
import 'package:athletes_application/models/athlete_models.dart';

IconData badgeIconForKey(String key) {
  return switch (key) {
    'emoji_events' => Icons.emoji_events,
    'golf_course' => Icons.golf_course,
    'trending_up' => Icons.trending_up,
    'groups' => Icons.groups,
    'public' => Icons.public,
    'sports_tennis' => Icons.sports_tennis,
    'wb_sunny' => Icons.wb_sunny,
    'pool' => Icons.pool,
    'star' => Icons.star,
    _ => Icons.military_tech_outlined,
  };
}

Color badgeColorForCategory(BadgeCategory category) {
  return switch (category) {
    BadgeCategory.tournament => const Color(0xFFB8860B),
    BadgeCategory.training => const Color(0xFF2D6A4F),
    BadgeCategory.milestone => const Color(0xFF1B4965),
    BadgeCategory.community => const Color(0xFF5C4D7D),
  };
}
