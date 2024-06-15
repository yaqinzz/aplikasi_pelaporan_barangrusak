import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_jasa/main.dart';

void main() {
  testWidgets('Login page displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that LoginPage is displayed.
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('Register page displays correctly', (WidgetTester tester) async {
    // Build the app and navigate to the RegisterPage.
    await tester.pumpWidget(MyApp());

    // Tap the 'Register' button.
    await tester.tap(find.text("Don't have an account? Register"));
    await tester.pumpAndSettle();

    // Verify that RegisterPage is displayed.
    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('Can navigate to register and back to login', (WidgetTester tester) async {
    // Build the app.
    await tester.pumpWidget(MyApp());

    // Tap the 'Register' button.
    await tester.tap(find.text("Don't have an account? Register"));
    await tester.pumpAndSettle();

    // Verify that RegisterPage is displayed.
    expect(find.text('Register'), findsOneWidget);

    // Tap the 'Login' button.
    await tester.tap(find.text('Already have an account? Login'));
    await tester.pumpAndSettle();

    // Verify that LoginPage is displayed again.
    expect(find.text('Login'), findsOneWidget);
  });
}