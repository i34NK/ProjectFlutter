import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/consentdata.dart';
import 'package:flutter_application_register/page/suspended.dart';

class Activitie extends StatefulWidget {
  const Activitie({Key? key}) : super(key: key);

  @override
  _ActivitieState createState() => _ActivitieState();
}

class _ActivitieState extends State<Activitie> {
  PageController _pageController = PageController();
  int selectedPage = 0;
  String _firstName = '';
  String _lastName = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final response = await http.get(Uri.parse('https://reqres.in/api/users/1'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _firstName = data['data']['first_name'];
          _lastName = data['data']['last_name'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to load data: $error');
    }
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
              '$_firstName $_lastName',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
            SizedBox(height: 12),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: PageView(
                controller: _pageController,
                children: [
                  ConsentData(),
                  SuspendedPage(),
                ],
                onPageChanged: onPageChange,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedPage,
        backgroundColor: Color.fromARGB(255, 145, 235, 148),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.article_outlined,
              color: Colors.white,
            ),
            label: 'เอกสารคำยินยอม',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.description,
              color: Colors.white,
            ),
            label: 'ความยินยอมที่ระงับ',
          ),
        ],
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  void onPageChange(int index) {
    setState(() {
      selectedPage = index;
    });
  }
}
