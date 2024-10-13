import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<StatefulWidget> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(icon: Icon(Icons.chevron_left,size: 35, color: Colors.blue.shade900), onPressed: () {  },),
        const Text('May/2024', style: TextStyle(
            fontWeight: FontWeight.bold,
          fontSize: 18
        ),),
        IconButton(icon: Icon(Icons.chevron_right,size: 35, color: Colors.blue.shade900), onPressed: () {  },),
      ],
    );
  }

}
