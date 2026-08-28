import 'package:flutter/material.dart';

import '../../app/split_bill_controller.dart';
import '../../ui/split_components.dart';
import '../../ui/split_tokens.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.controller});

  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
                label: const Text('New Bill'),
              ),
              const SizedBox(height: SplitSpacing.sm),
              OutlinedButton.icon(
                onPressed: () {},
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
