// UI preview only; production continues to use main.dart and team authentication.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_colors.dart';
import 'features/parent/screens/parent_academic_screen.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Pratinjau Akademik Wali Murid',
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.brandBlue),
    textTheme: GoogleFonts.poppinsTextTheme(),
  ),
  home: const ParentAcademicScreen(),
));
