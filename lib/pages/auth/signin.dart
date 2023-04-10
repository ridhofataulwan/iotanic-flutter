// ignore_for_file: prefer_const_constructors, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

import '../../widgets/button.dart';
import '../../model/http_request.dart';
import '../../pages/auth/signup.dart';
import '../../widgets/loader_dialog.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final focusNode = FocusNode();
  Http_request dataResponse = Http_request();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: HexColor("#FCFCFC"),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              logoAuth(),
              Center(
                child: Text(
                  (dataResponse.data == null)
                      ? ""
                      : (dataResponse.data['account'] == null)
                          ? "Email atau password Anda salah"
                          : "",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Material(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                // elevation: 3.0,
                                // shadowColor: Colors.lightGreen,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || !isEmail(value)) {
                                      return 'Email is not valid!';
                                    }
                                  },
                                  controller: email,
                                  obscureText: false,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                    ),
                                    hintText: 'Email',
                                    hintStyle: TextStyle(fontSize: 14),
                                    fillColor: Colors.white70,
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Material(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                // shadowColor: Colors.lightGreen,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value == "") {
                                      return 'Password is not valid!';
                                    }
                                  },
                                  controller: password,
                                  obscureText: !_passwordVisible,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(fontSize: 14),
                                    fillColor: Colors.white70,
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 10,
                                    ),
                                    suffixIcon: IconButton(
                                      padding: EdgeInsets.only(right: 15),
                                      icon: Icon(
                                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 15),
                  ButtonTheme(
                    padding: const EdgeInsets.fromLTRB(35, 20, 35, 20),
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          showLoaderDialog(context);
                          Http_request.signIn(email.text, password.text).then((value) {
                            setState(
                              () {
                                dataResponse = value;
                                if (dataResponse.data['account'] != null) {
                                  Navigator.pop(context);
                                  Navigator.of(context).pushReplacementNamed('/app');
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: HexColor("#002D3B"),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50)))),
                      child: const Text(
                        "Masuk",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Belum memiliki akun?"),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/signup');
                        },
                        child: Text(
                          'Daftar',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  // Column(children: [
                  //   Text((dataResponse.data == null)
                  //       ? "Data : There's no message"
                  //       : "Data : ${dataResponse.data}"),
                  // ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================== Extract Widget Below  ==============================

Widget logoAuth() {
  return Image(
    image: AssetImage("assets/img/logo.png"),
    width: 120,
  );
}

/* // ! Unused
@override
Widget formSignin(BuildContext context) {
  return Column(children: [
    Container(
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
                  shadowColor: Colors.lightGreen,
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    ),
                    // autofocus: true,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
    Container(
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
                shadowColor: Colors.lightGreen,
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  // autofocus: true,
                ),
              )
            ],
          ))
        ],
      ),
    ),
    goToApp(context),
  ]);
}
*/

/* // ! Unused
@override
Widget goToSignUp(BuildContext context) {
  return Column(
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonTheme(
              minWidth: 130,
              child: RaisedButton(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  onPressed: () {},
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Row(
                    children: const [
                      Icon(
                        LineAwesomeIcons.facebook,
                      ),
                      Text("Masuk",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                    ],
                  ))),
          ButtonTheme(
            minWidth: 130,
            child: RaisedButton(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              onPressed: () {},
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Row(
                children: const [
                  Icon(
                    LineAwesomeIcons.google_logo,
                  ),
                  Text("Masuk",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
      Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an Account? "),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const SignUp();
                  }),
                );
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      )
    ],
  );
}
*/

