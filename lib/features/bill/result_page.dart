import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../core/money.dart';
import '../../domain/split_bill_models.dart';
import '../../ui/split_components.dart';
import '../../ui/split_tokens.dart';

class ResultView extends StatelessWidget {
  const ResultView({
    super.key,
    required this.calculation,
    this.title,
    this.occurredAt,
    this.mode,
    this.onCopy,
    this.onSave,
    this.saveLabel = 'Save Bill',
  });

  final BillCalculation calculation;
  final String? title;
  final DateTime? occurredAt;
  final SplitMode? mode;
  final VoidCallback? onCopy;
  final VoidCallback? onSave;
  final String saveLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GrandTotalCard(
          calculation: calculation,
          title: title,
          occurredAt: occurredAt,
          mode: mode,
        ),
        const SizedBox(height: SplitSpacing.lg),
        Text('Per person', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: SplitSpacing.md),
        for (final result in calculation.results) ...[
          _PersonResultCard(result: result),
          if (result != calculation.results.last) const SizedBox(height: SplitSpacing.sm),
        ],
        if (onCopy != null || onSave != null) ...[
          const SizedBox(height: SplitSpacing.lg),
          Row(
            children: [
              if (onCopy != null)
                Expanded(
                  child: SplitSecondaryButton(
                    label: 'Copy Summary',
                    icon: Icons.content_copy_rounded,
                    onPressed: onCopy,
                  ),
                ),
              if (onCopy != null && onSave != null) const SizedBox(width: SplitSpacing.sm),
              if (onSave != null)
                Expanded(
                  child: SplitPrimaryButton(
                    label: saveLabel,
                    icon: Icons.save_rounded,
                    onPressed: onSave,
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: SplitSpacing.xs),
        Text(
          'Total peserta: ${calculation.results.length}',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.textMuted),
        ),
      ],
    );
  }
}

class _GrandTotalCard extends StatelessWidget {
  const _GrandTotalCard({
    required this.calculation,
    required this.title,
    required this.occurredAt,
    required this.mode,
  });

  final BillCalculation calculation;
  final String? title;
  final DateTime? occurredAt;
  final SplitMode? mode;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    final note = _roundingNote(calculation.results);
    return SplitCard(
      backgroundColor: colors.primarySoft.withValues(alpha: 0.52),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title == null || title!.trim().isEmpty ? 'Split Bill' : title!.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (occurredAt != null) ...[
                      const SizedBox(height: SplitSpacing.xs),
                      Text(
                        DateFormat('d MMM y', 'id_ID').format(occurredAt!),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
              if (mode != null) ...[
                const SizedBox(width: SplitSpacing.md),
                SplitModeBadge(mode: mode!),
              ],
            ],
          ),
          const SizedBox(height: SplitSpacing.lg),
          Text('Grand Total', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: SplitSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SplitMoneyText(calculation.grandTotal, size: 32),
          ),
          const SizedBox(height: SplitSpacing.lg),
          SplitSummaryRow(label: 'Subtotal', value: formatRupiah(calculation.subtotal)),
          if (calculation.taxAmount != 0)
            SplitSummaryRow(label: 'Tax', value: '+ ${formatRupiah(calculation.taxAmount)}'),
          if (calculation.serviceAmount != 0)
            SplitSummaryRow(label: 'Service', value: '+ ${formatRupiah(calculation.serviceAmount)}'),
          if (calculation.discountAmount != 0)
            SplitSummaryRow(
              label: 'Discount',
              value: '- ${formatRupiah(calculation.discountAmount)}',
              valueColor: colors.success,
            ),
          if (note != null) ...[
            const SizedBox(height: SplitSpacing.md),
            SplitWarningBanner(message: note),
          ],
        ],
      ),
    );
  }
}

class _PersonResultCard extends StatelessWidget {
  const _PersonResultCard({required this.result});

  final SettlementResult result;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    return SplitCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(
            SplitSpacing.lg,
            SplitSpacing.sm,
            SplitSpacing.md,
            SplitSpacing.sm,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            SplitSpacing.lg,
            0,
            SplitSpacing.lg,
            SplitSpacing.lg,
          ),
          leading: SplitParticipantAvatar(participant: result.participant),
          title: Text(
            result.participant.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            'Due ${formatRupiah(result.amountDue)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SplitMoneyText(result.amountDue, size: 14),
              Icon(Icons.expand_more_rounded, color: colors.textMuted, size: 20),
            ],
          ),
          children: [
            SplitSummaryRow(label: 'Base items', value: formatRupiah(result.baseAmount)),
            SplitSummaryRow(label: 'Tax and service', value: formatRupiah(result.chargesAmount)),
            SplitSummaryRow(
              label: 'Discount',
              value: '- ${formatRupiah(result.discountAmount)}',
              valueColor: colors.success,
            ),
            if (result.roundingAmount != 0)
              SplitSummaryRow(label: 'Rounding', value: formatRupiah(result.roundingAmount)),
            if (result.items.isNotEmpty) ...[
              const SizedBox(height: SplitSpacing.md),
              const SplitSectionLabel('Items'),
              const SizedBox(height: SplitSpacing.xs),
              for (final item in result.items)
                SplitSummaryRow(label: item.itemName, value: formatRupiah(item.amount)),
            ],
          ],
        ),
      ),
    );
  }
}

Future<void> copyBillSummary(
  BillCalculation calculation, {
  String? title,
  DateTime? occurredAt,
}) async {
  final buffer = StringBuffer()
    ..writeln(title == null || title.trim().isEmpty ? 'Split Bill Summary' : title.trim());
  if (occurredAt != null) {
    buffer.writeln(DateFormat('d MMM y', 'id_ID').format(occurredAt));
  }
  buffer.writeln('Grand total: ${formatRupiah(calculation.grandTotal)}');
  for (final result in calculation.results) {
    buffer.writeln('${result.participant.name}: ${formatRupiah(result.amountDue)}');
  }
  await Clipboard.setData(ClipboardData(text: buffer.toString().trim()));
}

String? _roundingNote(List<SettlementResult> results) {
  if (results.every((result) => result.roundingAmount == 0)) return null;
  return 'Ada penyesuaian pembulatan supaya jumlah per peserta tetap sama dengan grand total.';
}
