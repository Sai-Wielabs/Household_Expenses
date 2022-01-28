class UserModel {
  final String userName;
  final double monthlyLimit;
  final String gender;
  final String theme;
  final List months;
  final Map monthlyBudgets;
  UserModel(
      {this.userName,
      this.monthlyBudgets,
      this.gender,
      this.monthlyLimit,
      this.months,
      this.theme});
}

class FieldModel {
  final double fieldTotal;
  final double amount;
  final String datecreated;
  final String fieldName;
  final List log;
  FieldModel({
    this.fieldName,
    this.fieldTotal,
    this.datecreated,
    this.amount,
    this.log,
  });
}
