import 'package:fake_wallet/database.dart';
import 'package:flutter/material.dart';

class Db extends InheritedWidget {
   const Db({
    super.key,
    required this.appDatabase,
    required super.child,
  });

  final AppDatabase appDatabase;

  static Db? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Db>();
  }

  static Db? of(BuildContext context) {
    final Db? result = maybeOf(context);
    return result;
  }

  @override
  bool updateShouldNotify(Db oldWidget) => appDatabase != oldWidget.appDatabase;
}