import 'package:flutter/material.dart';
import 'package:human_resource/utils/colors.dart';

Container butonContainer(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
    child: Text(text, style: const TextStyle(color: Colors.white),),
  );
}

InputDecoration textFieldNormalDecoration(String hintText){
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    hintText: hintText,
    hintStyle: const TextStyle(fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: kPrimaryLight,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: kPrimaryLight,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: kPrimaryLight,
      ),
    ),
    filled: true,
    fillColor: kPrimaryLight,
  );
}

DropdownMenuItem<String> menuItemStr(String value) => DropdownMenuItem(
  value: value,
  child: Text(value, style: const TextStyle(fontSize: 14)),
);

DropdownMenuItem<int> menuItemInt(int value, String text) => DropdownMenuItem(
  value: value,
  child: Padding(
    padding: const EdgeInsets.only(left: 15),
    child: Text(text, style: const TextStyle(fontSize: 14)),
  ),
);
