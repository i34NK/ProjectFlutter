import 'package:flutter/material.dart';
import 'package:flutter_application_register/model/example_consent.dart';
import 'package:flutter_application_register/page/activitie.dart';
import 'package:flutter_application_register/page/suspended.dart';
import 'package:quickalert/quickalert.dart';

class ConsentData extends StatefulWidget {
  const ConsentData({super.key});

  @override
  State<ConsentData> createState() => _ConsentDataState();
}

class _ConsentDataState extends State<ConsentData> {
  static List<ConsentModel> consenttitle = [
    ConsentModel('ยินยอมให้ข้อมูล', 1, 'หมายเลขแบบฟอร์มที่ ','ยินยอม'),
    ConsentModel('หนังสือขอความยินยอมในการเก็บรวบรวมใช้หรือเปิดเผย', 2, 'หมายเลขแบบฟอร์มที่ ','ยินยอม'),
    ConsentModel('ข้อมูลทั่วไป', 3, 'หมายเลขแบบฟอร์มที่ ','ยินยอม'),
    ConsentModel('รวบรวมเพื่อการโฆษณา', 4, 'หมายเลขแบบฟอร์มที่ ','ยินยอม'),
  ];

  List<ConsentModel> display_list = List.from(consenttitle);

  void updateList(String value) {
    setState(() {
      display_list = consenttitle
          .where((element) =>
              element.consenttitle!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void showAlert() {
    QuickAlert.show(context: context, type: QuickAlertType.confirm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text('เอกสารความยินยอม',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20), // ระยะห่าง
              child: Text('รายการเอกสารความยินยอมของคุณ',
                  style: TextStyle(fontSize: 15, color: Colors.grey)),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 1, 10, 5),
              child: TextField(
                onChanged: (value)=> updateList(value),
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
            Container(
              margin: EdgeInsets.fromLTRB(5, 2, 5, 5),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView.separated(
                    padding: EdgeInsets.all(15),
                    itemCount: display_list.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {},
                        title: Text(display_list[index].consenttitle!),
                        subtitle: Text(
                            '${display_list[index].description!} ${display_list[index].numberconsent} ${display_list[index].status}'),
                        trailing: IconButton(
                          icon: Icon(Icons.align_horizontal_left_sharp),
                          onPressed: () {
                            _showMyDialog(context);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                showAlert();
              },
              child: Text('ยกเลิกให้คำยินยอม'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showAlert();
              },
              child: Text('ระงับ'),
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
}
