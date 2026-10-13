import 'package:flutter/material.dart';
// Import file nilai_siswa_page.dart dari folder page13
import 'package:smart_school_mobile/page13/nilai_siswa_page.dart';

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
      // Panggil class NilaiSiswaPage sebagai halaman utama
      home: const NilaiSiswaPage(),
    );
  }
}