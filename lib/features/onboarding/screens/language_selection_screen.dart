import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              _buildHeader(),
              SizedBox(height: 16.h),
              _buildInfoBox(),
              SizedBox(height: 16.h),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ScreenUtil().screenWidth > 600 ? 3 : 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 2.0,
                  ),
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    return _buildLanguageButton(languages[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 34.r,
          backgroundColor: Colors.green,
          child: Icon(Icons.agriculture, color: Colors.white, size: 34.sp),
        ),
        SizedBox(height: 12.h),
        Text(
          'Krishi Rath',
          style: TextStyle(
              fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6.h),
        Text(
          'Choose your language / अपनी भाषा चुनें',
          style: TextStyle(fontSize: 13.sp, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.volume_up, color: Colors.blue, size: 17.sp),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              'Tap any language to hear it spoken',
              style: TextStyle(fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(LanguageOption lang) {
    final bool isSpeaking = _currentlySpeaking == lang.languageCode;
    return Card(
      elevation: 2,
      color: isSpeaking ? Colors.green[100] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(
          color: isSpeaking ? Colors.green : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _speak(lang),
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                lang.nativeName,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 3.h),
              Text(
                lang.englishName,
                style: TextStyle(
                  fontSize: 11.sp,
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
