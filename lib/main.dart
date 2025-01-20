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

  static final lightColorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Colors.blue,
      onPrimary: Colors.blue,
      secondary: Colors.blue,
      onSecondary: Colors.blue,
      error: Colors.blue,
      onError: Colors.blue,
      surface: Colors.lightBlue.shade50,
      onSurface: Colors.blue);

  static final darkColorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.blue.shade900,
      onPrimary: Colors.blue.shade900,
      secondary: Colors.blue.shade900,
      onSecondary: Colors.blue.shade900,
      error: Colors.blue.shade900,
      onError: Colors.blue.shade900,
      surface: Colors.blueGrey.shade900,
      onSurface: Colors.blue.shade900);

  final ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    final database = AppDatabase();
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Fake Wallet',
      themeMode: themeMode,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: LoaderOverlay(
        overlayColor: Colors.grey,
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
