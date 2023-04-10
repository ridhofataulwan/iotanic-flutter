import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:iotanic_app/constant.dart';
import 'package:iotanic_app/index.dart';
import 'package:iotanic_app/pages/app/monitoring_page.dart';
import 'package:iotanic_app/pages/auth/signin.dart';
import 'package:iotanic_app/pages/auth/signup.dart';
import 'package:iotanic_app/pages/splash.dart';
import 'package:iotanic_app/utils/user_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map user = await UserPreferences.getAuth();
  await initializeDateFormatting('id_ID', null).then((_) => runApp(MaterialApp(
        home: (user['name'] == null) ? Splash() : App(),
        title: 'IoTanic',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        routes: {
          '/splash': (context) => Splash(),
          '/signin': (context) => SignIn(),
          '/signup': (context) => SignUp(),
          '/app': (context) => App(),
          '/monitoring': (context) => Monitoring(),
        },
      )));
}
/*void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoTanic',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const Splash(),
    );
  }
}
*/