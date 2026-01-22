// personalized_plan_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi_rath/services/localization_service.dart';

class PersonalizedPlanScreen extends StatelessWidget {
  final String landArea;
  final String soilType;
  final String irrigationType;

  const PersonalizedPlanScreen({
    super.key,
    required this.landArea,
    required this.soilType,
    required this.irrigationType,
  });

  String _tr(String key) => localizationService.translate(key);

  @override
  Widget build(BuildContext context) {
    final recommendedCrop = _getRecommendedCrop(soilType);
    final cropNameKey = _getCropNameKey(recommendedCrop);

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('personalized_plan_title')),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _buildCropHeader(recommendedCrop, cropNameKey),
          SizedBox(height: 16.h),
          _buildSummaryCard(context, recommendedCrop, cropNameKey),
          SizedBox(height: 16.h),
          _buildPlanStepCard(
            context,
            step: 1,
            title: _tr('personalized_plan_step1_title'),
            icon: Icons.landscape,
            color: Colors.brown,
            tasks: [_tr('plan_task_plow'), _tr('plan_task_manure')],
          ),
          _buildPlanStepCard(
            context,
            step: 2,
            title: _tr('personalized_plan_step2_title'),
            icon: Icons.grass,
            color: Colors.green,
            tasks: [_tr('plan_task_seeds'), _tr('plan_task_spacing')],
          ),
          _buildPlanStepCard(
            context,
            step: 3,
            title: _tr('personalized_plan_step3_title'),
            icon: Icons.science_outlined,
            color: Colors.blue,
            tasks: [_tr('plan_task_npk1'), _tr('plan_task_npk2')],
          ),
        ],
      ),
    );
  }

  Widget _buildCropHeader(String recommendedCrop, String cropNameKey) {
    return Card(
      elevation: 4,
      color: Colors.green.shade50,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Icon(Icons.eco, size: 56.sp, color: Colors.green[700]),
            SizedBox(height: 16.h),
            Text(
              _tr('recommended_crop'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
            ),
            SizedBox(height: 8.h),
            Text(
              _tr(cropNameKey),
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              recommendedCrop,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String recommendedCrop, String cropNameKey) {
    final color = Theme.of(context).primaryColor.withAlpha(25); // Modern replacement for .withOpacity(0.1)
    return Card(
      color: color,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge,
            children: [
              TextSpan(text: '${_tr('recommendation_based_on')} '),
              TextSpan(text: '$landArea ${_tr('acres_unit')}', style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' ${_tr('recommendation_land_area')} '),
              TextSpan(text: _tr(soilType), style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' ${_tr('recommendation_soil')} '),
              TextSpan(text: irrigationType.toLowerCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' ${_tr('recommendation_irrigation')} '),
              TextSpan(text: _tr(cropNameKey), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              const TextSpan(text: '.'),
            ],
          ),
        ),
      ),
    );
  }

  String _getRecommendedCrop(String soilType) {
    final s = soilType.toLowerCase();
    if (s.contains('loamy') || s.contains('दोमट') || s.contains('चिकणमाती')) return _tr('recommendation_crop_loamy');
    if (s.contains('sandy') || s.contains('रेतीली') || s.contains('वालुकामय')) return _tr('recommendation_crop_sandy');
    if (s.contains('clay') || s.contains('चिकनी') || s.contains('चिकण')) return _tr('recommendation_crop_clay');
    return _tr('recommendation_crop_default');
  }

  String _getCropNameKey(String recommendedCrop) {
    if (recommendedCrop.contains('Wheat') || recommendedCrop.contains('गहू')) return 'crop_advisory_wheat';
    if (recommendedCrop.contains('Rice') || recommendedCrop.contains('तांदूळ')) return 'crop_advisory_rice';
    if (recommendedCrop.contains('Cotton') || recommendedCrop.contains('कापूस')) return 'crop_advisory_cotton';
    if (recommendedCrop.contains('Maize') || recommendedCrop.contains('मका')) return 'crop_advisory_maize';
    return 'crop_advisory_rice';
  }

  Widget _buildPlanStepCard(
      BuildContext context, {
        required int step,
        required String title,
        required IconData icon,
        required Color color,
        required List<String> tasks,
      }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${_tr('Step')} $step', style: TextStyle(color: Colors.grey.shade600)),
                    Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            Divider(height: 24.h),
            ...tasks.map(
                  (task) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, color: Theme.of(context).primaryColor, size: 20.sp),
                    SizedBox(width: 8.w),
                    Expanded(child: Text(task)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
