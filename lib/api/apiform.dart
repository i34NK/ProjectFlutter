import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_register/model/ConsentFormModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchConsentFormList {
  Future<List<Payload>> getConsentFormList() async {
    // ทำการเรียกใช้ SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('phone');

    if (phoneNumber == null) {
      throw Exception('Phone number not found');
    }

    Uri uri =
        Uri.parse('https://api.pdpaconsults.com/formByUser?phone=$phoneNumber');

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List<Payload> forms = (jsonData['payload'] as List).map((form) => Payload.fromJson(form)).toList();
      return forms;
    } else {
      throw Exception('Failed to load data');
    }
  }
}