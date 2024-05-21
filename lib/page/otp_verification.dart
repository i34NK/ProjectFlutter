import 'dart:async';

import 'package:flutter_application_register/page/myForm.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/activitie.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_register/page/sendOTP.dart';

class OTPPage extends StatefulWidget {
  final String phoneNumber;
  final String? token;
  final Function sendOtpFunction;
  OTPPage({Key? key, required this.phoneNumber, this.token, required this.sendOtpFunction}) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  String otp = '';
  String? token;
  Timer? _timer;
  int _countDown = 300;
  bool canResend = false;


  @override
  void checkOTP(String pin, String token) async {
    // กำหนด URL ของ API verifyOtp
    String url = 'https://api.pdpaconsults.com/verifyOTP';

    // กำหนดข้อมูลที่จะส่งไปยัง API
    Map<String, dynamic> requestBody = {
      'pin': pin,
      'token': token, // ส่ง token ที่คุณเก็บไว้มาด้วย
    };

    // ส่งคำขอ POST ไปยัง API
    var response = await http.post(
      Uri.parse(url),
      body: json.encode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    // ตรวจสอบสถานะของการตรวจสอบ OTP
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token!);
      // ตรวจสอบ OTP สำเร็จ
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyForm()));
    } else {
      // ไม่สามารถตรวจสอบ OTP ได้
      // คุณสามารถดำเนินการต่อได้ตามต้องการ เช่น แสดงข้อความแจ้งเตือน
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Failed'),
          content: Text('OTP verification failed. Please try again.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }


  void initState() {
    super.initState();
    token = widget
        .token; // !!!!!สำคัญมาก สำหรับเช็ค token ไม่ให้แสดงผลว่า token is missing ตรวจสอบว่ามีการรับ token จาก widget อย่างถูกต้อง
    startTimer();
  }


  void dispose() {
    super.dispose();
    _timer!.cancel();
  }


  //ฟังก์ชันตัวนับเวลา
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_countDown == 0) {
        setState(() {
          timer.cancel();
          canResend = true;  // Allow user to resend OTP after timer ends
        });
      } else {
        setState(() {
          _countDown--;
        });
      }
    });
  }

  //ฟังก์ชันส่ง OTP อีกครั้ง
  void resendOTP() {
    if (canResend) {
      setState(() {
        _countDown = 300; // Reset the countdown back to 5 minutes
        canResend = false; // Reset resend ability
        startTimer();
      });
      
      
      widget.sendOtpFunction(); // เรียกใช้ฟังก์ชันส่ง OTP
    }
  }

  
  

  // แสดงเวลาให้เป็นนาที
  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}.${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'images/lock.png',
                  height: 200,
                ),
                SizedBox(
                  height: 80,
                ),
                Text(
                  "ยืนยันรหัส OTP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "กรอกรหัส OTP",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                OTPTextField(
                  fieldWidth: 50,
                  fieldStyle: FieldStyle.box,
                  length: 6,
                  keyboardType: TextInputType.number,
                  width: MediaQuery.of(context).size.width,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  textFieldAlignment: MainAxisAlignment.spaceEvenly,
                  onChanged: (pin) {
                    otp = pin;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(formatTime(_countDown)),
                    Row(
                      children: [
                        Text("ไม่ได้รับ OTP?",
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(width: 5),
                        InkWell(
                          onTap: canResend ? resendOTP : null,
                          child: Text(
                            "ส่งซ้ำ",
                            style: TextStyle(color: canResend ? Colors.blue : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (otp.length == 6)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // ตรวจสอบว่ามี token หรือยัง
                        if (token != null) {
                          // ถ้ามี token ให้เรียกใช้ checkOTP
                          checkOTP(otp, token!);
                        } else {
                          // ถ้าไม่มี token ให้แสดงข้อความแจ้งเตือน
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Error'),
                              content: Text('Token is missing.'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
