import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DateInputFormatter extends TextInputFormatter {
  
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    DateTime value = DateTime.parse(newValue.text);

    final formatter = DateFormat.d("pt_Br");

    String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
