import 'package:flutter/material.dart';
import 'package:kulyx/views/tab_bar.dart';

void main() {
  runApp(const Kulyx());
}

class Kulyx extends StatelessWidget {
  const Kulyx({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TabBarComponent(),
    );
  }
}