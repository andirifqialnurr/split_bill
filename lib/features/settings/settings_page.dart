import 'package:flutter/material.dart';

import '../../app/split_bill_controller.dart';
import '../../ui/split_components.dart';
import '../../ui/split_tokens.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.controller});

  final SplitBillController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final colors = context.splitColors;
    return SplitScreen(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: SplitSpacing.xs),
                  Text(
                    'Preferensi lokal untuk tampilan Split Bill.',
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
              Text('Theme', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: SplitSpacing.xs),
              Text(
                'Pilih mode yang nyaman untuk dipakai saat membagi tagihan.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: SplitSpacing.lg),
              SegmentedButton<ThemeMode>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('System'),
                    icon: Icon(Icons.brightness_auto_rounded),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text('Light'),
                    icon: Icon(Icons.light_mode_rounded),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text('Dark'),
                    icon: Icon(Icons.dark_mode_rounded),
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
          backgroundColor: colors.surfaceAlt,
          child: Row(
            children: [
              Icon(Icons.storage_rounded, color: colors.textMuted),
              const SizedBox(width: SplitSpacing.md),
              Expanded(
                child: Text(
                  'Semua bill tersimpan di SQLite lokal perangkat.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
