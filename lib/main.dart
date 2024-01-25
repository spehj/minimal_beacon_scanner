import 'package:flutter/material.dart';
import 'package:simple_estibeacon_scanner/scan_beacons_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beacon Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF102A43), // Deep blue color for AppBar
          secondary: Color(0xFF68B2A0), // Teal color for Floating Action Button
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF102A43), // Deep blue color for AppBar
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF68B2A0), // Teal color for Floating Action Button
        ),
      ),
      home: const ScanBeaconsScreen(),
    );
  }
}
