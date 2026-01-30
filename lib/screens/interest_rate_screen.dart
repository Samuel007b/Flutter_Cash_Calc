import 'package:flutter/material.dart';
import 'package:flutter_calculadora_juros_compostos/models/financial_application.dart';
import 'package:flutter_calculadora_juros_compostos/widgets/text_field_widget.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

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
  bool isRateMonthly = true;
  bool isPeriodMonthly = true;
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
      num annualRate = (pow(1+i, 12)-1)*100;
      fa.setInterestRate(i*100);
      fa.setInvestedCapital(initialCapital+monthlyContribution*period);
      fa.setInterest(fa.getAmount()-fa.getInvestedCapital());
      if(fa.getInterest()<0){
        fa.setInterest(0);
      }
      setState(() {
        result="Rentabilidade: ${fa.getInterestRate().toStringAsFixed(2).replaceAll('.', ',')}% a.m.\n(${annualRate.toStringAsFixed(2).replaceAll('.', ',')}% a.a.)";
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
          title: const Text("Cálculo de Rentabilidade", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
          backgroundColor: Colors.yellow[600],
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
                child: Image.asset('assets/rateIcon.png', width: 150,),
              ),
              const SizedBox(height: 40),
              getTextField(1, _amountController, fa),
              const SizedBox(height: 30),
              getTextField(2, _initialCapitalController, fa),
              const SizedBox(height: 30),
              getTextField(3, _monthlyContributionController, fa),
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
                    _calculateInterestRate(fa.getAmount(), fa.getInitialCapital(), fa.getMonthlyContribution(), fa.getPeriod());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[600],
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