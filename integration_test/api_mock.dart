import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:flutter_application_register/model/ConsentFormModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FetchMockFormList {

  final http.Client client;


  FetchMockFormList(this.client);
  Future<List<Payload>> getMockFormList(String phoneNumber) async {
    Uri uri = Uri.parse('https://api.pdpaconsults.com/formByUser?phone=$phoneNumber');

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List<Payload> forms = (jsonData['payload'] as List)
        .map((form) => Payload.fromJson(form))
        .where((item) => item.statusId == "1") // Filter here based on status_id
        .toList();
      return forms;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
