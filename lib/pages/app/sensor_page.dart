// ignore_for_file: deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:iotanic_app/model/device.dart';
import 'package:iotanic_app/pages/app/monitoring_page.dart';
import 'package:iotanic_app/widgets/loader_dialog.dart';

import '../../index.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Sensor extends StatefulWidget {
  const Sensor({Key? key}) : super(key: key);

  @override
  State<Sensor> createState() => _SensorState();
}

class _SensorState extends State<Sensor> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController deviceID = TextEditingController();
  dynamic message;
  dynamic value;
  String data = "";
  Future<String> _scan() async {
    return await FlutterBarcodeScanner.scanBarcode("#000000", "Kembali", true, ScanMode.QR);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: HexColor('#F5F6FA'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /**
             * Hidden Title form
             */
            // TitleSensor(),

            formDevice(_formKey, deviceID, message),
            // Text(
            //   (message == null) ? "" : message,
            //   style: TextStyle(
            //       color: (value == null)
            //           ? Colors.black
            //           : (value != 200)
            //               ? Colors.red
            //               : Colors.green),
            // ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(HexColor("#CFE5DD")),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ))),
              onPressed: () async {
                data = await _scan();
                deviceID.text = data;
                if (_formKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  showLoaderDialog(context);
                  Device.setUserDevice(deviceID.text).then((val) {
                    setState(
                      () {
                        value = val;
                        if (val == 500) {
                          message = "ID Perangkat tidak valid";
                          Navigator.pop(context);
                        } else if (val == 503) {
                          message = "Error Server 503";
                          Navigator.pop(context);
                        } else if (val == 200) {
                          message = "ID Perangkat berhasil di tambah";
                          deviceID.text = "";
                          Navigator.pop(context);
                        } else {
                          message = "ID Perangkat sudah digunakan";
                          Navigator.pop(context);
                        }
                      },
                    );
                  });
                }
                // Device.setUserDevice(data).then((val) {
                //   print(val);
                // });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Scan ", style: TextStyle(color: HexColor("#002D3B"), fontWeight: FontWeight.w600)),
                  Icon(Icons.qr_code_2, color: HexColor("#002D3B")),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ButtonTheme(
                    minWidth: 100,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          showLoaderDialog(context);
                          Device.setUserDevice(deviceID.text).then((val) {
                            setState(
                              () {
                                value = val;
                                if (val == 500) {
                                  message = "ID Perangkat tidak valid";
                                  Navigator.pop(context);
                                } else if (val == 503) {
                                  message = "Error Server 503";
                                  Navigator.pop(context);
                                } else if (val == 200) {
                                  message = "ID Perangkat berhasil di tambah";
                                  deviceID.text = "";
                                  Navigator.pop(context);
                                } else {
                                  message = "ID Perangkat sudah digunakan";
                                  Navigator.pop(context);
                                }
                              },
                            );
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: HexColor("#002D3B"),
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                      ),
                      child: Text("Tambahkan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),

            // buttonSubmitDevice(_formKey, context, deviceID.text),
          ],
        ),
      ),
    );
  }
}

class TitleSensor extends StatelessWidget {
  const TitleSensor({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: const Text(
        'Tambahkan Sensor',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
    );
  }
}

@override
Widget formDevice(key, deviceID, message) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50.0),
    child: Column(
      children: [
        Form(
          key: key,
          child: Column(
            children: [
              SizedBox(
                width: 300,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value == "" || message != null) {
                      return 'ID Perangkat tidak valid!';
                    }
                  },
                  controller: deviceID,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    hintText: 'Kode ID Perangkat',
                    hintStyle: TextStyle(fontSize: 14),
                    fillColor: Colors.white70,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

// @override
// Widget buttonSubmitDevice(key, context, deviceID) {
//   return Padding(
//     padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         ButtonTheme(
//             minWidth: 100,
//             height: 50,
//             child: RaisedButton(
//               padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
//               onPressed: () {
//                 FocusScope.of(context).unfocus();
//                 if (key.currentState!.validate()) {
//                   // showLoaderDialog(context);
//                   Device.setUserDevice(deviceID).then((value) {
//                     setState(
//                       () {
//                         var dataResponse = value;
//                         if (dataResponse.data['account'] != null) {
//                           Navigator.pop(context);
//                           Navigator.of(context).pushReplacementNamed('/app');
//                         } else {
//                           Navigator.pop(context);
//                         }
//                       },
//                     );
//                   });
//                 }
//               },
//               // Navigator.of(context).push(
//               //   MaterialPageRoute(
//               //     builder: (BuildContext context) {
//               //       return const SubmitDevice();
//               //     },
//               //   ),
//               // )
//               // Navigator.pop(context);
//               color: HexColor("#002D3B"),
//               shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(50))),
//               child: const Text("Submit",
//                   style: TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.w600)),
//             )),
//       ],
//     ),
//   );
// }

class SubmitDevice extends StatelessWidget {
  const SubmitDevice({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Perangkat berhasil ditambah"),
            FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ScannerBarcode extends StatefulWidget {
  const ScannerBarcode({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScannerBarcodeState();
}

class _ScannerBarcodeState extends State<ScannerBarcode> {
  String _data = "";

  Future<String> _scan() async {
    return await FlutterBarcodeScanner.scanBarcode("#000000", "kembali", true, ScanMode.QR);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          child: const Text("Scanning Barcode"),
          onPressed: () async => _data = await _scan(),
        ),
        Text(_data)
      ],
    );
  }
}
