import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/screens/database.dart';
import 'package:fake_wallet/screens/home.dart';
import 'package:fake_wallet/widgets/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final database = AppDatabase();
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Fake Wallet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
        useMaterial3: true,
      ),
      home: LoaderOverlay(
        overlayColor: Colors.blue.shade900,
        child: Db(
            appDatabase: database,
            child: Builder(
              builder: (BuildContext innerContext) {
                return Home(database: Db.of(context)?.appDatabase ?? database);
              },
            )),
      ),
    );
  }
}
