import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import 'unavailable_report_success_screen.dart';
import '../models/teacher_schedule.dart';

class TeacherUnavailableScreen extends StatefulWidget {
  final TeacherSchedule schedule;

  const TeacherUnavailableScreen({super.key, required this.schedule});

  @override
  State<TeacherUnavailableScreen> createState() =>
      _TeacherUnavailableScreenState();
}

class _TeacherUnavailableScreenState extends State<TeacherUnavailableScreen> {
  static const List<String> _reasons = [
    'Sakit',
    'Izin',
    'Dinas',
    'Rapat',
    'Lainnya',
  ];

  static const Map<String, String> _defaultNotes = {
    'Sakit': 'Sedang berhalangan mengajar karena sakit.',
    'Izin': 'Sedang izin keperluan mendesak.',
    'Dinas': 'Mengikuti kegiatan dinas luar sekolah.',
    'Rapat': 'Mengikuti rapat sekolah.',
    'Lainnya': '',
  };

  String _selectedReason = 'Rapat';
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(
      text: _defaultNotes[_selectedReason],
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String get _cleanClassName => widget.schedule.className.replaceAll('-', '');

  void _selectReason(String reason) {
    final currentText = _noteController.text.trim();
    final isUsingDefault =
        currentText.isEmpty || _defaultNotes.values.contains(currentText);

    setState(() {
      _selectedReason = reason;
      if (isUsingDefault) {
        _noteController.text = _defaultNotes[reason] ?? '';
      }
    });
  }

  void _handleSubmit() {
    final note = _noteController.text.trim();
    if (note.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Harap isi keterangan ketidakhadiran Anda.',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.dangerRed,
        ),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => UnavailableReportSuccessScreen(
          subjectName: widget.schedule.subjectName,
          className: _cleanClassName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Column(
        children: [
          _buildTopHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                _buildScheduleBanner(),
                const SizedBox(height: 24),
                Text(
                  'Alasan tidak dapat mengajar',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                _buildReasonGrid(),
                const SizedBox(height: 22),
                Text(
                  'Keterangan',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 10),
                _buildNoteField(),
                const SizedBox(height: 18),
                _buildParentNoticeBanner(),
              ],
            ),
          ),
          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
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
                      'Lapor Berhalangan',
                      style: GoogleFonts.poppins(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Informasikan ketidakhadiran Anda',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2377D2), Color(0xFF1761B8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandBlue.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.menu_book_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.schedule.subjectName,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Kelas $_cleanClassName • ${widget.schedule.timeRange}',
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Hari ini',
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildReasonTile(_reasons[0])),
            const SizedBox(width: 12),
            Expanded(child: _buildReasonTile(_reasons[1])),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildReasonTile(_reasons[2])),
            const SizedBox(width: 12),
            Expanded(child: _buildReasonTile(_reasons[3])),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildReasonTile(_reasons[4])),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildReasonTile(String reason) {
    final isSelected = _selectedReason == reason;

    return Material(
      color: isSelected ? const Color(0xFFEAF3FE) : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isSelected ? const Color(0xFF6EAEEB) : AppColors.border,
          width: isSelected ? 1.3 : 1.1,
        ),
      ),
      child: InkWell(
        onTap: () => _selectReason(reason),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.brandBlue
                        : const Color(0xFFCBD5E1),
                    width: isSelected ? 5.5 : 1.6,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  reason,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.brandBlue
                        : AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _noteController,
        minLines: 4,
        maxLines: 5,
        style: GoogleFonts.poppins(fontSize: 13.5, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: 'Tuliskan keterangan alasan tidak dapat mengajar...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.textMuted.withValues(alpha: 0.7),
          ),
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFDCE4EE)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.brandBlue,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParentNoticeBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF0D8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF9A5212),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wali murid akan diberi tahu',
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF8F4B10),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Informasi ini akan dikirim kepada wali murid siswa kelas $_cleanClassName.',
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: const Color(0xFF9A5212),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _handleSubmit,
                  icon: const Icon(
                    Icons.send_outlined,
                    size: 19,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Kirim Informasi',
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Batal',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandBlue,
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
