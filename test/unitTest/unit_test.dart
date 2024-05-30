import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/firstpage.dart';
import 'package:flutter_application_register/page/sendOTP.dart';
import 'package:flutter_test/flutter_test.dart';


void main(){
  testWidgets('เทสการกดปุ่มหน้าแรกเพื่อไปยังหน้าต่อไป', (WidgetTester tester) async{
    await tester.pumpWidget(MaterialApp(
      home: FirstPage(),
    ));


    final nextbutton = find.byType(ElevatedButton);
    await tester.tap(nextbutton);

    await tester.pumpAndSettle();

    // ตรวจสอบว่ามีหน้า SendOTPPage ปรากฏขึ้น
    expect(find.byType(SendOTPPage), findsOneWidget);
  });
  testWidgets('test phone number input and form submission', (WidgetTester tester) async {
    // Build the SendOTPPage widget.
    await tester.pumpWidget(MaterialApp(
      home: SendOTPPage(),
    ));

    // Find the phone number input field using Key.
    final phoneField = find.byType(TextFormField);

    // Enter the phone number '0987654321'.
    await tester.enterText(phoneField, '0987654321');

    // Verify the input value.
    expect(find.text('0987654321'), findsOneWidget);

    // Tap the submit button.
    final submitButton = find.byType(ElevatedButton);
    await tester.tap(submitButton);

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // Verify the loading indicator is shown.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}