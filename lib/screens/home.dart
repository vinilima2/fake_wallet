import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/models/expense_model.dart';
import 'package:fake_wallet/utils/database_utils.dart';
import 'package:fake_wallet/utils/export_utils.dart';
import 'package:fake_wallet/utils/date_utils.dart' as myDateUtils;
import 'package:fake_wallet/widgets/alert.dart';
import 'package:fake_wallet/widgets/chart.dart';
import 'package:fake_wallet/widgets/expense_form.dart';
import 'package:fake_wallet/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
  String monthAndYear = myDateUtils.DateUtils.now();
  int? selectedCategory;
  double totalValueExpenses = 0;

  late DatabaseUtils db;

  void insertExpense(ExpenseModel expenseModel) async {
    context.loaderOverlay.show();
    await db.insertExpense(expenseModel);
    if (mounted) {
      Navigator.of(context).pop();
      context.loaderOverlay.hide();
      Alert().showMessage(context, AppLocalizations.of(context)!.successSave,
          AlertType.SUCCESS);
    }
    db.listAllExpensesPerDate(monthAndYear).then((list) {
      setState(() {
        expenses = list;
      });
      calculateCharts();
    });
  }

  Future<void> calculateCharts() async {
    if (expenses.isEmpty) {
      setState(() {
        finalList = [];
        totalValueExpenses = 0;
      });
      return;
    }

    context.loaderOverlay.show();

    var total = expenses
        .map((expense) => expense.value)
        .reduce((current, preview) => (current) + (preview));

    setState(() {
      totalValueExpenses = double.parse(total.toStringAsFixed(2));
    });

    var list = categories
        .map((category) {
          var expensesPerCategory = expenses
              .where((expense) => expense.category == category.id)
              .toList();

          var totalValueExpensesPerCategory = expensesPerCategory.fold(
              0.0, (sum, expense) => sum + expense.value);

          var percentage =
              (totalValueExpensesPerCategory * 100) / (totalValueExpenses);

          return {
            'id': category.id,
            'description': category.description,
            'icon': category.icon,
            'percentage': double.parse(percentage.toStringAsFixed(2)),
            'color': category.color
          };
        })
        .where((item) => (item['percentage']! as double) > 0)
        .toList();

    setState(() {
      finalList = list;
    });

    context.loaderOverlay.hide();
  }

  void initHome() async {
    db = await DatabaseUtils.init(widget.database);
    db.listAllCategories(context).then((list) {
      setState(() {
        categories = list;
      });

      db.listAllExpensesPerDate(monthAndYear).then((list) {
        setState(() {
          expenses = list;
        });
        calculateCharts();
      });
    });
  }

  @override
  void initState() {
    initHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final Locale locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultColorScheme.onSurface,
        title: Text(
          'Fake Wallet',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: defaultColorScheme.surface),
        ),
        actions: [
          TextButton(
            key: const Key('call_add_expense'),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                      backgroundColor: defaultColorScheme.onSecondary,
                      title: Text(AppLocalizations.of(context)!.newExpense),
                      titleTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: defaultColorScheme.onSurface,
                          fontSize: 20),
                      content: ExpenseForm(
                          key: const Key('expense_form'),
                          onSave: (expense) {
                            insertExpense(expense);
                          },
                          categories: categories),
                    );
                  });
            },
            child: Icon(
              Icons.add,
              color: defaultColorScheme.surface,
              size: 30,
            ),
          ),
          totalValueExpenses > 0
              ? TextButton(
                  onPressed: () async {
                    context.loaderOverlay.show();
                    await ExportUtils().exportToXLSX(context, expenses);
                    if (mounted) {
                      context.loaderOverlay.hide();
                    }
                  },
                  child: Icon(
                    Icons.share,
                    size: 22,
                    color: defaultColorScheme.surface,
                  ))
              : Container()
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Header(callback: (date) {
            setState(() {
              monthAndYear = date;
            });
            db.listAllExpensesPerDate(date).then((list) {
              setState(() {
                expenses = list;
              });
              calculateCharts();
            });
          }),
          SizedBox(
            height: 250,
            child: Chart(
              expenses: finalList,
              onChangeCategory: (category) {
                if (selectedCategory == category) {
                  setState(() {
                    selectedCategory = null;
                  });
                  db.listAllExpensesPerDate(monthAndYear).then((list) {
                    setState(() {
                      expenses = list;
                    });
                    calculateCharts();
                  });
                } else {
                  setState(() {
                    selectedCategory = category;
                  });

                  db
                      .listAllExpensesPerCategoryAndDate(category, monthAndYear)
                      .then((list) {
                    setState(() {
                      expenses = list;
                    });
                    calculateCharts();
                  });
                }
              },
            ),
          ),
          const Divider(height: 5),
          Container(
              padding: const EdgeInsets.all(5),
              height: 500,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCategory != null
                        ? categories
                            .where((c) => c.id == selectedCategory!)
                            .map((c) => c.description)
                            .first
                        : (expenses.isNotEmpty)
                            ? AppLocalizations.of(context)!.expense
                            : AppLocalizations.of(context)!
                                .emptyExpensesMessage,
                    style: TextStyle(
                        color: defaultColorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: expenses.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int indice) {
                          var expense = expenses[indice];
                          return Dismissible(
                            key: Key(expense.id.toString()),
                            onDismissed: (DismissDirection direction) async {
                              Alert().showMessage(
                                  context,
                                  AppLocalizations.of(context)!.successDelete,
                                  AlertType.SUCCESS);
                              setState(() {
                                expenses = expenses
                                    .where((e) => e.id != expense.id)
                                    .toList();
                              });
                              await calculateCharts();
                            },
                            direction: DismissDirection.startToEnd,
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                  context: context,
                                  builder: (builder) {
                                    return AlertDialog(
                                      title: Text(AppLocalizations.of(context)!
                                          .attention),
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .removeQuestion),
                                      actions: <Widget>[
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          child: Text(
                                              AppLocalizations.of(context)!.no),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .yes),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                            widget.database
                                                .delete(widget.database.expense)
                                                .deleteReturning(expense);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: expense.fixed
                                      ? defaultColorScheme.onTertiary
                                      : defaultColorScheme.onSecondary,
                                  border: Border(
                                      left: BorderSide(
                                          color: expense.fixed
                                              ? defaultColorScheme.tertiary
                                              : defaultColorScheme.secondary,
                                          width: 5)),
                                ),
                                padding: const EdgeInsets.all(7),
                                margin:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(expense.expenseDate),
                                          style: TextStyle(
                                              color: expense.fixed
                                                  ? defaultColorScheme.tertiary
                                                  : defaultColorScheme
                                                      .secondary,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Icon(Icons.chevron_right,
                                            size: 15,
                                            color: expense.fixed
                                                ? defaultColorScheme.tertiary
                                                : defaultColorScheme.secondary)
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "${expense.title} - ${expense.name}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: expense.fixed
                                                    ? defaultColorScheme
                                                        .tertiary
                                                    : defaultColorScheme
                                                        .secondary,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Text(
                                          NumberFormat.simpleCurrency(
                                                  locale: locale.languageCode)
                                              .format(expense.value),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: expense.fixed
                                                  ? defaultColorScheme.tertiary
                                                  : defaultColorScheme
                                                      .secondary),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          );
                        }),
                  ),
                ],
              ))
        ],
      )),
      resizeToAvoidBottomInset: true,
      extendBody: true,
      bottomNavigationBar: Container(
        color: defaultColorScheme.onSurface,
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.total,
                style: TextStyle(
                    color: defaultColorScheme.surface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text(
              NumberFormat.simpleCurrency(locale: locale.languageCode)
                  .format(totalValueExpenses),
              style: TextStyle(
                  color: defaultColorScheme.surface,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
