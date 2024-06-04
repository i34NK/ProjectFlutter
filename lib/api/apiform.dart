import 'dart:convert';
import 'package:flutter_application_register/model/ConsentModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FetchConsentFormList {
  Future<FormModel> getConsentFormList() async {
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
      FormModel formModel = FormModel.fromJson(jsonData);
      print('Data fetched successfully: ${formModel.payload.forms.length} forms');
      return formModel;
    } else {
      print('Failed to load data');
      throw Exception('Failed to load data');
    }
  }
}