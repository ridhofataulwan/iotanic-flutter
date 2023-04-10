import 'package:shared_preferences/shared_preferences.dart';

getAuth(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.get(key));
  return prefs.get(key);
}
