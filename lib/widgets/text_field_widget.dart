import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calculadora_juros_compostos/widgets/text_field_decoration_widget.dart';
import 'package:flutter_calculadora_juros_compostos/models/financial_application.dart';
import 'package:google_fonts/google_fonts.dart';

TextField getTextField(int id, TextEditingController valueController, FinancialApplication fa, {
  bool? isRateMonthly, VoidCallback? onToggleRate, bool? isPeriodMonthly, VoidCallback? onTogglePeriod,}){
  double? parsePtBrDouble(String value) {
    return double.tryParse(value.replaceAll(',', '.'));
  }
  double? number;
  if(id==1){
    return TextField(
      style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
      controller: valueController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[.]')), FilteringTextInputFormatter.allow(RegExp(r'^\d+(,\d*)?$'),)],
      decoration: getTextFieldDecoration("Montante (R\$): ", "0,00"),
      onChanged: (value) {
        number = parsePtBrDouble(value);
        fa.setAmount(number ?? 0.0);
      },
    );
  }
  else if(id==2){
    return TextField(
      style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
      controller: valueController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[.]')), FilteringTextInputFormatter.allow(RegExp(r'^\d+(,\d*)?$'),)],
      decoration: getTextFieldDecoration("Capital Inicial (R\$): ", "0,00"),
      onChanged: (value) {
        number = parsePtBrDouble(value);
        fa.setInitialCapital(number ?? 0.0);
      },
    );
  }
  else if(id==3){
    return TextField(
      style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
      controller: valueController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[.]')), FilteringTextInputFormatter.allow(RegExp(r'^\d+(,\d*)?$'),)],
      decoration: getTextFieldDecoration("Aporte Mensal (R\$): ", "0,00"),
      onChanged: (value) {
        number = parsePtBrDouble(value);
        fa.setMonthlyContribution(number ?? 0.0);
      },
    );
  }
  else if(id==4){
    final bool rateMonthly = isRateMonthly ?? true;
    return TextField(
      style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
      controller: valueController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[.]')), FilteringTextInputFormatter.allow(RegExp(r'^\d+(,\d*)?$'),)],
      decoration: getTextFieldDecoration("Taxa de Juros (%):", "0,00").copyWith(
        suffixIcon: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(width: 1, height: 24, color: Colors.grey),
              SizedBox(
                width: 80,
                child: TextButton(
                  onPressed: onToggleRate,
                  child: Text(rateMonthly ? "a.m." : "a.a.", style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
      onChanged: (value) {
        double? rate = parsePtBrDouble(value);
        if (rate == null) {
          fa.setInterestRate(0);
          return;
        }
        if (!rateMonthly) {
          rate = (pow(1 + rate / 100, 1 / 12) - 1) * 100;
        }
        fa.setInterestRate(rate);
      },
    );
  }
  else{
    final bool periodMonthly = isPeriodMonthly ?? true;
    return TextField(
      style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
      controller: valueController,
      keyboardType: TextInputType.number, 
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: getTextFieldDecoration("Período: ", "0").copyWith(
        suffixIcon: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(width: 1, height: 24, color: Colors.grey),
              SizedBox(
                width: 80,
                child: TextButton(
                  onPressed: onTogglePeriod,
                  child: Text(periodMonthly ? "meses" : "anos", style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
      onChanged: (value) {
        int? period = int.tryParse(value);
        if (period == null) {
          fa.setPeriod(0);
          return;
        }
        if (!periodMonthly) {
          period *= 12;
        }
        fa.setPeriod(period);
      },
    );
  }
}