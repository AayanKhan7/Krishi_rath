import 'package:flutter/material.dart';
import 'package:krishi_rath/features/diary/models/diary_models.dart';
import 'package:krishi_rath/services/localization_service.dart';

class TodaysActivityCard extends StatelessWidget {
  final Activity activity;
  final String planTitle;
  final Function(bool?) onStatusChanged;
  final VoidCallback onAddDetails;

  const TodaysActivityCard({
    super.key,
    required this.activity,
    required this.planTitle,
    required this.onStatusChanged,
    required this.onAddDetails,
  });

  String _tr(String key) => localizationService.translate(key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double padding = screenWidth * 0.03;
    final double iconSize = screenWidth * 0.07;
    final double titleFontSize = screenWidth * 0.045;
    final double subtitleFontSize = screenWidth * 0.035;
    final double buttonFontSize = screenWidth * 0.035;
    final double spacing = screenHeight * 0.008;

    bool isCompleted = activity.status == ActivityStatus.completed;
    bool hasDetails = activity.notes.isNotEmpty || activity.expenses > 0;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: spacing),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCompleted ? Colors.green : Colors.grey.shade300,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(activity.icon, color: Theme.of(context).primaryColor, size: iconSize),
                SizedBox(width: padding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      SizedBox(height: spacing),
                      Text(
                        planTitle,
                        style: TextStyle(fontSize: subtitleFontSize, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: isCompleted,
                  onChanged: onStatusChanged,
                  activeColor: Colors.green,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            Divider(height: spacing * 4),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: Icon(
                  hasDetails ? Icons.edit_note : Icons.note_add_outlined,
                  size: iconSize * 0.8,
                  color: hasDetails ? Colors.green : null,
                ),
                label: Text(
                  hasDetails ? _tr('diary_view_edit_details') : _tr('diary_add_details'),
                  style: TextStyle(
                    fontSize: buttonFontSize,
                    color: hasDetails ? Colors.green : null,
                  ),
                ),
                onPressed: onAddDetails,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
