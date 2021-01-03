import 'package:cadastro/pages/lista.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaxiGestao());
}

class MaxiGestao extends StatefulWidget {
  @override
  _MaxiGestaoState createState() => _MaxiGestaoState();
}

class _MaxiGestaoState extends State<MaxiGestao> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaxiGestão',
      theme: ThemeData(
        primaryColor: Colors.red[900],
      ),
      home: ListUsersPage(),
    );
  }
}
