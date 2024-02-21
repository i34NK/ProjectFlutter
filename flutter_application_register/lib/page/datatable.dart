import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quickalert/quickalert.dart';

//เพิ่ม refreshindicator ด้วย
class DataTableUser extends StatelessWidget {
  const DataTableUser();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('เอกสารความยินยอม',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 1), // ระยะห่าง
              child: Text('รายการเอกสารความยินยอมของคุณ',
                  style: TextStyle(fontSize: 20)),
            ),
            Expanded(
              child: DataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 419,
                columns: [
                  DataColumn2(
                    label: Text('หมายเลขแบบฟอร์ม'),
                  ),
                  DataColumn(
                    label: Text('แบบฟอร์มคำยินยอม'),
                  ),
                  DataColumn(
                    label: Text('รายละเอียด'),
                  ),
                ],
                rows: List<DataRow>.generate(
                  5,
                  (index) => DataRow(
                    cells: [
                      DataCell(Text('Ex1' * (1))),
                      DataCell(Text('Ex2' * (1))),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.align_horizontal_left_sharp),
                              onPressed: () {
                                _showMyDialog(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
}
