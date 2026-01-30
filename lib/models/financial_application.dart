class FinancialApplication{
  double initialCapital;
  double monthlyContribution;
  double interestRate;
  int period;
  double amount;
  double interest;
  double investedCapital;

  FinancialApplication({
    required this.initialCapital,
    required this.monthlyContribution,
    required this.interestRate,
    required this.period,
    required this.amount,
    required this.interest,
    required this.investedCapital,
  });

  double getInitialCapital(){
    return initialCapital;
  }
  void setInitialCapital(double initialCapital){
    this.initialCapital=initialCapital;
  }
  double getMonthlyContribution(){
    return monthlyContribution;
  }
  void setMonthlyContribution(double monthlyContribution){
    this.monthlyContribution=monthlyContribution;
  }
  double getInterestRate(){
    return interestRate;
  }
  void setInterestRate(double interestRate){
    this.interestRate=interestRate;
  }
  int getPeriod(){
    return period;
  }
  void setPeriod(int period){
    this.period=period;
  }
  double getAmount(){
    return amount;
  }
  void setAmount(double amount){
    this.amount=amount;
  }
  double getInterest(){
    return interest;
  }
  void setInterest(double interest){
    this.interest=interest;
  }
  double getInvestedCapital(){
    return investedCapital;
  }
  void setInvestedCapital(double investedCapital){
    this.investedCapital=investedCapital;
  }
  
}
