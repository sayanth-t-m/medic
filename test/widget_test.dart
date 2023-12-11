// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ocr_scanner/main.dart';

void main() {
  testWidgets('OCR Scanner widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Check Home screen widgets
    expect(find.widgetWithText(ElevatedButton, 'Select Image'), findsOneWidget);
    expect(find.text('Choose an option'), findsNothing);

    // Tap the home screen button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Select Image'));
    await tester.pump();

    // Check Alert Dialog
    expect(find.text('Choose an option'), findsOneWidget);
    expect(find.byType(IconButton), findsNWidgets(2));
  });
}
