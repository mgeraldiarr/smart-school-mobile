
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class NotifikasiWaliMurid extends StatefulWidget {
  final VoidCallback onBack;

  const NotifikasiWaliMurid({
    super.key,
    required this.onBack,
  });

  @override
  State<NotifikasiWaliMurid> createState() => _NotifikasiWaliMuridState();
}

class _NotifikasiWaliMuridState extends State<NotifikasiWaliMurid> {
  bool _allRead = false;

  final List<Map<String, dynamic>> _todayNotifications = [
    {
      'icon': Icons.check_rounded,
      'color': const Color(0xFF079B68),
      'background': const Color(0xFFE0F6ED),
      'title': 'Kehadiran Siswa',
      'description':
          'Ahmad Rizki telah hadir pada mata pelajaran Matematika pukul 07.15 WIB.',
      'time': '07.16',
    },
    {
      'icon': Icons.info_outline_rounded,
      'color': const Color(0xFFFF8500),
      'background': const Color(0xFFFFF0DC),
      'title': 'Informasi Pembelajaran',
      'description':
          'Pak Ahmad, guru Matematika kelas 8A, berhalangan mengajar pukul 07.00 - 08.30 karena rapat sekolah.',
      'time': '06.50',
    },
  ];

  final List<Map<String, dynamic>> _yesterdayNotifications = [
    {
      'icon': Icons.bookmark_border_rounded,
      'color': primaryBlue,
      'background': const Color(0xFFE5F1FF),
      'title': 'Nilai Diperbarui',
      'description':
          'Nilai UAS mata pelajaran IPA telah diperbarui menjadi 92.',
      'time': '16.20',
    },
  ];

  int get _unreadCount => _allRead ? 0 : 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(21, 20, 21, 24),
                children: [
                  _buildSectionTitle('HARI INI'),
                  const SizedBox(height: 12),
                  ..._todayNotifications.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildNotificationCard(
                        item,
                        unread: !_allRead,
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),
                  _buildSectionTitle('KEMARIN'),
                  const SizedBox(height: 12),
                  ..._yesterdayNotifications.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildNotificationCard(
                        item,
                        unread: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 17),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: borderColor.withValues(alpha: 0.65),
          ),
        ),
      ),
      child: Row(
        children: [
          Material(
            color: const Color(0xFFEDF4FC),
            borderRadius: BorderRadius.circular(17),
            child: InkWell(
              onTap: widget.onBack,
              borderRadius: BorderRadius.circular(17),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: primaryBlue,
                  size: 30,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pusat Notifikasi',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$_unreadCount notifikasi belum dibaca',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _allRead = true;
              });
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Tandai dibaca',
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF8A9BB2),
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildNotificationCard(
    Map<String, dynamic> item, {
    required bool unread,
  }) {
    final Color iconColor = item['color'] as Color;
    final Color iconBackground = item['background'] as Color;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: unread ? const Color(0xFFFBFDFF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: unread
              ? const Color(0xFFC9E0FC)
              : const Color(0xFFE0E9F5),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              item['icon'] as IconData,
              color: iconColor,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (unread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF43A4F8),
                              shape: BoxShape.circle,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          item['time'] as String,
                          style: const TextStyle(
                            color: Color(0xFF9AAAC0),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Text(
                  item['description'] as String,
                  style: const TextStyle(
                    color: Color(0xFF687D9A),
                    fontSize: 11,
                    height: 1.6,
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
