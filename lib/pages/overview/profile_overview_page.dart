// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iotanic_app/utils/user_preferences.dart';
import 'package:validators/validators.dart';

import '../../model/user.dart';
import '../../widgets/loader_dialog.dart';

class ProfileOverview extends StatefulWidget {
  const ProfileOverview({super.key});

  @override
  State<ProfileOverview> createState() => _ProfileOverviewState();
}

class _ProfileOverviewState extends State<ProfileOverview> {
  final _formKey = GlobalKey<FormState>();
  dynamic user, message, statusCode;
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: HexColor("#002D3B"),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Profil Saya',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: HexColor("#002D3B"),
            )),
        backgroundColor: HexColor("#FAFAFA"),
        toolbarHeight: 98.0,
        elevation: 0.0,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   "Profil Saya",
              //   style: TextStyle(fontSize: 20),
              // ),
              Text(
                (message == null) ? "" : message,
                style: TextStyle(
                    color: (statusCode == null)
                        ? Colors.black
                        : (statusCode != 200)
                            ? Colors.red
                            : Colors.green),
              ),
              Container(
                child: SizedBox(
                  width: 300,
                  child: FutureBuilder(
                    future: SharedPreferences.getInstance().then((value) {
                      user = {
                        'name': value.get('name').toString(),
                        'age': value.get('age').toString(),
                        'email': value.get('email').toString(),
                      };
                      name.text = value.get('name').toString();
                      age.text = value.get('age').toString();
                      email.text = value.get('email').toString();
                      // return user;
                    }),
                    builder: (context, snapshot) {
                      // print(user);
                      // print(user.runtimeType);
                      // print(snapshot.data);
                      // print(snapshot.data.runtimeType);
                      return Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Profile(
                              controller: name,
                              label: 'Nama',
                              validator: (value) {
                                if (value == null) {
                                  return 'Nama harus diisi';
                                }
                              },
                              enabled: true,
                            ),
                            SizedBox(height: 20),
                            Profile(
                              controller: age,
                              label: 'Age',
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null) {
                                  return 'Umur harus diisi';
                                }
                              },
                              enabled: true,
                            ),
                            SizedBox(height: 20),
                            Profile(
                              controller: email,
                              label: 'Email',
                              validator: (value) {
                                if (value == null || !isEmail(value)) {
                                  return 'Email tidak valid';
                                }
                              },
                              enabled: false,
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(HexColor("#CFE5DD")),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ))),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      'Kembali',
                                      style: TextStyle(color: HexColor("#002D3B"), fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(HexColor("#CFE5DD")),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ))),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      showLoaderDialog(context);
                                      User.updateUser(email.text, name.text, age.text).then((value) {
                                        print(value['status']);
                                        setState(() {
                                          if (value['status'] == 200) {
                                            UserPreferences.updateAuth('email', email.text);
                                            UserPreferences.updateAuth('name', name.text);
                                            UserPreferences.updateAuth('age', age.text);
                                            message = "Data berhsail diperbarui";
                                          } else if (value['status'] == 400) {
                                            message = "Data gagal diperbarui";
                                          }
                                          statusCode = value['status'];
                                          Navigator.pop(context);
                                        });
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      'Ubah',
                                      style: TextStyle(color: HexColor("#002D3B"), fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Profile extends StatelessWidget {
  Profile({Key? key, this.value, this.label, this.controller, this.validator, this.keyboardType, this.inputFormatters, this.enabled}) : super(key: key);
  dynamic label, validator, controller;
  dynamic? value, keyboardType, inputFormatters, enabled;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      // initialValue: value,
      validator: validator,
      controller: controller,
      enableInteractiveSelection: false,
      keyboardType: keyboardType,
      inputFormatters: (inputFormatters != null) ? inputFormatters : <TextInputFormatter>[],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        filled: true,
        labelText: label,
        contentPadding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),
      ),
    );
  }
}
