import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calculadora_juros_compostos/widgets/text_field_decoration_widget.dart';
import 'package:flutter_calculadora_juros_compostos/models/financial_application.dart';

TextField getTextField(int id, TextEditingController valueController, FinancialApplication fa){
  double? number;
  if(id==1){
    return TextField(
      controller: valueController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
      ],
      decoration: getTextFieldDecoration("Digite o montante desejado (R\$): ", "0,00"),
      onChanged: (value) {
        number = double.tryParse(value);
        fa.setAmount(number ?? 0.0);
      },
    );
  }
  else if(id==2){
    return TextField(
      controller: valueController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
      ],
      decoration: getTextFieldDecoration("Digite o capital inicial (R\$): ", "0,00"),
      onChanged: (value) {
        number = double.tryParse(value);
        fa.setInitialCapital(number ?? 0.0);
      },
    );
  }
  else if(id==3){
    return TextField(
      controller: valueController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
      ],
      decoration: getTextFieldDecoration("Digite o aporte mensal (R\$): ", "0,00"),
      onChanged: (value) {
        number = double.tryParse(value);
        fa.setMonthlyContribution(number ?? 0.0);
      },
    );
  }
  else if(id==4){
    bool isRateMonthly = true;
    return TextField(
      controller: valueController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
      ],
      decoration: getTextFieldDecoration("Taxa de Juros (%)", "0,00").copyWith(
        suffixIcon: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(width: 1, height: 24, color: Colors.grey),
              SizedBox(
                width: 80,
                child: TextButton(
                  onPressed: () {
                    isRateMonthly = !isRateMonthly;
                  },
                  child: Text(
                    isRateMonthly ? "a.m." : "a.a.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onChanged: (value) {
        double? number = double.tryParse(value);
        if(number != null){
          isRateMonthly ? () : (
            number = (pow((1+number/100), 1 / 12)-1)*100
          );
          fa.setInterestRate(number);
        }
        else{
          fa.setInterestRate(number ?? 0.0);
        }
      },
    );
  }
  else{
    bool isPeriodMonthly = true;
    return TextField(
      controller: valueController,
      keyboardType: TextInputType.number, 
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, 
      ],
      decoration: getTextFieldDecoration("Digite o período: ", "0").copyWith(
        suffixIcon: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(width: 1, height: 24, color: Colors.grey),
              SizedBox(
                width: 80,
                child: TextButton(
                  onPressed: () {
                    isPeriodMonthly = !isPeriodMonthly;
                  },
                  child: Text(
                    isPeriodMonthly ? "meses" : "anos",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onChanged: (value) {
        int? period = int.tryParse(value);
        if(period != null){
          isPeriodMonthly ? () : (
            period*=12
          );
          fa.setPeriod(period);
        }
        else{
          fa.setPeriod(period ?? 0);
        }
      },
    );
  }
}