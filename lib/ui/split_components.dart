import 'package:flutter/material.dart';

import '../app/split_bill_state.dart';
import 'split_tokens.dart';

class SplitScreen extends StatelessWidget {
  const SplitScreen({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(20, 18, 20, 112),
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: padding,
        children: [
          for (final child in children) ...[
            child,
            const SizedBox(height: SplitSpacing.lg),
          ],
        ],
      ),
    );
  }
}

class SplitCard extends StatelessWidget {
  const SplitCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(SplitSpacing.lg),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class SplitFloatingNav extends StatelessWidget {
  const SplitFloatingNav({
    super.key,
    required this.activeTab,
    required this.onChanged,
  });

  final SplitTab activeTab;
  final ValueChanged<SplitTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(SplitRadius.xl),
          border: Border.all(color: scheme.outline.withValues(alpha: 0.68)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(SplitSpacing.sm),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.receipt_long_rounded,
                label: 'Bills',
                selected: activeTab == SplitTab.home,
                onTap: () => onChanged(SplitTab.home),
              ),
              _NavItem(
                icon: Icons.tune_rounded,
                label: 'Settings',
                selected: activeTab == SplitTab.settings,
                onTap: () => onChanged(SplitTab.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Material(
        color: selected ? scheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SplitSpacing.md,
              vertical: SplitSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                ),
                const SizedBox(width: SplitSpacing.sm),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: selected
                              ? scheme.onPrimary
                              : scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
