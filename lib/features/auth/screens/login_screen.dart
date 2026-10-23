import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // NUPTK minimal 16 digit (data seeder 18 digit), NISM siswa jauh lebih pendek
  static const int _nuptkMinLength = 16;

  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;
    final isTeacher = identifier.length >= _nuptkMinLength;

    bool success = false;
    if (isTeacher) {
      success = await auth.loginTeacher(nuptk: identifier, password: password);
    } else {
      success = await auth.loginParent(nis: identifier, password: password);
    }

    if (success && mounted) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Berhasil masuk sebagai ${isTeacher ? "Guru" : "Wali Murid"}',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.successGreen,
        ),
      );
      // Nanti akan diarahkan ke Dashboard Guru atau Dashboard Ortu
    }
  }

  void _showHelpInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Silakan hubungi admin sekolah untuk bantuan akun Anda.',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        backgroundColor: AppColors.brandBlue,
      ),
    );
  }

  // ==========================================
  // DIALOG LUPA KATA SANDI (GMAIL OTP)
  // ==========================================
  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    final otpController = TextEditingController();
    final newPasswordController = TextEditingController();
    int currentStep = 1; // 1: Input Email, 2: Input OTP & Sandi Baru

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final auth = context.watch<AuthProvider>();

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                currentStep == 1
                    ? 'Pemulihan Kata Sandi'
                    : 'Verifikasi Kode OTP',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppColors.textDark,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (auth.errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.dangerRed.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          auth.errorMessage!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.dangerRed,
                          ),
                        ),
                      ),
                    if (currentStep == 1) ...[
                      Text(
                        'Masukkan alamat surel Gmail yang terdaftar untuk menerima 6 digit kode verifikasi.',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'nama@gmail.com',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Kode 6 digit telah dikirim ke ${emailController.text}. Masukkan kode tersebut dan buat kata sandi baru Anda.',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 6,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '000000',
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Kata Sandi Baru (Min. 8 Karakter)',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    auth.clearError();
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    'Batal',
                    style: GoogleFonts.poppins(color: AppColors.textMuted),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          final navigator = Navigator.of(ctx);
                          final messenger = ScaffoldMessenger.of(context);

                          if (currentStep == 1) {
                            if (emailController.text.trim().isEmpty) return;
                            final sent = await auth.requestOtp(
                              emailController.text.trim(),
                            );
                            if (sent) {
                              setDialogState(() => currentStep = 2);
                            }
                          } else {
                            if (otpController.text.length != 6 ||
                                newPasswordController.text.length < 8) {
                              return;
                            }
                            final reset = await auth.resetPassword(
                              email: emailController.text.trim(),
                              otp: otpController.text.trim(),
                              newPassword: newPasswordController.text,
                            );
                            if (reset && mounted) {
                              navigator.pop();
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Kata sandi berhasil diperbarui. Silakan login kembali.',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: AppColors.successGreen,
                                ),
                              );
                            }
                          }
                        },
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          currentStep == 1 ? 'Kirim OTP' : 'Simpan Sandi',
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.headerTint, Color(0xFFF5F9FE)],
              ),
            ),
            child: Stack(
              children: [
                // Ornamen lingkaran di pojok kanan atas
                Positioned(
                  top: -30,
                  right: -58,
                  child: Container(
                    width: 176,
                    height: 176,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.brandBlue.withValues(alpha: 0.06),
                        width: 30,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    SafeArea(bottom: false, child: _buildBrandHeader()),
                    _buildFormCard(auth),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 28, 24, 72),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.brandBlueBright, AppColors.brandBlueDeep],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandBlue.withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.school_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart School',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brandBlueDeep,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Sekolah pintar, masa depan hebat',
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

  Widget _buildFormCard(AuthProvider auth) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        // Kartu memenuhi sisa layar di bawah header
        minHeight: MediaQuery.sizeOf(context).height * 0.7,
      ),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PORTAL SEKOLAH',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.brandBlue,
                letterSpacing: 1.6,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Selamat Datang',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
                letterSpacing: -0.8,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Masuk untuk melanjutkan aktivitas sekolah Anda.',
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),

            // Info penggunaan NUPTK / NISM
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.brandBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          color: AppColors.textMuted,
                        ),
                        children: [
                          const TextSpan(text: 'Gunakan '),
                          _boldBlueSpan('NUPTK'),
                          const TextSpan(text: ' untuk Guru atau '),
                          _boldBlueSpan('NISM'),
                          const TextSpan(text: ' siswa untuk Wali Murid.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (auth.errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.dangerRed.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.dangerRed.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  auth.errorMessage!,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.dangerRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            // Input Identifier (NISM / NUPTK)
            _buildFieldLabel('NISM / NUPTK'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _identifierController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: AppColors.textDark,
              ),
              decoration: _inputDecoration(
                hintText: 'Masukkan NISM atau NUPTK',
                prefixIcon: Icons.person_outline,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'NISM / NUPTK wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // Input Password
            _buildFieldLabel('Kata sandi'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: AppColors.textDark,
              ),
              decoration: _inputDecoration(
                hintText: 'Masukkan kata sandi',
                prefixIcon: Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.lock_outline
                        : Icons.lock_open_outlined,
                    color: AppColors.textMuted,
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Kata sandi wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            // Lupa Sandi Link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _showForgotPasswordDialog,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Lupa kata sandi?',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Tombol Masuk
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brandBlue.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: auth.isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandBlue,
                  disabledBackgroundColor: AppColors.brandBlue.withValues(
                    alpha: 0.7,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: auth.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Masuk',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 22),

            // Bantuan
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Butuh bantuan? ',
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showHelpInfo,
                    child: Text(
                      'Hubungi admin sekolah',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brandBlue,
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

  TextSpan _boldBlueSpan(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.brandBlue,
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 3),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark.withValues(alpha: 0.85),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: AppColors.textMuted.withValues(alpha: 0.7),
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 4),
        child: Icon(prefixIcon, color: AppColors.textMuted, size: 22),
      ),
      suffixIcon: suffixIcon == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(right: 8),
              child: suffixIcon,
            ),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.brandBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.dangerRed, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.dangerRed, width: 1.5),
      ),
    );
  }
}
