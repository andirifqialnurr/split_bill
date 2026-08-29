import 'package:flutter/material.dart';

import '../../app/split_bill_controller.dart';
import '../../core/money.dart';
import '../../data/split_bill_repository.dart';
import '../../ui/split_components.dart';
import '../../ui/split_tokens.dart';
import 'history_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.controller});

  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    final strings = controller.strings;
    final history = controller.state.history;
    final savedTotal = history.fold<int>(0, (sum, bill) => sum + bill.grandTotal);
    return SplitScreen(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(strings.appTitle, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: SplitSpacing.xs),
                  Text(
                    strings.homeIntro,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colors.primarySoft,
                borderRadius: BorderRadius.circular(SplitRadius.lg),
              ),
              child: Icon(Icons.groups_rounded, color: colors.primary),
            ),
          ],
        ),
        SplitCard(
          child: Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: strings.recentBills,
                  value: '${history.length}',
                  icon: Icons.receipt_long_rounded,
                ),
              ),
              const SizedBox(width: SplitSpacing.md),
              Expanded(
                child: _MetricTile(
                  label: strings.totalSaved,
                  value: formatRupiah(savedTotal),
                  icon: Icons.payments_rounded,
                ),
              ),
            ],
          ),
        ),
        SplitCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(strings.recentBills, style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Text(
                    strings.savedCount(history.length),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colors.textMuted,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: SplitSpacing.md),
              if (controller.state.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (history.isEmpty)
                SplitEmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: strings.noBillsTitle,
                  message: strings.noBillsMessage,
                )
              else
                Column(
                  children: [
                    for (final bill in history) ...[
                      _HistoryCard(
                        bill: bill,
                        modeLabel: strings.modeLabel(bill.mode),
                        participantLabel: strings.participantCount(bill.participantCount),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => HistoryDetailPage(
                                controller: controller,
                                billId: bill.id,
                              ),
                            ),
                          );
                        },
                      ),
                      if (bill != history.last) const SizedBox(height: SplitSpacing.sm),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colors.textMuted),
        const SizedBox(height: SplitSpacing.sm),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: SplitSpacing.xs),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.bill,
    required this.modeLabel,
    required this.participantLabel,
    required this.onTap,
  });

  final SavedBillSummary bill;
  final String modeLabel;
  final String participantLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    return Material(
      color: colors.surfaceAlt,
      borderRadius: BorderRadius.circular(SplitRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(SplitRadius.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(SplitSpacing.md),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.secondarySoft,
                  borderRadius: BorderRadius.circular(SplitRadius.sm),
                ),
                child: Icon(splitModeIcon(bill.mode), color: colors.secondary),
              ),
              const SizedBox(width: SplitSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: SplitSpacing.xs),
                    Text(
                      '$modeLabel - $participantLabel',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: SplitSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SplitMoneyText(bill.grandTotal, size: 13.5),
                  const SizedBox(height: SplitSpacing.xs),
                  Icon(Icons.chevron_right_rounded, color: colors.textMuted, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
