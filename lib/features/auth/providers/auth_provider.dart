import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData;
  String? _userRole;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;
  String? get userRole => _userRole;
  bool get isAuthenticated => _userData != null;

  // Respons login menyimpan profil di 'teacher', sedangkan /auth/me di 'profile'.
  // 'profile' didahulukan karena selalu berasal dari data server terbaru.
  Map<String, dynamic>? get teacherProfile =>
      (_userData?['profile'] ?? _userData?['teacher']) as Map<String, dynamic>?;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ==========================================
  // 1. LOGIN GURU (NUPTK)
  // ==========================================
  Future<bool> loginTeacher({
    required String nuptk,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _apiService.post(
        ApiConstants.teacherLogin,
        data: {'nuptk': nuptk.trim(), 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final token = data['token'];

        await _apiService.saveSession(token: token, role: 'teacher');
        await _apiService.saveUserData(data);
        _userData = data;
        _userRole = 'teacher';

        _setLoading(false);
        return true;
      }
    } on DioException catch (e) {
      _errorMessage =
          e.response?.data['message'] ??
          'Gagal masuk. Periksa NUPTK dan kata sandi Anda.';
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan sistem. Silakan coba lagi.';
    }

    _setLoading(false);
    return false;
  }

  // ==========================================
  // 2. LOGIN ORANG TUA (NIS MURID)
  // ==========================================
  Future<bool> loginParent({
    required String nis,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _apiService.post(
        ApiConstants.parentLogin,
        data: {'nis': nis.trim(), 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final token = data['token'];

        await _apiService.saveSession(token: token, role: 'parent');
        await _apiService.saveUserData(data);
        _userData = data;
        _userRole = 'parent';

        _setLoading(false);
        return true;
      }
    } on DioException catch (e) {
      _errorMessage =
          e.response?.data['message'] ??
          'Gagal masuk. Periksa NIS Murid dan kata sandi Anda.';
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan sistem. Silakan coba lagi.';
    }

    _setLoading(false);
    return false;
  }

  // ==========================================
  // 3. CEK SESI LOGIN (AUTO LOGIN SAAT BUKA APLIKASI)
  // ==========================================
  // Sesi hanya berakhir bila pengguna menekan Keluar atau server menolak token
  // (401). Gangguan jaringan tidak memaksa pengguna login ulang.
  Future<bool> tryAutoLogin() async {
    final token = await _apiService.getToken();
    final role = await _apiService.getUserRole();

    if (token == null || role == null) {
      return false;
    }

    try {
      final response = await _apiService
          .get(ApiConstants.me)
          .timeout(_autoLoginTimeout);
      final data = response.data['data'] as Map<String, dynamic>;
      // /auth/me tidak mengirim profil siswa/guru selengkap respons login,
      // jadi data lama digabung dengan data terbaru dari server.
      final cached = await _apiService.getUserData() ?? {};
      _userData = {...cached, ...data};
      await _apiService.saveUserData(_userData!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _apiService.clearSession(); // Token dicabut atau kedaluwarsa.
        return false;
      }
      if (!await _restoreCachedUser()) return false;
    } on TimeoutException {
      if (!await _restoreCachedUser()) return false;
    } catch (_) {
      // Respons tak terduga (misal halaman error ngrok): tetap pakai cache.
      if (!await _restoreCachedUser()) return false;
    }

    _userRole = role;
    notifyListeners();
    return true;
  }

  static const _autoLoginTimeout = Duration(seconds: 8);

  /// Pakai data akun tersimpan saat server tidak bisa dihubungi.
  Future<bool> _restoreCachedUser() async {
    final cached = await _apiService.getUserData();
    if (cached == null) return false;
    _userData = cached;
    return true;
  }

  // ==========================================
  // 4. LUPA KATA SANDI (GMAIL OTP)
  // ==========================================
  Future<bool> requestOtp(String email) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _apiService.post(
        ApiConstants.forgotPassword,
        data: {'email': email.trim()},
      );
      _setLoading(false);
      return response.statusCode == 200;
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Email tidak ditemukan.';
    } catch (_) {
      _errorMessage = 'Gagal mengirim kode OTP.';
    }

    _setLoading(false);
    return false;
  }

  Future<bool> verifyOtp(String email, String otp) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _apiService.post(
        ApiConstants.verifyOtp,
        data: {'email': email.trim(), 'otp': otp.trim()},
      );
      _setLoading(false);
      return response.statusCode == 200;
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? 'Kode OTP tidak sesuai.';
    } catch (_) {
      _errorMessage = 'Gagal memverifikasi OTP.';
    }

    _setLoading(false);
    return false;
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _apiService.post(
        ApiConstants.resetPassword,
        data: {
          'email': email.trim(),
          'otp': otp.trim(),
          'password': newPassword,
          'password_confirmation': newPassword,
        },
      );
      _setLoading(false);
      return response.statusCode == 200;
    } on DioException catch (e) {
      _errorMessage =
          e.response?.data['message'] ?? 'Gagal memperbarui kata sandi.';
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan sistem.';
    }

    _setLoading(false);
    return false;
  }

  // ==========================================
  // 5. KELUAR SESI (LOGOUT)
  // ==========================================
  Future<void> logout() async {
    try {
      await _apiService.post(ApiConstants.logout);
    } catch (_) {}

    await _apiService.clearSession();
    _userData = null;
    _userRole = null;
    notifyListeners();
  }
}
