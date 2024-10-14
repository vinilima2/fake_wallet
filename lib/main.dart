import 'package:fake_wallet/database.dart';
import 'package:fake_wallet/screens/database.dart';
import 'package:fake_wallet/screens/home.dart';
import 'package:fake_wallet/widgets/db.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final database = AppDatabase();
    return MaterialApp(
        title: 'Fake Wallet',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
          useMaterial3: true,
        ),
        home: Db(
            appDatabase: database,
            child: Builder(
              builder: (BuildContext innerContext) {
                return DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.blue.shade900,
                      title: const Text(
                        'Fake Wallet',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        Home( database: Db.of(context)?.appDatabase ?? database ),
                        Database( database: Db.of(context)?.appDatabase ?? database),
                        Container(),
                      ],
                    ),
                    bottomNavigationBar: const TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.home)),
                        Tab(icon: Icon(Icons.data_usage_rounded)),
                        Tab(icon: Icon(Icons.settings)),
                      ],
                    ),
                  ),
                );
              },
            )));
  }
}
