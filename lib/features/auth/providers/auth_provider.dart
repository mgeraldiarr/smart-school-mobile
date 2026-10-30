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

  // Respons login menyimpan profil di 'teacher', sedangkan /auth/me di 'profile'
  Map<String, dynamic>? get teacherProfile =>
      (_userData?['teacher'] ?? _userData?['profile']) as Map<String, dynamic>?;

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
  Future<bool> tryAutoLogin() async {
    final token = await _apiService.getToken();
    final role = await _apiService.getUserRole();

    if (token == null || role == null) {
      return false;
    }

    try {
      final response = await _apiService.get(ApiConstants.me);
      if (response.statusCode == 200) {
        _userData = response.data['data'];
        _userRole = role;
        notifyListeners();
        return true;
      }
    } catch (_) {
      await _apiService.clearSession();
    }

    return false;
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
