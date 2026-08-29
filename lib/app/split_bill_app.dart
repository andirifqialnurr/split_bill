import 'package:flutter/material.dart';

import '../domain/split_bill_models.dart';
import '../features/bill/new_bill_page.dart';
import '../features/home/home_page.dart';
import '../features/home/history_page.dart';
import '../features/settings/settings_page.dart';
import '../ui/split_components.dart';
import '../ui/split_theme.dart';
import 'split_bill_controller.dart';
import 'split_bill_state.dart';

class SplitBillApp extends StatefulWidget {
  const SplitBillApp({super.key, this.loadPersistenceOnStart = true});

  final bool loadPersistenceOnStart;

  @override
  State<SplitBillApp> createState() => _SplitBillAppState();
}

class _SplitBillAppState extends State<SplitBillApp> {
  late final SplitBillController controller;

  @override
  void initState() {
    super.initState();
    controller = SplitBillController();
    if (widget.loadPersistenceOnStart) {
      controller.loadHistory();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          title: 'Split Bill',
          debugShowCheckedModeBanner: false,
          theme: SplitTheme.light(),
          darkTheme: SplitTheme.dark(),
          themeMode: controller.state.themeMode,
          home: SplitShell(controller: controller),
        );
      },
    );
  }
}

class SplitShell extends StatelessWidget {
  const SplitShell({super.key, required this.controller});

  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final page = switch (state.activeTab) {
      SplitTab.home => HomePage(controller: controller),
      SplitTab.history => HistoryPage(controller: controller),
      SplitTab.settings => SettingsPage(controller: controller),
    };

    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: KeyedSubtree(
          key: ValueKey(state.activeTab),
          child: page,
        ),
      ),
      floatingActionButton: state.activeTab == SplitTab.home
          ? FloatingActionButton(
              tooltip: controller.strings.newBill,
              onPressed: () => _startBill(context),
              child: const Icon(Icons.add_rounded),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: SplitFloatingNav(
        activeTab: state.activeTab,
        onChanged: controller.setTab,
        billsLabel: controller.strings.bills,
        historyLabel: controller.strings.history,
        settingsLabel: controller.strings.settings,
      ),
    );
  }

  void _startBill(BuildContext context) {
    controller.startBill(SplitMode.items);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewBillPage(controller: controller),
      ),
    );
  }
}
