import 'package:flutter/material.dart';
import 'package:athletes_application/core/platform/ecosystem_platform_config.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/domain/adapters/passport_ecosystem_bridge.dart';
import 'package:athletes_application/domain/ecosystem/athlete_ecosystem_identity.dart';
import 'package:athletes_application/domain/ecosystem/stakeholder_kind.dart';
import 'package:athletes_application/domain/modules/ecosystem_module.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';
import 'package:athletes_application/models/athlete_models.dart';

class EcosystemPlatformSection extends StatelessWidget {
  const EcosystemPlatformSection({
    super.key,
    required this.data,
    this.config = EcosystemPlatformConfig.current,
  });

  final AthletePassportData data;
  final EcosystemPlatformConfig config;

  @override
  Widget build(BuildContext context) {
    final identity = PassportEcosystemBridge.identityFromPassport(data);
    final live = EcosystemModuleRegistry.byLifecycle(ModuleLifecycle.live);
    final beta = EcosystemModuleRegistry.byLifecycle(ModuleLifecycle.beta);
    final planned = EcosystemModuleRegistry.byLifecycle(ModuleLifecycle.planned);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        PassportSectionCard(
          title: config.platformName,
          subtitle: config.platformTagline,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AthleteCenterCard(identity: identity),
              const SizedBox(height: 16),
              Text(
                'Network around every athlete',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.navy,
                    ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final kind in athleteCentricNetwork)
                    _NetworkChip(kind: kind),
                ],
              ),
            ],
          ),
        ),
        _ModuleGroup(title: 'Live today', modules: live, config: config),
        if (beta.isNotEmpty) _ModuleGroup(title: 'Early access', modules: beta, config: config),
        _ModuleGroup(title: 'Roadmap', modules: planned, config: config),
        PassportSectionCard(
          title: 'International by design',
          subtitle: 'Built for multi-region rollout from day one',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoLine(
                label: 'Country',
                value: identity.international.countryCode,
              ),
              _InfoLine(
                label: 'Region shard',
                value: identity.international.regionCode,
              ),
              _InfoLine(
                label: 'Locale',
                value: identity.international.localeTag,
              ),
              _InfoLine(
                label: 'Primary sport',
                value: identity.primarySport.displayName,
              ),
              if (identity.secondarySports.isNotEmpty)
                _InfoLine(
                  label: 'Also plays',
                  value: identity.secondarySports.map((s) => s.displayName).join(', '),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AthleteCenterCard extends StatelessWidget {
  const _AthleteCenterCard({required this.identity});

  final AthleteEcosystemIdentity identity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.navy, Color(0xFF1B3A4B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ATHLETE AT CENTER',
            style: TextStyle(
              color: AppTheme.gold,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            identity.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            '${identity.primarySport.displayName} · ${identity.passportId}',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            'Public: ${identity.publicSlug}',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _NetworkChip extends StatelessWidget {
  const _NetworkChip({required this.kind});

  final StakeholderKind kind;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(kind.label, style: const TextStyle(fontSize: 11)),
      backgroundColor: AppTheme.teal.withValues(alpha: 0.12),
      side: BorderSide(color: AppTheme.teal.withValues(alpha: 0.35)),
    );
  }
}

class _ModuleGroup extends StatelessWidget {
  const _ModuleGroup({
    required this.title,
    required this.modules,
    required this.config,
  });

  final String title;
  final List<EcosystemModule> modules;
  final EcosystemPlatformConfig config;

  @override
  Widget build(BuildContext context) {
    return PassportSectionCard(
      title: title,
      subtitle: '${modules.length} capabilities',
      child: Column(
        children: [
          for (final module in modules) _ModuleTile(module: module, config: config),
        ],
      ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({required this.module, required this.config});

  final EcosystemModule module;
  final EcosystemPlatformConfig config;

  @override
  Widget build(BuildContext context) {
    final lifecycle = module.lifecycle;
    final enabled = config.isModuleEnabled(module);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.title,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.navy),
                ),
                const SizedBox(height: 4),
                Text(
                  module.summary,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _LifecycleBadge(lifecycle: lifecycle, enabled: enabled),
        ],
      ),
    );
  }
}

class _LifecycleBadge extends StatelessWidget {
  const _LifecycleBadge({required this.lifecycle, required this.enabled});

  final ModuleLifecycle lifecycle;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (lifecycle) {
      ModuleLifecycle.live => ('Live', AppTheme.teal),
      ModuleLifecycle.beta => ('Beta', AppTheme.gold),
      ModuleLifecycle.planned => ('Planned', Colors.grey.shade600),
    };

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
          ),
        ),
        if (!enabled && lifecycle == ModuleLifecycle.live)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text('Off', style: TextStyle(fontSize: 9)),
          ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.navy),
            ),
          ),
        ],
      ),
    );
  }
}
