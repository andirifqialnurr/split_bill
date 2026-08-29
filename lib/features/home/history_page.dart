import 'package:flutter/material.dart';

import '../../app/split_bill_controller.dart';
import '../../data/split_bill_repository.dart';
import '../../domain/split_bill_models.dart';
import '../../ui/split_components.dart';
import '../../ui/split_tokens.dart';
import 'history_detail_page.dart';

enum _HistoryModeFilter { all, equal, items, custom }

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.controller});

  final SplitBillController controller;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _searchController = TextEditingController();
  var _modeFilter = _HistoryModeFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final strings = controller.strings;
    final history = controller.state.history;
    final searchQuery = _searchController.text.trim();
    final filteredHistory = history.where((bill) {
      if (!_matchesModeFilter(bill.mode)) return false;
      return _matchesSearch(
        bill: bill,
        query: searchQuery,
        modeLabel: strings.modeLabel(bill.mode),
        participantLabel: strings.participantCount(bill.participantCount),
      );
    }).toList(growable: false);
    return SplitScreen(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        Text(
          strings.history,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SplitCard(
          child: SplitTextField(
            fieldKey: const ValueKey('history-search-field'),
            controller: _searchController,
            label: strings.searchHistory,
            hint: strings.searchHistoryHint,
            textInputAction: TextInputAction.search,
            onChanged: (_) => setState(() {}),
          ),
        ),
        SplitCard(
          padding: const EdgeInsets.all(SplitSpacing.sm),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<_HistoryModeFilter>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: _HistoryModeFilter.all,
                  label: Text(strings.all),
                ),
                ButtonSegment(
                  value: _HistoryModeFilter.equal,
                  label: Text(strings.modeLabel(SplitMode.equal)),
                ),
                ButtonSegment(
                  value: _HistoryModeFilter.items,
                  label: Text(strings.modeLabel(SplitMode.items)),
                ),
                ButtonSegment(
                  value: _HistoryModeFilter.custom,
                  label: Text(strings.modeLabel(SplitMode.custom)),
                ),
              ],
              selected: {_modeFilter},
              onSelectionChanged: (selection) {
                setState(() => _modeFilter = selection.single);
              },
            ),
          ),
        ),
        if (controller.state.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (history.isEmpty)
          SplitEmptyState(
            icon: Icons.receipt_long_outlined,
            title: strings.noBillsTitle,
            message: strings.noBillsMessage,
          )
        else if (filteredHistory.isEmpty)
          SplitEmptyState(
            icon: Icons.search_off_rounded,
            title: strings.noSearchResultsTitle,
            message: strings.noSearchResultsMessage,
          )
        else
          Column(
            children: [
              for (final bill in filteredHistory) ...[
                _HistoryListTile(
                  bill: bill,
                  modeLabel: strings.modeLabel(bill.mode),
                  participantLabel: strings.participantCount(bill.participantCount),
                  deleteLabel: strings.deleteBill,
                  onTap: () => _openDetail(context, bill.id),
                  onDelete: () => _confirmDelete(context, bill.id),
                ),
                if (bill != filteredHistory.last) const SizedBox(height: SplitSpacing.sm),
              ],
            ],
          ),
      ],
    );
  }

  bool _matchesModeFilter(SplitMode mode) {
    return switch (_modeFilter) {
      _HistoryModeFilter.all => true,
      _HistoryModeFilter.equal => mode == SplitMode.equal,
      _HistoryModeFilter.items => mode == SplitMode.items,
      _HistoryModeFilter.custom => mode == SplitMode.custom,
    };
  }

  bool _matchesSearch({
    required SavedBillSummary bill,
    required String query,
    required String modeLabel,
    required String participantLabel,
  }) {
    if (query.isEmpty) return true;
    final normalized = query.toLowerCase();
    return bill.title.toLowerCase().contains(normalized) ||
        modeLabel.toLowerCase().contains(normalized) ||
        participantLabel.toLowerCase().contains(normalized) ||
        bill.participantCount.toString().contains(normalized);
  }

  void _openDetail(BuildContext context, int billId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HistoryDetailPage(
          controller: widget.controller,
          billId: billId,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, int billId) async {
    final strings = widget.controller.strings;
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

    final deleted = await widget.controller.deleteSavedBill(billId);
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
