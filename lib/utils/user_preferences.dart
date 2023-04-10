// ignore_for_file: unused_field

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future saveAuth(name, email, age, profileID, accountID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('email', email);
    prefs.setInt('age', age);
    prefs.setString('profileID', profileID);
    prefs.setString('accountID', accountID);
  }

  static getAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = {
      'name': prefs.get('name'),
      'email': prefs.get('email'),
      'age': prefs.get('age'),
      'profileID': prefs.get('profileID'),
      'accountID': prefs.get('accountID'),
    };
    return user;
  }

  static getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get('name');
  }

  static removeAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('age');
    prefs.remove('profileID');
    prefs.remove('accountID');
  }

  static Future updateAuth(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value.runtimeType == bool) {
      prefs.setBool(key, value);
    }
    if (value.runtimeType == String) {
      prefs.setString(key, value);
    }
    if (value.runtimeType == int) {
      prefs.setInt(key, value);
    }
  }
}
