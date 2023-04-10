import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import './auth/signin.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildSplasher(context));
  }
}

@override
Widget _buildSplasher(BuildContext context) {
  return Container(
    color: HexColor("#FCFCFC"),
    child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
      const SizedBox(
        height: 150.0,
      ),
      headlineSplash(),
      navButtonSplash(context),
    ]),
  );
}

// ============================== Extract Widget Below  ==============================

Widget headlineSplash() {
  return Column(children: const [
    Text(
      'IOTANIC',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 32,
      ),
      textAlign: TextAlign.center,
    ),
    Text(
      'Connect with Your Plants',
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    ),
  ]);
}

Widget navButtonSplash(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(left: 50.0, right: 50.0),
    decoration: BoxDecoration(
      color: HexColor('#91C4B1'),
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(130.5), bottom: Radius.circular(0)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 75),
        // ignore: deprecated_member_use
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            elevation: 9,
            backgroundColor: HexColor("#002D3B"),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return const SignIn();
              }),
            );
          },
          child: const Text(
            "Get Started",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          width: 500,
          height: 75,
        )
      ],
    ),
  );
}
