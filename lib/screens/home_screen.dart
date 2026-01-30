import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_calculadora_juros_compostos/screens/amount_screen.dart';
import 'package:flutter_calculadora_juros_compostos/screens/initial_capital_screen.dart';
import 'package:flutter_calculadora_juros_compostos/screens/interest_rate_screen.dart';
import 'package:flutter_calculadora_juros_compostos/screens/monthly_contribution_screen.dart';
import 'package:flutter_calculadora_juros_compostos/screens/period_screen.dart';
import 'package:flutter_calculadora_juros_compostos/widgets/button_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora de Juros Compostos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
        backgroundColor: Colors.yellow[700],
        centerTitle: true,
        shadowColor: Colors.black,
        elevation: 6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
        children: [
          Center(
            child: Image.asset('assets/money.png', width: 300,),
          ),
          const SizedBox(height: 12),
          Text("Encontre o caminho da liberdade financeira!",
          textAlign: TextAlign.center,
          style: GoogleFonts.audiowide(
            fontSize: 20,
            fontWeight: FontWeight.normal,
          )),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonWidget(text: "Montante", color: Colors.red, onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AmountScreen()),
                ); 
              }, textColor: Colors.black),
              ButtonWidget(text: "Capital Inicial", color: Colors.orange, onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InitialCapitalScreen()),
                );
              }, textColor: Colors.black),
              ButtonWidget(text: "Rentabilidade", color: Colors.yellow, onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InterestRateScreen()),
                );
              }, textColor: Colors.black),
              ButtonWidget(text: "Aporte Mensal", color: Colors.green, onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MonthlyContributionScreen()),
                );
              }, textColor: Colors.black),
              ButtonWidget(text: "Período", color: Colors.blue, onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PeriodScreen()),
                );
              }, textColor: Colors.black),
            ]
          )
        ],
      )),
    );
  }
}