import 'package:flutter/material.dart';

InputDecoration getTextFieldDecoration(String label, String hint){
  return InputDecoration(
    labelText: label,
    hintText: hint,
    fillColor: Colors.white,
    filled: true,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.black, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.amber, width: 2),
    ),
  );
}