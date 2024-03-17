import 'package:expense/components/login_components/login_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense/pages/login_page.dart';
import 'package:flutter/material.dart';



void main() {
  testWidgets('Login page UI test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
      ),
    );

    // Verify the presence of certain widgets on the screen.
    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Track and hack your finances like never before'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Login form validation test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
      ),
    );

    // Fill in an invalid email address.
    await tester.enterText(find.byType(TextFormField), 'invalidemail');

    // Trigger the form submission.
    await tester.tap(find.descendant(of: find.byType(Column), matching: find.byType(ElevatedButton)));
    await tester.pump();

    // Verify that the error message appears.
    expect(find.text('Please enter a valid email address'), findsOneWidget);

    // Clear the text field.
    await tester.enterText(find.byType(TextFormField), '');

    // Trigger the form submission again.
    await tester.tap(find.descendant(of: find.byType(Column), matching: find.byType(ElevatedButton)));
    await tester.pump();

    // Verify that the "Please enter your email" error message appears.
    expect(find.text('Please enter your email'), findsOneWidget);
  });

  // Add more test cases as needed for different scenarios.
}