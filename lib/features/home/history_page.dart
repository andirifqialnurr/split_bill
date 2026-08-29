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
    return SplitScreen(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        Text(
          strings.history,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
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
                  deleteLabel: strings.deleteBill,
                  onTap: () => _openDetail(context, bill.id),
                  onDelete: () => _confirmDelete(context, bill.id),
                ),
                if (bill != history.last) const SizedBox(height: SplitSpacing.sm),
              ],
            ],
          ),
      ],
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

  Future<void> _confirmDelete(BuildContext context, int billId) async {
    final strings = controller.strings;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(strings.deleteBillTitle),
          content: Text(strings.deleteBillMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(strings.remove),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) return;

    final deleted = await controller.deleteSavedBill(billId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(deleted ? strings.billDeleted : strings.deleteFailed),
      ),
    );
  }
}

class _HistoryListTile extends StatelessWidget {
  const _HistoryListTile({
    required this.bill,
    required this.modeLabel,
    required this.participantLabel,
    required this.deleteLabel,
    required this.onTap,
    required this.onDelete,
  });

  final SavedBillSummary bill;
  final String modeLabel;
  final String participantLabel;
  final String deleteLabel;
  final VoidCallback onTap;
  final VoidCallback onDelete;

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
              SplitMoneyText(bill.grandTotal, size: 13.5),
              IconButton(
                tooltip: deleteLabel,
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: colors.textMuted,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
