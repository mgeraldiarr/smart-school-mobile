import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../parent/screens/parent_home_screen.dart';
import '../../teacher/screens/teacher_home_screen.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

/// Tujuan setelah splash, dipisah dari UI supaya mudah dites.
enum StartDestination { login, teacherHome, parentHome }

StartDestination startDestinationFor({
  required bool isLoggedIn,
  required String? role,
}) {
  if (!isLoggedIn) return StartDestination.login;
  return switch (role) {
    'teacher' => StartDestination.teacherHome,
    'parent' => StartDestination.parentHome,
    _ => StartDestination.login, // Peran tak dikenal: minta login ulang.
  };
}

/// Layar pembuka: logo muncul perlahan sambil memeriksa sesi login tersimpan.
/// Pengguna yang belum pernah Keluar langsung masuk ke beranda.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Logo tetap tampil minimal selama ini agar tidak sekadar berkedip.
  static const _minimumDisplay = Duration(milliseconds: 1400);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );
  late final Animation<double> _scale = Tween<double>(
    begin: 0.86,
    end: 1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final auth = context.read<AuthProvider>();
    // Animasi & pengecekan sesi berjalan bersamaan, bukan bergantian.
    final results = await Future.wait([
      auth.tryAutoLogin(),
      Future<void>.delayed(_minimumDisplay).then((_) => true),
    ]);
    if (!mounted) return;

    final destination = startDestinationFor(
      isLoggedIn: results.first,
      role: auth.userRole,
    );
    final Widget next = switch (destination) {
      StartDestination.teacherHome => const TeacherHomeScreen(),
      StartDestination.parentHome => const ParentHomeScreen(),
      StartDestination.login => const LoginScreen(),
    };

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, _, _) => next,
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(scale: _scale, child: const AppLogo()),
          ),
        ),
      ),
    );
  }
}

/// Logo aplikasi: kotak biru bergradasi dengan ikon toga.
class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 112});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Smart School',
      image: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.brandBlueBright, AppColors.brandBlue],
          ),
          borderRadius: BorderRadius.circular(size * 0.28),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandBlue.withValues(alpha: 0.28),
              blurRadius: size * 0.3,
              offset: Offset(0, size * 0.12),
            ),
          ],
        ),
        child: Icon(
          Icons.school_outlined,
          color: Colors.white,
          size: size * 0.54,
        ),
      ),
    );
  }
}
