import 'package:flutter/material.dart';
import 'package:scanner_kasir/screens/scanner_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasir Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScannerScreen(),
    );
  }
}
