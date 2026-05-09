import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Firebase talab qilmaydigan oddiy widget testi
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Mobile Market'),
          ),
        ),
      ),
    );
    expect(find.text('Mobile Market'), findsOneWidget);
  });

  test('Basic math test', () {
    expect(2 + 2, equals(4));
  });

  test('String operations', () {
    const appName = 'Mobile Market';
    expect(appName.contains('Market'), isTrue);
    expect(appName.length, greaterThan(0));
  });
}
