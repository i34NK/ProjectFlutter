import 'dart:convert';
import 'package:flutter_application_register/data/formList.dart';
import 'package:flutter_application_register/page/sendOTP.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/suspended.dart';
import 'package:flutter_application_register/data/formdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Activitie extends StatefulWidget {
  const Activitie({Key? key}) : super(key: key);

  @override
  _ActivitieState createState() => _ActivitieState();
}

class _ActivitieState extends State<Activitie> {
  String phoneNumber = '';
  int _selectedIndex = 0;
  String token = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  //ฟังก์ชันการเก็บข้อมูลการล็อกอินไว้ที่เครื่องตลอด
  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
      phoneNumber = prefs.getString('phone') ?? '';
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
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Phone Number",
              style: TextStyle(color: Colors.black, fontSize: 10),
            ),
            SizedBox(height: 5),
            Text(
              phoneNumber, // แสดงเบอร์โทรศัพท์
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Padding(
          //       padding: EdgeInsets.all(8.0),
          //       child: Text(
          //         'หมายเลข',
          //         style: TextStyle(fontSize: 15, color: Colors.grey),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.all(8.0),
          //       child: Text(
          //         'แบบฟอร์มคำยินยอม',
          //         style: TextStyle(fontSize: 15, color: Colors.grey),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.all(8.0),
          //       child: Text(
          //         'รายละเอียด',
          //         style: TextStyle(fontSize: 15, color: Colors.grey),
          //       ),
          //     ),
          //   ],
          // ),
          Divider(
            color: Colors.grey,
            thickness: 3,
          ),
          Expanded(
            // เรียกใช้หน้าแสดงแบบฟอร์ม
            child: FormFutureBuilder(),
          ),
        ],
      ),

      // Footer ส่วนล่าง
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

  //ฟังก์ชันการออกจากระบบ
  void _logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove("phone");
    await pref.remove("token");
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SendOTPPage()),
      (route) => false,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}