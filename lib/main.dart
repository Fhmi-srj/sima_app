import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_screen.dart';
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
        // Add page transition theme
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/academic') {
          int initialTab = 0;
          if (settings.arguments != null && settings.arguments is int) {
            initialTab = settings.arguments as int;
          }
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) =>
                AcademicPage(initialTab: initialTab),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  );
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0),
                      end: Offset.zero,
                    ).animate(curvedAnimation),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 350),
          );
        }
        return null;
      },
    );
  }
}
