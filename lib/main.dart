import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_rath/features/onboarding/screens/language_selection_screen.dart';
import 'package:krishi_rath/services/localization_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const KrishiRathApp());
}

class KrishiRathApp extends StatelessWidget {
  const KrishiRathApp({super.key});

  @override
  Widget build(BuildContext context) {
    // This AnimatedBuilder will rebuild the entire app with new translations
    // whenever the language is changed in the localizationService.
    return AnimatedBuilder(
      animation: localizationService,
      builder: (context, child) {
        return MaterialApp(
          title: 'Krishi Rath',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            // Corrected from CardTheme to CardThemeData
            cardTheme: CardThemeData(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // The starting screen of the application
          home: const LanguageSelectionScreen(),
        );
      },
    );
  }
}