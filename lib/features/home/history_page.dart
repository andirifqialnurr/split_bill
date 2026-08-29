import 'package:flutter/material.dart';

import '../../app/split_bill_controller.dart';
import '../../data/split_bill_repository.dart';
import '../../ui/split_components.dart';
import '../../ui/split_tokens.dart';
import 'history_detail_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required this.controller});

  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    final strings = controller.strings;
    final history = controller.state.history;
    return Scaffold(
      body: SplitScreen(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        children: [
          _Header(title: strings.recentBills, backLabel: strings.back),
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
                  _HistoryListTile(
                    bill: bill,
                    modeLabel: strings.modeLabel(bill.mode),
                    participantLabel: strings.participantCount(bill.participantCount),
                    onTap: () => _openDetail(context, bill.id),
                  ),
                  if (bill != history.last) const SizedBox(height: SplitSpacing.sm),
                ],
              ],
            ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, int billId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HistoryDetailPage(
          controller: controller,
          billId: billId,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.backLabel,
  });

  final String title;
  final String backLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SplitIconButton(
          tooltip: backLabel,
          icon: Icons.arrow_back_rounded,
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: SplitSpacing.md),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }
}

class _HistoryListTile extends StatelessWidget {
  const _HistoryListTile({
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
