import 'package:flutter/material.dart';

Widget myInput({
  required TextEditingController controller,
  required String hintText,
   required IconData icon,
  bool obscureText = false,
  Widget? suffixIcon,
  String? Function(String?)? validator,
  void Function(String?)? onSaved,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      hintText: hintText,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: Colors.white,
      errorStyle: const TextStyle(
        color: Colors.red,
        fontSize: 12,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
    ),
    keyboardType: obscureText ? TextInputType.text : TextInputType.emailAddress,
    validator: validator,
    onSaved: onSaved,
  );
}

Widget myInput2({
  required TextEditingController controller,
  required String hintText,
  bool obscureText = false,
  Widget? suffixIcon,
  int?maxLines,
  String? Function(String?)? validator,
  void Function(String?)? onSaved,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscureText,
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: Colors.white,
      errorStyle: const TextStyle(
        color: Colors.red,
        fontSize: 12,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
    ),
    keyboardType: obscureText ? TextInputType.text : TextInputType.emailAddress,
    validator: validator,
    onSaved: onSaved,
  );
}
