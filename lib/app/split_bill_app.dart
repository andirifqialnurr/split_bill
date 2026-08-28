import 'package:flutter/material.dart';

import '../features/home/home_page.dart';
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
      bottomNavigationBar: SplitFloatingNav(
        activeTab: state.activeTab,
        onChanged: controller.setTab,
        billsLabel: controller.strings.bills,
        settingsLabel: controller.strings.settings,
      ),
    );
  }
}
