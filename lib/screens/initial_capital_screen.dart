import 'package:flutter/material.dart';
import 'package:flutter_calculadora_juros_compostos/models/financial_application.dart';
import 'package:flutter_calculadora_juros_compostos/widgets/text_field_widget.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class InitialCapitalScreen extends StatefulWidget{
  const InitialCapitalScreen({super.key});
  @override
  _InitialCapitalScreenState createState() => _InitialCapitalScreenState();
}

class _InitialCapitalScreenState extends State<InitialCapitalScreen>{
  String result="", investedCapital="", interest="";
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _monthlyContributionController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();
  FinancialApplication fa = FinancialApplication(initialCapital: 0, monthlyContribution: 0, interestRate: 0, period: 0, amount: 0, interest: 0, investedCapital: 0);
  double? amount, monthlyContribution, interestRate;
  int? period;
  @override
  void dispose() {
    _amountController.dispose();
    _monthlyContributionController.dispose();
    _interestRateController.dispose();
    _periodController.dispose();
    super.dispose();
  }
  void _calculateInitialCapital(double amount, double monthlyContribution, double interestRate, int period){
    if(amount==0){
      setState(() {
        investedCapital = "O montante desejado não pode ser nulo!";
        result="";
        interest="";
      });
    }
    else if(monthlyContribution==0 && interestRate==0){
      setState(() {
        investedCapital="O aporte mensal e a taxa de juros não podem ser nulos simultaneamente!";
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
      double initialCapital=(amount-monthlyContribution*(pow((1+interestRate),period)-1)/interestRate)/pow((1+interestRate),period);
      fa.setInitialCapital(initialCapital);
      fa.setInvestedCapital(initialCapital+monthlyContribution*period);
      fa.setInterest(fa.getAmount()-fa.getInvestedCapital());
      setState(() {
        result="Capital Inicial: R\$ ${fa.getInitialCapital().toStringAsFixed(2)}";
        investedCapital="Capital Investido: R\$ ${fa.getInvestedCapital().toStringAsFixed(2)}";
        interest="Juros: R\$ ${fa.getInterest().toStringAsFixed(2)}";
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cálculo de Capital Inicial", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
        backgroundColor: Colors.orange,
        centerTitle: true,
        shadowColor: Colors.black,
        elevation: 6,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
          children: [
            const SizedBox(height: 20),
            getTextField(1, _amountController, fa),
            const SizedBox(height: 20),
            getTextField(3, _monthlyContributionController, fa),
            const SizedBox(height: 20),
            getTextField(4, _interestRateController, fa),
            const SizedBox(height: 20),
            getTextField(5, _periodController, fa),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton(
                onPressed: (){
                  _calculateInitialCapital(fa.getAmount(), fa.getMonthlyContribution(), fa.getInterestRate()/100, fa.getPeriod());
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
      ),
    );
  }
}