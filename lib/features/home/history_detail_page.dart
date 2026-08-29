import 'package:flutter/material.dart';

import '../../app/split_bill_controller.dart';
import '../../ui/split_components.dart';
import '../../ui/split_tokens.dart';
import '../bill/result_page.dart';

class HistoryDetailPage extends StatelessWidget {
  const HistoryDetailPage({
    super.key,
    required this.controller,
    required this.billId,
  });

  final SplitBillController controller;
  final int billId;

  @override
  Widget build(BuildContext context) {
    final strings = controller.strings;
    return Scaffold(
      body: FutureBuilder(
        future: controller.getBillDetail(billId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final detail = snapshot.data;
          if (detail == null) {
            return SplitScreen(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                _Header(title: strings.billNotFound, backLabel: strings.back),
                SplitWarningBanner(
                  message: strings.billNotFoundMessage,
                  isError: true,
                ),
              ],
            );
          }
          return SplitScreen(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            children: [
              _Header(
                title: detail.bill.title.trim().isEmpty ? strings.savedBill : detail.bill.title,
                backLabel: strings.back,
                deleteLabel: strings.deleteBill,
                onDelete: () => _confirmDelete(context),
              ),
              ResultView(
                calculation: detail.calculation,
                strings: strings,
                title: detail.bill.title,
                occurredAt: detail.bill.occurredAt,
                mode: detail.bill.mode,
                onShare: () async {
                  await shareBillSummary(
                    detail.calculation,
                    strings: strings,
                    title: detail.bill.title,
                    occurredAt: detail.bill.occurredAt,
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(strings.summaryReadyToShare)),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
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
    if (deleted) {
      Navigator.of(context).pop();
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.backLabel,
    this.deleteLabel,
    this.onDelete,
  });

  final String title;
  final String backLabel;
  final String? deleteLabel;
  final VoidCallback? onDelete;

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
        if (onDelete != null) ...[
          const SizedBox(width: SplitSpacing.sm),
          SplitIconButton(
            tooltip: deleteLabel,
            icon: Icons.delete_outline_rounded,
            onPressed: onDelete,
          ),
        ],
      ],
    );
  }
}
