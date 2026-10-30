import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

/// Academic page UI with fictional grades. No API or authentication changes.
class ParentAcademicScreen extends StatefulWidget {
  const ParentAcademicScreen({super.key, this.onMenuSelected});

  /// Let the team's router handle other menus after their features are merged.
  final ValueChanged<int>? onMenuSelected;

  @override
  State<ParentAcademicScreen> createState() => _ParentAcademicScreenState();
}

class _ParentAcademicScreenState extends State<ParentAcademicScreen> {
  String _semester = 'Semester Ganjil 2026/2027';
  static const _grades = <_SubjectGrade>[
    _SubjectGrade('Matematika', 85, 90, AppColors.brandBlue),
    _SubjectGrade('IPA', 88, 92, AppColors.successGreen),
    _SubjectGrade('Bahasa Indonesia', 82, 87, AppColors.warningOrange),
    _SubjectGrade('Bahasa Inggris', 86, 88, Color(0xFF7A63CD)),
    _SubjectGrade('IPS', 84, 89, AppColors.infoBlue),
    _SubjectGrade('Pendidikan Pancasila', 88, 90, Color(0xFF168B68)),
  ];
  bool get _hasGrades => _semester == 'Semester Ganjil 2026/2027';
  double get _average => _grades.fold<double>(0, (sum, grade) => sum + grade.average) / _grades.length;
  String _decimal(double value) => value.toStringAsFixed(1).replaceAll('.', ',');

  void _selectMenu(int index) {
    if (index == 3) return;
    if (widget.onMenuSelected != null) {
      widget.onMenuSelected!(index);
      return;
    }
    const names = ['Beranda', 'Kehadiran', 'Jadwal', 'Akademik', 'Profil'];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Halaman ${names[index]} belum disambungkan pada pratinjau ini.'),
    ));
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
    ),
    child: Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nilai Akademik', style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.w700,
                    color: AppColors.textDark, letterSpacing: -.6)),
                  SizedBox(height: 6),
                  Text('Ahmad Rizki • Kelas 8A', style: TextStyle(
                    color: AppColors.textMuted, fontSize: 13)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _card(child: DropdownButtonFormField<String>(
                    initialValue: _semester,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Periode Akademik', border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.brandBlue),
                    items: const ['Semester Ganjil 2026/2027', 'Semester Genap 2026/2027']
                      .map((value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                      )).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _semester = value);
                    },
                  )),
                  const SizedBox(height: 16),
                  if (_hasGrades) ...[
                    _summary(),
                    const SizedBox(height: 24),
                    Row(children: [
                      const Expanded(child: Text('Nilai per Mata Pelajaran',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700,
                          color: AppColors.textDark))),
                      const SizedBox(width: 8),
                      Text('${_grades.length} mapel', style: const TextStyle(
                        color: AppColors.brandBlue, fontSize: 12)),
                    ]),
                    const SizedBox(height: 14),
                    for (final grade in _grades)
                      Padding(padding: const EdgeInsets.only(bottom: 10),
                        child: _gradeCard(grade)),
                    const SizedBox(height: 6),
                    const Text('Nilai akhir contoh = (UTS + UAS) ÷ 2. '
                      'Bobot penilaian sebenarnya mengikuti kebijakan sekolah.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11, height: 1.6)),
                  ] else
                    _card(child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(child: Column(children: [
                        Icon(Icons.menu_book_outlined, size: 42, color: AppColors.textMuted),
                        SizedBox(height: 14),
                        Text('Nilai belum tersedia', style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700)),
                        SizedBox(height: 8),
                        Text('Belum ada nilai pada semester yang dipilih.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ])),
                    )),
                  const SizedBox(height: 18),
                  const Text('Pratinjau UI • Identitas dan nilai adalah data contoh, '
                    'belum terhubung API akademik.',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11, height: 1.6)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 3,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.headerTint,
        onDestinationSelected: _selectMenu,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.check_rounded), label: 'Kehadiran'),
          NavigationDestination(icon: Icon(Icons.calendar_today_outlined), label: 'Jadwal'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded, color: AppColors.brandBlue),
            label: 'Akademik'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    ),
  );

  Widget _summary() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [AppColors.brandBlueDeep, AppColors.brandBlueBright],
      ),
    ),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Rata-rata nilai', style: TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 6),
        Text(_decimal(_average), style: const TextStyle(
          color: Colors.white, fontSize: 38, fontWeight: FontWeight.w800)),
      ])),
      const SizedBox(width: 12),
      Column(children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(18)),
          child: const Text('A', style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800))),
        const SizedBox(height: 6),
        const Text('Sangat Baik', style: TextStyle(color: Colors.white70, fontSize: 10)),
      ]),
    ]),
  );

  Widget _gradeCard(_SubjectGrade grade) => _card(
    child: LayoutBuilder(builder: (context, constraints) {
      // Stack exam scores below the title when text is enlarged or space is tight.
      final compact = constraints.maxWidth < 290 || MediaQuery.textScalerOf(context).scale(14) > 18;
      final heading = Row(children: [
        Container(width: 44, height: 44,
          decoration: BoxDecoration(color: grade.color, borderRadius: BorderRadius.circular(14)),
          child: const Icon(Icons.menu_book_outlined, color: Colors.white, size: 25)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(grade.subject, style: const TextStyle(fontWeight: FontWeight.w700,
            fontSize: 13, color: AppColors.textDark)),
          const SizedBox(height: 5),
          Text('Nilai akhir ${_decimal(grade.average)}',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          const SizedBox(height: 8),
          ClipRRect(borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: grade.average / 100,
              backgroundColor: AppColors.border, color: AppColors.brandBlueBright,
              minHeight: 3, semanticsLabel: 'Nilai akhir ${grade.subject}',
              semanticsValue: '${_decimal(grade.average)} dari 100')),
        ])),
      ]);
      final exams = Row(mainAxisSize: MainAxisSize.min, children: [
        _score('UTS', grade.uts), const SizedBox(width: 6), _score('UAS', grade.uas),
      ]);
      if (compact) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        heading, const SizedBox(height: 12), Align(alignment: Alignment.centerRight, child: exams),
      ]);
      return Row(children: [Expanded(child: heading), const SizedBox(width: 12), exams]);
    }),
  );

  Widget _score(String label, int value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
    child: Column(children: [
      Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
      Text('$value', style: const TextStyle(
        fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textDark)),
    ]),
  );

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.surface,
      borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border, width: 1.2)),
    child: child,
  );
}

class _SubjectGrade {
  const _SubjectGrade(this.subject, this.uts, this.uas, this.color);
  final String subject;
  final int uts;
  final int uas;
  final Color color;
  double get average => (uts + uas) / 2;
}
