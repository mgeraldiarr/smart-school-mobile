import 'package:flutter/material.dart';
// Import file jadwal_pelajaran.dart yang ada di folder page12
import 'package:smart_school_mobile/page12/jadwal_pelajaran.dart';

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
      // Panggil class JadwalPelajaranPage di sini
      home: const JadwalPelajaranPage(),
    );
  }
}