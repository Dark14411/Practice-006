// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:javerage_timer/core/app/timer_app.dart';

void main() {
  testWidgets('Timer app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TimerApp());

    // Verify that timer starts at 01:00
    expect(find.text('01:00'), findsOneWidget);
    
    // Verify that play button is present
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });
}
