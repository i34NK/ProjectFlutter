import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/suspended.dart';
import 'package:flutter_application_register/page/formdata.dart';
import 'package:flutter_application_register/page/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Activitie extends StatefulWidget {
  const Activitie({Key? key}) : super(key: key);

  @override
  _ActivitieState createState() => _ActivitieState();
}

class _ActivitieState extends State<Activitie> {
  String fname = '';
  String lname = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      fname = pref.getString("login")!; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.asset('images/woman.png'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Username",
              style: TextStyle(color: Colors.black, fontSize: 10),
            ),
            SizedBox(height: 5),
            Text(
              '${fname}',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Text(
              'เอกสารความยินยอม',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              'รายการเอกสารความยินยอมของคุณ',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 236, 233, 233),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: 'ค้นหาแบบฟอร์ม',
                hintStyle: TextStyle(fontSize: 15),
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.black,
                isDense: true,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'หมายเลข',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'แบบฟอร์มคำยินยอม',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'รายละเอียด',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
            thickness: 3,
          ),
          Expanded(
            child: FormData(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 145, 235, 148),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              label: 'เอกสารคำยินยอม',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              label: 'ความยินยอมที่ระงับ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'ออกจากระบบ',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) async {
            setState(() {
              _selectedIndex = index;
              if (index == 1) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SuspendedPage()));
              }
              if (index == 2) {
                _logout(); // เรียกฟังก์ชัน _logout()
              }
            });
          }),
    );
  }

  void _logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove("login");
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}