import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/dashboard.dart';
import 'package:flutter_application_register/page/activitie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val = await prefs.getString("login");
    if (val != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Activitie()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 35),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.password),
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {
                  login(context);
                },
                icon: Icon(Icons.login),
                label: Text('Login'),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void login(BuildContext context) async {
    if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty) {
      var response = await http.post(
          Uri.parse("https://api.pdpaconsults.online/login"),
          body: jsonEncode({
            "email": emailController.text,
            "password": passwordController.text
          }),
          headers: {
            "Content-Type": "application/json",
          });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print("Login: " + body["payload"]["fname"]);
        
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text("Token: ${body["token"]}")));

        pageRoute(body['payload'][
            'fname']); // เรียกใช้ฟังก์ชัน pageRoute เพื่อเก็บ token และเปลี่ยนหน้าไปยัง Activitie

      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("รหัสไม่ถูก")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Blank field")));
    }
  }

  void pageRoute(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("login", token);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Activitie()), (route) => false);
  }
}
