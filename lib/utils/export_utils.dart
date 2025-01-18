import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fake_wallet/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ExportUtils {

  Future<void> exportToXLSX(BuildContext context, String monthAndYear, List<ExpenseData> expenses) async {
    List<int>? fileBytes = await getSheet(context, monthAndYear, expenses);
    Directory directory = await saveFileTemporary(fileBytes);
    await Share.shareXFiles(
        [XFile("${directory.path}/temp-file.xlsx")]);
  }

  Future<Directory> saveFileTemporary(List<int>? fileBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    File("${directory.path}/temp-file.xlsx")
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
    return directory;
  }

  Future<List<int>?> getSheet(BuildContext context, String monthAndYear, List<ExpenseData> expenses) async {
    var excel = Excel.createExcel();

    Sheet sheetObject = excel[excel.getDefaultSheet()!];

    CellStyle cellStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      fontFamily: getFontFamily(FontFamily.Arial),
      fontSize: 12,
      numberFormat: const CustomDateTimeNumFormat(
          formatCode: 'dd/MM/yyyy'),
    );

    var cell = sheetObject.cell(CellIndex.indexByString('A1'));
    cell.value = TextCellValue(
        '${AppLocalizations.of(context)!.expense} - $monthAndYear');
    cell.cellStyle = cellStyle;

    excel.merge(
        excel.getDefaultSheet()!,
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
        CellIndex.indexByColumnRow(
            columnIndex: 3, rowIndex: 0));

    excel.appendRow(excel.getDefaultSheet()!, [
      TextCellValue(AppLocalizations.of(context)!.title),
      TextCellValue(AppLocalizations.of(context)!.expenseDate),
      TextCellValue(AppLocalizations.of(context)!.value),
      TextCellValue(AppLocalizations.of(context)!.category),
    ]);

    expenses.forEach((expense) {
      excel.appendRow(excel.getDefaultSheet()!, [
        TextCellValue(expense.title),
        TextCellValue(DateFormat('dd/MM/yyyy')
            .format(expense.expenseDate)),
        TextCellValue(NumberFormat.simpleCurrency(
            locale: Intl.systemLocale)
            .format(expense.value)),
        IntCellValue(expense.category)
      ]);
    });

    var status = await Permission.storage.status;
    if (status.isDenied) await Permission.storage.request();

    var fileBytes = excel.save();
    return fileBytes;
  }


}