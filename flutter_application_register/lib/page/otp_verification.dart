import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/activitie.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter_application_register/page/activitie.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  String otp = '';
  Timer? _timer;
  int _countDown = 30;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
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
                  length: 4,
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
                if (otp.length == 4)
                  SizedBox(
                    width: double.infinity, 
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Activitie()));

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
