// lib/register.dart

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/otp_verification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Country selectedcountry = Country(
      phoneCode: "66",
      countryCode: "THA",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Thai",
      example: "Thai",
      displayName: "Thai",
      displayNameNoCountryCode: "THA",
      e164Key: "");

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
                  key: _formkey,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: phoneNumberController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      _formkey.currentState?.validate();
                    },
                    validator: (value) {
                      // ตรวจสอบว่ามีการกรอกข้อมูลหรือไม่
                      if (value == null || value.isEmpty) {
                        return 'กรุณาใส่หมายเลขโทรศัพท์';
                      }

                      // ตรวจสอบความยาวของหมายเลขโทรศัพท์
                      if (value.length < 10) {
                        return 'หมายเลขโทรศัพท์ต้องมีอย่างน้อย 10 ตัว';
                      }
                      if(value.length >10){
                        return 'หมายเลขโทรศัพท์ต้องมีน้อยกว่า 10 ตัว';
                      }
                      // กรณีผ่านการตรวจสอบทั้งหมด
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
                          borderSide: const BorderSide(color: Colors.black12)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black12)),
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
                                  selectedcountry = value;
                                });
                              },
                            );
                          },
                          child: Text(
                              "${selectedcountry.flagEmoji} + ${selectedcountry.phoneCode}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                      suffixIcon: phoneNumberController.text.length > 9
                          ? Container(
                              height: 30,
                              width: 30,
                              margin: const EdgeInsets.all(10.0),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.green),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPPage(),
                          ));
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
