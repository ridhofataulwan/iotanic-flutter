import 'dart:convert';

import 'package:iotanic_app/constant.dart';

import 'functions.dart';
import 'package:http/http.dart' as http;

class Device {
  int? status;
  dynamic? values;

  Device({this.status, this.values});

  static Future getDevice() async {
    final api = await getApi();
    final profileID = await getAuth('profileID');
    final response = await http.post(
      Uri.parse(api + "/device/"),
      headers: {
        "Accept": "application/json",
      },
      body: {
        'profile': profileID,
      },
    );
    Map<String, dynamic> data = await jsonDecode(response.body);
    // Map result = data['values'];
    if (data['values'] == null) {
      List<dynamic> result = data["values"];
      return result;
    } else {
      List<dynamic> result = data["values"]["devices"];
      return result;
    }
    // List<Device> devices = result.;
  }

  static setUserDevice(deviceID) async {
    final api = await getApi();
    final profileID = await getAuth('profileID');
    final response1 = await http.post(
      Uri.parse(api + "/device/check/"),
      headers: {
        "Accept": "application/json",
      },
      body: {
        'device': deviceID,
      },
    );
    if (response1.statusCode == 503) {
      return 503;
    }
    if (response1.statusCode == 500) {
      return 500;
    }
    Map<String, dynamic> isAvailiable = await jsonDecode(response1.body);

    if (isAvailiable['values']['available']) {
      // Is Avaliable
      final response2 = await http.post(
        Uri.parse(api + "/device/set/"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          'profile': profileID,
          'device': deviceID,
        },
      );
      Map<String, dynamic> data = await jsonDecode(response2.body);
      return 200;
    } else {
      // Not Avaliable
      return isAvailiable['values']['available'];
    }
  }

  static Future get10Records() async {
    final api = await getApi();
    final profileID = await getAuth('profileID');
    final response = await http.post(
      Uri.parse(api + "/device/"),
      headers: {
        "Accept": "application/json",
      },
      body: {
        'profile': profileID,
      },
    );
    Map<String, dynamic> data = await jsonDecode(response.body);

    // Map result = data['values'];
    if (data['values'] == null) {
      List<dynamic> result = data["values"];
      return result;
    } else {
      List<dynamic> result = data["values"]["devices"];
      var records = result[0]['records'];
      var length = records.length;
      if (length > 10) {
        records = records.sublist(length - 10);
        Map map = records.asMap();
        return map;
        // print(records.sublist(length - 10));
      } else {
        // print(records);
      }
      return records;
    }
    // List<Device> devices = result.;
  }
}
