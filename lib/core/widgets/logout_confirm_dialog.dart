import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

/// Dialog "Keluar dari akun?" yang dipakai profil guru dan wali murid.
/// Mengembalikan true hanya bila pengguna menekan "Keluar".
Future<bool> showLogoutConfirmDialog(
  BuildContext context, {
  String message = 'Anda perlu masuk kembali untuk menggunakan aplikasi.',
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Keluar dari akun?',
        style: GoogleFonts.poppins(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
      content: Text(
        message,
        style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textMuted),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(
            'Batal',
            style: GoogleFonts.poppins(color: AppColors.textMuted),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(
            'Keluar',
            style: GoogleFonts.poppins(
              color: AppColors.dangerRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
  return confirmed ?? false; // Ditutup dengan tap di luar dialog = batal.
}
