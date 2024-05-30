import 'package:flutter/material.dart';
import 'package:flutter_application_register/api/apiMyform.dart';
import 'package:flutter_application_register/api/apiform.dart';
import 'package:flutter_application_register/model/ConsentFormModel.dart';
import 'package:flutter_application_register/search/search_delegrate.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormFutureBuilder extends StatefulWidget {
  const FormFutureBuilder({super.key});

  @override
  State<FormFutureBuilder> createState() => _FormFutureBuilderState();
}

class _FormFutureBuilderState extends State<FormFutureBuilder> {

  List<Payload> _myforms = [];
  bool _isLoading = true;
  Future<List<Payload>> _getMyForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('phone');

    if (phoneNumber == null) {
      print("No phone number found!");
      return [];
    }

    FetchMyConsentFormList myFormDataList = FetchMyConsentFormList();
    try {
      List<Payload> myforms =
          await myFormDataList.getMyConsentFormList(phoneNumber);
      List<Payload> filteredForms =
          myforms.where((form) => form.statusId == '1').toList();
      print("Filtered Forms: ${filteredForms.length}"); // Debugging line
      return filteredForms;
    } catch (e) {
      print("Error loading forms: $e");
      return [];
    }
    
  }

  @override
  void initState() {
    super.initState();
    _getMyForm();
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
              future: _getMyForm(), // This now returns Future<List<Payload>>
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error.toString()}'));
                }
                if (snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('ไม่แบบฟอร์ม'));
                }
                return DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Material(
                        child: Container(
                          height: 60,
                          color: Colors.white,
                          child: TabBar(
                            physics: ClampingScrollPhysics(),
                            padding: EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 10),
                            unselectedLabelColor: Colors.grey,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color.fromARGB(255, 145, 235, 148),
                            ),
                            tabs: [
                              Tab(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text('ยินยอม'),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text('หมดอายุ'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _getMyForm,
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var form = snapshot.data![index];
                              return ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            snapshot.data![index].title,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text('Status ID: ${form.statusId}'),
                                          SizedBox(height: 5),
                                          Text(
                                            DateFormat('yyyy-MM-dd').format(
                                                snapshot
                                                    .data[index].requestDate),
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
                        ),
                      ),
                    ],
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
