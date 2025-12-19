import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';
import 'student/academic_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIMA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A90E2)),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          insetPadding: EdgeInsets.only(bottom: 100, left: 16, right: 16),
        ),
      ),
      home: const LoginPage(),
      onGenerateRoute: (settings) {
        if (settings.name == '/academic') {
          int initialTab = 0;
          if (settings.arguments != null && settings.arguments is int) {
            initialTab = settings.arguments as int;
          }
          return MaterialPageRoute(
            builder: (context) => AcademicPage(initialTab: initialTab),
          );
        }
        return null;
      },
    );
  }
}
