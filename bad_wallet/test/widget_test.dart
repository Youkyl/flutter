import 'package:flutter_test/flutter_test.dart';
import 'package:bad_wallet/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BadWalletApp());
    expect(find.byType(BadWalletApp), findsOneWidget);
  });
}
