import 'package:flutter/material.dart';
import '../constants.dart';

class TextInput extends StatelessWidget {
  final TextEditingController inputController;
  final MaterialColor mainInputColor;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final String? Function(String? value)? validator;

  const TextInput(
      {super.key,
      required this.inputController,
      this.mainInputColor = mainColor,
      this.obscureText = false,
      required this.labelText,
      required this.hintText,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: mainInputColor,
      controller: inputController,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: mainInputColor),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        labelText: labelText,
        floatingLabelStyle: TextStyle(color: mainInputColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: mainInputColor),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
