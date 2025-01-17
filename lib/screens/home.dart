import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:excel/excel.dart';
import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/models/expensive.dart';
import 'package:fake_wallet/widgets/chart.dart';
import 'package:fake_wallet/widgets/expensive_form.dart';
import 'package:fake_wallet/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fake_wallet/utils/date_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  final AppDatabase database;
  const Home({super.key, required this.database});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int touchedIndex = 0;

  List<ExpenseData> expenses = [];
  List<CategoryData> categories = [];
  List<Map<String, dynamic>> finalList = [];
  String monthAndYear = DateUtil.now();
  double totalValueExpenses = 0;

  Future<void> listAllExpenses(String? date) async {
    List<String> splitDate = (date ?? monthAndYear).split('/');
    (widget.database.select(widget.database.expense)
          ..where((tbl) {
            return tbl.expenseDate.month.equals(int.parse(splitDate[0])) &
                tbl.expenseDate.year.equals(int.parse(splitDate[1]));
          }))
        .watch()
        .listen((list) {
      setState(() {
        expenses = list;
      });
      calculateCharts();
    }, onDone: () {
      reassemble();
    });
  }

  Future<void> listAllCategories() async {
    var list = await widget.database.select(widget.database.category).get();
    setState(() {
      categories = list;
    });
  }

  void insertExpense(Expensive expensive) async {
    await widget.database.into(widget.database.expense).insert(
        ExpenseCompanion.insert(
            title: expensive.title,
            name: expensive.name,
            value: double.parse(expensive.value
                .replaceAll('.', '')
                .replaceFirst(',', '.')
                .replaceAll(RegExp(r"[^\d.]+"), '')),
            fixed: expensive.fixed,
            createdAt: DateTime.now(),
            expenseDate: DateFormat('dd/MM/yyyy').parse(expensive.expenseDate),
            category: expensive.category));

    if (expensive.fixed) {
      insertFixedExpense(expensive);
    }

    Navigator.of(context).pop();
    listAllExpenses(null);
  }

  void insertFixedExpense(Expensive expensive) async {
    DateTime actualDateTime =
        DateFormat('dd/MM/yyyy').parse(expensive.expenseDate);
    for (int i = 1; i < 7; i++) {
      await widget.database.into(widget.database.expense).insert(
          ExpenseCompanion.insert(
              title: expensive.title,
              name: expensive.name,
              value: double.parse(expensive.value
                  .replaceAll('.', '')
                  .replaceFirst(',', '.')
                  .replaceAll(RegExp(r"[^\d.]+"), '')),
              fixed: expensive.fixed,
              createdAt: DateTime.now(),
              expenseDate: actualDateTime.copyWith(
                  day: 1, month: actualDateTime.month + i),
              category: expensive.category));
    }
  }

  void calculateCharts() {
    if (expenses.isEmpty) {
      setState(() {
        finalList = [];
        totalValueExpenses = 0;
      });
      return;
    }

    var total = expenses
        .map((expense) => expense.value)
        .reduce((current, preview) => (current) + (preview));

    setState(() {
      totalValueExpenses = double.parse(total.toStringAsFixed(2));
    });

    var list = categories.map((category) {
      var expensesPerCategory =
          expenses.where((expense) => expense.category == category.id).toList();

      var totalValueExpensesPerCategory = expensesPerCategory.isNotEmpty
          ? expensesPerCategory
              .map((expense) => expense.value)
              .reduce((current, preview) => (current) + (preview))
          : 0;

      var percentage =
          (totalValueExpensesPerCategory * 100) / (totalValueExpenses);

      return {
        'id': category.id,
        'description': category.description,
        'icon': category.icon,
        'percentage': double.parse(percentage.toStringAsFixed(2))
      };
    }).toList();

    setState(() {
      finalList = list;
    });
  }

  @override
  void initState() {
    listAllCategories().then((c) => listAllExpenses(null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text(
          'Fake Wallet',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.newExpense),
                      content: ExpensiveForm(
                          onSave: (ex) {
                            insertExpense(ex);
                          },
                          categories: categories),
                    );
                  });
            },
            // backgroundColor: Colors.redAccent,
            child: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 30,
            ),
          ),
          totalValueExpenses > 0
              ? TextButton(
                  onPressed: () async {
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
                    final directory = await getApplicationDocumentsDirectory();
                    File("${directory.path}/temp-file.xlsx")
                      ..createSync(recursive: true)
                      ..writeAsBytesSync(fileBytes!);
                    await Share.shareXFiles(
                        [XFile("${directory.path}/temp-file.xlsx")]);
                  },
                  child: const Icon(
                    Icons.share,
                    size: 22,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ))
              : Container()
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Header(callback: (p0) {
            listAllExpenses(p0);
          }),
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 4,
            child: Chart(
              expenses: finalList,
            ),
          ),
          const Divider(height: 5),
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 2,
            child: ListView.builder(
                itemCount: expenses.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int indice) {
                  var expense = expenses[indice];

                  return Dismissible(
                    onResize: () {
                      widget.database
                          .delete(widget.database.expense)
                          .deleteReturning(expense);
                    },
                    direction: DismissDirection.startToEnd,
                    confirmDismiss: (direction) async {
                      return await showDialog(
                          context: context,
                          builder: (builder) {
                            return AlertDialog(
                              title:
                                  Text(AppLocalizations.of(context)!.attention),
                              content: Text(
                                  AppLocalizations.of(context)!.removeQuestion),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: Text(AppLocalizations.of(context)!.no),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child:
                                      Text(AppLocalizations.of(context)!.yes),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    key: Key(expense.name),
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(248, 242, 252, 255),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        padding: const EdgeInsets.all(7),
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(expense.expenseDate),
                                  style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(Icons.chevron_right,
                                    size: 15, color: Colors.blue.shade900)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    "${expense.title} - ${expense.name}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Text(
                                  NumberFormat.simpleCurrency(
                                          locale: Intl.systemLocale)
                                      .format(expense.value),
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900),
                                ),
                              ],
                            ),
                          ],
                        )),
                  );
                }),
          ),
          Container(
            color: Colors.blue.shade900,
            padding: EdgeInsets.all(3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.total,
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                Text(
                  NumberFormat.simpleCurrency(locale: Intl.systemLocale)
                      .format(totalValueExpenses),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
