import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../pages/dashboard_wali_murid.dart';
import '../../../pages/jadwal_pelajaran_wali_murid.dart';
import '../../../pages/notifikasi_wali_murid.dart';
import '../../../pages/rekap_kehadiran_wali_murid.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';
import 'parent_academic_screen.dart';

/// Kerangka navigasi utama Wali Murid: Beranda, Kehadiran, Jadwal, Akademik, Profil.
class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  int _currentIndex = 0;

  static const _navItems = [
    (Icons.home_outlined, Icons.home_rounded, 'Beranda'),
    (Icons.check_circle_outline_rounded, Icons.check_circle_rounded, 'Kehadiran'),
    (Icons.calendar_today_outlined, Icons.calendar_today_rounded, 'Jadwal'),
    (Icons.menu_book_outlined, Icons.menu_book_rounded, 'Akademik'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'Profil'),
  ];

  void _openNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          backgroundColor: const Color(0xFFF5F8FD),
          body: NotifikasiWaliMurid(
            onBack: () => Navigator.of(ctx).pop(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardWaliMurid(
            onOpenAttendance: () => setState(() => _currentIndex = 1),
            onOpenSchedule: () => setState(() => _currentIndex = 2),
            onOpenNotifications: _openNotifications,
          ),
          const RekapKehadiranWaliMurid(),
          const JadwalPelajaranWaliMurid(),
          const ParentAcademicScreen(showBottomNav: false),
          const _ParentProfileTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border.withValues(alpha: 0.7)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              for (var i = 0; i < _navItems.length; i++)
                Expanded(child: _buildNavItem(i)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final (icon, activeIcon, label) = _navItems[index];
    final isActive = index == _currentIndex;
    final color = isActive
        ? AppColors.brandBlue
        : AppColors.textMuted.withValues(alpha: 0.8);

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.brandBlue.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(isActive ? activeIcon : icon, color: color, size: 22),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParentProfileTab extends StatelessWidget {
  const _ParentProfileTab();

  Future<void> _logout(BuildContext context) async {
    final navigator = Navigator.of(context);
    await context.read<AuthProvider>().logout();
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<AuthProvider>().userData;
    final parentMap =
        (userData?['parent'] ?? userData?['profile']) as Map<String, dynamic>?;
    final studentMap = userData?['student'] as Map<String, dynamic>?;
    final fullName =
        (parentMap?['full_name'] as String?) ?? 'Hendra Fauzi';
    final studentName =
        (studentMap?['full_name'] as String?) ?? 'Ahmad Rizki';
    final studentNis = (studentMap?['nis'] as String?) ?? '20241001';

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
        children: [
          Center(
            child: Container(
              width: 84,
              height: 84,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.brandBlueBright, AppColors.brandBlueDeep],
                ),
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(
                Icons.family_restroom_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            fullName,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Wali Murid dari $studentName (NIS $studentNis)',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: Text(
                'Keluar',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.dangerRed,
                side: BorderSide(
                  color: AppColors.dangerRed.withValues(alpha: 0.4),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
