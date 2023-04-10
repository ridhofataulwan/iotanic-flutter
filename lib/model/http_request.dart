import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iotanic_app/constant.dart';
import 'package:iotanic_app/utils/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Http_request {
  dynamic? data;

  Http_request({this.data});

  static signUp(email, password) async {
    final api = await getApi();
    Uri url = Uri.parse("${api}/signup");

    var response = await http.post(
      url,
      body: {
        "email": email,
        "password": password,
      },
    );

    var hasilResponse = json.decode(response.body);
    return Http_request(
      data: hasilResponse["values"],
    );
  }

  static signIn(email, password) async {
    final api = await getApi();
    Uri url = Uri.parse("${api}/signin");

    var response = await http.post(
      url,
      body: {
        "email": email,
        "password": password,
      },
    );
    print("${api}/signin");
    var hasilResponse = json.decode(response.body);

    if (hasilResponse['values']['msg'] == "Success signin") {
      dynamic profileID = hasilResponse['values']['account']['_id'];
      dynamic name = hasilResponse['values']['account']['name'];
      dynamic age = hasilResponse['values']['account']['age'];
      dynamic accountID = hasilResponse['values']['account']['account'];

      UserPreferences.saveAuth(name, email, age, profileID, accountID);
    }
    print(hasilResponse['values']);
    return Http_request(
      data: hasilResponse["values"],
    );
  }

  static userDevice(profileID) async {
    final api = await getApi();
    Uri url = Uri.parse("${api}/device");

    var response = await http.post(
      url,
      body: {
        "profile": profileID,
      },
    );

    var hasilResponse = json.decode(response.body);
    // Make Session
    print(hasilResponse['values']);
    if (hasilResponse['values']['devices'] == false) {
      print("You Don't have devices that connect");
    }
    ;
    return Http_request(
      data: {
        'values': hasilResponse["values"],
        'totalDevices': hasilResponse["values"]["devices"],
        'records': hasilResponse["values"]["devices"][0],
      },
    );
  }

  static getDevice(String deviceID) async {
    final api = await getApi();
    Uri url = Uri.parse("${api}/device/${deviceID}");

    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
      },
    );

    var hasilResponse = json.decode(response.body);
    // Make Session
    return Http_request(
      data: {
        'values': hasilResponse["values"],
        'totalDevices': hasilResponse["values"]["device"],
        'records': hasilResponse["values"]["device"][0],
      },
    );
  }

  static getAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic user = {
      'name': prefs.get('name'),
      'email': prefs.get('email'),
      'age': prefs.get('age'),
      'profileID': prefs.get('profileID'),
      'accountID': prefs.get('accountID'),
    };
    return user;
  }

  static getSharedPreferences(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }
}
