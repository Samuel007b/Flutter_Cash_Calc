import 'package:flutter/material.dart';
import 'package:flutter_calculadora_juros_compostos/models/financial_application.dart';
import 'package:flutter_calculadora_juros_compostos/widgets/text_field_widget.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class MonthlyContributionScreen extends StatefulWidget{
  const MonthlyContributionScreen({super.key});
  @override
  _MonthlyContributionScreenState createState() => _MonthlyContributionScreenState();
}

class _MonthlyContributionScreenState extends State<MonthlyContributionScreen>{
  String result="", investedCapital="", interest="";
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _initialCapitalController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();
  FinancialApplication fa = FinancialApplication(initialCapital: 0, monthlyContribution: 0, interestRate: 0, period: 0, amount: 0, interest: 0, investedCapital: 0);
  double? amount, initialCapital, interestRate;
  int? period;
  @override
  void dispose() {
    _amountController.dispose();
    _initialCapitalController.dispose();
    _interestRateController.dispose();
    _periodController.dispose();
    super.dispose();
  }
  void _calculateMonthlyContribution(double amount, double initialCapital, double interestRate, int period){
    if(amount==0){
      setState(() {
        investedCapital = "O montante desejado não pode ser nulo!";
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
      double monthlyContribution=(interestRate*(amount-initialCapital*pow((1+interestRate),period)))/(pow((1+interestRate),period)-1);
      fa.setMonthlyContribution(monthlyContribution);
      fa.setInvestedCapital(initialCapital+monthlyContribution*period);
      fa.setInterest(fa.getAmount()-fa.getInvestedCapital());
      setState(() {
        result="Aporte Mensal: R\$ ${fa.getMonthlyContribution().toStringAsFixed(2)}";
        investedCapital="Capital Investido: R\$ ${fa.getInvestedCapital().toStringAsFixed(2)}";
        interest="Juros: R\$ ${fa.getInterest().toStringAsFixed(2)}";
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cálculo de Aporte Mensal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
        backgroundColor: Colors.green,
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
            getTextField(2, _initialCapitalController, fa),
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
                  _calculateMonthlyContribution(fa.getAmount(), fa.getInitialCapital(), fa.getInterestRate()/100, fa.getPeriod());
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