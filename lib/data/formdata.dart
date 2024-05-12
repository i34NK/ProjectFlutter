import 'package:flutter/material.dart';
import 'package:flutter_application_register/model/ConsentFormModel.dart';
import 'package:flutter_application_register/api/apiform.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class FormData extends StatefulWidget {
  @override
  _FormDataState createState() => _FormDataState();
}

class _FormDataState extends State<FormData> {
  List<Payload> _forms = [];

  @override
  void initState() {
    super.initState();
    _loadForms();
  }

  Future<void> _loadForms() async {
    FetchConsentFormList formDataList = FetchConsentFormList();
    List<Payload> forms = await formDataList.getConsentFormList();
    setState(() {
      _forms = forms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _forms.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _forms.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Row(
                        children: [
                          // Container(
                          //   width: 60,
                          //   height: 60,
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          //   child: Center(
                          //     child: Text(
                          //       '${_forms?[index].formId}',
                          //       style: TextStyle(
                          //           fontSize: 20,
                          //           fontWeight: FontWeight.bold,
                          //           color: Colors.black),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_forms?[index].title}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Type: '
                                  '${_forms?[index].dataType}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Date: '
                                  '${_forms?[index].requestDate}',
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
                          _showMyDialog(context, _forms[index]);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

Future<void> _showMyDialog(BuildContext context, Payload formData) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('${formData.title}'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Text(
              '${formData.content}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text(
              '${formData.footer}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              showAlert(context);
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

void showAlert(BuildContext context) {
  QuickAlert.show(context: context, type: QuickAlertType.confirm);
}