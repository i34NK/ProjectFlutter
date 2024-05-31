import 'package:flutter/material.dart';
import 'package:flutter_application_register/api/apiform.dart';
import 'package:flutter_application_register/data/formList.dart';
import 'package:flutter_application_register/model/ConsentFormModel.dart';
import 'package:flutter_application_register/model/PayloadFormModel.dart';
import 'package:intl/intl.dart';

class FormSearchDelegate extends SearchDelegate {
  FetchConsentFormList _formList = FetchConsentFormList();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Payloads>>(
      future: _formList.getConsentFormList() as Future<List<Payloads>>?,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No results found'));
        }

        List<Payloads> data = snapshot.data!;
        List<Payloads> results = data
            .where((form) =>
                form.formName.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: results.length,
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
                          results[index].formName,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          results[index].formDetail,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          DateFormat('yyyy-MM-dd')
                              .format(results[index].requestDate),
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
                      builder: (context) => FormDetail(form: results[index]),
                    ),
                  );
                },
                icon: Icon(Icons.article_outlined),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormDetail(form: results[index]),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Text('ค้นหาแบบฟอร์ม'));
  }
}
