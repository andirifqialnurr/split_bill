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
                _Header(title: 'Bill not found'),
                const SplitCard(child: Text('This saved bill is no longer available.')),
              ],
            );
          }
          return SplitScreen(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            children: [
              _Header(title: detail.bill.title.trim().isEmpty ? 'Saved Bill' : detail.bill.title),
              ResultView(calculation: detail.calculation),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
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
