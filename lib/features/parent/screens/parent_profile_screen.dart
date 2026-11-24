import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/profile_photo_controller.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/change_password_dialog.dart';
import '../../../core/utils/name_utils.dart';
import '../../../core/widgets/logout_confirm_dialog.dart';
import '../../../core/widgets/profile_avatar.dart';
import '../../../core/widgets/profile_photo_picker.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';
import '../models/parent_profile.dart';

const _headerGradient = [Color(0xFF1560C4), Color(0xFF2A86E0)];
const _cardBorder = Color(0xFFDCE7F5);
const _tintBlue = Color(0xFFEAF3FE);
const _dividerColor = Color(0xFFE9EFF6);
const _logoutRed = Color(0xFFDC2626);

/// Tab Profil wali murid: identitas, anak terhubung, dan pengaturan akun.
class ParentProfileScreen extends StatefulWidget {
  const ParentProfileScreen({super.key});

  @override
  State<ParentProfileScreen> createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  // Hasil edit lokal. TODO(api): hapus setelah ada endpoint update profil,
  // lalu muat ulang data dari AuthProvider.
  ParentProfile? _editedProfile;
  ProfilePhotoController? _photo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Controller dibuat ulang hanya bila akun yang login berganti.
    final userData = context.read<AuthProvider>().userData;
    final accountKey = ParentProfile.fromUserData(userData).accountKey;
    final ownerKey = 'parent_$accountKey';
    if (_photo?.ownerKey != ownerKey) {
      _photo?.dispose();
      _photo = ProfilePhotoController(ownerKey: ownerKey)..load();
    }
  }

  @override
  void dispose() {
    _photo?.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: color,
      ),
    );
  }

  Future<void> _editProfile(ParentProfile profile) async {
    final updated = await showDialog<ParentProfile>(
      context: context,
      builder: (_) => _EditProfileDialog(profile: profile),
    );
    if (updated == null || !mounted) return;

    setState(() => _editedProfile = updated);
    _showSnackBar('Profil berhasil diperbarui.', color: AppColors.successGreen);
  }

  Future<void> _changePassword() async {
    final changed = await showChangePasswordDialog(context);
    if (!changed || !mounted) return;

    _showSnackBar(
      'Kata sandi berhasil diperbarui.',
      color: AppColors.successGreen,
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showLogoutConfirmDialog(
      context,
      message: 'Anda perlu masuk kembali untuk melihat data anak.',
    );
    if (!confirmed || !mounted) return;

    final navigator = Navigator.of(context);
    await context.read<AuthProvider>().logout();
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<AuthProvider>().userData;
    final profile = _editedProfile ?? ParentProfile.fromUserData(userData);
    final student = profile.student;
    final photo = _photo!;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Hanya header yang dibangun ulang saat foto berubah.
        ListenableBuilder(
          listenable: photo,
          builder: (context, _) => _ProfileHeader(
            profile: profile,
            avatar: ProfileAvatar(
              initials: nameInitials(profile.fullName, fallback: 'W'),
              localPath: photo.localPath,
              photoUrl: profile.photoUrl,
              isLoading: photo.isBusy,
              onTap: () => showChangeProfilePhotoFlow(context, photo),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            children: [
              _IdentityCard(profile: profile),
              if (student != null) ...[
                const SizedBox(height: 18),
                _LinkedStudentCard(student: student),
              ],
              const SizedBox(height: 18),
              _ActionList(
                onEditProfile: () => _editProfile(profile),
                onChangePassword: _changePassword,
                onLogout: _confirmLogout,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final ParentProfile profile;
  final Widget avatar;

  const _ProfileHeader({required this.profile, required this.avatar});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final studentName = profile.student?.fullName;

    return Container(
      padding: EdgeInsets.fromLTRB(20, topInset + 14, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _headerGradient,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Profil',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          avatar,
          const SizedBox(height: 14),
          Text(
            profile.fullName,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            studentName == null ? 'Wali Murid' : 'Wali Murid • $studentName',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityCard extends StatelessWidget {
  final ParentProfile profile;

  const _IdentityCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          _IdentityRow(
            icon: Icons.person_outline_rounded,
            label: 'Nama',
            value: profile.fullName,
          ),
          const Divider(height: 1, color: _dividerColor),
          _IdentityRow(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            value: profile.email,
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
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

class _LinkedStudentCard extends StatelessWidget {
  final LinkedStudent student;

  const _LinkedStudentCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: _headerGradient,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _headerGradient.first.withValues(alpha: 0.22),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              nameInitials(student.fullName),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.brandBlue,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ANAK TERHUBUNG',
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    letterSpacing: 0.6,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                Text(
                  student.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Kelas ${student.className} • NIS ${student.nis}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.82),
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

class _ActionList extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;
  final VoidCallback onLogout;

  const _ActionList({
    required this.onEditProfile,
    required this.onChangePassword,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    const divider = Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: _dividerColor,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          _ActionTile(
            icon: Icons.edit_outlined,
            title: 'Edit Profil',
            onTap: onEditProfile,
          ),
          divider,
          _ActionTile(
            icon: Icons.lock_outline_rounded,
            title: 'Ubah Kata Sandi',
            onTap: onChangePassword,
          ),
          divider,
          _ActionTile(
            icon: Icons.logout_rounded,
            title: 'Keluar',
            onTap: onLogout,
            isDestructive: true,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? _logoutRed : AppColors.brandBlue;

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
                color: isDestructive ? const Color(0xFFFDECEC) : _tintBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: isDestructive ? _logoutRed : AppColors.textDark,
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

class _EditProfileDialog extends StatefulWidget {
  final ParentProfile profile;

  const _EditProfileDialog({required this.profile});

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.fullName);
    final email = widget.profile.email;
    _emailController = TextEditingController(text: email == '-' ? '' : email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    // TODO(api): kirim ke endpoint update profil wali murid.
    Navigator.of(context).pop(
      widget.profile.copyWith(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: dialogTitle('Edit Profil'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                style: GoogleFonts.poppins(fontSize: 13.5),
                decoration: dialogFieldDecoration(
                  'Nama Lengkap',
                  Icons.person_outline_rounded,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Nama tidak boleh kosong.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.poppins(fontSize: 13.5),
                decoration: dialogFieldDecoration(
                  'Email',
                  Icons.mail_outline_rounded,
                ),
                validator: (v) => _emailPattern.hasMatch(v?.trim() ?? '')
                    ? null
                    : 'Format email tidak valid.',
              ),
            ],
          ),
        ),
      ),
      actions: dialogActions(context, _save),
    );
  }
}
