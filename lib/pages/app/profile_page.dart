// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iotanic_app/index.dart';
import 'package:iotanic_app/pages/overview/profile_overview_page.dart';
import 'package:iotanic_app/utils/user_preferences.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../widgets/loader_dialog.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/img/gradient.png'), fit: BoxFit.cover)),
          child: Column(
            children: const <Widget>[
              ProfilePic(),
              Name(),
              ListProfile(),
            ],
          ),
        ),
      ),
    );
  }
}

class Name extends StatelessWidget {
  const Name({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
      child: FutureBuilder(
        future: UserPreferences.getName(),
        builder: (context, snapshot) {
          return Text(
            snapshot.data.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          );
        },
      ),
    );
  }
}

class ListProfile extends StatelessWidget {
  const ListProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(56),
          topRight: Radius.circular(56),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0.3,
            blurRadius: 5,
          )
        ],
        // changes position of shadow),
        color: Colors.white,
      ),
      height: 563,
      child: Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return ProfileOverview();
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                primary: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(
                    LineAwesomeIcons.user,
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      'Akun Saya',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                primary: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(
                    LineAwesomeIcons.cog,
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      'Pengaturan',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                primary: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(
                    LineAwesomeIcons.info_circle,
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      'Bantuan',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                primary: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(
                    LineAwesomeIcons.phone,
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      'Hubungi Kami',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                primary: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(
                    LineAwesomeIcons.user_check,
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      'Tentang Kami',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                primary: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(
                    LineAwesomeIcons.key,
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      'Kebijakan Privasi',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                primary: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(
                    LineAwesomeIcons.file,
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      'Syarat dan Ketentuan',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showLoaderDialog(context);
                Navigator.of(context).pop();
                UserPreferences.removeAuth();
                Navigator.of(context).pushReplacementNamed('/signin');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                primary: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(LineAwesomeIcons.alternate_sign_out, color: Colors.red),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      'Keluar',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ])),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 110,
      margin: EdgeInsets.fromLTRB(0, 80, 0, 15),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // const CircleAvatar(
          //   backgroundImage: AssetImage('assets/icon/icon.png'),
          //   backgroundColor: Colors.red,
          // ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                image: AssetImage('assets/img/img1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: -1,
            bottom: -3,
            child: SizedBox(
              height: 45,
              width: 45,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: BorderSide(color: Colors.white)),
                  primary: Color(0xFFF5F6F9),
                ),
                onPressed: () {},
                child: const Icon(LineAwesomeIcons.camera),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
