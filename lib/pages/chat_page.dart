import 'package:flutter/material.dart';

import '../repositories/user_repository.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  var formKey = GlobalKey<FormState>();

  TextEditingController textMessage = TextEditingController();

  List<String> currentContext = [];

  final _scrollController = ScrollController();

  bool waitingResponse = false;

  late AnimationController animationController;


  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> submitMsg() async {
    {
      //AQUI PULSO EL BOTON ENTRAR

      bool resultValidation = formKey.currentState?.validate() ?? false;
      print("RESULT VALIDATION IS: $resultValidation");

      if (resultValidation) {
        //ENVIAR CAMPOS AL SERVIDOR
        try {
          setState(() {
            currentContext.add(textMessage.text);
            textMessage.clear();
          });
          scrollDown();
          waitingResponse = true;
          animationController.repeat();
          String newMessage =
              await UserRepository().sendMessage(chatContext: currentContext);
          setState(() {
            currentContext.add(newMessage);
            animationController.stop();
            waitingResponse = false;
          });
          scrollDown();
        } catch (e, stacktrace) {
          print("ERROR CAPTURADO: $e\n$stacktrace");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("${e.toString()}")));
        }
      }
    }
  }

  void scrollDown() {
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Hola, ¿en que puedo ayudarte?",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    opacity: 0.4,
                    fit: BoxFit.cover,
                    image: AssetImage('assets/chat_bg.jpg'))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.indigo.withOpacity(.2),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            child: ListView.separated(
                                itemCount: currentContext.length,
                                controller: _scrollController,
                                shrinkWrap: true,
                                reverse: true,
                                separatorBuilder: (context, index) => const SizedBox(
                                      height: 12,
                                    ),
                                itemBuilder: (context, i) {
                                  int index = currentContext.length - 1 - i;
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: 32,
                                              child: Icon(index.isEven
                                                  ? Icons.account_circle
                                                  : Icons.smart_toy_outlined)),
                                          const SizedBox(width: 16),
                                          Text(
                                            index.isEven ? "User" : "ChatGPT",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 48),
                                          Flexible(
                                              child: Text(
                                                  currentContext.elementAt(index))),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: waitingResponse,
                          controller: textMessage,
                          validator: (value) {
                            //SI EL VALIDADOR DEVUELVE NULL HA IDO TODO BIEN
                            if (value == null || value.isEmpty) {
                              return "El campo no puede estar vacío";
                            }
                            return null;
                          },
                          onEditingComplete: submitMsg,
                          decoration: InputDecoration(
                            filled: true,
                            prefixIcon: const Icon(Icons.chat),
                            hintText: waitingResponse ? "..." : "Message ChatGPT...",
                            enabled: !waitingResponse,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo.shade300,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: waitingResponse ? null : submitMsg,
                          child: !waitingResponse ? const Icon(Icons.arrow_upward) : RotationTransition(
                            alignment: Alignment.center,
                            turns: Tween(begin: 0.0, end: 1.0).animate(animationController),
                            child: const Icon(Icons.workspaces_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            )));
  }
}
