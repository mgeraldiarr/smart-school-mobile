import 'package:flutter/material.dart';
// Ganti import ke folder page11
import 'package:smart_school_mobile/page11/daftar_kehadiran.dart';

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
      // Panggil class DaftarKehadiranPage dari page11 di sini
      home: const DaftarKehadiranPage(),
    );
  }
}