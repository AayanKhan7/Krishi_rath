// personalized_plan_screen.dart
import 'package:flutter/material.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('personalized_plan_title')),
      ),
      body: ListView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        children: [
          _buildCropHeader(recommendedCrop, cropNameKey, screenWidth),
          SizedBox(height: screenWidth * 0.04),
          _buildSummaryCard(context, recommendedCrop, cropNameKey),
          SizedBox(height: screenWidth * 0.04),
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

  Widget _buildCropHeader(String recommendedCrop, String cropNameKey, double screenWidth) {
    return Card(
      elevation: 4,
      color: Colors.green.shade50,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            Icon(Icons.eco, size: screenWidth * 0.15, color: Colors.green[700]),
            SizedBox(height: screenWidth * 0.04),
            Text(
              _tr('recommended_crop'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              _tr(cropNameKey),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenWidth * 0.02),
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
        padding: const EdgeInsets.all(16.0),
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
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${_tr('Step')} $step', style: TextStyle(color: Colors.grey.shade600)),
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            ...tasks.map(
                  (task) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, color: Theme.of(context).primaryColor, size: 20),
                    const SizedBox(width: 8),
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
