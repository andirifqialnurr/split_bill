import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/money.dart';
import '../../domain/split_bill_models.dart';
import '../../ui/split_components.dart';
import '../../ui/split_tokens.dart';

class ResultView extends StatelessWidget {
  const ResultView({
    super.key,
    required this.calculation,
    this.onCopy,
    this.onSave,
    this.saveLabel = 'Save Bill',
  });

  final BillCalculation calculation;
  final VoidCallback? onCopy;
  final VoidCallback? onSave;
  final String saveLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SplitCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Grand Total', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: SplitSpacing.xs),
              Text(
                formatRupiah(calculation.grandTotal),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: SplitSpacing.md),
              Wrap(
                spacing: SplitSpacing.sm,
                runSpacing: SplitSpacing.sm,
                children: [
                  _MetricChip(label: 'Subtotal', value: calculation.subtotal),
                  _MetricChip(label: 'Tax', value: calculation.taxAmount),
                  _MetricChip(label: 'Service', value: calculation.serviceAmount),
                  _MetricChip(label: 'Discount', value: -calculation.discountAmount),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: SplitSpacing.lg),
        for (final result in calculation.results) ...[
          Card(
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: SplitSpacing.lg,
                  vertical: SplitSpacing.sm,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(
                  SplitSpacing.lg,
                  0,
                  SplitSpacing.lg,
                  SplitSpacing.lg,
                ),
                leading: CircleAvatar(
                  backgroundColor: scheme.primaryContainer,
                  foregroundColor: scheme.onPrimaryContainer,
                  child: Text(result.participant.initial),
                ),
                title: Text(
                  result.participant.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text('Due ${formatRupiah(result.amountDue)}'),
                children: [
                  _BreakdownRow(label: 'Base items', amount: result.baseAmount),
                  _BreakdownRow(label: 'Tax and service', amount: result.chargesAmount),
                  _BreakdownRow(label: 'Discount', amount: -result.discountAmount),
                  if (result.roundingAmount != 0)
                    _BreakdownRow(label: 'Rounding', amount: result.roundingAmount),
                  if (result.items.isNotEmpty) ...[
                    const SizedBox(height: SplitSpacing.sm),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Items',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    const SizedBox(height: SplitSpacing.xs),
                    for (final item in result.items)
                      _BreakdownRow(label: item.itemName, amount: item.amount),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: SplitSpacing.sm),
        ],
        if (onCopy != null || onSave != null) ...[
          const SizedBox(height: SplitSpacing.sm),
          Row(
            children: [
              if (onCopy != null)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onCopy,
                    icon: const Icon(Icons.copy_rounded),
                    label: const Text('Copy Summary'),
                  ),
                ),
              if (onCopy != null && onSave != null)
                const SizedBox(width: SplitSpacing.sm),
              if (onSave != null)
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onSave,
                    icon: const Icon(Icons.save_rounded),
                    label: Text(saveLabel),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SplitSpacing.md,
        vertical: SplitSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(SplitRadius.sm),
      ),
      child: Text('$label ${formatRupiah(value)}'),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({required this.label, required this.amount});

  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SplitSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: SplitSpacing.md),
          Text(
            formatRupiah(amount),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

Future<void> copyBillSummary(BillCalculation calculation) async {
  final buffer = StringBuffer()
    ..writeln('Split Bill Summary')
    ..writeln('Grand total: ${formatRupiah(calculation.grandTotal)}');
  for (final result in calculation.results) {
    buffer.writeln('${result.participant.name}: ${formatRupiah(result.amountDue)}');
  }
  await Clipboard.setData(ClipboardData(text: buffer.toString().trim()));
}
