import 'package:flutter_test/flutter_test.dart';
import 'package:eurolingo/main.dart';

void main() {
  testWidgets('EuroLingo app should launch', (WidgetTester tester) async {
    await tester.pumpWidget(const EuroLingoApp());
    expect(find.text('EuroLingo'), findsOneWidget);
  });
}
