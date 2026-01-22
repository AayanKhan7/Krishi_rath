import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi_rath/common/widgets/listen_button.dart';
import 'package:krishi_rath/features/crop_advisory/screens/crop_advisor_form_screen.dart';
import 'package:krishi_rath/services/localization_service.dart';

class CropAdvisoryScreen extends StatelessWidget {
  const CropAdvisoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('crop_advisory_title')),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Text(
              tr('crop_advisory_subtitle'),
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 20.h),
            _buildCustomizeCard(context, tr),
            SizedBox(height: 20.h),
            _buildCropGrid(context, tr),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizeCard(
      BuildContext context, String Function(String) tr) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CropAdvisorFormScreen()),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Icon(Icons.settings_suggest,
                  color: Colors.blue, size: 32.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  tr('crop_advisory_customize'),
                  style: TextStyle(
                      fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ),
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCropGrid(BuildContext context, String Function(String) tr) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      children: [
        _buildCropCard(tr, 'Rice', 'crop_advisory_rice', Colors.green),
        _buildCropCard(tr, 'Wheat', 'crop_advisory_wheat', Colors.orange),
        _buildCropCard(tr, 'Cotton', 'crop_advisory_cotton', Colors.grey),
        _buildCropCard(tr, 'Maize', 'crop_advisory_maize', Colors.yellow),
      ],
    );
  }

  Widget _buildCropCard(
      String Function(String) tr, String name, String nameKey, Color color) {
    final translatedName = tr(nameKey);
    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(Icons.grass, color: color),
            ),
            Text(
              translatedName,
              textAlign: TextAlign.center,
              style:
              TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            // Correctly pass the translated name to the ListenButton
            ListenButton(textToSpeak: translatedName),
          ],
        ),
      ),
    );
  }
}