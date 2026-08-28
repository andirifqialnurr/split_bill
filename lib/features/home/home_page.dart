import 'package:flutter/material.dart';

import '../../app/split_bill_controller.dart';
import '../../core/money.dart';
import '../../domain/split_bill_models.dart';
import '../../ui/split_components.dart';
import '../../ui/split_tokens.dart';
import '../bill/new_bill_page.dart';
import 'history_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.controller});

  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final history = controller.state.history;
    return SplitScreen(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Split Bill',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: SplitSpacing.xs),
                  Text(
                    'Offline bill sharing for meals and small trips.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 24,
              backgroundColor: scheme.secondaryContainer,
              foregroundColor: scheme.onSecondaryContainer,
              child: const Icon(Icons.groups_rounded),
            ),
          ],
        ),
        SplitCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Split a new bill',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: SplitSpacing.sm),
              Text(
                'Create people, assign items, add charges, and get exact dues.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: SplitSpacing.lg),
              FilledButton.icon(
                onPressed: () => _startBill(context, SplitMode.items),
                icon: const Icon(Icons.add_rounded),
                label: const Text('New Bill'),
              ),
              const SizedBox(height: SplitSpacing.sm),
              OutlinedButton.icon(
                onPressed: () => _startBill(context, SplitMode.equal),
                icon: const Icon(Icons.drag_handle_rounded),
                label: const Text('Equal Split'),
              ),
            ],
          ),
        ),
        SplitCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Bills',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: SplitSpacing.md),
              if (controller.state.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (history.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(SplitSpacing.lg),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(SplitRadius.md),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: SplitSpacing.sm),
                      Text(
                        'No saved bills yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: SplitSpacing.xs),
                      Text(
                        'Start with item split or equal split.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              else
                ...history.map(
                  (bill) => Padding(
                    padding: const EdgeInsets.only(bottom: SplitSpacing.sm),
                    child: Material(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(SplitRadius.md),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SplitRadius.md),
                        ),
                        title: Text(
                          bill.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          '${bill.participantCount} people',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: Text(
                          formatRupiah(bill.grandTotal),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
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
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _startBill(BuildContext context, SplitMode mode) {
    controller.startBill(mode);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewBillPage(controller: controller),
      ),
    );
  }
}
