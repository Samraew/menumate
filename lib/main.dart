import 'package:flutter/material.dart';
import 'features/home/home_page.dart';

void main() {
  runApp(const MenuMateApp());
}

class MenuMateApp extends StatelessWidget {
  const MenuMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MenuMate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
