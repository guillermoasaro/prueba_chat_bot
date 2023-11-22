import 'dart:convert';
import '/constants.dart';
import 'package:http/http.dart' as http;
import '/shared_preferences_manager.dart';
import '/models/user.dart';

class UserRepository{

 /* Future<User> getUserProfile({required String id}){

    //AQUI OBTINDRIEM LA INFO COMPLETA DE L'USUARI EN EL ENTRY POINT
    // https://cifo.indalter.es/api/user/profile/6551e75dc4bbaf494db33387


  }*/

  Future<List<User>> getUserList({int page = 1}) async {

    Uri uri = Uri.parse("$baseUrl/user/list/$page");

    var token = await SharedPreferencesManager.getToken();

    http.Response response = await http.get(uri,
      headers:{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization': token ?? ""
      },
    );

    if(response.statusCode >= 200  && response.statusCode < 300){

      //PARSEO LISTA Y DEVUELVO
      //OBTENGO MI RESPUES EN FORMATO Map<String,dynamic>
      var mapResponse = jsonDecode(response.body);

      // OBTENGO LA LISTA DE USERS EN FORMATO Iterable<Map<String,dynamic>
      var mapUsers = mapResponse["data"]["users"];

      //FINALMENTE MAPEO CADA UNO DE LOS Map<String,dynamic> a Objeto User.
      List<User> listUsers = mapUsers.map((el)=>User.fromJson(el)).toList();

      return listUsers;
    }else{
      throw Exception("ERROR PARSEANDO LISTA DE USUARIOS");
    }
  }


  Future<User> getUserProfile({required String idUser}) async {

    Uri uri = Uri.parse("$baseUrl/user/profile/$idUser");

    var token = await SharedPreferencesManager.getToken();

    http.Response response = await http.get(uri,
      headers:{
        'Content-Type':'application/json; charset=UTF-8',
        'Authorization': token ?? ""
      },
    );

    if(response.statusCode >= 200 && response.statusCode < 300){
      //LA PETICION HA IDO BIEN

      var mapData = jsonDecode(response.body);

      print("RESPONSE BODY SYCCESS: ${response.body}");

      User user = User.fromJson(mapData["user"]);

      return user;

    }else{
      print("RESPONSE BODY: ${response.body}");
      throw Exception("Error getting profile");
    }


  }

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


          SharedPreferencesManager.setToken(token);
          SharedPreferencesManager.setUserId(responseMap['user']['_id']);

          return true;
        }else{

          var error = jsonDecode(response.body);
          throw Exception(error['message']);
        }

  }

  Future<String> sendMessage({required List<String> chatContext}) async {
    var token = await SharedPreferencesManager.getToken();
    Uri uri = Uri.parse("$baseUrl/chat/getResponse");
    int index = 0;
    var requestBody = {
      "history": List.from(chatContext.map((message){
        var messageContext = {
          "role": index.isEven ? "user" : "assistant",
          "content": message
        };
        index++;
        return messageContext;
      }))
    };

    print("requestBody: $requestBody");

    http.Response response = await http.post(uri,
        headers:{
          'Content-Type':'application/json; charset=UTF-8',
          'Authorization': token ?? ""
        },
        body: jsonEncode(requestBody)
    );
    if(response.statusCode >= 200 && response.statusCode < 300){
      //LA PETICION HA IDO BIEN

      var mapBody = jsonDecode(response.body);
      print("RESPONSE BODY SYCCESS: ${mapBody}");

      return mapBody["message"]?["content"] ?? "";

    }else{
      print("RESPONSE BODY: ${response.body}");
      throw Exception("Error getting the response");
    }

  }

}