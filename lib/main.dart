import 'package:flutter/material.dart';
// Import file absensi_manual.dart yang ada di folder page10
import 'package:smart_school_mobile/page10/absensi_manual.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart School Mobile',
      // Panggil class AbsensiManualPage di sini
      home: const AbsensiManualPage(),
    );
  }
}