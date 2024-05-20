import 'package:flutter/material.dart';
import 'package:flutter_application_register/api/apiform.dart';
import 'package:flutter_application_register/model/ConsentFormModel.dart';
import 'package:flutter_application_register/search/search_delegrate.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_register/api/apiform.dart';
import 'package:flutter_application_register/model/ConsentFormModel.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_register/search/search_delegrate.dart';

class FormFutureBuilder extends StatefulWidget {
  const FormFutureBuilder({super.key});

  @override
  State<FormFutureBuilder> createState() => _FormFutureBuilderState();
}

class _FormFutureBuilderState extends State<FormFutureBuilder> {
  Future<List<Payload>> _getForm() async {
    FetchConsentFormList formDataList = FetchConsentFormList();
    List<Payload> forms = await formDataList.getConsentFormList();
    return forms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
              onTap: () {
                showSearch(context: context, delegate: FormSearchDelegate());
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Payload>>(
              future: _getForm(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return Center(child: Text('No data found'));
                }

                return RefreshIndicator(
                  onRefresh: _getForm,
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    snapshot.data[index].title,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    snapshot.data[index].dataType,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    DateFormat('yyyy-MM-dd').format(
                                        snapshot.data[index].requestDate),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FormDetail(snapshot.data[index]),
                              ),
                            );
                          },
                          icon: Icon(Icons.article_outlined),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FormDetail(snapshot.data[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class FormDetail extends StatelessWidget {
  final Payload form;

  FormDetail(this.form);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายเอียดแบบฟอร์ม',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 145, 235, 148),
      ),
      body: SingleChildScrollView( // Add this
        child: Container(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      form.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      form.content,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),

                    // แก้ไขจาก lorem เป็นอย่างอื่น

                    Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 150),
                    Padding(
                      padding: EdgeInsets.fromLTRB(100, 0, 0, 100), // Adjust the value as needed
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          form.footer,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    // MaterialButton(onPressed: (){
                    //   _showDialog(context, 'ต้องการยกเลิกให้คำยินยอมหรือไม่');
                    // },
                    //   child: Text('ยกเลิกให้คำยินยอม',style: TextStyle(color: Colors.red),),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


void _showDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('ยกเลิกให้คำยินยอม'),
        content: Text('ต้องการยกเลิกให้คำยินยอมหรือไม่'),
        actions: [
          MaterialButton(
            onPressed: () {
              // Add your button logic here
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
          ),
          MaterialButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      );
    }
  );
}