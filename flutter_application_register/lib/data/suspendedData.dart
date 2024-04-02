import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_register/page/activitie.dart';
import 'package:flutter_application_register/page/suspended.dart';
import 'package:flutter_application_register/api/API.dart';
import 'package:flutter_application_register/model/UserModel.dart';
import 'package:flutter_application_register/model/search.dart';
import 'package:quickalert/quickalert.dart';

class SuspendedData extends StatefulWidget {
  const SuspendedData({super.key});

  @override
  State<SuspendedData> createState() => _SuspendedDataState();
}

class _SuspendedData extends StatefulWidget {
  @override
  _SuspendedDataState createState() => _SuspendedDataState();
}

class _SuspendedDataState extends State<SuspendedData> {
  FetchUserList _userList = FetchUserList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        
        padding: EdgeInsets.all(20),
        child: FutureBuilder<List<Userlist>>(
          future: _userList.getuserList(),
          builder: (context, snapshot) {
            var data = snapshot.data;
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '${data?[index].id}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${data?[index].name}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Status: '
                                  '${data?[index].email}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.article_outlined),
                        onPressed: () {
                          _showMyDialog(context);
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
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
            child: Text('ตกลง'),
          ),
        ],
      );
    },
  );
}

void showAlert(BuildContext context) {
  QuickAlert.show(context: context, type: QuickAlertType.confirm);
}
