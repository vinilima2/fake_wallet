import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/screens/home.dart';
import 'package:fake_wallet/widgets/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() {
  Future<Widget> getDefaultWidget() async {
    final database = AppDatabase();
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: LoaderOverlay(
        overlayColor: const Color.fromARGB(68, 187, 187, 184),
        child: Db(
            appDatabase: database,
            child: Builder(
              builder: (BuildContext innerContext) {
                return Home(database: database);
              },
            )),
      ),
    );
  }

  testWidgets('Confirm loaded application', (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(await getDefaultWidget());
    await widgetTester.pumpAndSettle();
    final finder = find.text('Fake Wallet');
    expect(finder, findsOneWidget);
  });

  testWidgets('Open Expense Modal', (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(await getDefaultWidget());
    Finder modalFinder = find.byKey(const Key('expense_form'));
    expect(modalFinder, findsNothing);
    final buttonNewExpense = find.byKey(const Key('call_add_expense'));
    await widgetTester.tap(buttonNewExpense);
    await widgetTester.pumpAndSettle();
    modalFinder = find.byKey(const Key('expense_form'));
    expect(modalFinder, findsOneWidget);
  });

  testWidgets('Create a new expense', (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(await getDefaultWidget());
    final buttonNewExpense = find.byKey(const Key('call_add_expense'));
    await widgetTester.tap(buttonNewExpense);
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(
        find.byKey(const Key('title')), 'Flutter title text');
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(
        find.byKey(const Key('name')), 'Flutter name text');
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(find.byKey(const Key('value')), '250');
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(
        find.byKey(const Key('expenseDate')), '01/01/1999');
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(find.byKey(const Key('category')));
    await widgetTester.pumpAndSettle();
    // await widgetTester.tap(find.textContaining('Ener').first); Think how test it
    // await widgetTester.pumpAndSettle();
    await widgetTester.tap(find.byKey(const Key('saveButton')));
  });
}
