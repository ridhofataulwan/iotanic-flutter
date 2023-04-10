// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iotanic_app/model/http_request.dart';
import 'package:iotanic_app/pages/overview/monitoring_overview_page.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:iotanic_app/model/device.dart';

class Monitoring extends StatefulWidget {
  const Monitoring({Key? key}) : super(key: key);

  @override
  State<Monitoring> createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {
  Http_request dataResponse = Http_request();

  // Future<List> getDevice() async {
  //   final profileID = await getAuth('profileID');
  //   var response = await http.post(
  //     Uri.parse("${api}/device/"),
  //     headers: {
  //       "Accept": "application/json",
  //     },
  //     body: {
  //       'profile': profileID,
  //     },
  //   );
  //   Map<String, dynamic> map = json.decode(response.body);
  //   List<dynamic> data = map["values"]["devices"];
  //   return data;
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Device.getDevice(),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Map device = snapshot.data[index];
                int realtime = device['records'].length - 1;
                String lastUpdate = device['records'][realtime]['datetime'];
                print(lastUpdate);
                var dateTime = DateTime.parse(lastUpdate).add(Duration(hours: 7));
                var date = DateFormat("d MMMM yyyy", "id_ID").format(dateTime);
                var time = DateFormat("HH:mm:ss", "id_ID").format(dateTime);
                return ListTile(
                  hoverColor: Colors.amber,
                  focusColor: Colors.amber,
                  onTap: () {
                    print(device['_id']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MonitoringOverview(data: device),
                      ),
                    );
                  },
                  leading: CircleAvatar(child: Icon(LineAwesomeIcons.leaf)),
                  title: Text(device['name']),
                  subtitle: Text("ID: " + device['_id'], style: TextStyle(fontSize: 12)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(date, style: TextStyle(fontSize: 12)),
                      Text(time, style: TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              });
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
