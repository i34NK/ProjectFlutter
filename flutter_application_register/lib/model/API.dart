import 'dart:convert';
import 'package:flutter_application_register/model/UserModel.dart';
import 'package:http/http.dart' as http;

class FetchUserList {
  var data = [];
  List<Userlist> results = [];
  String urlList = 'https://jsonplaceholder.typicode.com/users/';

  Future<List<Userlist>> getuserList({String? query}) async {
    var url = Uri.parse(urlList);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
      
        data = json.decode(response.body);
        results = data.map((e) => Userlist.fromJson(e)).toList();
        if (query!= null){
          results = results.where((element) => element.name!.toLowerCase().contains((query.toLowerCase()))).toList();
        }
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }
}