
import 'package:flutter/material.dart';
import '/helpers.dart';
import '/repositories/user_repository.dart';
import 'chat_page.dart';

class LoginPage extends StatelessWidget {

  LoginPage({super.key});

  var formKey = GlobalKey<FormState>();

  TextEditingController textEmail = TextEditingController(text:"test@tester.com");
  TextEditingController textPassword = TextEditingController(text:"123456");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.4,
            fit: BoxFit.cover,
            image:AssetImage('assets/image.jpg')
          )
        ),
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  TextFormField(
                        controller: textEmail,
                        validator: (value){
                          //SI EL VALIDADOR DEVUELVE NULL HA IDO TODO BIEN
                          if(value == null || value.isEmpty){
                            return "El campo no puede estar vacío";
                          }
                          if(!Helpers.isEmail(value)){
                            return "El campo email no tiene un formato correcto";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                           filled: true,
                           prefixIcon: Icon(Icons.alternate_email),
                           labelText: "Email",
                           fillColor: Colors.white,
                           border:OutlineInputBorder(
                             borderRadius: BorderRadius.circular(15)
                           ),
                       ),
                  ),
                  const SizedBox(height:20),
                  TextFormField(
                    controller: textPassword,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "El campo password no puede estar vacio";
                      }
                      if(value.length < 6){
                        return "El campo debe ser mayor a 6 caracteres";
                      }
                      return null;
                    },
                    obscureText: true,
                    //keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        filled: true,
                        prefixIcon: const Icon(Icons.lock),
                        hintText: "Password",
                        fillColor: Colors.white,
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),
                  ),
                  const SizedBox(height:20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        )
                      ),
                      onPressed: () async{
                        //AQUI PULSO EL BOTON ENTRAR

                        bool resultValidation =
                              formKey.currentState?.validate() ?? false;
                        print("RESULT VALIDATION IS: $resultValidation");

                        if(resultValidation){
                          print("ENVIO ${textEmail.text}");
                          print("ENVIO ${textPassword.text}");
                          //ENVIAR CAMPOS AL SERVIDOR
                          try {
                           bool isLogged = await UserRepository()
                                .loginUser(email: textEmail.text,
                                password: textPassword.text);

                            if(isLogged){
                              // ME VOY A LA SIGUIENTE PANTALLA

                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_)=>ChatPage())
                              );
                            }

                            //await SharedPreferencesManager.setCurrentUser(user);

                            //UserRepository().getUserProfile(idUser: user.id);



                          }catch(e,stacktrace){
                            print("ERROR CAPTURADO: $stacktrace");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${e.toString()}"))
                            );



                          }

                          //var prefs = await SharedPreferences.getInstance();
                          //prefs.setBool("isLogged", true);

                          // EL SERVIDOR ME DICE QUE OK
                          /*Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder:(context)=>GamePage()
                            )
                          );*/
                          /*Helpers.navigate(
                              context: context,
                              page: TabsPage(),
                              isReplacement: true);*/


                        }
                      },
                      child: Text("ENTRAR"),
                    ),
                  ),



                ]
            ),
          ),
        )
      )
    );
  }
}
