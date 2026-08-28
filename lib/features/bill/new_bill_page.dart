import 'package:flutter/material.dart';

import '../../app/split_bill_controller.dart';
import '../../app/split_bill_state.dart';
import '../../core/money.dart';
import '../../domain/split_bill_models.dart';
import '../../ui/split_components.dart';
import '../../ui/split_tokens.dart';
import 'result_page.dart';

class NewBillPage extends StatefulWidget {
  const NewBillPage({super.key, required this.controller});

  final SplitBillController controller;

  @override
  State<NewBillPage> createState() => _NewBillPageState();
}

class _NewBillPageState extends State<NewBillPage> {
  final titleController = TextEditingController();
  final totalController = TextEditingController();
  final participantController = TextEditingController();
  final itemNameController = TextEditingController();
  final itemQuantityController = TextEditingController(text: '1');
  final itemTotalController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    totalController.dispose();
    participantController.dispose();
    itemNameController.dispose();
    itemQuantityController.dispose();
    itemTotalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final draft = widget.controller.state.draft;
        if (draft == null) {
          return const Scaffold(body: Center(child: Text('No active bill.')));
        }

        return Scaffold(
          body: SplitScreen(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            children: [
              _Header(controller: widget.controller),
              _StepIndicator(step: widget.controller.state.currentStep),
              _buildStep(context, draft),
              _FooterActions(
                controller: widget.controller,
                onSave: () => _save(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStep(BuildContext context, DraftBill draft) {
    return switch (widget.controller.state.currentStep) {
      BillStep.detail => _DetailStep(
          draft: draft,
          titleController: titleController,
          totalController: totalController,
          controller: widget.controller,
        ),
      BillStep.people => _PeopleStep(
          draft: draft,
          participantController: participantController,
          controller: widget.controller,
        ),
      BillStep.items => _ItemsStep(
          draft: draft,
          nameController: itemNameController,
          quantityController: itemQuantityController,
          totalController: itemTotalController,
          controller: widget.controller,
        ),
      BillStep.charges => _ChargesStep(draft: draft, controller: widget.controller),
      BillStep.result => _ResultStep(controller: widget.controller, onSave: () => _save(context)),
    };
  }

  Future<void> _save(BuildContext context) async {
    final id = await widget.controller.saveCurrentBill();
    if (!context.mounted) return;
    if (id == null) {
      final message = widget.controller.state.errorMessage ?? 'Could not save bill.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bill saved to history.')),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: () => _close(context),
          icon: const Icon(Icons.close_rounded),
        ),
        const SizedBox(width: SplitSpacing.md),
        Expanded(
          child: Text(
            'New Bill',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }

  Future<void> _close(BuildContext context) async {
    if (!controller.hasDraftChanges) {
      controller.closeDraft();
      Navigator.of(context).pop();
      return;
    }
    final shouldClose = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard this bill?'),
        content: const Text('Unsaved bill data will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (shouldClose != true || !context.mounted) return;
    controller.closeDraft();
    Navigator.of(context).pop();
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step});

  final BillStep step;

  @override
  Widget build(BuildContext context) {
    final labels = {
      BillStep.detail: 'Detail',
      BillStep.people: 'People',
      BillStep.items: 'Items',
      BillStep.charges: 'Charges',
      BillStep.result: 'Result',
    };
    final activeIndex = BillStep.values.indexOf(step);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < BillStep.values.length; index++) ...[
            _StepPill(
              label: labels[BillStep.values[index]]!,
              active: index == activeIndex,
              done: index < activeIndex,
            ),
            if (index != BillStep.values.length - 1)
              const SizedBox(width: SplitSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _StepPill extends StatelessWidget {
  const _StepPill({
    required this.label,
    required this.active,
    required this.done,
  });

  final String label;
  final bool active;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SplitSpacing.md,
        vertical: SplitSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: active ? scheme.primary : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(SplitRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            done ? Icons.check_rounded : Icons.circle_rounded,
            size: 12,
            color: active ? scheme.onPrimary : scheme.onSurfaceVariant,
          ),
          const SizedBox(width: SplitSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: active ? scheme.onPrimary : scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _DetailStep extends StatelessWidget {
  const _DetailStep({
    required this.draft,
    required this.titleController,
    required this.totalController,
    required this.controller,
  });

  final DraftBill draft;
  final TextEditingController titleController;
  final TextEditingController totalController;
  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    if (titleController.text != draft.title) {
      titleController.text = draft.title;
    }
    final totalText = draft.equalTotalAmount == 0 ? '' : draft.equalTotalAmount.toString();
    if (totalController.text != totalText && totalController.text.isEmpty) {
      totalController.text = totalText;
    }

    return SplitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bill detail', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: SplitSpacing.lg),
          TextField(
            controller: titleController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Dinner at Braga',
            ),
            onChanged: controller.setTitle,
          ),
          const SizedBox(height: SplitSpacing.md),
          SegmentedButton<SplitMode>(
            segments: const [
              ButtonSegment(
                value: SplitMode.items,
                label: Text('Items'),
                icon: Icon(Icons.receipt_long_rounded),
              ),
              ButtonSegment(
                value: SplitMode.equal,
                label: Text('Equal'),
                icon: Icon(Icons.drag_handle_rounded),
              ),
              ButtonSegment(
                value: SplitMode.custom,
                label: Text('Custom'),
                icon: Icon(Icons.edit_note_rounded),
              ),
            ],
            selected: {draft.mode},
            onSelectionChanged: (value) => controller.setMode(value.first),
          ),
          if (draft.mode != SplitMode.items) ...[
            const SizedBox(height: SplitSpacing.md),
            TextField(
              controller: totalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Bill total',
                prefixText: 'Rp ',
              ),
              onChanged: controller.setBillTotal,
            ),
          ],
        ],
      ),
    );
  }
}

class _PeopleStep extends StatelessWidget {
  const _PeopleStep({
    required this.draft,
    required this.participantController,
    required this.controller,
  });

  final DraftBill draft;
  final TextEditingController participantController;
  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    final remaining = draft.equalTotalAmount -
        draft.customShares.values.fold<int>(0, (sum, amount) => sum + amount);
    return SplitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('People', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: SplitSpacing.lg),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: participantController,
                  decoration: const InputDecoration(
                    labelText: 'Nickname',
                    hintText: 'Ayu',
                  ),
                  onSubmitted: (_) => _addParticipant(),
                ),
              ),
              const SizedBox(width: SplitSpacing.sm),
              IconButton.filled(
                onPressed: _addParticipant,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          const SizedBox(height: SplitSpacing.lg),
          if (draft.participants.isEmpty)
            const _InlineNotice(
              icon: Icons.person_add_alt_1_rounded,
              text: 'Add at least one participant.',
            )
          else
            Wrap(
              spacing: SplitSpacing.sm,
              runSpacing: SplitSpacing.sm,
              children: [
                for (final participant in draft.participants)
                  InputChip(
                    avatar: CircleAvatar(child: Text(participant.initial)),
                    label: Text(participant.name),
                    onPressed: () => _rename(context, participant),
                    onDeleted: () => _remove(context, participant),
                  ),
              ],
            ),
          if (draft.mode == SplitMode.custom && draft.participants.isNotEmpty) ...[
            const SizedBox(height: SplitSpacing.lg),
            Text('Custom amounts', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: SplitSpacing.sm),
            for (final participant in draft.participants) ...[
              TextFormField(
                key: ValueKey('custom-${participant.localId}'),
                initialValue: (draft.customShares[participant.localId] ?? 0) == 0
                    ? ''
                    : (draft.customShares[participant.localId] ?? 0).toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: participant.name,
                  prefixText: 'Rp ',
                ),
                onChanged: (value) => controller.setCustomShare(participant.localId, value),
              ),
              const SizedBox(height: SplitSpacing.sm),
            ],
            _InlineNotice(
              icon: remaining == 0 ? Icons.check_circle_rounded : Icons.pending_rounded,
              text: 'Remaining ${formatRupiah(remaining)}',
            ),
          ],
        ],
      ),
    );
  }

  void _addParticipant() {
    controller.addParticipant(participantController.text);
    participantController.clear();
  }

  Future<void> _rename(
    BuildContext context,
    BillParticipant participant,
  ) async {
    final editController = TextEditingController(text: participant.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit participant'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nickname'),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(editController.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    editController.dispose();
    if (newName == null) return;
    controller.renameParticipant(participant.localId, newName);
  }

  Future<void> _remove(
    BuildContext context,
    BillParticipant participant,
  ) async {
    if (!controller.participantHasAssignment(participant.localId)) {
      controller.removeParticipant(participant.localId);
      return;
    }
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove ${participant.name}?'),
        content: const Text('Item assignments and custom amount for this person will be cleared.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (shouldRemove == true) {
      controller.removeParticipant(participant.localId);
    }
  }
}

class _ItemsStep extends StatelessWidget {
  const _ItemsStep({
    required this.draft,
    required this.nameController,
    required this.quantityController,
    required this.totalController,
    required this.controller,
  });

  final DraftBill draft;
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController totalController;
  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    if (draft.mode != SplitMode.items) {
      return const SplitCard(
        child: _InlineNotice(
          icon: Icons.task_alt_rounded,
          text: 'No item entry needed for this split mode.',
        ),
      );
    }

    return SplitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Items', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: SplitSpacing.lg),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Item name'),
          ),
          const SizedBox(height: SplitSpacing.sm),
          Row(
            children: [
              SizedBox(
                width: 92,
                child: TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Qty'),
                ),
              ),
              const SizedBox(width: SplitSpacing.sm),
              Expanded(
                child: TextField(
                  controller: totalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total price',
                    prefixText: 'Rp ',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SplitSpacing.sm),
          FilledButton.icon(
            onPressed: () {
              controller.addItem(
                name: nameController.text,
                quantity: quantityController.text,
                totalAmount: totalController.text,
              );
              nameController.clear();
              quantityController.text = '1';
              totalController.clear();
            },
            icon: const Icon(Icons.add_shopping_cart_rounded),
            label: const Text('Add Item'),
          ),
          const SizedBox(height: SplitSpacing.lg),
          if (draft.items.isEmpty)
            const _InlineNotice(
              icon: Icons.playlist_add_rounded,
              text: 'Add item totals, then assign people.',
            )
          else
            for (final item in draft.items) ...[
              _ItemTile(
                item: item,
                participants: draft.participants,
                onAssign: () => _showAssignSheet(context, item),
                onDelete: () => controller.removeItem(item.localId),
              ),
              const SizedBox(height: SplitSpacing.sm),
            ],
        ],
      ),
    );
  }

  void _showAssignSheet(BuildContext context, BillItem item) {
    final selected = item.participantIds.toSet();
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: SplitSpacing.md),
                    Wrap(
                      spacing: SplitSpacing.sm,
                      runSpacing: SplitSpacing.sm,
                      children: [
                        for (final participant in draft.participants)
                          FilterChip(
                            label: Text(participant.name),
                            avatar: CircleAvatar(child: Text(participant.initial)),
                            selected: selected.contains(participant.localId),
                            onSelected: (isSelected) {
                              setSheetState(() {
                                if (isSelected) {
                                  selected.add(participant.localId);
                                } else {
                                  selected.remove(participant.localId);
                                }
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: SplitSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setSheetState(() {
                                selected
                                  ..clear()
                                  ..addAll(draft.participants.map((p) => p.localId));
                              });
                            },
                            child: const Text('Select All'),
                          ),
                        ),
                        const SizedBox(width: SplitSpacing.sm),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              controller.setItemParticipants(item.localId, selected.toList());
                              Navigator.of(context).pop();
                            },
                            child: const Text('Done'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.item,
    required this.participants,
    required this.onAssign,
    required this.onDelete,
  });

  final BillItem item;
  final List<BillParticipant> participants;
  final VoidCallback onAssign;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final assignedNames = participants
        .where((participant) => item.participantIds.contains(participant.localId))
        .map((participant) => participant.name)
        .join(', ');
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(SplitRadius.md),
      child: ListTile(
        title: Text(
          item.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          assignedNames.isEmpty ? 'Unassigned' : assignedNames,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Wrap(
          spacing: SplitSpacing.xs,
          children: [
            IconButton(
              tooltip: 'Assign',
              onPressed: onAssign,
              icon: const Icon(Icons.group_add_rounded),
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
        onTap: onAssign,
      ),
    );
  }
}

class _ChargesStep extends StatelessWidget {
  const _ChargesStep({required this.draft, required this.controller});

  final DraftBill draft;
  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    final calculation = controller.currentCalculation;
    final subtotal = calculation?.subtotal ?? _draftSubtotal();
    final grandTotal = calculation?.grandTotal ?? subtotal;
    return SplitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Charges', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: SplitSpacing.sm),
          Text('Subtotal ${formatRupiah(subtotal)}'),
          const SizedBox(height: SplitSpacing.lg),
          _ChargeEditor(label: 'Tax', charge: draft.tax, onChanged: controller.setTax),
          const SizedBox(height: SplitSpacing.md),
          _ChargeEditor(label: 'Service', charge: draft.service, onChanged: controller.setService),
          const SizedBox(height: SplitSpacing.md),
          _ChargeEditor(label: 'Discount', charge: draft.discount, onChanged: controller.setDiscount),
          const SizedBox(height: SplitSpacing.lg),
          _InlineNotice(
            icon: Icons.payments_rounded,
            text: 'Preview total ${formatRupiah(grandTotal)}',
          ),
        ],
      ),
    );
  }

  int _draftSubtotal() {
    return switch (draft.mode) {
      SplitMode.items => draft.items.fold<int>(0, (sum, item) => sum + item.totalAmount),
      SplitMode.equal || SplitMode.custom => draft.equalTotalAmount,
    };
  }
}

class _ChargeEditor extends StatelessWidget {
  const _ChargeEditor({
    required this.label,
    required this.charge,
    required this.onChanged,
  });

  final String label;
  final BillCharge charge;
  final ValueChanged<BillCharge> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: SplitSpacing.sm),
        SegmentedButton<ChargeType>(
          segments: const [
            ButtonSegment(value: ChargeType.none, label: Text('None')),
            ButtonSegment(value: ChargeType.fixed, label: Text('Rp')),
            ButtonSegment(value: ChargeType.percentage, label: Text('%')),
          ],
          selected: {charge.type},
          onSelectionChanged: (value) {
            onChanged(charge.copyWith(type: value.first, value: 0));
          },
        ),
        if (charge.type != ChargeType.none) ...[
          const SizedBox(height: SplitSpacing.sm),
          TextFormField(
            key: ValueKey('$label-${charge.type}'),
            initialValue: charge.value == 0
                ? ''
                : charge.type == ChargeType.percentage
                    ? (charge.value / 100).toString()
                    : charge.value.toString(),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: charge.type == ChargeType.percentage ? '$label percent' : '$label amount',
              prefixText: charge.type == ChargeType.fixed ? 'Rp ' : null,
              suffixText: charge.type == ChargeType.percentage ? '%' : null,
            ),
            onChanged: (value) {
              final parsed = charge.type == ChargeType.percentage
                  ? percentageToBasisPoints(value)
                  : parseRupiah(value);
              onChanged(charge.copyWith(value: parsed));
            },
          ),
        ],
      ],
    );
  }
}

class _ResultStep extends StatelessWidget {
  const _ResultStep({required this.controller, required this.onSave});

  final SplitBillController controller;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    try {
      final calculation = controller.calculateOrThrow();
      return ResultView(
        calculation: calculation,
        onCopy: () async {
          await copyBillSummary(calculation);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Summary copied.')),
          );
        },
        onSave: onSave,
      );
    } on BillValidationException catch (error) {
      return SplitCard(
        child: _InlineNotice(
          icon: Icons.error_outline_rounded,
          text: error.message,
        ),
      );
    }
  }
}

class _FooterActions extends StatelessWidget {
  const _FooterActions({
    required this.controller,
    required this.onSave,
  });

  final SplitBillController controller;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final step = controller.state.currentStep;
    return Row(
      children: [
        if (step != BillStep.detail)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: controller.previousStep,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Back'),
            ),
          ),
        if (step != BillStep.detail) const SizedBox(width: SplitSpacing.sm),
        Expanded(
          child: FilledButton.icon(
            onPressed: step == BillStep.result ? onSave : controller.nextStep,
            icon: Icon(step == BillStep.result ? Icons.save_rounded : Icons.arrow_forward_rounded),
            label: Text(step == BillStep.result ? 'Save Bill' : 'Next'),
          ),
        ),
      ],
    );
  }
}

class _InlineNotice extends StatelessWidget {
  const _InlineNotice({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SplitSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(SplitRadius.md),
      ),
      child: Row(
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(width: SplitSpacing.sm),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
