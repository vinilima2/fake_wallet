import 'package:fake_wallet/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fake Wallet',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent.shade700),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue.shade900,
            title: const Text(
              'Fake Wallet',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
          body: const TabBarView(
            children: [
              Home(),
              Home(),
              Home(),
            ],
          ),
          bottomNavigationBar: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.abc_outlined)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
        ),
      ),
    );
  }
}
