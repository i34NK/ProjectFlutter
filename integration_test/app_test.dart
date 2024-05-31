import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/otp_verification.dart';
import 'package:flutter_application_register/page/sendOTP.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_register/page/firstpage.dart' as app;
import 'package:flutter_application_register/page/otp_verification.dart'; // Import the OTP page
import 'package:otp_text_field/otp_text_field.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('กดปุ่มต่อไปในหน้าแรก', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: app.FirstPage(),
    ));

    final Finder nextbutton = find.byType(ElevatedButton);
    await tester.tap(nextbutton);

    await tester.pumpAndSettle();

    // ตรวจสอบว่ามีหน้า SendOTPPage ปรากฏขึ้น
    expect(find.byType(SendOTPPage), findsOneWidget);
  });

  testWidgets('test phone number input and form submission', (WidgetTester tester) async {
    // Build the SendOTPPage widget with mock navigation.
    await tester.pumpWidget(MaterialApp(
      home: SendOTPPage(),
      routes: {
        '/otppage': (context) => OTPPage(
              phoneNumber: '0992194628',
              sendOtpFunction: () {},
            ), // Define the route for OTPPage
      },
    ));

    // Find the phone number input field using Key.
    final phoneField = find.byType(TextFormField);

    // Enter the phone number '0992194628'.
    await tester.enterText(phoneField, '0992194628');

    // Verify the input value.
    expect(find.text('0992194628'), findsOneWidget);

    // Tap the submit button.
    final submitButton = find.byType(ElevatedButton);
    await tester.tap(submitButton);

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // Verify the loading indicator is shown.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Simulate the navigation to the OTPPage.
    await tester.pumpAndSettle();

    // Verify the OTPPage is shown.
    expect(find.byType(OTPPage), findsOneWidget);

    // Find the OTP input field using OTPTextField.
    final otpField = find.byType(OTPTextField);

    // Enter the OTP '123456'.
    await tester.enterText(otpField, '123456');

    // Verify the input value.
    expect(find.text('123456'), findsOneWidget);

    // Tap the submit button on the OTPPage.
    final otpSubmitButton = find.byType(ElevatedButton);
    await tester.tap(otpSubmitButton);

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // Here you can add further assertions to check the outcome after OTP submission,
    // for example, checking if a success message is shown or if the user is navigated to another page.
  });

  testWidgets('เทสหน้ายืนยัน otp', (widgetTester) async {
    
  });
}
