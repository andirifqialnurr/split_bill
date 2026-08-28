import 'package:flutter_test/flutter_test.dart';
import 'package:split_bill/app/split_bill_app.dart';

void main() {
  testWidgets('shows Indonesian home by default', (tester) async {
    await tester.pumpWidget(const SplitBillApp(loadPersistenceOnStart: false));

    expect(find.text('Split Bill'), findsOneWidget);
    expect(find.text('Bill Baru'), findsWidgets);
    expect(find.text('Split Rata'), findsWidgets);
    expect(find.text('Bagi tagihan offline.'), findsOneWidget);
  });

  testWidgets('switches to English from settings', (tester) async {
    await tester.pumpWidget(const SplitBillApp(loadPersistenceOnStart: false));

    await tester.tap(find.text('Pengaturan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bills'));
    await tester.pumpAndSettle();

    expect(find.text('New Bill'), findsWidgets);
    expect(find.text('Equal Split'), findsWidgets);
    expect(find.text('Split bills offline.'), findsOneWidget);
  });
}
