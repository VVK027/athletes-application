import 'package:flutter/material.dart';
import 'package:athletes_application/core/layout/responsive_layout.dart';
import 'package:athletes_application/core/permissions/passport_permissions.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/passport_notifier.dart';
import 'package:athletes_application/features/athlete_passport/passport_scope.dart';
import 'package:athletes_application/features/athlete_passport/role_selector_sheet.dart';
import 'package:athletes_application/features/athlete_passport/sections/achievements_section.dart';
import 'package:athletes_application/features/athlete_passport/sections/access_section.dart';
import 'package:athletes_application/features/athlete_passport/sections/calendar_section.dart';
import 'package:athletes_application/features/athlete_passport/sections/family_pass_section.dart';
import 'package:athletes_application/features/athlete_passport/sections/memory_albums_section.dart';
import 'package:athletes_application/features/athlete_passport/sections/media_section.dart';
import 'package:athletes_application/features/athlete_passport/sections/performance_section.dart';
import 'package:athletes_application/features/athlete_passport/sections/profile_section.dart';
import 'package:athletes_application/features/athlete_passport/sections/public_profile_section.dart';
import 'package:athletes_application/features/athlete_passport/sections/sponsor_marketplace_section.dart';
import 'package:athletes_application/features/athlete_passport/sections/sponsors_section.dart';
import 'package:athletes_application/features/athlete_passport/sections/tournaments_section.dart';
import 'package:athletes_application/features/athlete_passport/sections/world_map_section.dart';
import 'package:athletes_application/domain/ecosystem/ecosystem_session.dart';
import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';
import 'package:athletes_application/features/athlete_passport/sections/verified_results_section.dart';
import 'package:athletes_application/features/ecosystem/ecosystem_platform_section.dart';
import 'package:athletes_application/features/ecosystem/talent_search_section.dart';
import 'package:athletes_application/features/athlete_passport/widgets/family_athlete_switcher.dart';
import 'package:athletes_application/models/athlete_models.dart';

class AthletePassportScreen extends StatefulWidget {
  const AthletePassportScreen({
    super.key,
    required this.data,
    required this.viewRole,
    required this.isProfilePublic,
    this.session,
    this.onSignOut,
  });

  final AthletePassportData data;
  final AccessRole viewRole;
  final bool isProfilePublic;
  final EcosystemSession? session;
  final Future<void> Function()? onSignOut;

  @override
  State<AthletePassportScreen> createState() => _AthletePassportScreenState();
}

class _AthletePassportScreenState extends State<AthletePassportScreen> {
  int _navIndex = 0;

  static const _tabMeta = {
    PassportTab.profile: (
      icon: Icons.badge_outlined,
      selected: Icons.badge,
      label: 'Profile',
    ),
    PassportTab.results: (
      icon: Icons.leaderboard_outlined,
      selected: Icons.leaderboard,
      label: 'Results',
    ),
    PassportTab.track: (
      icon: Icons.track_changes_outlined,
      selected: Icons.track_changes,
      label: 'Track',
    ),
    PassportTab.media: (
      icon: Icons.perm_media_outlined,
      selected: Icons.perm_media,
      label: 'Media',
    ),
    PassportTab.more: (
      icon: Icons.more_horiz,
      selected: Icons.more_horiz,
      label: 'More',
    ),
  };

  List<PassportTab> get _visibleTabs => PassportPermissions.visibleTabs(widget.viewRole);

  @override
  void didUpdateWidget(covariant AthletePassportScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewRole != widget.viewRole && _navIndex >= _visibleTabs.length) {
      _navIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _visibleTabs;
    final currentTab = tabs[_navIndex.clamp(0, tabs.length - 1)];
    final isRestricted = widget.viewRole != AccessRole.athlete;
    final useRail = context.useNavigationRail && tabs.length > 1;
    final navIndex = _navIndex.clamp(0, tabs.length - 1);
    final notifier = PassportScope.of(context);
    final familyPass = notifier.familyPass;
    final showFamilySwitcher = familyPass != null &&
        (widget.viewRole == AccessRole.parent || widget.viewRole == AccessRole.athlete);

    final mainColumn = Column(
      children: [
        _PassportHeader(
          profile: widget.data.profile,
          viewRole: widget.viewRole,
          isRestricted: isRestricted,
          session: widget.session,
          onSignOut: widget.onSignOut,
        ),
        if (showFamilySwitcher)
          FamilyAthleteSwitcher(
            familyPass: familyPass,
            activeAthleteId: notifier.activeAthleteId,
          ),
        if (isRestricted) _RoleBanner(role: widget.viewRole),
        Expanded(
          child: ResponsiveContent(child: _buildBody(currentTab)),
        ),
      ],
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: useRail
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NavigationRail(
                    selectedIndex: navIndex,
                    onDestinationSelected: (i) => setState(() => _navIndex = i),
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      for (final tab in tabs)
                        NavigationRailDestination(
                          icon: Icon(_tabMeta[tab]!.icon),
                          selectedIcon: Icon(_tabMeta[tab]!.selected),
                          label: Text(_tabMeta[tab]!.label),
                        ),
                    ],
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: mainColumn),
                ],
              )
            : mainColumn,
      ),
      bottomNavigationBar: useRail || tabs.length <= 1
          ? null
          : NavigationBar(
              selectedIndex: navIndex,
              onDestinationSelected: (i) => setState(() => _navIndex = i),
              destinations: [
                for (final tab in tabs)
                  NavigationDestination(
                    icon: Icon(_tabMeta[tab]!.icon),
                    selectedIcon: Icon(_tabMeta[tab]!.selected),
                    label: _tabMeta[tab]!.label,
                  ),
              ],
            ),
    );
  }

  Widget _buildBody(PassportTab tab) {
    final role = widget.viewRole;
    final data = widget.data;

    if (role == AccessRole.public || role == AccessRole.sponsor && tab == PassportTab.more) {
      return _buildMoreContent(role);
    }

    return switch (tab) {
      PassportTab.profile => PassportPermissions.canView(PassportFeature.profile, role)
          ? ProfileSection(data: data, viewRole: role)
          : _denied(),
      PassportTab.results => PassportPermissions.canView(PassportFeature.tournaments, role)
          ? TournamentsSection(data: data, viewRole: role)
          : _denied(),
      PassportTab.track => PassportPermissions.canView(PassportFeature.performance, role)
          ? PerformanceSection(data: data)
          : _denied(),
      PassportTab.media => PassportPermissions.canView(PassportFeature.media, role)
          ? MediaSection(data: data, viewRole: role)
          : _denied(),
      PassportTab.more => _buildMoreContent(role),
    };
  }

  Widget _buildMoreContent(AccessRole role) {
    if (role == AccessRole.public) {
      return PublicProfileSection(
        data: widget.data,
        isProfilePublic: widget.isProfilePublic,
        viewRole: role,
      );
    }

    return _MoreHub(
      data: widget.data,
      viewRole: role,
      isProfilePublic: widget.isProfilePublic,
      notifier: PassportScope.of(context),
    );
  }

  Widget _denied() => const Center(child: Text('Not available for this role'));
}

class _RoleBanner extends StatelessWidget {
  const _RoleBanner({required this.role});

  final AccessRole role;

  @override
  Widget build(BuildContext context) {
    final color = switch (role) {
      AccessRole.athlete => AppTheme.navy,
      AccessRole.coach => AppTheme.teal,
      AccessRole.parent => Colors.indigo,
      AccessRole.sponsor => AppTheme.gold,
      AccessRole.public => Colors.grey.shade700,
    };
    return Material(
      color: color.withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.visibility, size: 18, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Viewing as ${PassportPermissions.roleLabel(role)}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () => showRoleSelectorSheet(context, PassportScope.of(context)),
              child: const Text('Switch Role'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PassportHeader extends StatelessWidget {
  const _PassportHeader({
    required this.profile,
    required this.viewRole,
    required this.isRestricted,
    this.session,
    this.onSignOut,
  });

  final AthleteProfile profile;
  final AccessRole viewRole;
  final bool isRestricted;
  final EcosystemSession? session;
  final Future<void> Function()? onSignOut;

  @override
  Widget build(BuildContext context) {
    final notifier = PassportScope.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.navy, Color(0xFF1B3A4B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user, color: AppTheme.gold, size: 20),
              const SizedBox(width: 6),
              const Text(
                'Athletes Ecosystem',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              if (onSignOut != null)
                IconButton(
                  onPressed: () => onSignOut!(),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: 'Sign out',
                ),
              IconButton(
                onPressed: () => showRoleSelectorSheet(context, notifier),
                icon: Badge(
                  isLabelVisible: isRestricted,
                  label: isRestricted ? const Text('!') : null,
                  child: const Icon(Icons.swap_horiz, color: Colors.white),
                ),
                tooltip: 'Switch role',
              ),
              if (PassportPermissions.canView(PassportFeature.publicProfile, viewRole))
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.qr_code_2, color: Colors.white),
                  tooltip: 'Passport QR',
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.gold, width: 2),
                  color: AppTheme.teal.withValues(alpha: 0.25),
                ),
                alignment: Alignment.center,
                child: Text(
                  profile.avatarInitials,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${profile.sport} · #${profile.jerseyNumber}',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.club,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.credit_card, color: AppTheme.gold, size: 18),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    profile.passportId,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  session?.stakeholderKind?.label ??
                      PassportPermissions.roleLabel(viewRole),
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11),
                ),
              ],
            ),
          ),
          if (session != null) ...[
            const SizedBox(height: 8),
            Text(
              'Signed in as ${session!.displayName}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}

class _MoreHub extends StatelessWidget {
  const _MoreHub({
    required this.data,
    required this.viewRole,
    required this.isProfilePublic,
    required this.notifier,
  });

  final AthletePassportData data;
  final AccessRole viewRole;
  final bool isProfilePublic;
  final PassportNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final familyPass = notifier.familyPass;
    final items = <_MoreItem>[
      if (PassportPermissions.moreItemVisible(MorePassportItem.talentSearch, viewRole))
        _MoreItem(
          icon: Icons.travel_explore,
          title: 'Talent discovery',
          subtitle: '${notifier.talentSearchResults.length} athletes in last search',
          builder: (_) => const TalentSearchSection(),
        ),
      if (PassportPermissions.moreItemVisible(MorePassportItem.verifiedResults, viewRole))
        _MoreItem(
          icon: Icons.verified_outlined,
          title: 'Verified results',
          subtitle: '${notifier.verifiedResults.length} federation-verified events',
          builder: (_) => VerifiedResultsSection(results: notifier.verifiedResults),
        ),
      if (PassportPermissions.moreItemVisible(MorePassportItem.ecosystemPlatform, viewRole))
        _MoreItem(
          icon: Icons.hub_outlined,
          title: 'Athletes Ecosystem',
          subtitle: 'Platform vision · network · roadmap',
          builder: (_) => EcosystemPlatformSection(data: data),
        ),
      if (PassportPermissions.moreItemVisible(MorePassportItem.familyPass, viewRole) &&
          familyPass != null)
        _MoreItem(
          icon: Icons.family_restroom,
          title: 'Family Pass',
          subtitle: '${familyPass.athletes.length} athletes on one account',
          builder: (_) => FamilyPassSection(
            familyPass: familyPass,
            activeAthleteId: notifier.activeAthleteId,
            data: data,
          ),
        ),
      if (PassportPermissions.moreItemVisible(MorePassportItem.memoryAlbums, viewRole))
        _MoreItem(
          icon: Icons.photo_album_outlined,
          title: 'Memory albums',
          subtitle: '${data.memoryAlbums.length} season & event albums',
          builder: (_) => MemoryAlbumsSection(data: data),
        ),
      if (PassportPermissions.moreItemVisible(MorePassportItem.worldMap, viewRole))
        _MoreItem(
          icon: Icons.public,
          title: 'World map',
          subtitle: '${data.mapPins.length} tournament & achievement pins',
          builder: (_) => WorldMapSection(data: data),
        ),
      if (PassportPermissions.moreItemVisible(MorePassportItem.achievements, viewRole))
        _MoreItem(
          icon: Icons.military_tech_outlined,
          title: 'Badges & achievements',
          subtitle:
              '${data.badges.where((b) => b.isUnlocked).length} of ${data.badges.length} earned',
          builder: (_) => AchievementsSection(data: data),
        ),
      if (PassportPermissions.moreItemVisible(MorePassportItem.sponsorMarketplace, viewRole))
        _MoreItem(
          icon: Icons.storefront_outlined,
          title: 'Sponsor marketplace',
          subtitle: '${notifier.marketplaceAthletes.length} discoverable athletes',
          builder: (_) => SponsorMarketplaceSection(athletes: notifier.marketplaceAthletes),
        ),
      if (PassportPermissions.moreItemVisible(MorePassportItem.access, viewRole))
        _MoreItem(
          icon: Icons.group_outlined,
          title: 'Coach & parent access',
          subtitle: '${data.accessContacts.length} contacts',
          builder: (_) => AccessSection(data: data, viewRole: viewRole),
        ),
      if (PassportPermissions.moreItemVisible(MorePassportItem.sponsors, viewRole))
        _MoreItem(
          icon: Icons.handshake_outlined,
          title: 'Sponsor management',
          subtitle: '${data.sponsors.length} partners',
          builder: (_) => SponsorsSection(data: data, viewRole: viewRole),
        ),
      if (PassportPermissions.moreItemVisible(MorePassportItem.calendar, viewRole))
        _MoreItem(
          icon: Icons.calendar_month_outlined,
          title: 'Calendar & travel',
          subtitle: '${data.calendarEvents.length} events',
          builder: (_) => CalendarSection(data: data),
        ),
      if (PassportPermissions.moreItemVisible(MorePassportItem.publicProfile, viewRole))
        _MoreItem(
          icon: Icons.public,
          title: 'Public profile',
          subtitle: 'Share with scouts',
          builder: (_) => PublicProfileSection(
            data: data,
            isProfilePublic: isProfilePublic,
            viewRole: viewRole,
          ),
        ),
    ];

    if (items.isEmpty) {
      return const Center(child: Text('No sections available'));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          'More passport features',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.navy,
              ),
        ),
        const SizedBox(height: 12),
        for (final item in items)
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.teal.withValues(alpha: 0.12),
                child: Icon(item.icon, color: AppTheme.teal),
              ),
              title: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.navy),
              ),
              subtitle: Text(item.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (routeContext) => PassportScope(
                      notifier: notifier,
                      child: item.builder(routeContext),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _MoreItem {
  const _MoreItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.builder,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final WidgetBuilder builder;
}
