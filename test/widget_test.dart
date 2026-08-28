import 'package:flutter_test/flutter_test.dart';
import 'package:split_bill/app/split_bill_app.dart';

void main() {
  testWidgets('shows Split Bill home smoke screen', (tester) async {
    await tester.pumpWidget(const SplitBillApp(loadPersistenceOnStart: false));

    expect(find.text('Split Bill'), findsOneWidget);
    expect(find.text('Split a new bill'), findsOneWidget);
    expect(find.text('New Bill'), findsOneWidget);
    expect(find.text('Equal Split'), findsOneWidget);
  });
}
