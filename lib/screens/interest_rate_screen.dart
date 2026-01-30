import 'package:flutter/material.dart';
import 'package:flutter_calculadora_juros_compostos/models/financial_application.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class InterestRateScreen extends StatefulWidget{
  const InterestRateScreen({super.key});
  @override
  _InterestRateScreenState createState() => _InterestRateScreenState();
}

class _InterestRateScreenState extends State<InterestRateScreen>{
  String result="", investedCapital="", interest="";
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _initialCapitalController = TextEditingController();
  final TextEditingController _monthlyContributionController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();
  FinancialApplication fa = FinancialApplication(initialCapital: 0, monthlyContribution: 0, interestRate: 0, period: 0, amount: 0, interest: 0, investedCapital: 0);
  double? amount, initialCapital, monthlyContribution;
  int? period;
  @override
  void dispose() {
    _amountController.dispose();
    _initialCapitalController.dispose();
    _monthlyContributionController.dispose();
    _periodController.dispose();
    super.dispose();
  }
  void _calculateInterestRate(double amount, double initialCapital, double monthlyContribution, int period){
    if(amount==0){
      setState(() {
        investedCapital = "O montante desejado não pode ser nulo!";
        result="";
        interest="";
      });
    }
    else if(initialCapital==0 && monthlyContribution==0){
      setState(() {
        investedCapital = "O capital inicial e o aporte mensal não podem ser nulos simultaneamente!";
        result="";
        interest="";
      });
    }
    else if(period==0){
      setState(() {
        investedCapital = "O período não pode ser nulo!";
        result="";
        interest="";
      });
    }
    else{
      double i=0.01;
      double erro=1e-6;
      for (int iter = 0; iter < 1000000; iter++) {
        double f = initialCapital*pow(1+i,period)+monthlyContribution*((pow(1+i,period)-1)/i)-amount;
        double f1 = initialCapital*period*pow(1+i,period-1)+monthlyContribution*((i*period*pow(1+i,period-1)-((pow(1+i,period)-1)))/(i*i));
        double novoI = i-f/f1;
        if((novoI-i).abs()<erro){
          i = novoI;
          break;
        }
        i = novoI;
      }
      fa.setInterestRate(i*100);
      fa.setInvestedCapital(initialCapital+monthlyContribution*period);
      fa.setInterest(fa.getAmount()-fa.getInvestedCapital());
      setState(() {
        result="Rentabilidade: R\$ ${fa.getInterestRate().toStringAsFixed(2)}% ao mês";
        investedCapital="Capital Investido: R\$ ${fa.getInvestedCapital().toStringAsFixed(2)}";
        interest="Juros: R\$ ${fa.getInterest().toStringAsFixed(2)}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cálculo de Rentabilidade", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
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
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
            ],
            decoration: InputDecoration(
              labelText: "Digite o montante desejado (R\$): ",
              hintText: "0.00",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                amount = double.tryParse(value);
                fa.setAmount(amount ?? 0.0);
              });
            },
          ),
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
                _calculateInterestRate(fa.getAmount(), fa.getInitialCapital(), fa.getMonthlyContribution(), fa.getPeriod());
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