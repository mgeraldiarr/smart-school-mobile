class ApiConstants {
  // Alamat backend diatur saat run/build tanpa mengubah file ini, contoh:
  //   flutter run --dart-define=API_URL=https://nama-kamu.ngrok-free.dev/api
  //   flutter run --dart-define=API_URL=http://10.0.2.2:8000/api   (Android Emulator)
  //   flutter run --dart-define=API_URL=http://192.168.1.15:8000/api (HP di Wi-Fi yang sama)
  // Jika tidak diisi, memakai server bersama tim (ngrok).
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://untried-payday-dotted.ngrok-free.dev/api',
  );

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
