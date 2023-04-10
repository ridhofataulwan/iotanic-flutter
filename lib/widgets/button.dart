// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iotanic_app/index.dart';

@override
Widget goToApp(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ButtonTheme(
            minWidth: 330.0,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: HexColor("#002D3B"),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return App();
                  }),
                );
              },
              child: const Text("Go To App", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            )),
        Container(
          margin: const EdgeInsets.only(top: 10.0, bottom: 30.0),
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget rbSignUp() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ButtonTheme(
            minWidth: 330.0,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                primary: HexColor("#002D3B"),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
              ),
              onPressed: () {},
              child: const Text("Daftar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            )),
        Container(
          margin: const EdgeInsets.only(top: 10.0, bottom: 80.0),
          // child: const Text(
          //   'Forgot Password?',
          //   style: TextStyle(
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
        ),
      ],
    ),
  );
}
