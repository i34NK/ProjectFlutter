import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_register/data/my_formList.dart';
import 'package:flutter_application_register/page/waitconsent.dart';
import 'package:flutter_application_register/page/myForm.dart';
import 'package:flutter_application_register/page/otp_verification.dart';
import 'package:flutter_application_register/page/sendOTP.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_register/page/firstpage.dart' as app;
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_test.mocks.dart';

@GenerateMocks(
    [http.Client]) // ใช้เพื่อเทสหน้า sendotp เพราะมีการใช้ httpclient
@GenerateMocks([SharedPreferences])
void main() {
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

  //หน้านี้การเทสมีการใช้ ้http จึงต้องใช้ mockito
  //test mock
  group('SendOTPPage', () {
    testWidgets('กรอกไม่ครบ 10 หลัก', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SendOTPPage(),
      ));

      // กรอกหมายเลขโทรศัพท์ที่ไม่ครบ 10 หลัก
      await tester.enterText(find.byType(TextFormField), '12345');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // ตรวจสอบว่ามีข้อความแจ้งเตือนแสดงขึ้น
      expect(find.text('กรุณากรอกเบอร์โทรศัพท์ 10 หลัก'), findsOneWidget);
    });
    testWidgets('กรอกครบ 10 หลัก', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SendOTPPage(),
      ));

      // กรอกหมายเลขโทรศัพท์ที่ครบ 10 หลัก
      await tester.enterText(find.byType(TextFormField), '1234567890');

      final Finder sendbutton = find.byType(ElevatedButton);
      await tester.tap(sendbutton);

      await tester.pump();
      expect(find.byType(SendOTPPage), findsOneWidget);
    });
  });

  group('หน้า myform', () {
    testWidgets(
        'เทสการกด icon ไปที่ เอกสารรอคำยินยอม Activitie ใน BottomNavigationBar',
        (WidgetTester tester) async {
      // ตั้งค่า mock สำหรับ SharedPreferences
      SharedPreferences.setMockInitialValues({
        'phone': '0123456789',
        'token': 'test-token',
      });

      await tester.pumpWidget(MaterialApp(
        home: MyForm(),
      ));

      // รอให้ widget ทำงานและแสดงผล
      await tester.pumpAndSettle();

      // คลิกที่ BottomNavigationBar ที่ตำแหน่งของ เอกสารรอคำยินยอม
      await tester.tap(find.byIcon(Icons.article_outlined));
      await tester.pumpAndSettle();

      // ตรวจสอบว่ามีการนำทางไปยังหน้า Activitie
      expect(find.byType(Activitie), findsOneWidget);
    });

    testWidgets('เทสการกด icon ไปที่ คำยินยอมของฉัน ใน BottomNavigationBar',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'phone': '0123456789',
        'token': 'test-token',
      });

      await tester.pumpWidget(MaterialApp(
        home: Activitie(),
      ));

      // รอให้ widget ทำงานและแสดงผล
      await tester.pumpAndSettle();

      // คลิกที่ BottomNavigationBar ที่ตำแหน่งของปุ่ม คำยินยอมของฉัน
      await tester.tap(find.byIcon(Icons.description));
      await tester.pumpAndSettle();

      // ตรวจสอบว่ามีการนำทางไปยังหน้า Activitie
      expect(find.byType(MyForm), findsOneWidget);
    });

    testWidgets('เทสการกด logout ที่หน้า Myform ใน BottomNavigationBar',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'phone': '0123456789',
        'token': 'test-token',
      });

      await tester.pumpWidget(MaterialApp(
        home: MyForm(),
      ));

      // รอให้ widget ทำงานและแสดงผล
      await tester.pumpAndSettle();

      // คลิกที่ BottomNavigationBar ที่ตำแหน่งของปุ่ม logout
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // ตรวจสอบว่ามีการนำทางไปยังหน้า Activitie
      expect(find.byType(SendOTPPage), findsOneWidget);
    });
    testWidgets('เทสการกด logout ที่หน้า Activitie ใน BottomNavigationBar',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'phone': '0123456789',
        'token': 'test-token',
      });

      await tester.pumpWidget(MaterialApp(
        home: Activitie(),
      ));

      // รอให้ widget ทำงานและแสดงผล
      await tester.pumpAndSettle();

      // คลิกที่ BottomNavigationBar ที่ตำแหน่งที่สอง
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      expect(find.byType(SendOTPPage), findsOneWidget);
    });
  });

  group('myformlist', () {
    testWidgets('เทสการกดปุ่ม tabbar ยินยอม ใน MyFormList',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'phone': '0123456789',
        'token': 'test-token',
      });

      await tester.pumpWidget(MaterialApp(
        home: MyFormList(),
      ));

      // รอให้ widget ทำงานและแสดงผล
      await tester.pumpAndSettle();

      // หา Tab ที่มีข้อความว่า 'ยินยอม'
      final agreetab = find.text('ยินยอม');
      await tester.tap(agreetab);
      await tester.pumpAndSettle();

    });

    testWidgets('เทสการกดปุ่ม tabbar หมดอายุ ใน MyFormList',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'phone': '0123456789',
        'token': 'test-token',
      });

      await tester.pumpWidget(MaterialApp(
        home: MyFormList(),
      ));

      // รอให้ widget ทำงานและแสดงผล
      await tester.pumpAndSettle();

      // หา Tab ที่มีข้อความว่า 'หมดอายุ'
      final expiredTab = find.text('หมดอายุ');
      await tester.tap(expiredTab);
      await tester.pumpAndSettle();

      expect(find.text('ไม่มีแบบฟอร์ม'), findsOneWidget);
    });
  });
}
