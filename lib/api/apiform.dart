import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_register/model/ConsentFormModel.dart';

class FetchConsentFormList {
  Future<List<Payload>> getConsentFormList() async {
    Uri uri = Uri.parse('https://api.pdpaconsults.com/formByUser?phone=0987654321');

    var response = await http.get(uri);
    if(response.statusCode == 200){
      var jsonData = json.decode(response.body);
      List<Payload> forms = (jsonData['payload'] as List).map((form) => Payload.fromJson(form)).toList();
      return forms;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
