import 'package:flutter/material.dart';

/// Breakpoints aligned with Material adaptive guidance.
abstract final class ResponsiveBreakpoints {
  static const double compact = 600;
  static const double medium = 840;
  static const double expanded = 1200;
}

extension ResponsiveContext on BuildContext {
  double get contentWidth => MediaQuery.sizeOf(this).width;

  bool get isCompactWidth => contentWidth < ResponsiveBreakpoints.compact;

  bool get isMediumWidth =>
      contentWidth >= ResponsiveBreakpoints.compact &&
      contentWidth < ResponsiveBreakpoints.medium;

  bool get useSideBySideSections => contentWidth >= ResponsiveBreakpoints.medium;

  bool get useNavigationRail => contentWidth >= ResponsiveBreakpoints.medium;

  int gridColumns({int compact = 2, int medium = 3, int expanded = 4}) {
    if (contentWidth >= ResponsiveBreakpoints.expanded) return expanded;
    if (contentWidth >= ResponsiveBreakpoints.compact) return medium;
    return compact;
  }
}

/// Centers passport content on wide viewports (web / tablet landscape).
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ResponsiveBreakpoints.expanded),
        child: child,
      ),
    );
  }
}

/// Stacks on narrow screens; places children left/right on medium+ widths.
class ResponsivePair extends StatelessWidget {
  const ResponsivePair({
    super.key,
    required this.first,
    required this.second,
    this.spacing = 16,
  });

  final Widget first;
  final Widget second;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (context.useSideBySideSections) {
      // Do not use IntrinsicHeight here — this widget is often a ListView child,
      // and intrinsic sizing breaks scroll layout on web/mobile.
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Align(alignment: Alignment.topCenter, child: first),
          ),
          SizedBox(width: spacing),
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Align(alignment: Alignment.topCenter, child: second),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [first, second],
    );
  }
}

/// Responsive grid for compact stat chips and similar tiles.
class ResponsiveWrapGrid extends StatelessWidget {
  const ResponsiveWrapGrid({
    super.key,
    required this.children,
    this.compactColumns = 2,
    this.mediumColumns = 3,
    this.expandedColumns = 5,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  final List<Widget> children;
  final int compactColumns;
  final int mediumColumns;
  final int expandedColumns;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    final columns = context.gridColumns(
      compact: compactColumns,
      medium: mediumColumns,
      expanded: expandedColumns,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSpacing = spacing * (columns - 1);
        final cellWidth = (constraints.maxWidth - totalSpacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: [
            for (final child in children)
              SizedBox(
                width: cellWidth,
                child: child,
              ),
          ],
        );
      },
    );
  }
}
