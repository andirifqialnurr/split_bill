import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../app/split_bill_strings.dart';
import '../../core/money.dart';
import '../../domain/split_bill_models.dart';
import '../../ui/split_components.dart';
import '../../ui/split_tokens.dart';

class ResultView extends StatelessWidget {
  const ResultView({
    super.key,
    required this.calculation,
    required this.strings,
    this.title,
    this.occurredAt,
    this.mode,
    this.onCopy,
    this.onShare,
    this.onSave,
    this.saveLabel,
  });

  final BillCalculation calculation;
  final SplitStrings strings;
  final String? title;
  final DateTime? occurredAt;
  final SplitMode? mode;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onSave;
  final String? saveLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GrandTotalCard(
          calculation: calculation,
          strings: strings,
          title: title,
          occurredAt: occurredAt,
          mode: mode,
        ),
        const SizedBox(height: SplitSpacing.lg),
        Text(strings.perPerson, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: SplitSpacing.md),
        for (final result in calculation.results) ...[
          _PersonResultCard(result: result, strings: strings),
          if (result != calculation.results.last) const SizedBox(height: SplitSpacing.sm),
        ],
        if (onCopy != null || onShare != null || onSave != null) ...[
          const SizedBox(height: SplitSpacing.lg),
          if (onCopy != null || onShare != null)
            Row(
              children: [
                if (onCopy != null)
                  Expanded(
                    child: SplitSecondaryButton(
                      label: strings.copySummary,
                      icon: Icons.content_copy_rounded,
                      onPressed: onCopy,
                    ),
                  ),
                if (onCopy != null && onShare != null) const SizedBox(width: SplitSpacing.sm),
                if (onShare != null)
                  Expanded(
                    child: SplitSecondaryButton(
                      label: strings.shareSummary,
                      icon: Icons.ios_share_rounded,
                      onPressed: onShare,
                    ),
                  ),
              ],
            ),
          if ((onCopy != null || onShare != null) && onSave != null)
            const SizedBox(height: SplitSpacing.sm),
          if (onSave != null)
            SplitPrimaryButton(
              label: saveLabel ?? strings.saveBill,
              icon: Icons.save_rounded,
              expand: true,
              onPressed: onSave,
            ),
        ],
        const SizedBox(height: SplitSpacing.xs),
        Text(
          strings.totalParticipants(calculation.results.length),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.textMuted),
        ),
      ],
    );
  }
}

class _GrandTotalCard extends StatelessWidget {
  const _GrandTotalCard({
    required this.calculation,
    required this.strings,
    required this.title,
    required this.occurredAt,
    required this.mode,
  });

  final BillCalculation calculation;
  final SplitStrings strings;
  final String? title;
  final DateTime? occurredAt;
  final SplitMode? mode;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    final note = _roundingNote(calculation.results, strings);
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
          Text(strings.grandTotal, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: SplitSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SplitMoneyText(calculation.grandTotal, size: 32),
          ),
          const SizedBox(height: SplitSpacing.lg),
          SplitSummaryRow(label: strings.subtotal, value: formatRupiah(calculation.subtotal)),
          if (calculation.taxAmount != 0)
            SplitSummaryRow(label: strings.tax, value: '+ ${formatRupiah(calculation.taxAmount)}'),
          if (calculation.serviceAmount != 0)
            SplitSummaryRow(label: strings.service, value: '+ ${formatRupiah(calculation.serviceAmount)}'),
          if (calculation.discountAmount != 0)
            SplitSummaryRow(
              label: strings.discount,
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
  const _PersonResultCard({
    required this.result,
    required this.strings,
  });

  final SettlementResult result;
  final SplitStrings strings;

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
            '${strings.due} ${formatRupiah(result.amountDue)}',
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
            SplitSummaryRow(label: strings.baseItems, value: formatRupiah(result.baseAmount)),
            SplitSummaryRow(label: strings.taxAndService, value: formatRupiah(result.chargesAmount)),
            SplitSummaryRow(
              label: strings.discount,
              value: '- ${formatRupiah(result.discountAmount)}',
              valueColor: colors.success,
            ),
            if (result.roundingAmount != 0)
              SplitSummaryRow(label: strings.rounding, value: formatRupiah(result.roundingAmount)),
            if (result.items.isNotEmpty) ...[
              const SizedBox(height: SplitSpacing.md),
              SplitSectionLabel(strings.items),
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
  required SplitStrings strings,
  String? title,
  DateTime? occurredAt,
}) async {
  final text = buildBillSummaryText(
    calculation,
    strings: strings,
    title: title,
    occurredAt: occurredAt,
  );
  await Clipboard.setData(ClipboardData(text: text));
}

Future<void> shareBillSummary(
  BillCalculation calculation, {
  required SplitStrings strings,
  String? title,
  DateTime? occurredAt,
}) async {
  final text = buildBillSummaryText(
    calculation,
    strings: strings,
    title: title,
    occurredAt: occurredAt,
  );
  await Clipboard.setData(ClipboardData(text: text));
}

String buildBillSummaryText(
  BillCalculation calculation, {
  required SplitStrings strings,
  String? title,
  DateTime? occurredAt,
}) {
  final buffer = StringBuffer()
    ..writeln(title == null || title.trim().isEmpty ? strings.splitBillSummary : title.trim());
  if (occurredAt != null) {
    buffer.writeln(DateFormat('d MMM y', 'id_ID').format(occurredAt));
  }
  buffer.writeln('${strings.grandTotal}: ${formatRupiah(calculation.grandTotal)}');
  for (final result in calculation.results) {
    buffer.writeln('${result.participant.name}: ${formatRupiah(result.amountDue)}');
  }
  return buffer.toString().trim();
}

String? _roundingNote(List<SettlementResult> results, SplitStrings strings) {
  if (results.every((result) => result.roundingAmount == 0)) return null;
  return strings.roundingNote;
}
