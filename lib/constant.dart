import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:http/http.dart' as http;

Future<String> getApi() async {
  String src = "https://text.iotanic.id/api.json";

  try {
    Uri url = Uri.parse(src);
    var response = await http.get(url);
    String data = response.body;
    String api = 'http://$data/api';
    return api;
  } catch (e) {
    print(e);
    src = 'http://iot.my.id/api.json';
    Uri url = Uri.parse(src);
    var response = await http.get(url);
    String data = response.body;
    String api = 'http://$data/api';
    return api;
  }
}

const spacingUnit = 10;

// Color
final primaryColor = HexColor("#000000");
final secondaryColor = HexColor("#000000");

final primaryAccentColor = HexColor("#000000");
final secondaryAccentColor = HexColor("#000000");

final primaryButtonColor = HexColor("#000000");
final secondaryButtonColor = HexColor("#000000");

final navButtonSplash = HexColor("#91C4B1");

// Font
final titleTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(spacingUnit.w * 1.7),
  fontWeight: FontWeight.w400,
);

final buttonTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(spacingUnit.w * 1.5),
  fontWeight: FontWeight.w400,
);

class MyColor {
  static const int primaryMyColor = 0xFF002D3B;
  static const MaterialColor myColor = MaterialColor(
    primaryMyColor,
    <int, Color>{
      50: Color.fromRGBO(0, 45, 59, 100), //10%
      100: Color.fromRGBO(0, 45, 59, 90), //20%
      200: Color.fromRGBO(0, 45, 59, 80), //30%
      300: Color.fromRGBO(0, 45, 59, 70), //40%
      400: Color.fromRGBO(0, 45, 59, 60), //50%
      500: Color.fromRGBO(0, 45, 59, 50), //60%
      600: Color.fromRGBO(0, 45, 59, 40), //70%
      700: Color.fromRGBO(0, 45, 59, 30), //80%
      800: Color.fromRGBO(0, 45, 59, 20), //90%
      900: Color.fromRGBO(0, 45, 59, 20), //100%
    },
  );
}

final appTheme = ThemeData(
  brightness: Brightness.light,
  // primaryColor: primaryColor,
  // canvasColor: primaryColor,
  // backgroundColor: secondaryColor,
  primarySwatch: MyColor.myColor,
  fontFamily: 'Poppins',
);
