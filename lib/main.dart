import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/screens/home.dart';
import 'package:fake_wallet/utils/theme_utils.dart';
import 'package:fake_wallet/widgets/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    final database = AppDatabase();
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Fake Wallet',
      themeMode: themeMode,
      theme: ThemeData(useMaterial3: true, colorScheme: ThemeUtils.lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: ThemeUtils.darkColorScheme),
      home: LoaderOverlay(
        overlayColor: const Color.fromARGB(68, 187, 187, 184),
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
