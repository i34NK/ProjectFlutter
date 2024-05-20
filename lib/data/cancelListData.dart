// import 'package:flutter/material.dart';
// import 'package:flutter_application_register/api/apiform.dart';
// import 'package:flutter_application_register/api/cancelApiform.dart';
// import 'package:flutter_application_register/model/ConsentFormModel.dart';
// import 'package:flutter_application_register/page/activitie.dart';
// import 'package:flutter_application_register/page/sendOTP.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_application_register/search/search_delegrate.dart';

// class CancelListData extends StatefulWidget {
//   const CancelListData({super.key});

//   @override
//   State<CancelListData> createState() => _CancelListDataState();
// }

// class _CancelListDataState extends State<CancelListData> {
//   int _selectedIndex = 0;

//   Future<List<Payload>> _getForm() async {
//     FetchCancelConsentFormList formCancelDataList = FetchCancelConsentFormList();
//     List<Payload> cancelforms = await formCancelDataList.getCancelConsentFormList();
//     return cancelforms;
//   }

//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(10),
//             child: TextField(
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Color.fromARGB(255, 236, 233, 233),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 hintText: 'ค้นหาแบบฟอร์ม',
//                 hintStyle: TextStyle(fontSize: 15),
//                 prefixIcon: Icon(Icons.search),
//                 prefixIconColor: Colors.black,
//                 isDense: true,
//               ),
//               onTap: () {
//                 showSearch(context: context, delegate: FormSearchDelegate());
//               },
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Payload>>(
//                 future: _getForm(),
//                 builder: (BuildContext context, AsyncSnapshot snapshot) {
//                   print(snapshot.data);
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   if (!snapshot.hasData || snapshot.data.isEmpty) {
//                     return Center(child: Text('No data found'));
//                   }
//                   return RefreshIndicator(
//                       onRefresh: _getForm,
//                       child: ListView.builder(
//                           itemCount: snapshot.data.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return ListTile(
//                               title: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         SizedBox(height: 10),
//                                         Text(
//                                           snapshot.data[index].title,
//                                           style: TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.w600),
//                                         ),
//                                         Text(
//                                           snapshot.data[index].dataType,
//                                           style: TextStyle(
//                                             color: Colors.grey,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                         SizedBox(height: 5),
//                                         Text(
//                                           DateFormat('yyyy-MM-dd').format(
//                                               snapshot.data[index].requestDate),
//                                           style: TextStyle(
//                                             color: Colors.grey,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               trailing: IconButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => FormCancelDetail(
//                                           snapshot.data[index],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   icon: Icon(Icons.article_outlined)),
//                               // title: Text(snapshot.data[index].title),
//                               // subtitle: Text(snapshot.data[index].dataType),
//                               onTap: () {
//                                 {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => FormCancelDetail(
//                                         snapshot.data[index],
//                                       ),
//                                     ),
//                                   );
//                                 }
//                               },
//                             );
//                           }));
//                 }),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FormCancelDetail extends StatelessWidget {
//   final Payload cancelform;

//   FormCancelDetail(this.cancelform);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'รายเอียดแบบฟอร์ม',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Color.fromARGB(255, 145, 235, 148),
//       ),
//       body: SingleChildScrollView(
//         // Add this
//         child: Container(
//           child: Column(
//             children: [
//               Center(
//                 child: Column(
//                   children: [
//                     SizedBox(height: 20),
//                     Text(
//                       cancelform.title,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       cancelform.content,
//                       style: TextStyle(
//                         fontSize: 14,
//                       ),
//                     ),

//                     // แก้ไขจาก lorem เป็นอย่างอื่น

//                     Text(
//                       'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
//                       style: TextStyle(
//                         fontSize: 14,
//                       ),
//                     ),
//                     SizedBox(height: 150),
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(
//                           100, 0, 0, 100), // Adjust the value as needed
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           cancelform.footer,
//                           style: TextStyle(
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
