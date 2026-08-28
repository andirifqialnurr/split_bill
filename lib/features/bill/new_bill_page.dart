import 'package:flutter/material.dart';

import '../../app/split_bill_controller.dart';
import '../../app/split_bill_strings.dart';
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
          return Scaffold(body: Center(child: Text(widget.controller.strings.helperNeedTotal)));
        }

        final strings = widget.controller.strings;
        return Scaffold(
          body: SplitScreen(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            children: [
              _Header(controller: widget.controller),
              _StepIndicator(
                step: widget.controller.state.currentStep,
                steps: _stepsFor(draft.mode),
                mode: draft.mode,
                strings: strings,
              ),
              _buildStep(context, draft),
              _FooterActions(
                draft: draft,
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
      BillStep.charges => _ChargesStep(
          draft: draft,
          totalController: totalController,
          controller: widget.controller,
        ),
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
      SnackBar(content: Text(widget.controller.strings.billSaved)),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    final strings = controller.strings;
    return Row(
      children: [
        SplitIconButton(
          tooltip: strings.close,
          icon: Icons.close_rounded,
          onPressed: () => _close(context),
        ),
        const SizedBox(width: SplitSpacing.md),
        Expanded(
          child: Text(
            strings.newBill,
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
        title: Text(controller.strings.discardTitle),
        content: Text(controller.strings.discardMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(controller.strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(controller.strings.discard),
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
  const _StepIndicator({
    required this.step,
    required this.steps,
    required this.mode,
    required this.strings,
  });

  final BillStep step;
  final List<BillStep> steps;
  final SplitMode mode;
  final SplitStrings strings;

  @override
  Widget build(BuildContext context) {
    final activeIndex = steps.indexOf(step).clamp(0, steps.length - 1);
    return SplitCard(
      padding: const EdgeInsets.all(SplitSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SplitModeBadge(mode: mode, label: strings.modeLabel(mode)),
              const Spacer(),
              Text(
                '${activeIndex + 1}/${steps.length}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: context.splitColors.textMuted,
                    ),
              ),
            ],
          ),
          const SizedBox(height: SplitSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(SplitRadius.pill),
            child: LinearProgressIndicator(
              value: (activeIndex + 1) / steps.length,
              minHeight: 8,
              backgroundColor: context.splitColors.surfaceAlt,
            ),
          ),
          const SizedBox(height: SplitSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var index = 0; index < steps.length; index++) ...[
                  _StepPill(
                    label: _stepLabel(steps[index], mode, strings),
                    active: index == activeIndex,
                    done: index < activeIndex,
                  ),
                  if (index != steps.length - 1) const SizedBox(width: SplitSpacing.sm),
                ],
              ],
            ),
          ),
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
    final colors = context.splitColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SplitSpacing.md,
        vertical: SplitSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: active ? colors.primary : colors.surfaceAlt,
        borderRadius: BorderRadius.circular(SplitRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            done ? Icons.check_rounded : Icons.circle_rounded,
            size: 12,
            color: active ? Colors.white : colors.textMuted,
          ),
          const SizedBox(width: SplitSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: active ? Colors.white : colors.textSecondary,
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
    required this.controller,
  });

  final DraftBill draft;
  final TextEditingController titleController;
  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    final strings = controller.strings;
    if (titleController.text != draft.title) {
      titleController.text = draft.title;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SplitCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.billDetail, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: SplitSpacing.lg),
              SplitTextField(
                controller: titleController,
                label: strings.title,
                hint: strings.titleHint,
                textInputAction: TextInputAction.next,
                onChanged: controller.setTitle,
              ),
            ],
          ),
        ),
        const SizedBox(height: SplitSpacing.lg),
        SplitSectionLabel(strings.splitMode),
        const SizedBox(height: SplitSpacing.md),
        for (final mode in SplitMode.values) ...[
          SplitModeCard(
            mode: mode,
            selected: draft.mode == mode,
            label: strings.modeLabel(mode),
            description: strings.modeDescription(mode),
            onTap: () => controller.setMode(mode),
          ),
          const SizedBox(height: SplitSpacing.sm),
        ],
      ],
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
    final strings = controller.strings;
    return SplitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.people, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: SplitSpacing.xs),
          Text(strings.peopleIntro, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: SplitSpacing.lg),
          Row(
            children: [
              Expanded(
                child: SplitTextField(
                  controller: participantController,
                  label: strings.nickname,
                  hint: 'Ayu',
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addParticipant(),
                ),
              ),
              const SizedBox(width: SplitSpacing.sm),
              SplitIconButton(
                tooltip: strings.addPerson,
                icon: Icons.add_rounded,
                onPressed: _addParticipant,
              ),
            ],
          ),
          const SizedBox(height: SplitSpacing.lg),
          if (draft.participants.isEmpty)
            SplitEmptyState(
              icon: Icons.person_add_alt_1_rounded,
              title: strings.noPeopleTitle,
              message: strings.noPeopleMessage,
            )
          else
            Wrap(
              spacing: SplitSpacing.sm,
              runSpacing: SplitSpacing.sm,
              children: [
                for (final participant in draft.participants)
                  SplitParticipantChip(
                    participant: participant,
                    onTap: () => _rename(context, participant),
                    onDeleted: () => _remove(context, participant),
                  ),
              ],
            ),
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
        title: Text(controller.strings.editParticipant),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: InputDecoration(labelText: controller.strings.nickname),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(controller.strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(editController.text),
            child: Text(controller.strings.save),
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
        title: Text(controller.strings.removeParticipantTitle(participant.name)),
        content: Text(controller.strings.removeParticipantMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(controller.strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(controller.strings.remove),
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
    final strings = controller.strings;
    return SplitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.items, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: SplitSpacing.xs),
          Text(strings.itemsIntro, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: SplitSpacing.lg),
          SplitTextField(
            controller: nameController,
            label: strings.itemName,
            hint: strings.itemHint,
          ),
          const SizedBox(height: SplitSpacing.sm),
          Row(
            children: [
              SizedBox(
                width: 92,
                child: SplitTextField(
                  controller: quantityController,
                  label: strings.quantity,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: SplitSpacing.sm),
              Expanded(
                child: SplitTextField(
                  controller: totalController,
                  label: strings.totalPrice,
                  prefixText: 'Rp ',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: SplitSpacing.md),
          SplitGhostAddButton(
            label: strings.addItem,
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
          ),
          const SizedBox(height: SplitSpacing.lg),
          if (draft.items.isEmpty)
            SplitEmptyState(
              icon: Icons.playlist_add_rounded,
              title: strings.noItemsTitle,
              message: strings.noItemsMessage,
            )
          else
            Column(
              children: [
                for (final item in draft.items) ...[
                  _ItemTile(
                    item: item,
                    participants: draft.participants,
                    unassignedLabel: strings.unassigned,
                    deleteTooltip: strings.deleteItem,
                    onAssign: () => _showAssignSheet(context, item),
                    onDelete: () => controller.removeItem(item.localId),
                  ),
                  if (item != draft.items.last) const SizedBox(height: SplitSpacing.sm),
                ],
              ],
            ),
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
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: SplitSpacing.md),
                    Wrap(
                      spacing: SplitSpacing.sm,
                      runSpacing: SplitSpacing.sm,
                      children: [
                        for (final participant in draft.participants)
                          SplitParticipantChip(
                            participant: participant,
                            selected: selected.contains(participant.localId),
                            onTap: () {
                              setSheetState(() {
                                if (selected.contains(participant.localId)) {
                                  selected.remove(participant.localId);
                                } else {
                                  selected.add(participant.localId);
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
                          child: SplitSecondaryButton(
                            label: controller.strings.selectAll,
                            icon: Icons.done_all_rounded,
                            onPressed: () {
                              setSheetState(() {
                                selected
                                  ..clear()
                                  ..addAll(draft.participants.map((p) => p.localId));
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: SplitSpacing.sm),
                        Expanded(
                          child: SplitPrimaryButton(
                            label: controller.strings.done,
                            icon: Icons.check_rounded,
                            onPressed: () {
                              controller.setItemParticipants(item.localId, selected.toList());
                              Navigator.of(context).pop();
                            },
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
    required this.unassignedLabel,
    required this.deleteTooltip,
    required this.onAssign,
    required this.onDelete,
  });

  final BillItem item;
  final List<BillParticipant> participants;
  final String unassignedLabel;
  final String deleteTooltip;
  final VoidCallback onAssign;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final assigned = participants
        .where((participant) => item.participantIds.contains(participant.localId))
        .toList(growable: false);
    final colors = context.splitColors;
    return Material(
      color: colors.surfaceAlt,
      borderRadius: BorderRadius.circular(SplitRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(SplitRadius.md),
        onTap: onAssign,
        child: Padding(
          padding: const EdgeInsets.all(SplitSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: SplitSpacing.sm),
                  SplitIconButton(
                    tooltip: deleteTooltip,
                    icon: Icons.delete_outline_rounded,
                    onPressed: onDelete,
                  ),
                ],
              ),
              const SizedBox(height: SplitSpacing.xs),
              Text(
                '${item.quantity}x • ${formatRupiah(item.totalAmount)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: SplitSpacing.md),
              Row(
                children: [
                  if (assigned.isEmpty)
                    _UnassignedBadge(label: unassignedLabel)
                  else
                    Flexible(child: SplitAvatarStack(participants: assigned)),
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded, color: colors.textMuted),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnassignedBadge extends StatelessWidget {
  const _UnassignedBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.splitColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SplitSpacing.md,
        vertical: SplitSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.warningSoft,
        borderRadius: BorderRadius.circular(SplitRadius.pill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.warning),
      ),
    );
  }
}

class _ChargesStep extends StatelessWidget {
  const _ChargesStep({
    required this.draft,
    required this.totalController,
    required this.controller,
  });

  final DraftBill draft;
  final TextEditingController totalController;
  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    final strings = controller.strings;
    final totalText = draft.equalTotalAmount == 0 ? '' : draft.equalTotalAmount.toString();
    if (totalController.text != totalText && totalController.text.isEmpty) {
      totalController.text = totalText;
    }
    final subtotal = _draftSubtotal();
    final calculation = controller.currentCalculation;
    final grandTotal = calculation?.grandTotal ??
        subtotal + draft.tax.resolve(subtotal) + draft.service.resolve(subtotal) - draft.discount.resolve(subtotal);
    return SplitCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            draft.mode == SplitMode.custom ? strings.customAmount : strings.charges,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: SplitSpacing.xs),
          Text(
            draft.mode == SplitMode.custom ? strings.customIntro : strings.chargesIntro,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SplitSpacing.lg),
          if (draft.mode == SplitMode.equal) ...[
            SplitTextField(
              controller: totalController,
              label: strings.billTotal,
              prefixText: 'Rp ',
              keyboardType: TextInputType.number,
              onChanged: controller.setBillTotal,
            ),
            const SizedBox(height: SplitSpacing.lg),
          ],
          if (draft.mode == SplitMode.custom) ...[
            _CustomAmountEditor(
              draft: draft,
              totalController: totalController,
              controller: controller,
            ),
            const SizedBox(height: SplitSpacing.lg),
          ],
          SplitSummaryRow(
            label: draft.mode == SplitMode.items ? strings.subtotalFromItems : strings.subtotal,
            value: formatRupiah(subtotal),
            bold: true,
          ),
          const SizedBox(height: SplitSpacing.lg),
          _ChargeEditor(label: strings.tax, strings: strings, charge: draft.tax, onChanged: controller.setTax),
          const SizedBox(height: SplitSpacing.md),
          _ChargeEditor(label: strings.service, strings: strings, charge: draft.service, onChanged: controller.setService),
          const SizedBox(height: SplitSpacing.md),
          _ChargeEditor(label: strings.discount, strings: strings, charge: draft.discount, onChanged: controller.setDiscount),
          const SizedBox(height: SplitSpacing.lg),
          Container(
            padding: const EdgeInsets.all(SplitSpacing.lg),
            decoration: BoxDecoration(
              color: context.splitColors.primarySoft.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(SplitRadius.lg),
            ),
            child: Column(
              children: [
                SplitSummaryRow(label: strings.subtotal, value: formatRupiah(subtotal)),
                if (draft.tax.type != ChargeType.none)
                  SplitSummaryRow(label: strings.tax, value: '+ ${formatRupiah(draft.tax.resolve(subtotal))}'),
                if (draft.service.type != ChargeType.none)
                  SplitSummaryRow(label: strings.service, value: '+ ${formatRupiah(draft.service.resolve(subtotal))}'),
                if (draft.discount.type != ChargeType.none)
                  SplitSummaryRow(
                    label: strings.discount,
                    value: '- ${formatRupiah(draft.discount.resolve(subtotal))}',
                    valueColor: context.splitColors.success,
                  ),
                Divider(color: context.splitColors.border),
                SplitSummaryRow(label: strings.grandTotal, value: formatRupiah(grandTotal.clamp(0, 1 << 62)), bold: true),
              ],
            ),
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

class _CustomAmountEditor extends StatelessWidget {
  const _CustomAmountEditor({
    required this.draft,
    required this.totalController,
    required this.controller,
  });

  final DraftBill draft;
  final TextEditingController totalController;
  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    final strings = controller.strings;
    final allocated = draft.customShares.values.fold<int>(0, (sum, amount) => sum + amount);
    final remaining = draft.equalTotalAmount - allocated;
    final ok = remaining == 0 && draft.equalTotalAmount > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SplitTextField(
          controller: totalController,
          label: strings.totalToSplit,
          prefixText: 'Rp ',
          keyboardType: TextInputType.number,
          onChanged: controller.setBillTotal,
        ),
        const SizedBox(height: SplitSpacing.md),
        SplitWarningBanner(
          message: ok ? strings.allocationOk : strings.remainingAmount(formatRupiah(remaining)),
          isError: !ok,
        ),
        const SizedBox(height: SplitSpacing.lg),
        for (final participant in draft.participants) ...[
          Row(
            children: [
              SplitParticipantAvatar(participant: participant),
              const SizedBox(width: SplitSpacing.md),
              Expanded(
                child: Text(
                  participant.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: SplitSpacing.md),
              SizedBox(
                width: 136,
                child: TextFormField(
                  key: ValueKey('custom-${participant.localId}-${draft.customShares[participant.localId] ?? 0}'),
                  initialValue: (draft.customShares[participant.localId] ?? 0) == 0
                      ? ''
                      : (draft.customShares[participant.localId] ?? 0).toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(prefixText: 'Rp '),
                  onChanged: (value) => controller.setCustomShare(participant.localId, value),
                ),
              ),
            ],
          ),
          const SizedBox(height: SplitSpacing.sm),
        ],
      ],
    );
  }
}

class _ChargeEditor extends StatelessWidget {
  const _ChargeEditor({
    required this.label,
    required this.strings,
    required this.charge,
    required this.onChanged,
  });

  final String label;
  final SplitStrings strings;
  final BillCharge charge;
  final ValueChanged<BillCharge> onChanged;

  @override
  Widget build(BuildContext context) {
    return SplitCard(
      padding: const EdgeInsets.all(SplitSpacing.md),
      backgroundColor: context.splitColors.surfaceAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: SplitSpacing.sm),
          SegmentedButton<ChargeType>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: ChargeType.none, label: Text(strings.none)),
              const ButtonSegment(value: ChargeType.fixed, label: Text('Rp')),
              const ButtonSegment(value: ChargeType.percentage, label: Text('%')),
            ],
            selected: {charge.type},
            onSelectionChanged: (value) {
              onChanged(charge.copyWith(type: value.first, value: 0));
            },
          ),
          if (charge.type != ChargeType.none) ...[
            const SizedBox(height: SplitSpacing.sm),
            TextFormField(
              key: ValueKey('$label-${charge.type}-${charge.value}'),
              initialValue: charge.value == 0
                  ? ''
                  : charge.type == ChargeType.percentage
                      ? (charge.value / 100).toString()
                      : charge.value.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: charge.type == ChargeType.percentage ? '$label ${strings.percent}' : '$label ${strings.amount}',
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
      ),
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
      final draft = controller.state.draft;
      final strings = controller.strings;
      return ResultView(
        calculation: calculation,
        title: draft?.title,
        occurredAt: draft?.occurredAt,
        mode: draft?.mode,
        onCopy: () async {
          await copyBillSummary(
            calculation,
            title: draft?.title,
            occurredAt: draft?.occurredAt,
          );
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(strings.summaryCopied)),
          );
        },
        onSave: onSave,
      );
    } on BillValidationException catch (error) {
      return SplitWarningBanner(message: error.message, isError: true);
    }
  }
}

class _FooterActions extends StatelessWidget {
  const _FooterActions({
    required this.draft,
    required this.controller,
    required this.onSave,
  });

  final DraftBill draft;
  final SplitBillController controller;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final step = controller.state.currentStep;
    final strings = controller.strings;
    final canAdvance = _canAdvance(step, draft);
    final isFirst = step == _stepsFor(draft.mode).first;
    final isResult = step == BillStep.result;
    return Column(
      children: [
        if (!canAdvance && !isResult) ...[
          SplitWarningBanner(message: _advanceHelper(step, draft, strings), isError: true),
          const SizedBox(height: SplitSpacing.sm),
        ],
        Row(
          children: [
            if (!isFirst)
              Expanded(
                child: SplitSecondaryButton(
                  label: strings.back,
                  icon: Icons.arrow_back_rounded,
                  onPressed: controller.previousStep,
                ),
              ),
            if (!isFirst) const SizedBox(width: SplitSpacing.sm),
            Expanded(
              child: SplitPrimaryButton(
                label: isResult ? strings.saveBill : strings.next,
                icon: isResult ? Icons.save_rounded : Icons.arrow_forward_rounded,
                onPressed: isResult ? onSave : (canAdvance ? controller.nextStep : null),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

List<BillStep> _stepsFor(SplitMode mode) {
  return switch (mode) {
    SplitMode.items => const [
        BillStep.detail,
        BillStep.people,
        BillStep.items,
        BillStep.charges,
        BillStep.result,
      ],
    SplitMode.equal || SplitMode.custom => const [
        BillStep.detail,
        BillStep.people,
        BillStep.charges,
        BillStep.result,
      ],
  };
}

String _stepLabel(BillStep step, SplitMode mode, SplitStrings strings) {
  return switch (step) {
    BillStep.detail => strings.billDetail,
    BillStep.people => strings.people,
    BillStep.items => strings.items,
    BillStep.charges => mode == SplitMode.custom ? strings.custom : strings.charges,
    BillStep.result => isEnglishResult(strings),
  };
}

bool _canAdvance(BillStep step, DraftBill draft) {
  return switch (step) {
    BillStep.detail => true,
    BillStep.people => draft.participants.length >= 2,
    BillStep.items => draft.items.isNotEmpty,
    BillStep.charges => _chargesValid(draft),
    BillStep.result => true,
  };
}

bool _chargesValid(DraftBill draft) {
  if (draft.mode == SplitMode.equal && draft.equalTotalAmount <= 0) return false;
  if (draft.mode == SplitMode.custom) {
    final allocated = draft.customShares.values.fold<int>(0, (sum, amount) => sum + amount);
    return draft.equalTotalAmount > 0 && allocated == draft.equalTotalAmount;
  }
  return draft.items.isNotEmpty;
}

String _advanceHelper(BillStep step, DraftBill draft, SplitStrings strings) {
  return switch (step) {
    BillStep.detail => '',
    BillStep.people => strings.helperNeedPeople,
    BillStep.items => strings.helperNeedItems,
    BillStep.charges => draft.mode == SplitMode.custom ? strings.helperNeedCustom : strings.helperNeedTotal,
    BillStep.result => '',
  };
}

String isEnglishResult(SplitStrings strings) => strings.isEnglish ? 'Result' : 'Hasil';
