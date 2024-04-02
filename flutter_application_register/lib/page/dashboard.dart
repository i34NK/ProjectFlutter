import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String token = "";
  String fname = "";
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("login")!;
      fname = pref.getString("login")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
            child: Center(
          child: Column(
            children: [
              Text("Welcome User"),
              SizedBox(
                height: 15,
              ),
              Text("Your token : ${token}"),
              SizedBox(
                height: 35,
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  await pref.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                },
                icon: Icon(Icons.logout),
                label: Text('Logout'),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
