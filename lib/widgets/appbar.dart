// ignore_for_file: preferructors

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/device.dart';
import '../model/functions.dart';

Widget sensorAppBar() {
  String data = "";

  Future<String> _scan() async {
    return await FlutterBarcodeScanner.scanBarcode("#000000", "kembali", true, ScanMode.QR);
  }

  return AppBar(
    title: Text('Tambah Perangkat',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: HexColor("#002D3B"),
        )),
    backgroundColor: HexColor("#F5F6FA"),
    toolbarHeight: 98.0,
    elevation: 0.0,
    automaticallyImplyLeading: false,
    actions: <Widget>[
      Container(
        margin: EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    ],
  );
}

Widget homeAppBar() {
  return AppBar(
    title: Container(
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: SharedPreferences.getInstance().then((value) {
              return getAuth('name');
            }),
            builder: (context, snapshot) {
              final name = snapshot.data.toString().split(' ');
              String firstName = name[0];
              return Text(
                "Hai, $firstName",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                  color: Colors.black,
                ),
              );
            },
          ),
          const Text('Selamat Datang di Smart Precision Farming', style: TextStyle(color: Colors.black, fontSize: 14.0))
        ],
      ),
    ),
    backgroundColor: Colors.white,
    toolbarHeight: 120.0,
    elevation: 0.0,
    automaticallyImplyLeading: false,
    // actions: <Widget>[],
  );
}

Widget monitoringAppBar() {
  return AppBar(
    title: Text('Perangkat Anda',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: HexColor("#002D3B"),
        )),
    backgroundColor: HexColor("#F5F6FA"),
    toolbarHeight: 98.0,
    elevation: 0.0,
    automaticallyImplyLeading: false,
    actions: <Widget>[
      Container(
        margin: EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    ],
  );
}

Widget listAppBar() {
  return PreferredSize(
      preferredSize: Size.fromHeight(0),
      child: AppBar(
        title: Text(''),
        backgroundColor: HexColor('#F5F6FA'),
        elevation: 0,
        shadowColor: HexColor('#F5F6FA'),
      ));
}

Widget profileAppBar() {
  return PreferredSize(
      preferredSize: Size.fromHeight(0),
      child: AppBar(
        title: Text(''),
        backgroundColor: HexColor('#F5F6FA'),
        elevation: 0,
        shadowColor: HexColor('#F5F6FA'),
      ));
}
