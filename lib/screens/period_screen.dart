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
  bool isRateMonthly = true;
  bool isPeriodMonthly = true;
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
      int period;
      if(interestRate==0){
        period=((amount-initialCapital)/monthlyContribution).ceil();
      }
      else{
        double a = (amount*interestRate+monthlyContribution)/(initialCapital*interestRate+monthlyContribution);
        double b = interestRate+1;
        period = (log(a) / log(b)).ceil();
      }
      fa.setPeriod(period);
      fa.setInvestedCapital(initialCapital+monthlyContribution*period);
      fa.setInterest(fa.getAmount()-fa.getInvestedCapital());
      if(fa.getInterest()<0){
        fa.setInterest(0);
      }
      setState(() {
        if(fa.getPeriod()>=12){
          if(fa.getPeriod() % 12 ==0){
            if(fa.getPeriod() == 12){
              result="Período: ${(fa.getPeriod()/12).toStringAsFixed(0)} ano";
            }
            else{
              result="Período: ${(fa.getPeriod()/12).toStringAsFixed(0)} anos";
            }
          }
          else{
            if(fa.getPeriod()<24){
              if(fa.getPeriod()%12==1){
                result="Período: ${((fa.getPeriod()-fa.getPeriod()%12)/12).toStringAsFixed(0)} ano e ${fa.getPeriod()%12} mês";
              }
              else{
                result="Período: ${((fa.getPeriod()-fa.getPeriod()%12)/12).toStringAsFixed(0)} ano e ${fa.getPeriod()%12} meses";
              }
            }
            else{
              if(fa.getPeriod()%12==1){
                result="Período: ${((fa.getPeriod()-fa.getPeriod()%12)/12).toStringAsFixed(0)} anos e ${fa.getPeriod()%12} mês";
              }
              else{
                result="Período: ${((fa.getPeriod()-fa.getPeriod()%12)/12).toStringAsFixed(0)} anos e ${fa.getPeriod()%12} meses";
              }
            }
          }
        }
        else{
          if(fa.getPeriod()==1){
            result="Período: ${fa.getPeriod()} mês";
          }
          else{
            result="Período: ${fa.getPeriod()} meses";
          }
        }
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
              const SizedBox(height: 10),
              Center(
                child: Image.asset('assets/periodIcon.png', width: 150,),
              ),
              const SizedBox(height: 40),
              getTextField(1, _amountController, fa),
              const SizedBox(height: 30),
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                  onPressed: (){
                    FocusScope.of(context).unfocus();
                    _calculatePeriod(fa.getAmount(), fa.getInitialCapital(), fa.getMonthlyContribution(), fa.getInterestRate()/100);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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