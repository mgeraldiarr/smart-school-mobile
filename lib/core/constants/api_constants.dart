class ApiConstants {
  // Ganti ke IP LAN laptop (misal: http://192.168.1.15:8000/api) jika pakai HP fisik
  // atau http://10.0.2.2:8000/api jika pakai Android Emulator
  static const String baseUrl =
      'https://untried-payday-dotted.ngrok-free.dev/api';

  // 1. Auth & Password Reset
  static const String teacherLogin = '/auth/teacher/login';
  static const String parentLogin = '/auth/parent/login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';

  // 2. Modul Guru (Presensi Wajah & Nilai)
  static const String faceScan = '/attendance/face-scan';
  static const String sessionAttendance = '/teacher/attendance/session';
  static const String manualAttendance = '/teacher/attendance/manual';
  static const String teacherSchedules = '/teacher/schedules';
  static const String teacherGrades = '/teacher/grades';
  static String classStudents(int classId) =>
      '/teacher/classes/$classId/students';

  // 3. Modul Orang Tua
  static const String studentStatus = '/parent/student-status';
  static const String studentGrades = '/parent/student-grades';
}
