import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_service.dart';
import '../models/teacher_schedule.dart';

class TeacherProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Sesuai enum day_of_week di backend (index 0 = Senin = DateTime.monday)
  static const List<String> _dayNames = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  bool _isLoading = false;
  String? _errorMessage;
  List<TeacherSchedule> _todaySchedules = const [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<TeacherSchedule> get todaySchedules => _todaySchedules;

  double get teachingHours =>
      _todaySchedules.fold<int>(0, (sum, s) => sum + s.durationMinutes) / 60;

  // Jadwal yang belum selesai, urut dari yang paling awal
  List<TeacherSchedule> remainingSchedules(DateTime now) => _todaySchedules
      .where((s) => s.statusAt(now) != ScheduleStatus.finished)
      .toList();

  // ==========================================
  // JADWAL MENGAJAR HARI INI
  // ==========================================
  Future<void> loadTodaySchedules() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final today = _dayNames[DateTime.now().weekday - 1];
      final response = await _apiService.get(
        ApiConstants.teacherSchedules,
        queryParameters: {'day': today},
      );

      final data = response.data['data'] as List<dynamic>;
      _todaySchedules =
          data
              .map((e) => TeacherSchedule.fromJson(e as Map<String, dynamic>))
              .toList()
            ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
    } on DioException catch (e) {
      final body = e.response?.data;
      _errorMessage = body is Map && body['message'] != null
          ? body['message'] as String
          : 'Gagal memuat jadwal. Periksa koneksi ke server.';
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan saat memuat jadwal.';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _todaySchedules = const [];
    _errorMessage = null;
    notifyListeners();
  }
}
