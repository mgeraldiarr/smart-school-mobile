import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/app_colors.dart';
import '../services/profile_photo_controller.dart';

enum _PhotoAction { camera, gallery, remove }

/// Alur lengkap ganti foto profil: tampilkan pilihan sumber, jalankan aksi,
/// lalu beri umpan balik (SnackBar) berhasil atau gagal.
Future<void> showChangeProfilePhotoFlow(
  BuildContext context,
  ProfilePhotoController controller,
) async {
  final action = await showModalBottomSheet<_PhotoAction>(
    context: context,
    backgroundColor: AppColors.surface,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _PhotoSourceSheet(hasPhoto: controller.hasPhoto),
  );
  if (action == null || !context.mounted) return;

  final messenger = ScaffoldMessenger.of(context);
  void show(String message, Color color) => messenger.showSnackBar(
    SnackBar(
      content: Text(message, style: GoogleFonts.poppins()),
      backgroundColor: color,
    ),
  );

  try {
    switch (action) {
      case _PhotoAction.camera:
      case _PhotoAction.gallery:
        final source = action == _PhotoAction.camera
            ? ImageSource.camera
            : ImageSource.gallery;
        final changed = await controller.pick(source);
        if (changed) {
          show('Foto profil berhasil diperbarui.', AppColors.successGreen);
        }
      case _PhotoAction.remove:
        await controller.remove();
        show('Foto profil dihapus.', AppColors.textDark);
    }
  } on PlatformException catch (e) {
    final denied = e.code.contains('denied') || e.code.contains('access');
    show(
      denied
          ? 'Izin kamera/galeri ditolak. Aktifkan di pengaturan HP.'
          : 'Gagal memuat foto. Silakan coba lagi.',
      AppColors.dangerRed,
    );
  } catch (_) {
    show('Gagal menyimpan foto. Silakan coba lagi.', AppColors.dangerRed);
  }
}

class _PhotoSourceSheet extends StatelessWidget {
  final bool hasPhoto;

  const _PhotoSourceSheet({required this.hasPhoto});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Foto Profil',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            _SheetOption(
              icon: Icons.photo_camera_outlined,
              label: 'Ambil dari Kamera',
              onTap: () => Navigator.of(context).pop(_PhotoAction.camera),
            ),
            _SheetOption(
              icon: Icons.photo_library_outlined,
              label: 'Pilih dari Galeri',
              onTap: () => Navigator.of(context).pop(_PhotoAction.gallery),
            ),
            if (hasPhoto)
              _SheetOption(
                icon: Icons.delete_outline_rounded,
                label: 'Hapus Foto',
                isDestructive: true,
                onTap: () => Navigator.of(context).pop(_PhotoAction.remove),
              ),
          ],
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.dangerRed : AppColors.brandBlue;

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: isDestructive ? AppColors.dangerRed : AppColors.textDark,
        ),
      ),
    );
  }
}
