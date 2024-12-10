import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'models/user.dart';

class AuthService {

  static Future<User?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString('user');
    if (userString != null) {
      Map<String, dynamic> userMap = jsonDecode(userString);
      return User.fromJson(userMap);
    }
    return null;
  }

  // Save login state
  static Future<void> saveLoginState(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('isLoggedIn', true);
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  // Get login state -> unused
  static Future<bool> getLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Default to false
  }

  // Clear login state
  static Future<void> clearLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    // await prefs.remove('isLoggedIn');
  }
}

User? thisUser;

Future<void> initGlobals() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userJson = prefs.getString('user');
  if (userJson != null) {
    Map<String, dynamic> data = jsonDecode(userJson);
    thisUser = User.fromJson(data);
  }
}