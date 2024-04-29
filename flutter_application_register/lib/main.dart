import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/firstpage.dart';
import 'package:flutter_application_register/page/registerpage.dart';
import 'package:flutter_application_register/page/activitie.dart';
import 'package:flutter_application_register/page/suspended.dart';
import 'package:flutter_application_register/page/formdata.dart';
import 'package:flutter_application_register/page/sendOTP.dart';
import 'package:flutter_application_register/page/sharedpreferences/homePage.dart';
import 'package:flutter_application_register/page/sharedpreferences/phonePage.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        
      ),
      home: FirstPage(),
    );
  }
}

