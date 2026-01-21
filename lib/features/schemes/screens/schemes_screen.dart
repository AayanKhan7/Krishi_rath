import 'package:flutter/material.dart';
import 'package:krishi_rath/features/schemes/widgets/scheme_card.dart';
import 'package:krishi_rath/services/localization_service.dart';

class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamic paddings and font sizes
    final horizontalPadding = screenWidth * 0.04;
    final verticalSpacing = screenHeight * 0.02;
    final subtitleFontSize = screenWidth * 0.045;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('schemes_title')),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalSpacing),
        children: [
          Text(
            tr('schemes_subtitle'),
            style: TextStyle(fontSize: subtitleFontSize),
          ),
          SizedBox(height: verticalSpacing),
          // Scheme cards
          const SchemeCard(
            titleKey: 'schemes_pm_kisan_title',
            descriptionKey: 'schemes_pm_kisan_desc',
            statusKey: 'schemes_status_active',
            amountKey: 'schemes_amount_per_year',
            deadline: '31 March 2025',
            helpline: '155261',
            tagKey: 'priority_high',
          ),
          SizedBox(height: verticalSpacing),
          const SchemeCard(
            titleKey: 'schemes_crop_insurance_title',
            descriptionKey: 'schemes_crop_insurance_desc',
            statusKey: 'schemes_status_open',
            amountKey: 'schemes_amount_upto',
            deadline: '15 January 2025',
            helpline: '14447',
            tagKey: 'priority_high',
          ),
        ],
      ),
    );
  }
}
