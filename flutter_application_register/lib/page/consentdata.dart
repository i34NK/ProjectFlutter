import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/activitie.dart';
import 'package:flutter_application_register/page/suspended.dart';
import 'package:quickalert/quickalert.dart';

class ConsentData extends StatefulWidget {
  const ConsentData({super.key});

  @override
  State<ConsentData> createState() => _ConsentDataState();
}

class _ConsentDataState extends State<ConsentData> {
  void showAlert() {
    QuickAlert.show(context: context, type: QuickAlertType.confirm,title: 'คุณต้องการยกเลิกการให้ความยินยอมใช่หรือไม่');
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
                    itemCount: 10,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {},
                        title: Text('แบบฟอร์มคำยินยอม '),
                        subtitle: Text('หมายเลขแบบฟอร์ม $index'),
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SuspendedPage()));
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
