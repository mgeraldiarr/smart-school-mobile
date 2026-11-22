import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ParentScheduleScreen extends StatefulWidget {
  const ParentScheduleScreen({super.key});

  @override
  State<ParentScheduleScreen> createState() => _ParentScheduleScreenState();
}

class _ParentScheduleScreenState extends State<ParentScheduleScreen> {
  int _selectedDay = 0;

  final List<Map<String, String>> _days = [
    {'day': 'Sen', 'date': '5'},
    {'day': 'Sel', 'date': '6'},
    {'day': 'Rab', 'date': '7'},
    {'day': 'Kam', 'date': '8'},
    {'day': 'Jum', 'date': '9'},
  ];

  final List<Map<String, String>> _schedule = [
    {
      'time': '07.00 - 08.30',
      'subject': 'Matematika',
      'teacher': 'Pak Ahmad',
      'status': 'Mengajar',
      'color': 'blue',
    },
    {
      'time': '08.30 - 10.00',
      'subject': 'IPA',
      'teacher': 'Bu Siti',
      'status': 'Mengajar',
      'color': 'AppColors.emerald',
    },
    {
      'time': '10.15 - 11.45',
      'subject': 'Bahasa Indonesia',
      'teacher': 'Pak Budi',
      'status': 'Berhalangan',
      'color': 'orange',
    },
    {
      'time': '12.30 - 14.00',
      'subject': 'Bahasa Inggris',
      'teacher': 'Bu Rina',
      'status': 'Terjadwal',
      'color': 'purple',
    },
  ];

  Color _subjectColor(String color) {
    switch (color) {
      case 'AppColors.emerald':
        return const Color(0xFF20A579);
      case 'orange':
        return const Color(0xFFF2932B);
      case 'purple':
        return const Color(0xFF8061D1);
      default:
        return AppColors.accentBlue;
    }
  }

  Color _statusBackground(String status) {
    switch (status) {
      case 'Berhalangan':
        return const Color(0xFFFFF0DD);
      case 'Terjadwal':
        return const Color(0xFFE5F0FF);
      default:
        return const Color(0xFFE1F7ED);
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Berhalangan':
        return const Color(0xFFC76B00);
      case 'Terjadwal':
        return AppColors.accentBlue;
      default:
        return const Color(0xFF078553);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(17, 24, 17, 20),
                children: [
                  _buildDaySelector(),
                  const SizedBox(height: 20),
                  ..._schedule.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildScheduleItem(item),
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
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.softBorder.withValues(alpha: 0.7),
          ),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jadwal Pelajaran',
            style: TextStyle(
              color: AppColors.slateText,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Kelas 8A • Oktober 2026',
            style: TextStyle(color: AppColors.slateMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Row(
      children: List.generate(_days.length, (index) {
        final selected = _selectedDay == index;
        final day = _days[index];

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == _days.length - 1 ? 0 : 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDay = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 70,
                decoration: BoxDecoration(
                  color: selected ? AppColors.accentBlue : Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: selected
                        ? AppColors.accentBlue
                        : AppColors.softBorder,
                    width: 1.5,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.accentBlue.withValues(alpha: 0.18),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day['day']!,
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.slateMuted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      day['date']!,
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.slateMuted,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildScheduleItem(Map<String, String> item) {
    final color = _subjectColor(item['color']!);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 98,
          child: Padding(
            padding: const EdgeInsets.only(top: 26),
            child: Text(
              item['time']!,
              style: const TextStyle(color: AppColors.slateMuted, fontSize: 12),
            ),
          ),
        ),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(minHeight: 76),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: AppColors.softBorder, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['subject']!,
                        style: const TextStyle(
                          color: AppColors.slateText,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['teacher']!,
                        style: const TextStyle(
                          color: AppColors.slateMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _statusBackground(item['status']!),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      item['status']!,
                      style: TextStyle(
                        color: _statusColor(item['status']!),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
