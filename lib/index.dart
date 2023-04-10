// ignore_for_file: deprecated_member_use, prefer_const_constructors, no_leading_underscores_for_local_identifiers, sort_child_properties_last, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:iotanic_app/constant.dart';
import 'package:iotanic_app/pages/app/home_page.dart';
import 'package:iotanic_app/pages/app/list_page.dart';
import 'package:iotanic_app/pages/app/monitoring_page.dart';
import 'package:iotanic_app/pages/app/profile_page.dart';
import 'package:iotanic_app/pages/app/sensor_page.dart';
import 'package:iotanic_app/widgets/appbar.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final List _appBar = [
      homeAppBar(),
      monitoringAppBar(),
      sensorAppBar(),
      listAppBar(),
      profileAppBar(),
    ];

    final List<Widget> _body = [
      Home(),
      Monitoring(),
      Sensor(),
      ListItem(),
      Profile(),
    ];

    double navItemWidth = ScreenUtil().setSp(70);

    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      appBar: _appBar.elementAt(_selectedIndex),
      body: Container(
        color: HexColor("#F5F6FA"),
        child: _body.elementAt(_selectedIndex),
      ),
      // bottomNavigationBar: bottomNavBar(_onItemTapped),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavButton(0, _selectedIndex, Icons.home, "Home", navItemWidth),
              NavButton(1, _selectedIndex, LineAwesomeIcons.desktop, "Device", navItemWidth),
              SizedBox(width: navItemWidth),
              NavButton(3, _selectedIndex, Icons.list, "List", navItemWidth),
              NavButton(4, _selectedIndex, Icons.person, "Akun", navItemWidth),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: showFab
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                backgroundColor: (_selectedIndex != 2) ? Colors.white : HexColor("#002D3B"),
                child: Icon(Icons.add, color: (_selectedIndex != 2) ? HexColor("#002D3B") : Colors.white),
                onPressed: () => setState(() {
                  _selectedIndex = 2;
                }),
              ),
            )
          : null,
    );
  }

  Widget NavButton(index, active, icon, label, navItemWidth) {
    return Container(
      decoration: BoxDecoration(
        color: (index == active) ? HexColor("#002D3B") : Colors.white,
        borderRadius: (index == 1 || index == 3)
            ? BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
            : (index == 0)
                ? BorderRadius.only(topRight: Radius.circular(10))
                : BorderRadius.only(topLeft: Radius.circular(10)),
      ),
      width: navItemWidth,
      // color: (index == active) ? HexColor("#002D3B") : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              _onItemTapped(index);
            },
            child: Column(
              children: [
                Icon(
                  icon,
                  color: (active == index) ? Colors.white : HexColor("#002D3B"),
                ),
                Text(
                  (active == index) ? label : "",
                  style: TextStyle(fontSize: 12, color: (index == active) ? Colors.white : HexColor("#002D3B")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
