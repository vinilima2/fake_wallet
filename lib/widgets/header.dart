import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  final Function(String) callback;
  const Header({super.key, required this.callback});

  @override
  State<StatefulWidget> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  DateTime data = DateTime.now();

  void addOrSubstractMonth({bool add = true}) {
    setState(() {
      data = data.add(Duration(days: add ? 30 : -30));
    });
    widget.callback(literal());
  }

  String literal() {
    return "${data.month.toString().padLeft(2, '0')}/${data.year.toString()}";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left, size: 35, color: Colors.blue.shade900),
          onPressed: () => addOrSubstractMonth(add: false),
        ),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.blue.shade900,
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          child: Text(
            literal(),
            style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white ),
          ),
        ),
        IconButton(
          icon:
              Icon(Icons.chevron_right, size: 35, color: Colors.blue.shade900),
          onPressed: () => addOrSubstractMonth(),
        ),
      ],
    );
  }
}
