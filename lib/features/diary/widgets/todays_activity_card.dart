import 'package:flutter/material.dart';
import 'package:krishi_rath/features/diary/models/diary_models.dart';

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

  @override
  Widget build(BuildContext context) {
    bool isCompleted = activity.status == ActivityStatus.completed;
    // Check if details have been added
    bool hasDetails = activity.notes.isNotEmpty || activity.expenses > 0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCompleted ? Colors.green : Colors.grey.shade300,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(activity.icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        planTitle,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: isCompleted,
                  onChanged: onStatusChanged,
                  activeColor: Colors.green,
                ),
              ],
            ),
            const Divider(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                // Change style based on whether details exist
                icon: Icon(
                  hasDetails ? Icons.edit_note : Icons.note_add_outlined,
                  size: 16,
                  color: hasDetails ? Colors.green : null,
                ),
                label: Text(
                  hasDetails ? 'View/Edit Details' : 'Add Details',
                  style: TextStyle(color: hasDetails ? Colors.green : null),
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