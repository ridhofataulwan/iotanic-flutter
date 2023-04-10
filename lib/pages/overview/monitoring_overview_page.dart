// ignore_for_file: deprecated_member_use, prefer_const_constructors, must_be_immutable, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:iotanic_app/model/http_request.dart';
import 'package:iotanic_app/widgets/loader_dialog.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

import '../../constant.dart';
import '../../model/device.dart';
import '../../model/functions.dart';

import '../../constant.dart';

// ignore: must_be_immutable
class MonitoringOverview extends StatefulWidget {
  MonitoringOverview({Key? key, required this.data}) : super(key: key);
  final Map data;

  @override
  State<MonitoringOverview> createState() => _MonitoringOverviewState();
}

class _MonitoringOverviewState extends State<MonitoringOverview> {
  Http_request dataResponse = Http_request();
  dynamic records;
  dynamic scale;
  dynamic ideal = {
    'n': 100,
    'p': 100,
    'k': 100,
    'ph': 7,
  };

  Future<Object> getDevice(deviceID) async {
    final api = await getApi();
    var response = await http.get(
      Uri.parse("${api}/device/${deviceID}"),
      headers: {
        "Accept": "application/json",
      },
    );
    var result = json.decode(response.body);
    Map<String, dynamic> map = await result['values'];
    print(map);
    return map;
    if (map['values'] == null) {
      List<dynamic> data = map["values"]["devices"];
      return data;
    }
    List<dynamic> data = map["values"];
    return map;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    int newest = widget.data['records'].length - 1;

    String lastUpdate = widget.data['records'][newest]['datetime'];
    var dateTime = DateTime.parse(lastUpdate).add(Duration(hours: 7));
    var date = DateFormat("EEEE, d MMMM yyyy", "id_ID").format(dateTime);
    var time = DateFormat("HH:mm:ss", "id_ID").format(dateTime);

    records = widget.data['records'][newest];
    scale = {
      'n': double.parse(((1 - ((ideal['n'] - records['n']).abs() / ideal['n'])) * 100).toStringAsFixed(1)),
      'p': double.parse(((1 - ((ideal['p'] - records['p']).abs() / ideal['p'])) * 100).toStringAsFixed(1)),
      'k': double.parse(((1 - ((ideal['k'] - records['k']).abs() / ideal['k'])) * 100).toStringAsFixed(1)),
      'ph': double.parse(((1 - ((ideal['ph'] - records['ph']).abs() / ideal['ph'])) * 100).toStringAsFixed(1)),
    };
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: HexColor("#002D3B"),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.data['name'],
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Text(
              "ID: " + widget.data['_id'],
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
        backgroundColor: HexColor("#FAFAFA"),
        toolbarHeight: 80,
        elevation: 0.0,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: HexColor("#CFE5DD"),
                  ),
                  child: const Text(
                    'Monitoring',
                    style: TextStyle(color: MyColor.myColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // ButtonTheme(
                //   minWidth: 130,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                //       primary: Colors.greenAccent,
                //       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                //     ),
                //     onPressed: () {
                //       showLoaderDialog(context);
                //       Http_request.getDevice(widget.data['_id']).then((value) {
                //         print(value);
                //         setState(() {
                //           dataResponse = value;
                //           print("Data");
                //           int newest = dataResponse.data['records']['records'].length - 1;
                //           records = dataResponse.data['records']['records'][newest];
                //           scale = {
                //             'n': ((1 - ((ideal['n'] - records['n']).abs() / ideal['n'])) * 100).toStringAsFixed(1),
                //             'p': ((1 - ((ideal['p'] - records['p']).abs() / ideal['p'])) * 100).toStringAsFixed(1),
                //             'k': ((1 - ((ideal['k'] - records['k']).abs() / ideal['k'])) * 100).toStringAsFixed(1),
                //             'ph': ((1 - ((ideal['ph'] - records['ph']).abs() / ideal['ph'])) * 100).toStringAsFixed(1),
                //           };
                //           int realtime = newest;
                //           String lastUpdate = records['datetime'];
                //           print(lastUpdate);
                //           var dateTime = DateTime.parse(lastUpdate).add(Duration(hours: 7));
                //           var date = DateFormat("d MMMM yyyy", "id_ID").format(dateTime);
                //           var time = DateFormat("HH:mm:ss", "id_ID").format(dateTime);
                //           Navigator.pop(context);
                //         });
                //       });
                //     },
                //     child: const Text("Perbarui Data", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                //   ),
                // ),
              ],
            ),
            PlantConditions(),
            sfCircularChart(),
            NewestRecord(records: records, scale: scale),
            Text(date),
            FutureBuilder(
              future: getDevice(widget.data['_id']),
              builder: (context, snapshot) {
                var data = snapshot.data;
                print(data.runtimeType);
                Map<String, dynamic> reversedMap = {};

                if (snapshot.hasData) {
                  // for (var i = 0; i < data.length; i++) {
                  //   var newDate = data[i]['datetime'];
                  //   var dateTime = DateTime.parse(newDate).add(Duration(hours: 7));
                  //   var time = DateFormat("HH:mm:ss", "id_ID").format(dateTime);
                  //   data[i]['datetime'] = time.toString();
                  // }
                  return Container();
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(date),
                Text(time),
              ],
            ),
            // Details Unsur Sections
            SizedBox(
              height: 200,
              width: 330,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nitrogen Start
                  SizedBox(
                    width: 350,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            // spreadRadius: 5,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            width: 101,
                            height: 25,
                            child: Row(children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                height: 25,
                                width: 25,
                                color: HexColor('#002D3B'),
                              ),
                              const Text('Nitrogen', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
                            ]),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            width: 100,
                            height: 25,
                            child: Text(
                              (records == null) ? "Null" : "${records['n']} mg/kg",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            width: 50,
                            height: 25,
                            child: Text(
                              (scale == null) ? "Null" : "${scale['n']} %",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Nitrogen End
                  // Fosfor Start
                  SizedBox(
                    width: 350,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            // spreadRadius: 5,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            width: 100,
                            height: 25,
                            child: Row(children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                height: 25,
                                width: 25,
                                color: HexColor('#05784D'),
                              ),
                              const Text('Fosfor', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
                            ]),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            width: 100,
                            height: 25,
                            child: Text(
                              (records == null) ? "Null" : "${records['p']} mg/kg",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            width: 50,
                            height: 25,
                            child: Text(
                              (scale == null) ? "Null" : "${scale['p']} %",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Fosfor End
                  // Kalsium Start
                  SizedBox(
                    width: 350,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            // spreadRadius: 5,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            width: 100,
                            height: 25,
                            child: Row(children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                height: 25,
                                width: 25,
                                color: HexColor('#759AA2'),
                              ),
                              const Text('Kalsium', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
                            ]),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            width: 100,
                            height: 25,
                            child: Text(
                              (records == null) ? "Null" : "${records['k']} mg/kg",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            width: 50,
                            height: 25,
                            child: Text(
                              (scale == null) ? "Null" : "${scale['k']} %",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Kalsium End
                  // Ph Start
                  SizedBox(
                    width: 350,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            // spreadRadius: 5,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            width: 100,
                            height: 25,
                            child: Row(children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                height: 25,
                                width: 25,
                                color: HexColor('#8BBEAB'),
                              ),
                              const Text('pH', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
                            ]),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            width: 100,
                            height: 25,
                            child: Text(
                              (records == null) ? "Null" : "${records['ph']} pH",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            width: 50,
                            height: 25,
                            child: Text(
                              (scale == null) ? "Null" : "${scale['ph']} %",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Ph End
                ],
              ),
            ),

            // SizedBox(
            //   height: 200,
            //   width: 330,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       // Nitrogen Start
            //       SizedBox(
            //         width: 350,
            //         child: Container(
            //           margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
            //           padding: const EdgeInsets.all(5),
            //           decoration: const BoxDecoration(
            //             color: Colors.white,
            //             shape: BoxShape.rectangle,
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(10),
            //               topRight: Radius.circular(10),
            //               bottomLeft: Radius.circular(10),
            //               bottomRight: Radius.circular(10),
            //             ),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.black12,
            //                 // spreadRadius: 5,
            //                 blurRadius: 2,
            //                 offset: Offset(0, 2),
            //               )
            //             ],
            //           ),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Container(
            //                 padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
            //                 width: 101,
            //                 height: 25,
            //                 child: Row(children: [
            //                   Container(
            //                     margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
            //                     height: 25,
            //                     width: 25,
            //                     color: HexColor('#002D3B'),
            //                   ),
            //                   const Text('Nitrogen',
            //                       style: TextStyle(
            //                           color: Colors.black,
            //                           fontWeight: FontWeight.w400)),
            //                 ]),
            //               ),
            //               Container(
            //                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            //                 width: 100,
            //                 height: 25,
            //                 child: const Text(
            //                   '132 g',
            //                   style: TextStyle(
            //                       color: Colors.black,
            //                       fontWeight: FontWeight.w400),
            //                   textAlign: TextAlign.right,
            //                 ),
            //               ),
            //               Container(
            //                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            //                 width: 50,
            //                 height: 25,
            //                 child: const Text(
            //                   '51%',
            //                   style: TextStyle(
            //                       color: Colors.black,
            //                       fontWeight: FontWeight.w400),
            //                   textAlign: TextAlign.right,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       // Nitrogen End
            //       // Fosfor Start
            //       SizedBox(
            //         width: 350,
            //         child: Container(
            //           margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
            //           padding: const EdgeInsets.all(5),
            //           decoration: const BoxDecoration(
            //             color: Colors.white,
            //             shape: BoxShape.rectangle,
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(10),
            //               topRight: Radius.circular(10),
            //               bottomLeft: Radius.circular(10),
            //               bottomRight: Radius.circular(10),
            //             ),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.black12,
            //                 // spreadRadius: 5,
            //                 blurRadius: 2,
            //                 offset: Offset(0, 2),
            //               )
            //             ],
            //           ),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Container(
            //                 padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
            //                 width: 100,
            //                 height: 25,
            //                 child: Row(children: [
            //                   Container(
            //                     margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
            //                     height: 25,
            //                     width: 25,
            //                     color: HexColor('#05784D'),
            //                   ),
            //                   const Text('Fosfor',
            //                       style: TextStyle(
            //                           color: Colors.black,
            //                           fontWeight: FontWeight.w400)),
            //                 ]),
            //               ),
            //               Container(
            //                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            //                 width: 100,
            //                 height: 25,
            //                 child: const Text(
            //                   '278 g',
            //                   style: TextStyle(
            //                       color: Colors.black,
            //                       fontWeight: FontWeight.w400),
            //                   textAlign: TextAlign.right,
            //                 ),
            //               ),
            //               Container(
            //                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            //                 width: 50,
            //                 height: 25,
            //                 child: const Text(
            //                   '78%',
            //                   style: TextStyle(
            //                       color: Colors.black,
            //                       fontWeight: FontWeight.w400),
            //                   textAlign: TextAlign.right,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       // Fosfor End
            //       // Kalsium Start
            //       SizedBox(
            //         width: 350,
            //         child: Container(
            //           margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
            //           padding: const EdgeInsets.all(5),
            //           decoration: const BoxDecoration(
            //             color: Colors.white,
            //             shape: BoxShape.rectangle,
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(10),
            //               topRight: Radius.circular(10),
            //               bottomLeft: Radius.circular(10),
            //               bottomRight: Radius.circular(10),
            //             ),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.black12,
            //                 // spreadRadius: 5,
            //                 blurRadius: 2,
            //                 offset: Offset(0, 2),
            //               )
            //             ],
            //           ),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Container(
            //                 padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
            //                 width: 100,
            //                 height: 25,
            //                 child: Row(children: [
            //                   Container(
            //                     margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
            //                     height: 25,
            //                     width: 25,
            //                     color: HexColor('#759AA2'),
            //                   ),
            //                   const Text('Kalsium',
            //                       style: TextStyle(
            //                           color: Colors.black,
            //                           fontWeight: FontWeight.w400)),
            //                 ]),
            //               ),
            //               Container(
            //                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            //                 width: 100,
            //                 height: 25,
            //                 child: const Text(
            //                   '205 g',
            //                   style: TextStyle(
            //                       color: Colors.black,
            //                       fontWeight: FontWeight.w400),
            //                   textAlign: TextAlign.right,
            //                 ),
            //               ),
            //               Container(
            //                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            //                 width: 50,
            //                 height: 25,
            //                 child: const Text(
            //                   '98%',
            //                   style: TextStyle(
            //                       color: Colors.black,
            //                       fontWeight: FontWeight.w400),
            //                   textAlign: TextAlign.right,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       // Kalsium End
            //       // Ph Start
            //       SizedBox(
            //         width: 350,
            //         child: Container(
            //           margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
            //           padding: const EdgeInsets.all(5),
            //           decoration: const BoxDecoration(
            //             color: Colors.white,
            //             shape: BoxShape.rectangle,
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(10),
            //               topRight: Radius.circular(10),
            //               bottomLeft: Radius.circular(10),
            //               bottomRight: Radius.circular(10),
            //             ),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.black12,
            //                 // spreadRadius: 5,
            //                 blurRadius: 2,
            //                 offset: Offset(0, 2),
            //               )
            //             ],
            //           ),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Container(
            //                 padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
            //                 width: 100,
            //                 height: 25,
            //                 child: Row(children: [
            //                   Container(
            //                     margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
            //                     height: 25,
            //                     width: 25,
            //                     color: HexColor('#8BBEAB'),
            //                   ),
            //                   const Text('pH',
            //                       style: TextStyle(
            //                           color: Colors.black,
            //                           fontWeight: FontWeight.w400)),
            //                 ]),
            //               ),
            //               Container(
            //                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            //                 width: 100,
            //                 height: 25,
            //                 child: const Text(
            //                   '7.1 pH',
            //                   style: TextStyle(
            //                       color: Colors.black,
            //                       fontWeight: FontWeight.w400),
            //                   textAlign: TextAlign.right,
            //                 ),
            //               ),
            //               Container(
            //                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            //                 width: 50,
            //                 height: 25,
            //                 child: const Text(
            //                   '50%',
            //                   style: TextStyle(
            //                       color: Colors.black,
            //                       fontWeight: FontWeight.w400),
            //                   textAlign: TextAlign.right,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       // Ph End
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget sfCircularChart() {
    int newest = widget.data['records'].length - 1;
    records = widget.data['records'][newest];

    // scale = {
    //   'n': 1 - ((ideal['n'] - records['n']).abs() / ideal['n']),
    //   'p': 1 - ((ideal['p'] - records['p']).abs() / ideal['p']),
    //   'k': 1 - ((ideal['k'] - records['k']).abs() / ideal['k']),
    //   'ph': 1 - ((ideal['ph'] - records['ph']).abs() / ideal['ph']),
    // };

    scale = {
      'n': double.parse(((1 - ((ideal['n'] - records['n']).abs() / ideal['n'])) * 100).toStringAsFixed(1)),
      'p': double.parse(((1 - ((ideal['p'] - records['p']).abs() / ideal['p'])) * 100).toStringAsFixed(1)),
      'k': double.parse(((1 - ((ideal['k'] - records['k']).abs() / ideal['k'])) * 100).toStringAsFixed(1)),
      'ph': double.parse(((1 - ((ideal['ph'] - records['ph']).abs() / ideal['ph'])) * 100).toStringAsFixed(1)),
    };

    NPKData nitrogen = NPKData('Nitrogen', scale['n'], '100%', HexColor('#002D3B'));
    NPKData fosfor = NPKData('Fosfor', scale['p'], '100%', HexColor('#05784D'));
    NPKData kalsium = NPKData('Kalsium', scale['k'], '100%', HexColor('#759AA2'));
    NPKData pH = NPKData('pH', scale['ph'], '100%', HexColor('#8BBEAB'));

    List<NPKData> chartData = [
      pH,
      kalsium,
      fosfor,
      nitrogen,
    ];
    return SfCircularChart(
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
      ),
      series: <CircularSeries>[
        RadialBarSeries<NPKData, String>(
          dataSource: chartData,
          pointRadiusMapper: (NPKData data, _) => data.text,
          pointColorMapper: (NPKData data, _) => data.color,
          xValueMapper: (NPKData data, _) => data.xData,
          yValueMapper: (NPKData data, _) => data.yData,
          gap: '7%',
          radius: '100%',
          trackOpacity: 0.1,
          maximumValue: 100,
          useSeriesColor: true,
          cornerStyle: CornerStyle.bothCurve,
          dataLabelSettings: const DataLabelSettings(
            isVisible: false,
          ),
        )
      ],
    );
  }
}

class MyData extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text("Date")),
      DataCell(Text("N")),
      DataCell(Text("P")),
      DataCell(Text("K")),
      DataCell(Text("pH")),
    ]);
    // TODO: implement getRow
    throw UnimplementedError();
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => throw UnimplementedError();

  @override
  // TODO: implement rowCount
  int get rowCount => throw UnimplementedError();

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => throw UnimplementedError();
}

class NewestRecord extends StatelessWidget {
  NewestRecord({
    Key? key,
    required this.records,
    required this.scale,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var records;
  var scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 330,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nitrogen Start
          SizedBox(
            width: 350,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    // spreadRadius: 5,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    width: 101,
                    height: 25,
                    child: Row(children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        height: 25,
                        width: 25,
                        color: HexColor('#002D3B'),
                      ),
                      const Text('Nitrogen', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    width: 100,
                    height: 25,
                    child: Text(
                      (records == null) ? "Null" : "${records['n']} mg/kg",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    width: 50,
                    height: 25,
                    child: Text(
                      (scale == null) ? "Null" : "${scale['n']} %",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Nitrogen End
          // Fosfor Start
          SizedBox(
            width: 350,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    // spreadRadius: 5,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    width: 100,
                    height: 25,
                    child: Row(children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        height: 25,
                        width: 25,
                        color: HexColor('#05784D'),
                      ),
                      const Text('Fosfor', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    width: 100,
                    height: 25,
                    child: Text(
                      (records == null) ? "Null" : "${records['p']} mg/kg",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    width: 50,
                    height: 25,
                    child: Text(
                      (scale == null) ? "Null" : "${scale['p']} %",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Fosfor End
          // Kalsium Start
          SizedBox(
            width: 350,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    // spreadRadius: 5,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    width: 100,
                    height: 25,
                    child: Row(children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        height: 25,
                        width: 25,
                        color: HexColor('#759AA2'),
                      ),
                      const Text('Kalsium', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    width: 100,
                    height: 25,
                    child: Text(
                      (records == null) ? "Null" : "${records['k']} mg/kg",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    width: 50,
                    height: 25,
                    child: Text(
                      (scale == null) ? "Null" : "${scale['k']} %",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Kalsium End
          // Ph Start
          SizedBox(
            width: 350,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    // spreadRadius: 5,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    width: 100,
                    height: 25,
                    child: Row(children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        height: 25,
                        width: 25,
                        color: HexColor('#8BBEAB'),
                      ),
                      const Text('pH', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    width: 100,
                    height: 25,
                    child: Text(
                      (records == null) ? "Null" : "${records['ph']} pH",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    width: 50,
                    height: 25,
                    child: Text(
                      (scale == null) ? "Null" : "${scale['ph']} %",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Ph End
        ],
      ),
    );
  }
}

class PlantConditions extends StatelessWidget {
  const PlantConditions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 129,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'NPK PH',
            style: TextStyle(letterSpacing: 5),
          ),
          Text(
            'Tanaman Anda',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 25,
            ),
          ),
          Text('Terlihat Baik Hari ini', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25)),
        ],
      ),
    );
  }
}

class NPKData {
  NPKData(this.xData, this.yData, this.text, this.color);
  final String xData;
  final num yData;
  final String? text;
  final HexColor? color;
}

/*
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(date),
        Text(time),
      ],
    ),
    ButtonTheme(
      minWidth: 130,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          primary: Colors.greenAccent,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
        ),
        onPressed: () {
          showLoaderDialog(context);
          Http_request.getDevice(widget.data['_id']).then((value) {
            print(value);
            setState(() {
              dataResponse = value;
              print("Data");
              int newest = dataResponse.data['records']['records'].length - 1;
              records = dataResponse.data['records']['records'][newest];
              scale = {
                'n': ((1 - ((ideal['n'] - records['n']).abs() / ideal['n'])) * 100).toStringAsFixed(1),
                'p': ((1 - ((ideal['p'] - records['p']).abs() / ideal['p'])) * 100).toStringAsFixed(1),
                'k': ((1 - ((ideal['k'] - records['k']).abs() / ideal['k'])) * 100).toStringAsFixed(1),
                'ph': ((1 - ((ideal['ph'] - records['ph']).abs() / ideal['ph'])) * 100).toStringAsFixed(1),
              };
              int realtime = newest;
              String lastUpdate = records['datetime'];
              print(lastUpdate);
              var dateTime = DateTime.parse(lastUpdate);
              var date = DateFormat("d MMMM yyyy", "id_ID").format(dateTime);
              var time = DateFormat("HH:m:s", "id_ID").format(dateTime);
              Navigator.pop(context);
            });
          });
        },
        child: const Text("Perbarui Data", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
      ),
    ),
  ],
),
*/