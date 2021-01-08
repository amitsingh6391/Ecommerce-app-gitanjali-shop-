import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/user.dart';

class ApiService {
  static String url(int nrResults) {
    return 'http://api.randomPuser.me/?results=$nrResults';
  }

  static Future<List<Puser>> getPusers({int nrPusers = 1}) async {
    try {
      var response = await http
          .get(url(nrPusers), headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        Iterable list = data["results"];
        List<Puser> Pusers = list.map((l) => Puser.fromJson(l)).toList();
        return Pusers;
      } else {
        print(response.body);
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
