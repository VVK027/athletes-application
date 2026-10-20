# ATHLETES APPLICATION

**ATHLETES APPLICATION** is a production-grade Flutter application designed for elite athletes, coaches, parents, sponsors, and sports federations. It provides a comprehensive multi-stakeholder platform for managing athlete passports, verified tournament results, training performance metrics, media archives, and sponsor marketplaces.

---

## Key Features

### 1. Multi-Stakeholder Role Simulation
- **Athlete**: Full passport control, training tracking, media uploads, and permission management.
- **Coach**: Access to stats, training logs, verified results, and media management.
- **Parent**: Calendar coordination, travel planning, family pass management, and public profile oversight.
- **Sponsor**: Sponsor marketplace visibility, talent scouting, and high-performance highlights.
- **Public**: Public profile viewing and talent discovery.

### 2. Athlete Passport & Verified Results
- Comprehensive athlete profiles with career timelines, achievements, world map milestones, and memory albums.
- Cryptographically verified tournament results from official sports federations.

### 3. Family Pass & Multi-Athlete Management
- Manage multiple family athletes under a single ecosystem account with secure confirmation flows when switching active profiles.

### 4. Advanced Media & Video Analysis
- Media gallery supporting photos and training videos.
- Video detail screen equipped with progress scrubbing, jump $\pm$5s controls, and variable playback speeds (`0.5x`, `1.0x`, `1.5x`, `2.0x`).

### 5. Offline-First Sync & Cloud Integration
- Resilient offline data persistence with synchronization status monitoring and mock/remote data source support.

---

## Project Structure

```text
lib/
├── core/
│   ├── config/        # Ecosystem auth & sync configurations
│   ├── layout/        # Responsive layout & navigation rail utilities
│   ├── permissions/   # Role-based feature and tab permission rules
│   └── theme/         # AppTheme (Light & High-Contrast Outdoor modes)
├── data/              # Repositories, serializers, sync envelopes, and mock datasets
├── domain/            # Ecosystem contracts, sessions, capabilities, and sport codes
└── features/
    ├── athlete_passport/ # Passport screen, notifier, media services, and feature sections
    ├── auth/             # Ecosystem root, onboarding, and welcome screens
    └── ecosystem/        # Talent search, platform sections, and organization placeholders
```

---

## Getting Started

### Prerequisites
- Flutter SDK (`^3.10.9` or higher)
- Dart SDK

### Installation & Running
1. Clone the repository and install dependencies:
   ```bash
   flutter pub get
   ```
2. Run the application:
   ```bash
   flutter run
   ```
3. Run the test suite:
   ```bash
   flutter test
   ```

---

## Testing & Quality Assurance
The project includes robust unit and widget test suites covering state management (`PassportNotifier`), role permissions, navigation flows, and multi-role views. Run tests using `flutter test`.
