import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/activitie.dart';
import 'package:flutter_application_register/page/otp_verification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false; // To manage loading state

  Country selectedCountry = Country(
    phoneCode: "66",
    countryCode: "THA",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Thai",
    example: "Thai",
    displayName: "Thai",
    displayNameNoCountryCode: "THA",
    e164Key: "",
  );

  Future<void> sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    String phoneNumber =
        '${selectedCountry.phoneCode}${phoneNumberController.text}';
    try {
      var response = await http.post(
        Uri.parse('https://api.pdpaconsults.com/requestOTP'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone': phoneNumber, // แก้ไข key ตามที่ API ของคุณต้องการ
        }),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['data']['error'] == "0") {
          // OTP sent successfully
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OTPPage(phoneNumber: phoneNumber)),
          );
        } else {
          // Handle the error scenario
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseData['data']['msg']}')),
          );
        }
      } else {
        // Handle the scenario when response code is not 200
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP: ${response.body}')),
        );
      }
    } catch (e) {
      // Handle errors if any
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending OTP: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    phoneNumberController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneNumberController.text.length),
    );
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
                  "Login",
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
                    "Enter your Phone Number to continue, we will send you OTP to verify",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: phoneNumberController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาใส่หมายเลขโทรศัพท์';
                      }
                      if (value.length != 10) {
                        return 'หมายเลขโทรศัพท์ต้องมี 10 หลัก';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter Phone Number",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(14.0),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              countryListTheme:
                                  CountryListThemeData(bottomSheetHeight: 550),
                              onSelect: (value) {
                                setState(() {
                                  selectedCountry = value;
                                });
                              },
                            );
                          },
                          child: Text(
                            "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      suffixIcon: phoneNumberController.text.length > 9
                          ? Container(
                              height: 30,
                              width: 30,
                              margin: const EdgeInsets.all(10.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: const Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      sendOtp(); // เรียกใช้ฟังก์ชัน sendOtp
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      "Send OTP",
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
