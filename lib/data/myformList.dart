import 'package:flutter/material.dart';
import 'package:flutter_application_register/api/apiMyform.dart';
import 'package:flutter_application_register/api/apiform.dart';
import 'package:flutter_application_register/model/ConsentFormModel.dart';
import 'package:flutter_application_register/search/search_delegrate.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFormList extends StatefulWidget {
  const MyFormList({Key? key}) : super(key: key);

  @override
  State<MyFormList> createState() => _MyFormListState();
}

class _MyFormListState extends State<MyFormList>
    with SingleTickerProviderStateMixin {
  List<Payload> _formsStatus2 = [];
  List<Payload> _formsStatus3 = [];
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getMyForms();
  }

  Future<void> _getMyForms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('phone');
    if (phoneNumber == null) {
      print("No phone number found!");
      setState(() => _isLoading = false);
      return;
    }

    try {
      List<Payload> forms =
          await FetchMyConsentFormList().getMyConsentFormList(phoneNumber);
      _formsStatus2 = forms.where((form) => form.statusId == '2').toList();
      _formsStatus3 = forms.where((form) => form.statusId == '3').toList();
      setState(() => _isLoading = false);
    } catch (e) {
      print("Error loading forms: $e");
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
                borderRadius: BorderRadius.circular(30),
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
                        'ยินยอม',
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
                        'หมดอายุ',
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
                _buildFormList(_formsStatus2),
                _buildFormList(_formsStatus3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormList(List<Payload> forms) {
    if (_isLoading) return Center(child: CircularProgressIndicator());
    if (forms.isEmpty) return Center(child: Text('ไม่มีแบบฟอร์ม'));

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
                      forms[index].title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      forms[index].dataType,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd').format(
                        forms[index].requestDate,
                      ),
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
                  builder: (context) => FormDetail(forms[index]),
                ),
              );
            },
            icon: Icon(Icons.article_outlined),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormDetail(forms[index]),
              ),
            );
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
  final Payload form;

  FormDetail(this.form);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายเอียดแบบฟอร์ม',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 145, 235, 148),
      ),
      body: SingleChildScrollView(
        // Add this
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

                    SizedBox(height: 150),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          100, 0, 0, 100), // Adjust the value as needed
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
