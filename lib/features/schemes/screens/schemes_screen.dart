import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi_rath/features/schemes/widgets/scheme_card.dart';
import 'package:krishi_rath/services/localization_service.dart';

class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('schemes_title')),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        children: [
          Text(
            tr('schemes_subtitle'),
            style: TextStyle(fontSize: 17.sp),
          ),
          SizedBox(height: 16.h),
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
          SizedBox(height: 16.h),
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
