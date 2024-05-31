import 'dart:convert';
import 'package:flutter_application_register/model/PayloadFormModel.dart';
import 'package:http/http.dart' as http;

class FetchMyConsentFormList {
  Future<List<Payloads>> getMyConsentFormList(String phoneNumber) async {
    Uri uri = Uri.parse('https://api.pdpaconsults.com/formByUser?phone=$phoneNumber');

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List<Payloads> forms = (jsonData['payload'] as List)
          .map((form) => Payloads.fromJson(form))
          .toList();
      print('Data fetched successfully: ${forms.length} forms');
      return forms;
    } else {
      print('Failed to load data');
      throw Exception('Failed to load data');
    }
  }
}
