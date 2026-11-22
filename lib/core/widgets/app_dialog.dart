import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

// Gaya bersama untuk dialog berisi form (edit profil, ubah kata sandi, dst.)
// supaya semua dialog di aplikasi terlihat seragam.

/// Dekorasi kolom isian di dalam dialog.
InputDecoration dialogFieldDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.poppins(fontSize: 12.5),
    prefixIcon: Icon(icon),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );
}

/// Judul dialog.
Widget dialogTitle(String text) => Text(
  text,
  style: GoogleFonts.poppins(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  ),
);

/// Tombol "Batal" dan "Simpan".
List<Widget> dialogActions(BuildContext context, VoidCallback onSave) => [
  TextButton(
    onPressed: () => Navigator.of(context).pop(),
    child: Text(
      'Batal',
      style: GoogleFonts.poppins(color: AppColors.textMuted),
    ),
  ),
  ElevatedButton(
    onPressed: onSave,
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.brandBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    child: Text(
      'Simpan',
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  ),
];
