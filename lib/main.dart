import 'package:anonymous_send_wa/view/landing_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anonymous Message Sender',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const LandingPage(),
    );
  }
}
