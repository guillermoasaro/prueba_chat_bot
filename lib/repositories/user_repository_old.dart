import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class UserRepository{
  Future<bool> loginUser({required String email, required String password}) async {
    Uri uri = Uri.parse("$baseUrl/user/login");

    http.Response response = await http.post(uri,
        headers:{
          'Content-Type':'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email':email,'password':password})
    );

    if(response.statusCode >= 200 && response.statusCode < 300){
      print("LOGIN OK");
      print(response.body);

      Map<String,dynamic> responseMap = jsonDecode(response.body);
      var token = responseMap['token'];
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("token", token);

      return true;
    }else{
      var error = jsonDecode(response.body);
      throw Exception(error['message']);
    }

    return false;
  }
}