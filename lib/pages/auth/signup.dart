// ignore_for_file: deprecated_member_use, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:validators/validators.dart';

import '../../widgets/loader_dialog.dart';
// import './signin.dart';
import '../../model/http_request.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Http_request dataResponse = Http_request();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConf = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool _passwordConfVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: HexColor("#FCFCFC"),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logoAuth(),
              Center(
                child: Text(
                  (dataResponse.data == null)
                      ? ""
                      : (dataResponse.data == "Email sudah terdaftar")
                          ? dataResponse.data
                          : dataResponse.data,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(minWidth: 300, maxWidth: 500),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Material(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
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
                                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                  ),
                                ),
                              )
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
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(fontSize: 14),
                                    fillColor: Colors.white70,
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                    Container(
                      constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Material(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                // shadowColor: Colors.lightGreen,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value != password.text) {
                                      return 'Password is not same!';
                                    }
                                  },
                                  controller: passwordConf,
                                  obscureText: !_passwordConfVisible,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                    ),
                                    hintText: 'Confirm Password',
                                    hintStyle: TextStyle(fontSize: 14),
                                    fillColor: Colors.white70,
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                    suffixIcon: IconButton(
                                      padding: EdgeInsets.only(right: 15),
                                      icon: Icon(
                                        _passwordConfVisible ? Icons.visibility : Icons.visibility_off,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordConfVisible = !_passwordConfVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
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
                                Http_request.signUp(email.text, password.text).then((value) {
                                  print(value.values);
                                  setState(() {
                                    dataResponse = value;
                                    Navigator.pop(context);
                                  });
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: HexColor("#002D3B"),
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50)))),
                            child: const Text(
                              "Daftar",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        // FlatButton(
                        //   onPressed: () {
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //           builder: (BuildContext context) {
                        //         return const SignIn();
                        //       }),
                        //     );
                        //   },
                        //   color: Colors.white,
                        //   shape: const RoundedRectangleBorder(
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(30))),
                        //   child: const Text("Masuk",
                        //       style: TextStyle(
                        //           color: Colors.black,
                        //           fontWeight: FontWeight.w600)),
                        // ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Sudah memiliki akun? "),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed('/signin');
                              },
                              child: const Text(
                                'Masuk',
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
            ],
          ),
        ),
      ),
    );
  }
}

// ============================== Extract Widget Below  ==============================

/* // ! Unused
@override
Widget goToSignIn(BuildContext context) {
  return Column(
    // crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an Account? "),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const SignIn();
                }),
              );
            },
            child: const Text(
              'Masuk',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      )
    ],
  );
}
*/
Widget logoAuth() {
  return Image(
    image: AssetImage("assets/img/logo.png"),
    width: 120,
  );
}
