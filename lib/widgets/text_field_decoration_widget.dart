import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration getTextFieldDecoration(String label, String hint){
  return InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
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