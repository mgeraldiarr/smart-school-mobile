import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../../informasi_berhasil.dart';
import '../../konfirmasi_mengajar.dart';
import '../providers/teacher_provider.dart';
import '../teacher_name.dart';
import '../widgets/schedule_card.dart';

class TeacherDashboardScreen extends StatefulWidget {
  final VoidCallback onSeeAllSchedules;

  const TeacherDashboardScreen({super.key, required this.onSeeAllSchedules});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherProvider>().loadTodaySchedules();
    });
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Fitur $feature segera hadir.',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        backgroundColor: AppColors.brandBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final teacher = context.watch<TeacherProvider>();
    final fullName = auth.teacherProfile?['full_name'] as String?;
    final now = DateTime.now();

    return RefreshIndicator(
      color: AppColors.brandBlue,
      onRefresh: teacher.loadTodaySchedules,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _DashboardHeader(
            fullName: fullName,
            now: now,
            scheduleCount: teacher.todaySchedules.length,
            teachingHours: teacher.teachingHours,
            onNotificationTap: () => _showComingSoon('notifikasi'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: _buildScheduleSection(teacher, now),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(TeacherProvider teacher, DateTime now) {
    final remaining = teacher.remainingSchedules(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _SectionTitle(
                title: 'Jadwal Hari Ini',
                subtitle: 'Jadwal aktif Anda',
              ),
            ),
            TextButton(
              onPressed: widget.onSeeAllSchedules,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Lihat semua',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brandBlue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (teacher.isLoading && teacher.todaySchedules.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.brandBlue),
            ),
          )
        else if (teacher.errorMessage != null)
          _InfoState(
            icon: Icons.cloud_off_rounded,
            message: teacher.errorMessage!,
            actionLabel: 'Coba lagi',
            onAction: teacher.loadTodaySchedules,
          )
        else if (teacher.todaySchedules.isEmpty)
          const _InfoState(
            icon: Icons.event_available_rounded,
            message: 'Tidak ada jadwal mengajar hari ini.',
          )
        else if (remaining.isEmpty)
          const _InfoState(
            icon: Icons.task_alt_rounded,
            message: 'Semua jadwal mengajar hari ini sudah selesai.',
          )
        else ...[
          ScheduleCard(
            schedule: remaining.first,
            status: remaining.first.statusAt(now),
            onStart: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KonfirmasiMengajarPage(
                  schedule: remaining.first,
                ),
              ),
            ),
            onUnavailable: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InformasiBerhasilPage(
                  subjectName: remaining.first.subjectName,
                  className: remaining.first.className,
                ),
              ),
            ),
          ),
          if (remaining.length > 1) ...[
            const SizedBox(height: 28),
            const _SectionTitle(title: 'Jadwal Berikutnya'),
            const SizedBox(height: 14),
            for (final schedule in remaining.skip(1)) ...[
              ScheduleCard(
                schedule: schedule,
                status: schedule.statusAt(now),
                isNext: true,
              ),
              const SizedBox(height: 14),
            ],
          ],
        ],
      ],
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final String? fullName;
  final DateTime now;
  final int scheduleCount;
  final double teachingHours;
  final VoidCallback onNotificationTap;

  const _DashboardHeader({
    required this.fullName,
    required this.now,
    required this.scheduleCount,
    required this.teachingHours,
    required this.onNotificationTap,
  });

  static String _greeting(int hour) {
    if (hour < 11) return 'Pagi';
    if (hour < 15) return 'Siang';
    if (hour < 18) return 'Sore';
    return 'Malam';
  }

  // 4.5 -> "4,5", 3.0 -> "3"
  static String _formatHours(double hours) {
    if (hours == hours.roundToDouble()) return hours.toInt().toString();
    return hours.toStringAsFixed(1).replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.fromLTRB(20, topInset + 16, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1560C4), Color(0xFF2B8FEB)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: AppColors.brandBlue,
                  size: 24,
                ),
              ),
              const Spacer(),
              _GlassIconButton(
                icon: Icons.notifications_outlined,
                onTap: onNotificationTap,
              ),
              const SizedBox(width: 10),
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  teacherInitials(fullName),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Selamat ${_greeting(now.hour)}, ${teacherFirstName(fullName)}',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEEE, d MMMM y', 'id_ID').format(now),
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _HeaderStat(
                    icon: Icons.calendar_today_outlined,
                    value: '$scheduleCount',
                    label: 'Jadwal hari ini',
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: Colors.white.withValues(alpha: 0.28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _HeaderStat(
                    icon: Icons.schedule_rounded,
                    value: _formatHours(teachingHours),
                    label: 'Jam mengajar',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _HeaderStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 10.5,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionTitle({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
      ],
    );
  }
}

class _InfoState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _InfoState({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: AppColors.brandBlue.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.brandBlue,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
