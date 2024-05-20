import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/activitie.dart';
import 'package:flutter_application_register/page/otp_verification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SendOTPPage extends StatefulWidget {
  @override
  _SendOTPPageState createState() => _SendOTPPageState();
}

class _SendOTPPageState extends State<SendOTPPage> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? token;

  void initState() {
    super.initState();
    checkLogin(context);
  }

  Future<void> sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse('https://api.pdpaconsults.com/requestOTP'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone': _phoneController.text,
        }),
      );

      var responseData = jsonDecode(response.body);

      //เช็คว่าส่ง OTP สำเร็จหรือไม่
      if (response.statusCode == 200 && responseData['data']['error'] == "0") {
        // ประกาศตัวแปรเพื่อรับค่า response จาก API ในส่วนของ data->result->token
        token = responseData['data']['result']['token'];

        // บันทึกเบอร์โทรศัพท์ลง SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('phone', _phoneController.text);

        // ส่งไปหน้า OTPPage พร้อมกับข้อมูล phoneNumber และ token

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPPage(
                phoneNumber: _phoneController.text,
                token: token!,
                sendOtpFunction: sendOtp // ส่งตัวอ้างอิงของฟังก์ชัน sendOtp
                ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('การส่ง OTP ไม่สำเร็จ: ${responseData['data']['msg']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('มีข้อผิดพลาดในการส่ง OTP: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //Write Data in SharedPreferences
  void pageRoute(BuildContext context, String token) async {
    // เก็บข้อมูล token ไว้ใน SharedPreferences
    SharedPreferences prefs =
        await SharedPreferences.getInstance(); // write data
    await prefs.setString('phone', token); // write data ของ phone และ token
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Activitie()));
  }

  //ฟังก์ชันการตรวจสอบการล็อกอิน และ Read Data
  void checkLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? saveToken = await prefs.getString('token'); // read data token
    if (saveToken != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Activitie()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(
                  'images/Logo Project Web.png',
                  height: 300,
                ),
                Text(
                  "เข้าสู่ระบบ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "กรอกหมายเลขโทรศัพท์ของคุณเพื่อดำเนินการต่อ เราจะส่ง OTP ไปยังหมายเลขโทรศัพท์ของคุณ",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "กรุณากรอกเบอร์โทรศัพท์ของคุณ",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.grey.shade600),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกเบอร์โทรศัพท์ของคุณ';
                        }
                        if (value.length != 10) {
                          return 'กรุณากรอกเบอร์โทรศัพท์ 10 หลัก';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: sendOtp,
                        child: Text(
                          "ส่งรหัส",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          minimumSize: Size(double.infinity, 50),
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
