import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

Widget bottomNavBar(_onItemTapped) {
  return SizedBox(
    height: 95,
    child: CurvedNavigationBar(
      color: Colors.white,
      animationDuration: const Duration(milliseconds: 100),
      items: const <Widget>[
        Icon(Icons.home_rounded, size: 30),
        Icon(LineAwesomeIcons.desktop, size: 30),
        Icon(Icons.add, size: 30),
        Icon(Icons.list, size: 30),
        Icon(Icons.person, size: 30),
      ],
      onTap: _onItemTapped,
    ),
  );
}
