import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import 'app_dialog.dart';

/// Dialog ubah kata sandi untuk guru dan wali murid.
/// Mengembalikan true bila kata sandi berhasil diubah.
Future<bool> showChangePasswordDialog(BuildContext context) async {
  final changed = await showDialog<bool>(
    context: context,
    builder: (_) => const _ChangePasswordDialog(),
  );
  return changed ?? false;
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  static const int _minLength = 8;

  final _formKey = GlobalKey<FormState>();
  final _oldController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _oldController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    // TODO(api): kirim ke endpoint ubah kata sandi (belum ada di ApiConstants).
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: dialogTitle('Ubah Kata Sandi'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _oldController,
                obscureText: true,
                style: GoogleFonts.poppins(fontSize: 13.5),
                decoration: dialogFieldDecoration(
                  'Kata Sandi Lama',
                  Icons.lock_outline_rounded,
                ),
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Kata sandi lama wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _newController,
                obscureText: true,
                style: GoogleFonts.poppins(fontSize: 13.5),
                decoration: dialogFieldDecoration(
                  'Kata Sandi Baru (Min. $_minLength Karakter)',
                  Icons.lock_outline_rounded,
                ),
                validator: (v) => (v == null || v.length < _minLength)
                    ? 'Minimal $_minLength karakter.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                obscureText: true,
                style: GoogleFonts.poppins(fontSize: 13.5),
                decoration: dialogFieldDecoration(
                  'Konfirmasi Kata Sandi Baru',
                  Icons.lock_outline_rounded,
                ),
                validator: (v) => v != _newController.text
                    ? 'Konfirmasi kata sandi tidak cocok.'
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: dialogActions(context, _save),
    );
  }
}
