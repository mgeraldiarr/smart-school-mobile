import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class RekapKehadiranWaliMurid extends StatefulWidget {
  const RekapKehadiranWaliMurid({super.key});

  @override
  State<RekapKehadiranWaliMurid> createState() =>
      _RekapKehadiranWaliMuridState();
}

class _RekapKehadiranWaliMuridState extends State<RekapKehadiranWaliMurid> {
  String _selectedPeriod = 'Bulan ini';

  final List<Map<String, String>> _history = [
    {
      'subject': 'Matematika',
      'date': 'Senin, 5 Oktober 2026',
      'time': '07.15 WIB',
      'status': 'Hadir',
    },
    {
      'subject': 'IPA',
      'date': 'Senin, 5 Oktober 2026',
      'time': '08.45 WIB',
      'status': 'Hadir',
    },
    {
      'subject': 'Bahasa Indonesia',
      'date': 'Jumat, 2 Oktober 2026',
      'time': '10.20 WIB',
      'status': 'Hadir',
    },
  ];
  List<Map<String, String>> get _filteredHistory {
    switch (_selectedPeriod) {
      case 'Hari ini':
        return _history
            .where((item) => item['date'] == 'Senin, 5 Oktober 2026')
            .toList();

      case 'Minggu ini':
        return _history
            .where(
              (item) =>
                  item['date'] == 'Senin, 5 Oktober 2026' ||
                  item['date'] == 'Jumat, 2 Oktober 2026',
            )
            .toList();

      case 'Bulan ini':
      default:
        return _history;
    }
  }

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
                padding: const EdgeInsets.fromLTRB(17, 16, 17, 20),
                children: [
                  _buildAttendanceSummary(),
                  const SizedBox(height: 14),
                  _buildStatistics(),
                  const SizedBox(height: 16),
                  _buildPeriodSelector(),
                  const SizedBox(height: 20),
                  const Text(
                    'Riwayat Kehadiran',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (_filteredHistory.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'Belum ada riwayat kehadiran',
                          style: TextStyle(color: textMuted, fontSize: 13),
                        ),
                      ),
                    )
                  else
                    ..._filteredHistory.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildHistoryCard(item),
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
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: borderColor.withValues(alpha: 0.7)),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rekap Kehadiran',
            style: TextStyle(
              color: textDark,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ahmad Rizki • Kelas 8A',
            style: TextStyle(color: textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1768C5), Color(0xFF328FDE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 6,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '91',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    height: 1.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    height: 1.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TINGKAT KEHADIRAN',
                  style: TextStyle(
                    color: Color(0xFFD8E9FF),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Sangat Baik',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '40 dari 44 pertemuan',
                  style: TextStyle(color: Color(0xFFE1EEFF), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Row(
      children: [
        _buildStatCard('40', 'Hadir'),
        const SizedBox(width: 10),
        _buildStatCard('2', 'Izin'),
        const SizedBox(width: 10),
        _buildStatCard('1', 'Sakit'),
        const SizedBox(width: 10),
        _buildStatCard('1', 'Alpa'),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(minHeight: 68),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: primaryBlue,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    const periods = ['Hari ini', 'Minggu ini', 'Bulan ini'];

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EFF7),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Row(
        children: periods.map((period) {
          final selected = _selectedPeriod == period;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? primaryBlue : textMuted,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, String> item) {
    return Container(
      constraints: const BoxConstraints(minHeight: 72),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(width: 5, height: 72, color: green),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(17, 14, 8, 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item['subject'] ?? '',
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${item['date'] ?? ''} • ${item['time'] ?? ''}',
                    style: const TextStyle(color: textMuted, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 13),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F6ED),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                item['status'] ?? 'Hadir',
                style: const TextStyle(
                  color: Color(0xFF078553),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
