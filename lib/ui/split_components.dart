import 'package:flutter/material.dart';

import '../app/split_bill_state.dart';
import '../core/money.dart';
import '../domain/split_bill_models.dart';
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
    this.onTap,
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    return Material(
      color: backgroundColor ?? colors.surface,
      borderRadius: BorderRadius.circular(SplitRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SplitRadius.lg),
            border: Border.all(color: colors.border),
          ),
          child: child,
        ),
      ),
    );
  }
}

class SplitIconButton extends StatelessWidget {
  const SplitIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(SplitRadius.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(SplitRadius.sm),
          onTap: onPressed,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, size: 21, color: colors.textSecondary),
          ),
        ),
      ),
    );
  }
}

class SplitPrimaryButton extends StatelessWidget {
  const SplitPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final child = FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.arrow_forward_rounded),
      label: Text(label, overflow: TextOverflow.ellipsis),
    );
    return expand ? SizedBox(width: double.infinity, child: child) : child;
  }
}

class SplitSecondaryButton extends StatelessWidget {
  const SplitSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final child = OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.more_horiz_rounded),
      label: Text(label, overflow: TextOverflow.ellipsis),
    );
    return expand ? SizedBox(width: double.infinity, child: child) : child;
  }
}

class SplitGhostAddButton extends StatelessWidget {
  const SplitGhostAddButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    return Material(
      color: colors.primarySoft.withValues(alpha: 0.46),
      borderRadius: BorderRadius.circular(SplitRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(SplitRadius.md),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: SplitSpacing.lg,
            vertical: SplitSpacing.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, color: colors.primary),
              const SizedBox(width: SplitSpacing.sm),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colors.primary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SplitTextField extends StatelessWidget {
  const SplitTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.prefixText,
    this.suffixText,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.fieldKey,
  });

  final TextEditingController controller;
  final Key? fieldKey;
  final String? label;
  final String? hint;
  final String? prefixText;
  final String? suffixText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: fieldKey,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefixText,
        suffixText: suffixText,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}

class SplitSectionLabel extends StatelessWidget {
  const SplitSectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: context.splitColors.textSecondary,
          ),
    );
  }
}

class SplitSummaryRow extends StatelessWidget {
  const SplitSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    final style = bold
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SplitSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: style?.copyWith(color: bold ? colors.textPrimary : colors.textSecondary),
            ),
          ),
          const SizedBox(width: SplitSpacing.md),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: style?.copyWith(
                color: valueColor ?? colors.textPrimary,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplitMoneyText extends StatelessWidget {
  const SplitMoneyText(
    this.amount, {
    super.key,
    this.size = 14.5,
    this.weight = FontWeight.w800,
    this.color,
    this.maxLines = 1,
  });

  final int amount;
  final double size;
  final FontWeight weight;
  final Color? color;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatRupiah(amount),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color ?? context.splitColors.textPrimary,
        fontSize: size,
        fontWeight: weight,
        letterSpacing: 0,
      ),
    );
  }
}

class SplitEmptyState extends StatelessWidget {
  const SplitEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SplitSpacing.xxl),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(SplitRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colors.primarySoft,
              borderRadius: BorderRadius.circular(SplitRadius.lg),
            ),
            child: Icon(icon, color: colors.primary),
          ),
          const SizedBox(height: SplitSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: SplitSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (action != null) ...[
            const SizedBox(height: SplitSpacing.lg),
            action!,
          ],
        ],
      ),
    );
  }
}

class SplitWarningBanner extends StatelessWidget {
  const SplitWarningBanner({
    super.key,
    required this.message,
    this.isError = false,
  });

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    final tone = isError ? colors.danger : colors.warning;
    final toneBg = isError ? colors.dangerSoft : colors.warningSoft;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SplitSpacing.lg),
      decoration: BoxDecoration(
        color: toneBg,
        borderRadius: BorderRadius.circular(SplitRadius.lg),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline_rounded : Icons.info_outline_rounded,
            size: 20,
            color: tone,
          ),
          const SizedBox(width: SplitSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: tone,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplitParticipantAvatar extends StatelessWidget {
  const SplitParticipantAvatar({
    super.key,
    required this.participant,
    this.size = 40,
  });

  final BillParticipant participant;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = SplitPalette.participantColor(participant.colorSeed);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Text(
        participant.initial,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.34,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class SplitParticipantChip extends StatelessWidget {
  const SplitParticipantChip({
    super.key,
    required this.participant,
    this.onTap,
    this.onDeleted,
    this.selected = false,
  });

  final BillParticipant participant;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    return InputChip(
      avatar: SplitParticipantAvatar(participant: participant, size: 28),
      label: Text(
        participant.name,
        overflow: TextOverflow.ellipsis,
      ),
      selected: selected,
      selectedColor: colors.primarySoft,
      backgroundColor: colors.surfaceAlt,
      side: BorderSide(color: selected ? colors.primary : colors.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SplitRadius.pill),
      ),
      onPressed: onTap,
      onDeleted: onDeleted,
    );
  }
}

class SplitAvatarStack extends StatelessWidget {
  const SplitAvatarStack({
    super.key,
    required this.participants,
    this.maxVisible = 4,
  });

  final List<BillParticipant> participants;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    final visible = participants.take(maxVisible).toList(growable: false);
    final hidden = participants.length - visible.length;
    return SizedBox(
      height: 32,
      width: (visible.length * 24 + (hidden > 0 ? 30 : 8)).toDouble(),
      child: Stack(
        children: [
          for (var index = 0; index < visible.length; index++)
            Positioned(
              left: index * 22,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: context.splitColors.surface, width: 2),
                ),
                child: SplitParticipantAvatar(participant: visible[index], size: 32),
              ),
            ),
          if (hidden > 0)
            Positioned(
              left: visible.length * 22,
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.splitColors.surfaceAlt,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.splitColors.surface, width: 2),
                ),
                child: Text(
                  '+$hidden',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SplitModeBadge extends StatelessWidget {
  const SplitModeBadge({
    super.key,
    required this.mode,
    this.label,
  });

  final SplitMode mode;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SplitSpacing.md,
        vertical: SplitSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.secondarySoft,
        borderRadius: BorderRadius.circular(SplitRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(splitModeIcon(mode), color: colors.secondary, size: 15),
          const SizedBox(width: SplitSpacing.xs),
          Text(
            label ?? splitModeLabel(mode),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.secondary,
                ),
          ),
        ],
      ),
    );
  }
}

class SplitModeCard extends StatelessWidget {
  const SplitModeCard({
    super.key,
    required this.mode,
    required this.selected,
    required this.onTap,
    this.label,
    this.description,
  });

  final SplitMode mode;
  final bool selected;
  final VoidCallback onTap;
  final String? label;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    return SplitCard(
      onTap: onTap,
      backgroundColor: selected ? colors.primarySoft.withValues(alpha: 0.58) : colors.surface,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: selected ? colors.primary : colors.surfaceAlt,
              borderRadius: BorderRadius.circular(SplitRadius.sm),
            ),
            child: Icon(
              splitModeIcon(mode),
              size: 21,
              color: selected ? Colors.white : colors.textSecondary,
            ),
          ),
          const SizedBox(width: SplitSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label ?? splitModeLabel(mode), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: SplitSpacing.xs),
                Text(description ?? splitModeDescription(mode), style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: SplitSpacing.sm),
          Icon(
            selected ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: selected ? colors.primary : colors.textMuted,
          ),
        ],
      ),
    );
  }
}

class SplitFloatingNav extends StatelessWidget {
  const SplitFloatingNav({
    super.key,
    required this.activeTab,
    required this.onChanged,
    this.billsLabel = 'Bills',
    this.historyLabel = 'History',
    this.settingsLabel = 'Settings',
  });

  final SplitTab activeTab;
  final ValueChanged<SplitTab> onChanged;
  final String billsLabel;
  final String historyLabel;
  final String settingsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(SplitRadius.xl),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.38 : 0.12),
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
                label: billsLabel,
                selected: activeTab == SplitTab.home,
                onTap: () => onChanged(SplitTab.home),
              ),
              _NavItem(
                icon: Icons.history_rounded,
                label: historyLabel,
                selected: activeTab == SplitTab.history,
                onTap: () => onChanged(SplitTab.history),
              ),
              _NavItem(
                icon: Icons.tune_rounded,
                label: settingsLabel,
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
    final colors = context.splitColors;
    return Expanded(
      child: Tooltip(
        message: label,
        child: Material(
          color: selected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(SplitRadius.pill),
          child: InkWell(
            borderRadius: BorderRadius.circular(SplitRadius.pill),
            onTap: onTap,
            child: SizedBox(
              height: 48,
              child: Icon(
                icon,
                size: 22,
                color: selected ? Colors.white : colors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String splitModeLabel(SplitMode mode) {
  return switch (mode) {
    SplitMode.equal => 'Split Rata',
    SplitMode.items => 'Per Item',
    SplitMode.custom => 'Custom',
  };
}

String splitModeDescription(SplitMode mode) {
  return switch (mode) {
    SplitMode.equal => 'Bagi rata total tagihan ke semua peserta',
    SplitMode.items => 'Tetapkan tiap item ke peserta yang memesan',
    SplitMode.custom => 'Tentukan sendiri jumlah bayar tiap peserta',
  };
}

IconData splitModeIcon(SplitMode mode) {
  return switch (mode) {
    SplitMode.equal => Icons.balance_rounded,
    SplitMode.items => Icons.receipt_long_rounded,
    SplitMode.custom => Icons.edit_note_rounded,
  };
}
