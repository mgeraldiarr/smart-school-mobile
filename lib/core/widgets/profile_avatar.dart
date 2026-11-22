import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

/// Avatar bulat untuk header profil, dengan tombol kamera di pojok kanan bawah.
///
/// Urutan sumber gambar:
/// 1. [localPath]: foto yang baru dipilih pengguna di perangkat ini
/// 2. [photoUrl]: foto dari backend
/// 3. [initials]: bila belum ada foto atau gambar gagal dimuat
class ProfileAvatar extends StatelessWidget {
  final String initials;
  final String? localPath;
  final String? photoUrl;
  final VoidCallback? onTap;
  final bool isLoading;
  final double size;

  const ProfileAvatar({
    super.key,
    required this.initials,
    this.localPath,
    this.photoUrl,
    this.onTap,
    this.isLoading = false,
    this.size = 96,
  });

  ImageProvider? get _image {
    final local = localPath;
    if (local != null) {
      // Di web, image_picker memberi blob URL, bukan path file.
      return kIsWeb ? NetworkImage(local) : FileImage(File(local));
    }
    final url = photoUrl;
    return url == null ? null : NetworkImage(url);
  }

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3A97F4), Color(0xFF1A6FCC)],
        ),
      ),
      child: Text(
        initials,
        style: GoogleFonts.poppins(
          fontSize: size * 0.29,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );

    final image = _image;

    return Semantics(
      button: onTap != null,
      label: 'Foto profil. Ketuk untuk mengganti.',
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: SizedBox(
          width: size + 4,
          height: size + 4,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.9),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.14),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (image == null)
                        fallback
                      else
                        Image(
                          image: image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => fallback,
                        ),
                      if (isLoading)
                        ColoredBox(
                          color: Colors.black.withValues(alpha: 0.35),
                          child: const Center(
                            child: SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.6,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (onTap != null)
                Positioned(
                  right: 0,
                  bottom: 2,
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    elevation: 2,
                    shadowColor: Colors.black.withValues(alpha: 0.15),
                    child: InkWell(
                      onTap: isLoading ? null : onTap,
                      borderRadius: BorderRadius.circular(10),
                      child: const SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 16,
                          color: AppColors.brandBlue,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
