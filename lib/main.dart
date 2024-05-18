import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const KvizzApp());
}

class KvizzApp extends StatelessWidget {
  const KvizzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KvizzR',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
