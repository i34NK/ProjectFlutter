import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/menu.dart';
import 'package:flutter_application_register/page/datatable.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('images/woman.png'),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Username",
              style: TextStyle(color: Colors.black, fontSize: 10),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "Joeshingshue",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildPageview(),
            SizedBox(height: 12,),
            buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget buildPageview() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: PageView(
        controller: _pageController,
        children: [
          ConsentData(),
          SuspendedPage(),
        ],
        onPageChanged: (index) {
          onPageChange(index);
        },
      ),
    );
  }

  Widget buildBottomNav() {
    return BottomNavigationBar(
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
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.description,
            color: Colors.white,
          ),
          label: 'ความยินยอมที่ระงับ',
        ),
      ],
      onTap: (int index) {
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  onPageChange(int index) {
    setState(() {
      selectedPage = index;
    });
  }
}
