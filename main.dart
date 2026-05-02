import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() => runApp(const SadakatApp());

class SadakatApp extends StatelessWidget {
  const SadakatApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown, useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
