import 'package:flutter/material.dart';
import 'package:flutter_application_register/data/my_formList.dart';
import 'package:flutter_application_register/data/my_formList.dart';
import 'package:flutter_application_register/page/waitconsent.dart';
import 'package:flutter_application_register/page/sendOTP.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String phoneNumber = '';
  int _selectedIndex = 0;
  String token = '';

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  //ฟังก์ชันการเก็บข้อมูลการล็อกอินไว้ที่เครื่องตลอด
  void getPrefs() async {
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
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "เบอร์โทรศัพท์ของคุณ",
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                SizedBox(height: 5),
                Text(
                  phoneNumber, // แสดงเบอร์โทรศัพท์
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ],
            ),
            Image.asset(
              'images/logoMobile.png',
              height: 60,
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
              'คำยินยอมของฉัน',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              'รายการเอกสารคำยินยอมของคุณ',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 3,
          ),
          Expanded(
            child: MyFormList(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 145, 235, 148),
          selectedItemColor: Colors.white,
          // unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              label: 'คำยินยอมของฉัน',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              label: 'เอกสารรอคำยินยอม',
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Activitie()));
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
    await pref.remove("phone");
    await pref.remove("token");
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SendOTPPage()),
      (route) => false,
    );
  }
}
