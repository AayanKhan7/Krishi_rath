import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi_rath/features/updates/widgets/update_card.dart';
import 'package:krishi_rath/services/localization_service.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            tr('updates_title'),
            style: TextStyle(fontSize: 17.sp),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: TabBar(
              isScrollable: true,
              labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 14.sp),
              tabs: [
                Tab(text: tr('updates_tab_all')),
                Tab(text: tr('updates_tab_alerts')),
                Tab(text: tr('updates_tab_tasks')),
                Tab(text: tr('updates_tab_market')),
                Tab(text: tr('updates_tab_weather')),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: ListView(
            children: [
              const UpdateCard(
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.red,
                titleKey: 'updates_pest_alert_title',
                descriptionKey: 'updates_pest_alert_desc',
                priority: 'High',
              ),
              const UpdateCard(
                icon: Icons.check_circle_outline,
                iconColor: Colors.orange,
                titleKey: 'updates_task_fertilizer_title',
                descriptionKey: 'updates_task_fertilizer_desc',
                priority: 'Medium',
              ),
              const UpdateCard(
                icon: Icons.trending_up,
                iconColor: Colors.green,
                titleKey: 'updates_market_price_title',
                descriptionKey: 'updates_market_price_desc',
                priority: 'Medium',
              ),
              SizedBox(height: 32.h),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(187.w, 48.h),
                    textStyle: TextStyle(fontSize: 15.sp),
                  ),
                  child: Text(tr('updates_load_more')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
