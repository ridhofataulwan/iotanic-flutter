// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';

Widget formBuilderEmail() {
  return Container(
    constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50.0),
    child: Column(
      children: [
        Form(
          child: Column(
            children: const [
              Material(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                elevation: 3.0,
                // shadowColor: Colors.lightGreen,
                child: TextField(
                  obscureText: false,
                  autofocus: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(fontSize: 14),
                    fillColor: Colors.white70,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  // autofocus: true,
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget formBuilderPassword() {
  return Container(
    constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50.0),
    child: Column(
      children: [
        Form(
            child: Column(
          children: const [
            Material(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              elevation: 3.0,
              // shadowColor: Colors.lightGreen,
              child: TextField(
                obscureText: true,
                autofocus: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(fontSize: 14),
                  fillColor: Colors.white70,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                // autofocus: true,
              ),
            )
          ],
        ))
      ],
    ),
  );
}

Widget formBuilderConfirmPassword() {
  return Container(
    constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50.0),
    child: Column(
      children: [
        Form(
            child: Column(
          children: const [
            Material(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              elevation: 3.0,
              // shadowColor: Colors.lightGreen,
              child: TextField(
                obscureText: true,
                autofocus: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(fontSize: 14),
                  fillColor: Colors.white70,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                // autofocus: true,
              ),
            )
          ],
        ))
      ],
    ),
  );
}

Widget formSearch() {
  return Container(
    constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50.0),
    child: Column(
      children: [
        Form(
          child: Column(
            children: [
              Material(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                elevation: 3.0,
                // shadowColor: Colors.lightGreen,
                child: TextFormField(
                  obscureText: false,
                  autofocus: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    hintText: 'Search',
                    hintStyle: TextStyle(fontSize: 14),
                    fillColor: Colors.white70,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
