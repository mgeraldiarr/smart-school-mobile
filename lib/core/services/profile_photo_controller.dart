import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mengelola foto profil satu pengguna: pilih dari kamera/galeri, simpan
/// permanen di perangkat, dan hapus.
///
/// Dipakai bersama oleh profil guru dan wali murid, sehingga logikanya tidak
/// ditulis dua kali. UI cukup mendengarkan perubahan lewat [ListenableBuilder].
///
/// TODO(api): setelah endpoint upload foto tersedia, unggah file di [pick]
/// lalu pakai URL dari backend sebagai sumber utama.
class ProfilePhotoController extends ChangeNotifier {
  /// Pembeda pemilik foto, misal "teacher_12" atau "parent_20260001",
  /// supaya foto antar akun di satu HP tidak tertukar.
  final String ownerKey;
  final ImagePicker _picker;

  ProfilePhotoController({required this.ownerKey, ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  static const _folderName = 'profile_photos';

  String? _localPath;
  bool _isBusy = false;

  /// Lokasi file foto lokal (atau blob URL di web). Null bila belum ada foto.
  String? get localPath => _localPath;
  bool get hasPhoto => _localPath != null;
  bool get isBusy => _isBusy;

  String get _prefsKey => 'profile_photo_$ownerKey';

  /// Memuat foto yang pernah disimpan. Dipanggil sekali saat halaman dibuka.
  Future<void> load() async {
    if (kIsWeb) return; // Web tidak punya penyimpanan file permanen.

    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_prefsKey);
    if (path != null && await File(path).exists()) {
      _localPath = path;
      notifyListeners();
    } else if (path != null) {
      await prefs.remove(_prefsKey); // File sudah terhapus dari perangkat.
    }
  }

  /// Membuka kamera/galeri. Mengembalikan false bila pengguna membatalkan.
  /// Error izin (misal akses kamera ditolak) diteruskan ke pemanggil.
  Future<bool> pick(ImageSource source) async {
    if (_isBusy) return false;
    _setBusy(true);

    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 720, // Cukup tajam untuk avatar, ukuran file tetap kecil.
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.front,
      );
      if (picked == null) return false;

      if (kIsWeb) {
        _localPath = picked.path;
        return true;
      }

      // File dari image_picker ada di folder cache yang bisa dibersihkan OS,
      // jadi disalin ke folder dokumen aplikasi agar permanen.
      final docs = await getApplicationDocumentsDirectory();
      final folder = Directory('${docs.path}/$_folderName');
      await folder.create(recursive: true);

      // Nama file memakai timestamp: Flutter meng-cache gambar berdasarkan
      // path, jadi path baru memastikan foto yang tampil langsung berganti.
      final stamp = DateTime.now().millisecondsSinceEpoch;
      final target = '${folder.path}/${_safeKey}_$stamp.jpg';
      await picked.saveTo(target);

      await _deleteFile(_localPath);
      _localPath = target;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, target);
      return true;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> remove() async {
    if (!kIsWeb) {
      await _deleteFile(_localPath);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsKey);
    }
    _localPath = null;
    notifyListeners();
  }

  String get _safeKey => ownerKey.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  static Future<void> _deleteFile(String? path) async {
    if (kIsWeb || path == null) return;
    final file = File(path);
    if (await file.exists()) await file.delete();
  }
}
