import 'package:flutter/material.dart';
import 'package:flutter_calculadora_juros_compostos/models/financial_application.dart';
import 'package:flutter_calculadora_juros_compostos/widgets/text_field_widget.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class PeriodScreen extends StatefulWidget{
  const PeriodScreen({super.key});
  @override
  _PeriodScreenState createState() => _PeriodScreenState();
}

class _PeriodScreenState extends State<PeriodScreen>{
  String result="", investedCapital="", interest="";
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _initialCapitalController = TextEditingController();
  final TextEditingController _monthlyContributionController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  FinancialApplication fa = FinancialApplication(initialCapital: 0, monthlyContribution: 0, interestRate: 0, period: 0, amount: 0, interest: 0, investedCapital: 0);
  double? amount, initialCapital, monthlyContribution, interestRate;
  @override
  void dispose() {
    _amountController.dispose();
    _initialCapitalController.dispose();
    _monthlyContributionController.dispose();
    _interestRateController.dispose();
    super.dispose();
  }
  void _calculatePeriod(double amount, double initialCapital, double monthlyContribution, double interestRate){
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
    else{
      double a = (amount*interestRate+monthlyContribution)/(initialCapital*interestRate+monthlyContribution);
      double b = interestRate+1;
      int period = (log(a) / log(b)).toInt();
      fa.setPeriod(period);
      fa.setInvestedCapital(initialCapital+monthlyContribution*period);
      fa.setInterest(fa.getAmount()-fa.getInvestedCapital());
      setState(() {
        result="Período: ${fa.getPeriod()} meses";
        investedCapital="Capital Investido: R\$ ${fa.getInvestedCapital().toStringAsFixed(2)}";
        interest="Juros: R\$ ${fa.getInterest().toStringAsFixed(2)}";
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cálculo de Período", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
        backgroundColor: Colors.blue,
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
            getTextField(3, _monthlyContributionController, fa),
            const SizedBox(height: 20),
            getTextField(4, _interestRateController, fa),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton(
                onPressed: (){
                  _calculatePeriod(fa.getAmount(), fa.getInitialCapital(), fa.getMonthlyContribution(), fa.getInterestRate()/100);
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