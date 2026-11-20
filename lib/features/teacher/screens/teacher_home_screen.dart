import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import 'teacher_dashboard_screen.dart';
import 'teacher_profile_screen.dart';

/// Kerangka utama aplikasi guru: Beranda, Jadwal, Nilai, Profil.
class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  static const int _scheduleTab = 1;

  int _currentIndex = 0;

  static const _navItems = [
    (Icons.home_outlined, Icons.home_rounded, 'Beranda'),
    (Icons.calendar_today_outlined, Icons.calendar_today_rounded, 'Jadwal'),
    (Icons.fact_check_outlined, Icons.fact_check_rounded, 'Nilai'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    final hasBlueHeader = _currentIndex == 0 || _currentIndex == 3;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Header Beranda & Profil berwarna biru, tab lain berlatar terang
      value: (hasBlueHeader
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark)
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FC),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            TeacherDashboardScreen(
              onSeeAllSchedules: () =>
                  setState(() => _currentIndex = _scheduleTab),
            ),
            const _ComingSoonTab(
              icon: Icons.calendar_month_outlined,
              title: 'Jadwal Mengajar',
            ),
            const _ComingSoonTab(
              icon: Icons.fact_check_outlined,
              title: 'Input Nilai',
            ),
            const TeacherProfileScreen(),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
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
              fontSize: 10.5,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComingSoonTab extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ComingSoonTab({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 56,
                color: AppColors.brandBlue.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Fitur ini sedang dikembangkan.',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
