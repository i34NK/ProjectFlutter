import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class FormList extends StatefulWidget {
  final Future<List<String>> formsFuture;

  FormList({required Key key, required this.formsFuture}) : super(key: key);

  @override
  _FormListState createState() => _FormListState();
}

class _FormListState extends State<FormList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: widget.formsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
        } else {
          var forms = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text('รายการแบบฟอร์ม'),
            ),
            body: forms!.isEmpty
                ? Center(
                    child: Text(
                    'ไม่มีแบบฟอร์ม',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ))
                : ListView.builder(
                    itemCount: forms.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(forms[index]),
                        ),
                      );
                    },
                  ),
          );
        }
      },
    );
  }
}