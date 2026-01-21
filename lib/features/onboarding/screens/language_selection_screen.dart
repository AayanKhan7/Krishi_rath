import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:krishi_rath/features/dashboard/screens/dashboard_screen.dart';
import 'package:krishi_rath/services/localization_service.dart'; // Import the service

// A simple data class to hold language information
class LanguageOption {
  final String englishName;
  final String nativeName;
  final String languageCode; // e.g., "hi-IN"
  final String localeCode; // e.g., "hi"

  LanguageOption(this.englishName, this.nativeName, this.languageCode, this.localeCode);
}

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late FlutterTts flutterTts;
  String? _currentlySpeaking;

  final List<LanguageOption> languages = [
    LanguageOption('English', 'English', 'en-US', 'en'),
    LanguageOption('Hindi', 'हिन्दी', 'hi-IN', 'hi'),
    LanguageOption('Marathi', 'मराठी', 'mr-IN', 'mr'),
    // LanguageOption('Assamese', 'অসমীয়া', 'as-IN', 'as'),
    // LanguageOption('Bengali', 'বাংলা', 'bn-IN', 'bn'),
    // LanguageOption('Bodo', 'बड़ो', 'brx-IN', 'brx'),
    // ... other languages commented out
  ];

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();

    // Set up TTS completion handler
    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _currentlySpeaking = null;
        });
        _navigateToDashboard();
      }
    });

    // Set speech rate for better pronunciation
    flutterTts.setSpeechRate(0.4);
    flutterTts.setPitch(1.0);
  }

  // Function to speak the selected language name AND set the app's language
  Future<void> _speak(LanguageOption language) async {
    await flutterTts.stop();
    localizationService.setLocale(Locale(language.localeCode));

    setState(() {
      _currentlySpeaking = language.languageCode;
    });

    try {
      await flutterTts.setLanguage(language.languageCode);
      await flutterTts.speak(language.nativeName);
    } catch (e) {
      print('TTS error for ${language.englishName}: $e');
      await flutterTts.setLanguage('en-US');
      await flutterTts.speak(language.englishName);
    }
  }

  void _navigateToDashboard() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.015),
              _buildHeader(screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildInfoBox(screenWidth),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 600 ? 3 : 2,
                    crossAxisSpacing: screenWidth * 0.03,
                    mainAxisSpacing: screenHeight * 0.015,
                    childAspectRatio: 2.0,
                  ),
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    return _buildLanguageButton(languages[index], screenWidth);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Column(
      children: [
        CircleAvatar(
          radius: screenWidth * 0.09,
          backgroundColor: Colors.green,
          child: Icon(Icons.agriculture, color: Colors.white, size: screenWidth * 0.09),
        ),
        SizedBox(height: screenWidth * 0.03),
        Text(
          'Krishi Rath',
          style: TextStyle(
              fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: screenWidth * 0.015),
        Text(
          'Choose your language / अपनी भाषा चुनें',
          style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoBox(double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenWidth * 0.025),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.volume_up, color: Colors.blue, size: screenWidth * 0.045),
          SizedBox(width: screenWidth * 0.015),
          Flexible(
            child: Text(
              'Tap any language to hear it spoken',
              style: TextStyle(fontSize: screenWidth * 0.035),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(LanguageOption lang, double screenWidth) {
    final bool isSpeaking = _currentlySpeaking == lang.languageCode;
    return Card(
      elevation: 2,
      color: isSpeaking ? Colors.green[100] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSpeaking ? Colors.green : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _speak(lang),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.025),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                lang.nativeName,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: screenWidth * 0.008),
              Text(
                lang.englishName,
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
