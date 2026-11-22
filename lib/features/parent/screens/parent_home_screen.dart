import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import 'parent_dashboard_screen.dart';
import 'parent_schedule_screen.dart';
import 'parent_notification_screen.dart';
import 'parent_attendance_screen.dart';
import 'parent_academic_screen.dart';
import 'parent_profile_screen.dart';

/// Kerangka navigasi utama Wali Murid: Beranda, Kehadiran, Jadwal, Akademik, Profil.
class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  static const int _profileTab = 4;

  int _currentIndex = 0;

  static const _navItems = [
    (Icons.home_outlined, Icons.home_rounded, 'Beranda'),
    (
      Icons.check_circle_outline_rounded,
      Icons.check_circle_rounded,
      'Kehadiran',
    ),
    (Icons.calendar_today_outlined, Icons.calendar_today_rounded, 'Jadwal'),
    (Icons.menu_book_outlined, Icons.menu_book_rounded, 'Akademik'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'Profil'),
  ];

  void _openNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          backgroundColor: const Color(0xFFF5F8FD),
          body: ParentNotificationScreen(onBack: () => Navigator.of(ctx).pop()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Header tab Profil berwarna biru, jadi ikon status bar dibuat putih
    final hasBlueHeader = _currentIndex == _profileTab;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          (hasBlueHeader
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark)
              .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8FD),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            ParentDashboardScreen(
              onOpenAttendance: () => setState(() => _currentIndex = 1),
              onOpenSchedule: () => setState(() => _currentIndex = 2),
              onOpenNotifications: _openNotifications,
            ),
            const ParentAttendanceScreen(),
            const ParentScheduleScreen(),
            const ParentAcademicScreen(),
            const ParentProfileScreen(),
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
