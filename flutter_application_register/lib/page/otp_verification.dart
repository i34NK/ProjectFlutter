import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/activitie.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OTPPage extends StatefulWidget {
  final String phoneNumber;
  final String? token;
  OTPPage({Key? key, required this.phoneNumber, this.token}) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  String otp = '';
  String? token;
  Timer? _timer;
  int _countDown = 30;
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
      // ตรวจสอบ OTP สำเร็จ
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Activitie()));
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
    startTimer();
    token = widget.token; // !!!!!สำคัญมาก สำหรับเช็ค token ไม่ให้แสดงผลว่า token is missing ตรวจสอบว่ามีการรับ token จาก widget อย่างถูกต้อง
  }

  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countDown > 0) {
          _countDown--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _resendOTP() {
    if (canResend) {
      setState(() {
        _countDown = 30;
        canResend = false;
      });
      startTimer();
    }
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
                  "OTP Verification",
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
                    "Enter the OTP sent to",
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
                    Text('00:${_countDown.toString()}'),
                    Row(
                      children: [
                        Text(
                          "Didn't receive OTP?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(width: 5),
                        InkWell(
                            onTap: () {
                              _resendOTP();
                            },
                            child: Text("Resend"))
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
                        "Login",
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
