import 'dart:convert';

import 'package:iotanic_app/constant.dart';
import 'package:iotanic_app/model/functions.dart';

import 'package:http/http.dart' as http;

class User {
  static updateUser(String email, String name, String age) async {
    final api = await getApi();
    final String profileID = await getAuth('profileID');
    Uri url = Uri.parse("${api}/profile");

    var response = await http.post(
      url,
      body: {
        'id': profileID,
        // 'email': email,
        'name': name,
        'age': age,
      },
    );
    return json.decode(response.body);
  }
}
