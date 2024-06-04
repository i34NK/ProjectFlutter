import 'package:flutter/material.dart';
import 'package:flutter_application_register/api/apiMyform.dart';
import 'package:flutter_application_register/model/ConsentModel.dart';
import 'package:flutter_application_register/model/PayloadFormModel.dart';
import 'package:flutter_application_register/search/search_delegrate.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormFutureBuilder extends StatefulWidget {
  @override
  State<FormFutureBuilder> createState() => _FormFutureBuilderState();
}

class _FormFutureBuilderState extends State<FormFutureBuilder>
    with SingleTickerProviderStateMixin {
  List<ConsentForm> _formsStatus1 = [];
  List<ConsentForm> _formsStatus4 = [];
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getMyForm();
  }

  Future<void> _getMyForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('phone');

    if (phoneNumber == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      FormModel formModel =
          await FetchMyConsentFormList().getMyConsentFormList(phoneNumber);
      List<ConsentForm> forms = formModel.payload.forms;
      setState(() {
        _formsStatus1 = forms.where((form) => form.statusId == '1').toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
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
          Container(
            height: 60,
            color: Colors.white,
            child: TabBar(
              physics: ClampingScrollPhysics(),
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromARGB(255, 145, 235, 148),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              controller: _tabController,
              tabs: [
                Tab(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'รอคำยินยอม',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'ปฏิเสธ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFormList(_formsStatus1),
                _buildFormList(_formsStatus4),
              ],
            ),
          ),
          // _isLoading
          //     ? Center(child: CircularProgressIndicator())
          //     : Expanded(
          //         child: _buildFormList(_formsStatus1),
          //       ),
        ],
      ),
    );
  }

  Widget _buildFormList(List<ConsentForm> forms) {
    if (forms.isEmpty) {
      return Center(child: Text('ไม่มีแบบฟอร์ม'));
    }
    return ListView.builder(
      itemCount: forms.length,
      itemBuilder: (context, index) {
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
                      forms[index].formName ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      forms[index].formDetail ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd').format(forms[index].requestDate),
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
                      builder: (context) => FormDetail(form: forms[index])));
            },
            icon: Icon(Icons.article_outlined),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FormDetail(form: forms[index])));
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class FormDetail extends StatelessWidget {
  final ConsentForm form;

  FormDetail({required this.form});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายเอียดแบบฟอร์ม',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 145, 235, 148),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      form.formName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      form.formDetail,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      
                    },
                    child: Text(
                      'ยินยอม',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      
                    },
                    child: Text(
                      'ไม่ยินยอม',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// void _showDialogAgree(BuildContext context, String message) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('ให้คำยินยอม'),
//         content: Text('ต้องการให้คำยินยอมหรือไม่'),
//         actions: [
//           MaterialButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Ok'),
//           ),
//           MaterialButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//         ],
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//       );
//     },
//   );
// }
// void _showDialogRefuse(BuildContext context, String message) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('ปฏิเสธการให้คำยินยอม'),
//         content: Text('ต้องการปฏิเสธการให้คำยินยอมหรือไม่'),
//         actions: [
//           MaterialButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Ok'),
//           ),
//           MaterialButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//         ],
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//       );
//     },
//   );
// }
