import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';
import '../providers/teacher_provider.dart';
import '../teacher_name.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  String? _overrideName;
  String? _overrideEmail;
  String? _overrideSubject;

  // Format 18 digit NUPTK/NIP menjadi "19870512 201203 1 004" seperti desain Figma
  static String _formatNip(String raw) {
    final digits = raw.replaceAll(RegExp(r'\s+'), '');
    if (digits.length == 18) {
      return '${digits.substring(0, 8)} ${digits.substring(8, 14)} '
          '${digits.substring(14, 15)} ${digits.substring(15)}';
    }
    return raw;
  }

  Future<void> _handleLogout(BuildContext context) async {
    final navigator = Navigator.of(context);
    final teacher = context.read<TeacherProvider>();
    await context.read<AuthProvider>().logout();
    teacher.clear();
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  void _showEditProfileDialog({
    required String currentName,
    required String currentEmail,
    required String currentSubject,
  }) {
    final nameController = TextEditingController(text: currentName);
    final emailController = TextEditingController(text: currentEmail);
    final subjectController = TextEditingController(text: currentSubject);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Edit Profil Guru',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: GoogleFonts.poppins(fontSize: 13.5),
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    labelStyle: GoogleFonts.poppins(fontSize: 12.5),
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.poppins(fontSize: 13.5),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: GoogleFonts.poppins(fontSize: 12.5),
                    prefixIcon: const Icon(Icons.mail_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: subjectController,
                  style: GoogleFonts.poppins(fontSize: 13.5),
                  decoration: InputDecoration(
                    labelText: 'Bidang Studi',
                    labelStyle: GoogleFonts.poppins(fontSize: 12.5),
                    prefixIcon: const Icon(Icons.school_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(color: AppColors.textMuted),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (nameController.text.trim().isNotEmpty) {
                    _overrideName = nameController.text.trim();
                  }
                  if (emailController.text.trim().isNotEmpty) {
                    _overrideEmail = emailController.text.trim();
                  }
                  if (subjectController.text.trim().isNotEmpty) {
                    _overrideSubject = subjectController.text.trim();
                  }
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Profil berhasil diperbarui.',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Simpan',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Ubah Kata Sandi',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPassController,
                  obscureText: true,
                  style: GoogleFonts.poppins(fontSize: 13.5),
                  decoration: InputDecoration(
                    labelText: 'Kata Sandi Lama',
                    labelStyle: GoogleFonts.poppins(fontSize: 12.5),
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPassController,
                  obscureText: true,
                  style: GoogleFonts.poppins(fontSize: 13.5),
                  decoration: InputDecoration(
                    labelText: 'Kata Sandi Baru (Min. 8 Karakter)',
                    labelStyle: GoogleFonts.poppins(fontSize: 12.5),
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmPassController,
                  obscureText: true,
                  style: GoogleFonts.poppins(fontSize: 13.5),
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Kata Sandi Baru',
                    labelStyle: GoogleFonts.poppins(fontSize: 12.5),
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(color: AppColors.textMuted),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (newPassController.text.length < 8) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Kata sandi baru minimal 8 karakter.',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: AppColors.dangerRed,
                    ),
                  );
                  return;
                }
                if (newPassController.text != confirmPassController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Konfirmasi kata sandi tidak cocok.',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: AppColors.dangerRed,
                    ),
                  );
                  return;
                }
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Kata sandi berhasil diperbarui.',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Simpan',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final teacher = context.watch<TeacherProvider>();
    final profile = auth.teacherProfile;
    final userMap = auth.userData?['user'] as Map<String, dynamic>?;

    final fullName =
        _overrideName ??
        (profile?['full_name'] as String?) ??
        'Ahmad Hidayat, S.Pd.';
    final rawNip = (profile?['nuptk'] as String?) ?? '198705122012031004';
    final formattedNip = _formatNip(rawNip);
    final email =
        _overrideEmail ??
        (userMap?['email'] as String?) ??
        (auth.userData?['email'] as String?) ??
        'ahmad@smartschool.id';

    final schedules = teacher.todaySchedules;
    final subjectName =
        _overrideSubject ??
        (schedules.isNotEmpty ? schedules.first.subjectName : 'Matematika');
    final homeroomClass = schedules.isNotEmpty
        ? schedules.first.className.replaceAll('-', '')
        : '8A';

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildHeader(
          context: context,
          fullName: fullName,
          subjectName: subjectName,
          homeroomClass: homeroomClass,
          onEditTap: () => _showEditProfileDialog(
            currentName: fullName,
            currentEmail: email,
            currentSubject: subjectName,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            children: [
              _buildIdentityCard(
                nip: formattedNip,
                email: email,
                subjectName: subjectName,
              ),
              const SizedBox(height: 16),
              _buildStatsRow(homeroomClass: homeroomClass),
              const SizedBox(height: 16),
              _buildActionsCard(
                context: context,
                onEditProfile: () => _showEditProfileDialog(
                  currentName: fullName,
                  currentEmail: email,
                  currentSubject: subjectName,
                ),
                onChangePassword: _showChangePasswordDialog,
                onLogout: () => _handleLogout(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required String fullName,
    required String subjectName,
    required String homeroomClass,
    required VoidCallback onEditTap,
  }) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.fromLTRB(20, topInset + 16, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1560C4), Color(0xFF2882DF)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Profil Guru',
                style: GoogleFonts.poppins(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Material(
                color: Colors.white.withValues(alpha: 0.18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
                child: InkWell(
                  onTap: onEditTap,
                  borderRadius: BorderRadius.circular(12),
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 98,
            height: 98,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: 94,
                  height: 94,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3A97F4), Color(0xFF1A6FCC)],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.9),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.14),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    teacherInitials(fullName),
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    elevation: 2,
                    shadowColor: Colors.black.withValues(alpha: 0.15),
                    child: InkWell(
                      onTap: onEditTap,
                      borderRadius: BorderRadius.circular(10),
                      child: const SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 16,
                          color: AppColors.brandBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            fullName,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Guru $subjectName • Wali Kelas $homeroomClass',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityCard({
    required String nip,
    required String email,
    required String subjectName,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _IdentityRow(
            icon: Icons.person_outline_rounded,
            label: 'NIP',
            value: nip,
          ),
          const Divider(height: 1, color: Color(0xFFE9EFF6)),
          _IdentityRow(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            value: email,
          ),
          const Divider(height: 1, color: Color(0xFFE9EFF6)),
          _IdentityRow(
            icon: Icons.school_outlined,
            label: 'Bidang Studi',
            value: subjectName,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow({required String homeroomClass}) {
    return Row(
      children: [
        const Expanded(
          child: _ProfileStatCard(
            icon: Icons.groups_outlined,
            value: '3',
            label: 'Kelas Diampu',
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: _ProfileStatCard(
            icon: Icons.menu_book_outlined,
            value: '18',
            label: 'Jam / Minggu',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ProfileStatCard(
            icon: Icons.calendar_today_outlined,
            value: homeroomClass,
            label: 'Wali Kelas',
          ),
        ),
      ],
    );
  }

  Widget _buildActionsCard({
    required BuildContext context,
    required VoidCallback onEditProfile,
    required VoidCallback onChangePassword,
    required VoidCallback onLogout,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _ProfileActionTile(
            icon: Icons.edit_outlined,
            iconColor: AppColors.brandBlue,
            iconBackground: const Color(0xFFEAF3FE),
            title: 'Edit Profil',
            titleColor: AppColors.textDark,
            onTap: onEditProfile,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0xFFE9EFF6)),
          _ProfileActionTile(
            icon: Icons.lock_outline_rounded,
            iconColor: AppColors.brandBlue,
            iconBackground: const Color(0xFFEAF3FE),
            title: 'Ubah Kata Sandi',
            titleColor: AppColors.textDark,
            onTap: onChangePassword,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0xFFE9EFF6)),
          _ProfileActionTile(
            icon: Icons.logout_rounded,
            iconColor: const Color(0xFFDC2626),
            iconBackground: const Color(0xFFFDECEC),
            title: 'Keluar',
            titleColor: const Color(0xFFDC2626),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}

class _IdentityRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _IdentityRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.brandBlue, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
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

class _ProfileStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _ProfileStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.brandBlue, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.brandBlue,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final Color titleColor;
  final VoidCallback onTap;

  const _ProfileActionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
