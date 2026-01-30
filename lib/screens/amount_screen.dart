import 'package:flutter/material.dart';
import 'package:flutter_calculadora_juros_compostos/models/financial_application.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class AmountScreen extends StatefulWidget{
  const AmountScreen({super.key});
  @override
  _AmountScreenState createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen>{
  String result="", investedCapital="", interest="";
  final TextEditingController _initialCapitalController = TextEditingController();
  final TextEditingController _monthlyContributionController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();
  FinancialApplication fa = FinancialApplication(initialCapital: 0, monthlyContribution: 0, interestRate: 0, period: 0, amount: 0, interest: 0, investedCapital: 0);
  double? initialCapital, monthlyContribution, interestRate;
  int? period;
  @override
  void dispose() {
    _initialCapitalController.dispose();
    _monthlyContributionController.dispose();
    _interestRateController.dispose();
    _periodController.dispose();
    super.dispose();
  }
  void _calculateAmount(double initialCapital, double monthlyContribution, double interestRate, int period){
    if(initialCapital==0 && monthlyContribution==0){
      setState(() {
        investedCapital="O capital investido e o aporte mensal não podem ser nulos simultaneamente!";
        result="";
        interest="";
      });
    }
    else if(period==0){
      setState(() {
        investedCapital="O período não pode ser nulo!";
        result="";
        interest="";
      });
    }
    else{
      double amount=initialCapital*pow((1+interestRate),period)+monthlyContribution*(pow((1+interestRate),period)-1)/interestRate;
      fa.setAmount(amount);
      fa.setInvestedCapital(initialCapital+monthlyContribution*period);
      fa.setInterest(fa.getAmount()-fa.getInvestedCapital());
      setState(() {
        result="Montante: R\$ ${fa.getAmount().toStringAsFixed(2)}";
        investedCapital="Capital Investido: R\$ ${fa.getInvestedCapital().toStringAsFixed(2)}";
        interest="Juros: R\$ ${fa.getInterest().toStringAsFixed(2)}";
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cálculo de Montante", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
        backgroundColor: Colors.yellow[700],
        centerTitle: true,
        shadowColor: Colors.black,
        elevation: 6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
        children: [
          const SizedBox(height: 20),
          TextField(
            controller: _initialCapitalController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
            ],
            decoration: InputDecoration(
              labelText: "Digite o capital inicial (R\$): ",
              hintText: "0.00",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                initialCapital = double.tryParse(value);
                fa.setInitialCapital(initialCapital ?? 0.0);
              });
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _monthlyContributionController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
            ],
            decoration: InputDecoration(
              labelText: "Digite o aporte mensal (R\$): ",
              hintText: "0.00",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                monthlyContribution = double.tryParse(value);
                fa.setMonthlyContribution(monthlyContribution ?? 0.0);
              });
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _interestRateController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
            ],
            decoration: InputDecoration(
              labelText: "Digite a taxa de juros (% am): ",
              hintText: "0.00",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                interestRate = double.tryParse(value);
                fa.setInterestRate(interestRate ?? 0.0);
              });
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _periodController,
            keyboardType: TextInputType.number, 
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, 
            ],
            decoration: const InputDecoration(
              labelText: "Digite o período (meses): ",
              hintText: "0",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                period = int.tryParse(value);
                fa.setPeriod(period ?? 0);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
              onPressed: (){
                _calculateAmount(fa.getInitialCapital(), fa.getMonthlyContribution(), fa.getInterestRate()/100, fa.getPeriod());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              child: Text("Calcular", style: GoogleFonts.urbanist(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)
              )
            )),
          ),
          const SizedBox(height: 20),
          Text(result, style: GoogleFonts.urbanist(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
          Text(investedCapital, style: GoogleFonts.urbanist(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          )),
          Text(interest, style: GoogleFonts.urbanist(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          )),
        ],
      )),
    );
  }
}