

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart';

class SharedPreferencesManager{

  static void setToken(String token) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  static Future<String?> getToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }


  static void setUserId(String token) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", token);
  }

  static Future<String?> getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }

  static Future<void> setCurrentUser(User user) async {
    var prefs = await SharedPreferences.getInstance();
    var jsonUser = user.toJson();

    prefs.setString("currentUser", jsonUser);
  }

  static Future<User?> getCurrentUser() async {

    var prefs = await SharedPreferences.getInstance();

    String? jsonUser = prefs.getString("currentUser");

    if(jsonUser != null) {
      User user = User.fromJson(jsonUser);

      return user;
    }else{
      return null;
    }
  }



}