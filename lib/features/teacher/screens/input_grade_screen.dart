import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../models/student_grade.dart';

// Warna khusus halaman ini (tint biru dari desain).
const _cardBorder = Color(0xFFD3E3F6);
const _tintBlue = Color(0xFFEAF3FE);

/// Halaman input/ubah nilai UTS & UAS satu siswa.
///
/// Halaman ini tidak mengubah data milik halaman lain. Hasil akhirnya
/// dikembalikan lewat `Navigator.pop(StudentGrade)`. Bila [onSubmit] diisi
/// (misal pemanggilan API), halaman menunggu proses itu selesai lebih dulu dan
/// menampilkan pesan bila gagal.
class InputGradeScreen extends StatefulWidget {
  final StudentGrade grade;
  final String subject;
  final String semester;
  final Future<void> Function(StudentGrade updated)? onSubmit;

  const InputGradeScreen({
    super.key,
    required this.grade,
    required this.subject,
    required this.semester,
    this.onSubmit,
  });

  @override
  State<InputGradeScreen> createState() => _InputGradeScreenState();
}

class _InputGradeScreenState extends State<InputGradeScreen> {
  late final TextEditingController _utsController;
  late final TextEditingController _uasController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _utsController = TextEditingController(text: '${widget.grade.uts}');
    _uasController = TextEditingController(text: '${widget.grade.uas}');
  }

  @override
  void dispose() {
    _utsController.dispose();
    _uasController.dispose();
    super.dispose();
  }

  int? get _uts => int.tryParse(_utsController.text);
  int? get _uas => int.tryParse(_uasController.text);

  bool get _isValid =>
      StudentGrade.isValidScore(_uts) && StudentGrade.isValidScore(_uas);

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_isValid || _isSaving) return;

    final updated = widget.grade.copyWith(uts: _uts, uas: _uas);
    setState(() => _isSaving = true);

    try {
      await widget.onSubmit?.call(updated);
      if (!mounted) return;
      Navigator.of(context).pop(updated);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyimpan nilai. Silakan coba lagi.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppColors.dangerRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _Header(onBack: () => Navigator.of(context).maybePop()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StudentCard(grade: widget.grade),
                    const SizedBox(height: 14),
                    _SubjectInfoCard(
                      subject: widget.subject,
                      semester: widget.semester,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _ScoreField(
                            label: 'Nilai UTS',
                            controller: _utsController,
                            onChanged: () => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _ScoreField(
                            label: 'Nilai UAS',
                            controller: _uasController,
                            onChanged: () => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _AverageBanner(uts: _uts, uas: _uas, isValid: _isValid),
                    const SizedBox(height: 16),
                    _SaveButton(
                      enabled: _isValid,
                      isLoading: _isSaving,
                      onPressed: _save,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: Color(0xFFE6EEF8))),
      ),
      child: Row(
        children: [
          Material(
            color: _tintBlue,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(12),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.accentBlue,
                  size: 26,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Input Nilai',
                style: GoogleFonts.poppins(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                'Perbarui nilai siswa',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final StudentGrade grade;

  const _StudentCard({required this.grade});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F1FD), Color(0xFFF6FAFF)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBFD7F2)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFDCEAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              grade.initials,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.accentBlue,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grade.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  'NIS ${grade.nis} • Kelas ${grade.className}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textMuted,
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

class _SubjectInfoCard extends StatelessWidget {
  final String subject;
  final String semester;

  const _SubjectInfoCard({required this.subject, required this.semester});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          _InfoRow(label: 'Mata Pelajaran', value: subject),
          const Divider(height: 1, color: Color(0xFFE9EFF6)),
          _InfoRow(label: 'Semester', value: semester),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _ScoreField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isValid = StudentGrade.isValidScore(int.tryParse(controller.text));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isValid ? _cardBorder : AppColors.dangerRed,
          width: isValid ? 1 : 1.4,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
          TextField(
            controller: controller,
            onChanged: (_) => onChanged(),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: isValid ? AppColors.accentBlue : AppColors.dangerRed,
            ),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 6),
            ),
          ),
          Text(
            isValid ? 'dari ${StudentGrade.maxScore}' : 'Isi 0–100',
            style: GoogleFonts.poppins(
              fontSize: 9.5,
              color: isValid ? AppColors.textMuted : AppColors.dangerRed,
            ),
          ),
        ],
      ),
    );
  }
}

class _AverageBanner extends StatelessWidget {
  final int? uts;
  final int? uas;
  final bool isValid;

  const _AverageBanner({
    required this.uts,
    required this.uas,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    final String title;
    final String subtitle;
    if (isValid) {
      final average = (uts! + uas!) / 2;
      final predicate = GradePredicate.fromAverage(average);
      title = 'Nilai rata-rata: ${formatScore(average)}';
      subtitle = 'Predikat ${predicate.letter} • ${predicate.description}';
    } else {
      title = 'Nilai rata-rata: -';
      subtitle = 'Lengkapi nilai UTS dan UAS (0–100)';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE5EFFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.accentBlue,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.accentBlue,
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

class _SaveButton extends StatelessWidget {
  final bool enabled;
  final bool isLoading;
  final VoidCallback onPressed;

  const _SaveButton({
    required this.enabled,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final active = enabled && !isLoading;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled ? 1 : 0.5,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1666C3), Color(0xFF2580DC)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentBlue.withValues(alpha: 0.28),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: active ? onPressed : null,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Simpan Nilai',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
