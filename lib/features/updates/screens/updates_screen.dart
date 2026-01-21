import 'package:flutter/material.dart';
import 'package:krishi_rath/features/updates/widgets/update_card.dart';
import 'package:krishi_rath/services/localization_service.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamic paddings
    final horizontalPadding = screenWidth * 0.04;
    final verticalPadding = screenHeight * 0.02;
    final tabFontSize = screenWidth * 0.038;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            tr('updates_title'),
            style: TextStyle(fontSize: screenWidth * 0.045),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: TabBar(
              isScrollable: true,
              labelStyle: TextStyle(fontSize: tabFontSize, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: tabFontSize),
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
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
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
              SizedBox(height: verticalPadding * 2),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth * 0.5, screenHeight * 0.06),
                    textStyle: TextStyle(fontSize: screenWidth * 0.04),
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
