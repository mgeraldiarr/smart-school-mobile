import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../models/teacher_schedule.dart';

/// Kartu jadwal mengajar. Jika [onStart] diisi, kartu tampil sebagai jadwal
/// aktif lengkap dengan tombol "Mulai Mengajar" dan "Berhalangan".
class ScheduleCard extends StatelessWidget {
  final TeacherSchedule schedule;
  final ScheduleStatus status;
  final bool isNext;
  final VoidCallback? onStart;
  final VoidCallback? onUnavailable;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.status,
    this.isNext = false,
    this.onStart,
    this.onUnavailable,
  });

  bool get _isActive => onStart != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isActive
              ? AppColors.brandBlue.withValues(alpha: 0.18)
              : AppColors.border.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandBlue.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Aksen biru di sisi kiri
              Container(
                width: 4,
                color: _isActive
                    ? AppColors.brandBlueBright
                    : AppColors.brandBlueBright.withValues(alpha: 0.8),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 15,
                            color: AppColors.brandBlue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            schedule.timeRange,
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.brandBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  schedule.subjectName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                    height: 1.3,
                                  ),
                                ),
                                Text(
                                  'Kelas ${schedule.className}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _StatusBadge(status: status, isNext: isNext),
                        ],
                      ),
                      if (_isActive) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _ActionButton(
                                label: 'Mulai Mengajar',
                                filled: true,
                                onPressed: onStart,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _ActionButton(
                                label: 'Berhalangan',
                                filled: false,
                                onPressed: onUnavailable,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ScheduleStatus status;
  final bool isNext;

  const _StatusBadge({required this.status, required this.isNext});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ScheduleStatus.ongoing => ('Berlangsung', AppColors.successGreen),
      ScheduleStatus.finished => ('Selesai', AppColors.textMuted),
      ScheduleStatus.upcoming when isNext => (
        'Berikutnya',
        AppColors.brandBlue,
      ),
      ScheduleStatus.upcoming => ('Belum Dimulai', AppColors.warningOrange),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: Color.lerp(color, Colors.black, 0.15),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.label,
    required this.filled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.poppins(
      fontSize: 12.5,
      fontWeight: FontWeight.w600,
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    if (!filled) {
      return SizedBox(
        height: 42,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.brandBlue,
            side: BorderSide(
              color: AppColors.brandBlue.withValues(alpha: 0.35),
              width: 1.2,
            ),
            shape: shape,
          ),
          child: Text(label, style: textStyle),
        ),
      );
    }

    return Container(
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandBlue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: shape,
        ),
        child: Text(label, style: textStyle),
      ),
    );
  }
}
