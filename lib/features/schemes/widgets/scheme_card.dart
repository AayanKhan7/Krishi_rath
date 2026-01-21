import 'package:flutter/material.dart';
import 'package:krishi_rath/common/widgets/listen_button.dart';
import 'package:krishi_rath/common/widgets/priority_tag.dart';
import 'package:krishi_rath/services/localization_service.dart';

class SchemeCard extends StatelessWidget {
  final String titleKey;
  final String descriptionKey;
  final String statusKey;
  final String amountKey;
  final String deadline;
  final String helpline;
  final String tagKey;

  const SchemeCard({
    super.key,
    required this.titleKey,
    required this.descriptionKey,
    required this.statusKey,
    required this.amountKey,
    required this.deadline,
    required this.helpline,
    required this.tagKey,
  });

  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamic sizing
    final horizontalPadding = screenWidth * 0.04;
    final verticalPadding = screenHeight * 0.015;
    final titleFontSize = screenWidth * 0.045;
    final descriptionFontSize = screenWidth * 0.038;
    final amountFontSize = screenWidth * 0.043;
    final infoFontSize = screenWidth * 0.035;

    // Translate text
    final title = tr(titleKey);
    final description = tr(descriptionKey);
    final status = tr(statusKey);
    final amount = tr(amountKey);
    final textToSpeak = '$title. $description';

    return Card(
      margin: EdgeInsets.only(bottom: verticalPadding * 2),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.06,
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.monetization_on, color: Colors.white, size: screenWidth * 0.06),
                ),
                SizedBox(width: horizontalPadding),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize,
                    ),
                  ),
                ),
                PriorityTag(priority: tr(tagKey)),
              ],
            ),
            SizedBox(height: verticalPadding),
            Text(
              description,
              style: TextStyle(fontSize: descriptionFontSize),
            ),
            SizedBox(height: verticalPadding * 2),
            Row(
              children: [
                Chip(
                  label: Text(status),
                  backgroundColor: Colors.green[100],
                  labelStyle: TextStyle(
                    color: Colors.green[800],
                    fontSize: infoFontSize,
                  ),
                ),
                SizedBox(width: horizontalPadding),
                Text(
                  amount,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: amountFontSize,
                  ),
                ),
                Spacer(),
                ListenButton(textToSpeak: textToSpeak),
              ],
            ),
            Divider(height: verticalPadding * 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${tr('schemes_deadline')}: $deadline',
                  style: TextStyle(color: Colors.grey, fontSize: infoFontSize),
                ),
                Text(
                  '${tr('schemes_helpline')}: $helpline',
                  style: TextStyle(color: Colors.grey, fontSize: infoFontSize),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
