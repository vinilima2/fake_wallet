class Expensive {
  String _title = '';
  String _name = '';
  String _expenseDate = '';
  String _value = '';
  bool _fixed = false;
  int _category = 0;

  int get numberMonthsOfFixedExpense => _numberMonthsOfFixedExpense;

  set numberMonthsOfFixedExpense(int value) {
    _numberMonthsOfFixedExpense = value;
  }

  int _numberMonthsOfFixedExpense = 1;

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get name => _name;

  bool get fixed => _fixed;

  set fixed(bool value) {
    _fixed = value;
  }

  String get value => _value;

  set value(String value) {
    _value = value;
  }

  String get expenseDate => _expenseDate;

  set expenseDate(String value) {
    _expenseDate = value;
  }

  set name(String value) {
    _name = value;
  }

  int get category => _category;

  set category(int value) {
    _category = value;
  }
}
