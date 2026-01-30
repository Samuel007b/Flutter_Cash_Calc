import 'package:flutter/material.dart';
import 'package:flutter_calculadora_juros_compostos/models/financial_application.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_calculadora_juros_compostos/widgets/text_field_widget.dart';

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
  bool isRateMonthly = true;
  bool isPeriodMonthly = true;
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
      double amount;
      if(interestRate==0){
        amount=initialCapital+monthlyContribution*period;
      }
      else{
        amount=initialCapital*pow((1+interestRate),period)+monthlyContribution*(pow((1+interestRate),period)-1)/interestRate;
      }
      fa.setAmount(amount);
      fa.setInvestedCapital(initialCapital+monthlyContribution*period);
      fa.setInterest(fa.getAmount()-fa.getInvestedCapital());
      if(fa.getInterest()<0){
        fa.setInterest(0);
      }
      setState(() {
        result="Montante: R\$ ${fa.getAmount().toStringAsFixed(2).replaceAll('.', ',')}";
        investedCapital="Capital Investido: R\$ ${fa.getInvestedCapital().toStringAsFixed(2).replaceAll('.', ',')}";
        interest="Juros: R\$ ${fa.getInterest().toStringAsFixed(2).replaceAll('.', ',')}";
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
      return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cálculo de Montante", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
          backgroundColor: Colors.red,
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
              const SizedBox(height: 10),
              Center(
                child: Image.asset('assets/amountIcon.png', width: 150,),
              ),
              const SizedBox(height: 40),
              getTextField(2, _initialCapitalController, fa),
              const SizedBox(height: 30),
              getTextField(3, _monthlyContributionController, fa),
              const SizedBox(height: 30),
              getTextField(4, _interestRateController, fa,
                isRateMonthly: isRateMonthly,
                onToggleRate: () {
                  setState(() {
                    isRateMonthly = !isRateMonthly;
                  });
                  final double? value = double.tryParse(_interestRateController.text.replaceAll(',', '.'));
                  if (value != null) {
                    if (isRateMonthly) {
                      fa.setInterestRate(value);
                    } else {
                      final double monthly = (pow(1 + value / 100, 1 / 12) - 1) * 100;
                      fa.setInterestRate(monthly);
                    }
                  }
                },
              ),
              const SizedBox(height: 30),
              getTextField(5, _periodController, fa,
                isPeriodMonthly: isPeriodMonthly,
                onTogglePeriod: () {
                  setState(() {
                    isPeriodMonthly = !isPeriodMonthly;
                  });
                  final int? value = int.tryParse(_periodController.text);
                  if (value != null) {
                    fa.setPeriod(isPeriodMonthly ? value : value * 12);
                  }
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                  onPressed: (){
                    FocusScope.of(context).unfocus();
                    _calculateAmount(fa.getInitialCapital(), fa.getMonthlyContribution(), fa.getInterestRate()/100, fa.getPeriod());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
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
              Text(result, textAlign: TextAlign.center, style: GoogleFonts.urbanist(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
              const SizedBox(height: 10),
              Text(investedCapital, textAlign: TextAlign.center, style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              )),
              const SizedBox(height: 5),
              Text(interest, textAlign: TextAlign.center, style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              )),
            ],
          )),
        ),
      ),
    );
  }
}