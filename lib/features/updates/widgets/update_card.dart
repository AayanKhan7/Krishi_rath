import 'package:flutter/material.dart';
import 'package:krishi_rath/common/widgets/listen_button.dart';
import 'package:krishi_rath/common/widgets/priority_tag.dart';
import 'package:krishi_rath/services/localization_service.dart';

class UpdateCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String titleKey;
  final String descriptionKey;
  final String priority;

  const UpdateCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.titleKey,
    required this.descriptionKey,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.04;
    final verticalPadding = screenHeight * 0.015;
    final iconSize = screenWidth * 0.07; // scales with screen width
    final titleFontSize = screenWidth * 0.045;
    final descriptionFontSize = screenWidth * 0.038;

    final textToSpeak = '${tr(titleKey)}. ${tr(descriptionKey)}';

    return Card(
      margin: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: iconSize),
            SizedBox(width: horizontalPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          tr(titleKey),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: titleFontSize),
                        ),
                      ),
                      PriorityTag(priority: priority),
                    ],
                  ),
                  SizedBox(height: verticalPadding),
                  Text(
                    tr(descriptionKey),
                    style: TextStyle(fontSize: descriptionFontSize),
                  ),
                  SizedBox(height: verticalPadding),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ListenButton(textToSpeak: textToSpeak),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
