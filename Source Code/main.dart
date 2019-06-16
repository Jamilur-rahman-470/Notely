import 'package:flutter/material.dart';
import 'package:notely/pages/notely.dart';

void main() => runApp(Notely());


class Notely extends StatelessWidget {
  const Notely({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        accentColor: Colors.black
      ),
      home: Notes(),
    );
  }
}