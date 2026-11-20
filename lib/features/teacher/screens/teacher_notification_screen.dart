import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';

class TeacherNotificationScreen extends StatefulWidget {
  const TeacherNotificationScreen({super.key});

  @override
  State<TeacherNotificationScreen> createState() =>
      _TeacherNotificationScreenState();
}

class _TeacherNotificationScreenState extends State<TeacherNotificationScreen> {
  final List<_TeacherNotificationItem> _todayItems = [
    _TeacherNotificationItem(
      title: 'Kehadiran Siswa',
      message:
          'Ahmad Rizki telah hadir pada mata pelajaran Matematika pukul 07.15 WIB.',
      time: '07.16',
      icon: Icons.check_rounded,
      iconColor: const Color(0xFF1D8F5A),
      iconBackground: const Color(0xFFE4F6EB),
      isUnread: true,
    ),
    _TeacherNotificationItem(
      title: 'Mata Pelajaran Selanjutnya',
      message:
          'Pengingat: Anda akan mengajar Matematika di kelas 8B pukul 10.15 - 11.45.',
      time: '09.45',
      icon: Icons.calendar_today_outlined,
      iconColor: AppColors.brandBlue,
      iconBackground: const Color(0xFFEAF3FE),
      badgeText: 'Dimulai dalam 30 menit',
      isUnread: true,
    ),
    _TeacherNotificationItem(
      title: 'Informasi Pembelajaran',
      message:
          'Pak Ahmad, guru Matematika kelas 8A, berhalangan mengajar pukul 07.00 - 08.30 karena rapat sekolah.',
      time: '06.50',
      icon: Icons.info_outline_rounded,
      iconColor: const Color(0xFFD97706),
      iconBackground: const Color(0xFFFEF0D8),
      isUnread: true,
    ),
  ];

  final List<_TeacherNotificationItem> _yesterdayItems = [
    _TeacherNotificationItem(
      title: 'Nilai Diperbarui',
      message: 'Nilai UAS mata pelajaran IPA telah diperbarui menjadi 92.',
      time: '16.20',
      icon: Icons.bookmark_added_outlined,
      iconColor: AppColors.brandBlue,
      iconBackground: const Color(0xFFEAF3FE),
      isUnread: false,
    ),
  ];

  int get _unreadCount =>
      _todayItems.where((n) => n.isUnread).length +
      _yesterdayItems.where((n) => n.isUnread).length;

  void _markAllAsRead() {
    setState(() {
      for (final item in _todayItems) {
        item.isUnread = false;
      }
      for (final item in _yesterdayItems) {
        item.isUnread = false;
      }
    });
  }

  void _markSingleAsRead(_TeacherNotificationItem item) {
    if (!item.isUnread) return;
    setState(() {
      item.isUnread = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final unread = _unreadCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Column(
        children: [
          _buildTopHeader(context, unread),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              children: [
                _buildSectionLabel('HARI INI'),
                const SizedBox(height: 12),
                for (final item in _todayItems) ...[
                  _NotificationCard(
                    item: item,
                    onTap: () => _markSingleAsRead(item),
                  ),
                  const SizedBox(height: 14),
                ],
                const SizedBox(height: 8),
                _buildSectionLabel('KEMARIN'),
                const SizedBox(height: 12),
                for (final item in _yesterdayItems) ...[
                  _NotificationCard(
                    item: item,
                    onTap: () => _markSingleAsRead(item),
                  ),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context, int unreadCount) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          child: Row(
            children: [
              Material(
                color: const Color(0xFFEAF3FE),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(14),
                  child: const SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.brandBlue,
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pusat Notifikasi',
                      style: GoogleFonts.poppins(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      unreadCount > 0
                          ? '$unreadCount notifikasi belum dibaca'
                          : 'Semua notifikasi telah dibaca',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: unreadCount > 0 ? _markAllAsRead : null,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Tandai dibaca',
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: unreadCount > 0
                        ? AppColors.brandBlue
                        : AppColors.textMuted.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF8A99AD),
        letterSpacing: 0.8,
      ),
    );
  }
}

class _TeacherNotificationItem {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String? badgeText;
  bool isUnread;

  _TeacherNotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    this.badgeText,
    this.isUnread = false,
  });
}

class _NotificationCard extends StatelessWidget {
  final _TeacherNotificationItem item;
  final VoidCallback onTap;

  const _NotificationCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: item.isUnread
              ? const Color(0xFFBFD9F6)
              : AppColors.border,
          width: item.isUnread ? 1.2 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: item.iconBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.iconColor,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              item.title,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (item.isUnread)
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(bottom: 3),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2B7DE9),
                                  shape: BoxShape.circle,
                                ),
                              )
                            else
                              const SizedBox(height: 11),
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                item.time,
                                style: GoogleFonts.poppins(
                                  fontSize: 10.5,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text(
                        item.message,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          color: AppColors.textMuted,
                          height: 1.45,
                        ),
                      ),
                    ),
                    if (item.badgeText != null) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF3FE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 15,
                                color: AppColors.brandBlue,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                item.badgeText!,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.brandBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
