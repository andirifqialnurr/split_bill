import 'package:flutter/material.dart';

import '../../app/split_bill_controller.dart';
import '../../app/split_bill_state.dart';
import '../../ui/split_components.dart';
import '../../ui/split_tokens.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.controller});

  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final colors = context.splitColors;
    final strings = controller.strings;
    return SplitScreen(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.settings,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: SplitSpacing.xs),
                  Text(
                    strings.localOnly,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colors.secondarySoft,
                borderRadius: BorderRadius.circular(SplitRadius.lg),
              ),
              child: Icon(Icons.tune_rounded, color: colors.secondary),
            ),
          ],
        ),
        SplitCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.theme,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: SplitSpacing.lg),
              SegmentedButton<ThemeMode>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(strings.system),
                    icon: const Icon(Icons.brightness_auto_rounded),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(strings.light),
                    icon: const Icon(Icons.light_mode_rounded),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(strings.dark),
                    icon: const Icon(Icons.dark_mode_rounded),
                  ),
                ],
                selected: {state.themeMode},
                onSelectionChanged: (value) {
                  controller.setThemeMode(value.first);
                },
              ),
            ],
          ),
        ),
        SplitCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.languageLabel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: SplitSpacing.lg),
              SegmentedButton<AppLanguage>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: AppLanguage.id,
                    label: Text(strings.indonesia),
                    icon: const Icon(Icons.translate_rounded),
                  ),
                  ButtonSegment(
                    value: AppLanguage.en,
                    label: Text(strings.english),
                    icon: const Icon(Icons.language_rounded),
                  ),
                ],
                selected: {state.language},
                onSelectionChanged: (value) {
                  controller.setLanguage(value.first);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
