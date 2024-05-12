import 'dart:convert';

import 'package:flutter_application_register/page/sendOTP.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/activitie.dart';
import 'package:flutter_application_register/page/suspended.dart';
import 'package:flutter_application_register/data/suspendedData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuspendedPage extends StatefulWidget {
  const SuspendedPage({Key? key}) : super(key: key);

  @override
  _SuspendedPageState createState() => _SuspendedPageState();
}

class _SuspendedPageState extends State<SuspendedPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Text(
              'เอกสารความยินยอมที่ถูกระงับ',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              'รายการเอกสารความยินยอมที่ถูกระงับ',
              style: TextStyle(fontSize: 15, color: Colors.grey),
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
            child: SuspendedData(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Color.fromARGB(255, 145, 235, 148), 
            selectedItemColor: Colors.white, 
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType
            .fixed, 
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
        onTap: (int index) async{
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Activitie()));
            }
            if (index == 2) {
                _logout(); // เรียกฟังก์ชัน _logout()
              }
          });
        },
      ),
    );
  }
  void _logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove("login");
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SendOTPPage()),
      (route) => false,
    );
  }
}


Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('ความยินยอมข้อมูลส่วนบุคคล'),
        content: Text(
            'Lorem ipsum dolor sit amet consectetur adipiscing elit. Vivamus ipsum est tincidunt sit amet posuere vel, luctus vel dolor. Suspendisse potenti. Curabitur vel mauris vel tortor pellentesque tempor. Pellentesque sodales, erat id congue blandit ipsum metus molestie arcu ac hendrerit felis est id leo. Pellentesque dolor ligula feugiat in diam nec lacinia tristique dui. Donec molestie ex eget purus malesuada egestas. Quisque commodo sagittis ante ac viverra. In id nulla nunc. Nulla elementum eros at vestibulum dignissim. Sed et lacinia est. Mauris non semper sapien. Lorem ipsum dolor sit amet consectetur adipiscing elit'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('ยกเลิกให้คำยินยอม'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('ตกลง'),
          ),
        ],
      );
    },
  );
}
