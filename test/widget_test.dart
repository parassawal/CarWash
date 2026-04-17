import 'package:flutter_test/flutter_test.dart';
import 'package:car_wash_app/main.dart';

void main() {
  testWidgets('App should render main navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const CarWashApp());
    expect(find.text('Home'), findsOneWidget);
  });
}
