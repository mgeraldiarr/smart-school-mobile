
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DashboardWaliMurid extends StatelessWidget {
  final VoidCallback? onOpenAttendance;
  final VoidCallback? onOpenSchedule;
  final VoidCallback? onOpenNotifications;

  const DashboardWaliMurid({
    super.key,
    this.onOpenAttendance,
    this.onOpenSchedule,
    this.onOpenNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _header(),
        ),
        SliverToBoxAdapter(
          child: _studentCard(),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ringkasan Akademik',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Semester Ganjil 2026/2027',
                  style: TextStyle(
                    fontSize: 14,
                    color: textMuted,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        icon: Icons.check_rounded,
                        value: '91%',
                        label: 'Rekap Kehadiran',
                        detail: '40 dari 44 pertemuan',
                        colors: const [
                          primaryBlue,
                          brightBlue,
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _summaryCard(
                        icon: Icons.bookmark_added_outlined,
                        value: '87,3',
                        label: 'Rata-rata Nilai',
                        detail: 'Predikat A • Sangat Baik',
                        colors: const [
                          Color(0xFF159675),
                          Color(0xFF27B989),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Mata Pelajaran Selanjutnya',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onOpenSchedule,
                      child: const Text(
                        'Jadwal lengkap',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'Dimulai dalam 30 menit',
                  style: TextStyle(
                    fontSize: 14,
                    color: textMuted,
                  ),
                ),
                const SizedBox(height: 18),
                _nextLesson(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Kehadiran Terbaru',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onOpenAttendance,
                      child: const Text(
                        'Lihat semua',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'Hari ini',
                  style: TextStyle(
                    fontSize: 14,
                    color: textMuted,
                  ),
                ),
                const SizedBox(height: 17),
                _recentAttendance(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Container(
      height: 195,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1767BE),
            Color(0xFF258FE5),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _headerIcon(Icons.school_outlined, isLogo: true),
              GestureDetector(
                onTap: onOpenNotifications,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _headerIcon(Icons.notifications_none_rounded),
                    Positioned(
                      top: 9,
                      right: 9,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFB547),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Selamat Datang, Bapak/Ibu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'Pantau perkembangan belajar buah hati Anda.',
            style: TextStyle(
              color: Color(0xFFE4F0FF),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon, {bool isLogo = false}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isLogo
            ? Colors.white
            : Colors.white.withValues(alpha: 0.17),
        borderRadius: BorderRadius.circular(17),
        border: isLogo
            ? null
            : Border.all(
                color: Colors.white.withValues(alpha: 0.3),
              ),
      ),
      child: Icon(
        icon,
        size: 29,
        color: isLogo ? primaryBlue : Colors.white,
      ),
    );
  }

  Widget _studentCard() {
    return Transform.translate(
      offset: const Offset(0, -4),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF416A9B)
                  .withValues(alpha: 0.08),
              blurRadius: 25,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFE0EEFF),
                borderRadius: BorderRadius.circular(19),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: primaryBlue,
                size: 40,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PUTRA ANDA',
                    style: TextStyle(
                      color: primaryBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Ahmad Rizki',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Kelas 8A • NIS 20260001',
                    style: TextStyle(
                      fontSize: 11,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            _statusChip('Hadir'),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String value,
    required String label,
    required String detail,
    required List<Color> colors,
  }) {
    return Container(
      height: 145,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.19),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: Colors.white, size: 21),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            detail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextLesson() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: borderColor, width: 1.3),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 43,
            child: Text(
              '10.15',
              style: TextStyle(
                color: primaryBlue,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
            width: 5,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF43A0F5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bahasa Indonesia',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Pak Budi • Ruang 8A • 10.15 – 11.45',
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 9,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0DC),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              'Berikutnya',
              style: TextStyle(
                color: Color(0xFFBD6900),
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentAttendance() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: borderColor, width: 1.3),
      ),
      child: Row(
        children: [
          Container(
            width: 53,
            height: 57,
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.menu_book_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Matematika',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Pak Ahmad • 07.15 WIB',
                  style: TextStyle(
                    fontSize: 11,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),
          _statusChip('Hadir'),
        ],
      ),
    );
  }

  Widget _statusChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE2F7ED),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF11865E),
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
