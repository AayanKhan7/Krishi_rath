import 'package:flutter/material.dart';
import 'package:krishi_rath/features/diary/models/diary_models.dart';
import 'package:krishi_rath/features/diary/screens/full_calendar_screen.dart';
import 'package:krishi_rath/features/diary/services/diary_service.dart';
import 'package:krishi_rath/features/diary/widgets/todays_activity_card.dart';
import 'package:krishi_rath/services/localization_service.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final DiaryService _diaryService = DiaryService();
  late Future<List<CropPlan>> _plansFuture;

  // Translation helper
  String _tr(String key) => localizationService.translate(key);

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  void _loadPlans() {
    _plansFuture = _diaryService.getPlans();
  }

  void _updateActivityStatus(CropPlan plan, Activity activity, bool isCompleted) {
    setState(() {
      final newStatus = isCompleted ? ActivityStatus.completed : ActivityStatus.pending;
      activity.status = newStatus;
      _diaryService.updateActivityStatus(plan.id, activity.id, newStatus);
    });
  }

  void _showAddDetailsModal(CropPlan plan, Activity activity) {
    final expensesController = TextEditingController(text: activity.expenses > 0 ? activity.expenses.toString() : '');
    final notesController = TextEditingController(text: activity.notes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final padding = screenWidth * 0.05;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: padding,
            left: padding,
            right: padding,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _tr('diary_details_for').replaceFirst('{activity}', activity.title),
                  style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextField(
                  controller: expensesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _tr('diary_expenses'),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.currency_rupee),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: _tr('diary_add_notes'),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.note),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, screenHeight * 0.06),
                  ),
                  onPressed: () {
                    final expenses = double.tryParse(expensesController.text) ?? 0.0;
                    final notes = notesController.text;
                    setState(() {
                      activity.expenses = expenses;
                      activity.notes = notes;
                      _diaryService.updateActivityDetails(plan.id, activity.id, expenses, notes);
                    });
                    Navigator.pop(context);
                  },
                  child: Text(_tr('diary_save_details')),
                ),
                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('diary_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _loadPlans()),
          ),
        ],
      ),
      body: FutureBuilder<List<CropPlan>>(
        future: _plansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(_tr('diary_no_plans')));
          }

          final allPlans = snapshot.data!;
          final Map<CropPlan, List<Activity>> todaysActivitiesByPlan = {};
          for (var plan in allPlans) {
            final todaysActivities = plan.activities.where((act) {
              final scheduledDate = act.scheduledDate;
              return scheduledDate.year == today.year &&
                  scheduledDate.month == today.month &&
                  scheduledDate.day == today.day;
            }).toList();
            if (todaysActivities.isNotEmpty) {
              todaysActivitiesByPlan[plan] = todaysActivities;
            }
          }

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: screenHeight * 0.02),
            children: [
              _buildSectionHeader(_tr('diary_my_crop_plans'), Icons.eco_outlined, screenWidth),
              SizedBox(height: screenHeight * 0.01),
              ...allPlans.map((plan) => _buildAtAGlanceCard(context, plan, screenWidth, screenHeight)),
              SizedBox(height: screenHeight * 0.03),
              _buildSectionHeader(_tr('diary_upcoming_tasks'), Icons.today, screenWidth),
              SizedBox(height: screenHeight * 0.01),
              if (todaysActivitiesByPlan.isNotEmpty)
                ...todaysActivitiesByPlan.entries.expand((entry) {
                  final plan = entry.key;
                  final activities = entry.value;
                  return activities.map((activity) => TodaysActivityCard(
                    activity: activity,
                    planTitle: plan.title,
                    onStatusChanged: (isCompleted) =>
                        _updateActivityStatus(plan, activity, isCompleted ?? false),
                    onAddDetails: () => _showAddDetailsModal(plan, activity),
                  ));
                })
              else
                Center(child: Text(_tr('diary_no_tasks_today'))),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAtAGlanceCard(BuildContext context, CropPlan plan, double screenWidth, double screenHeight) {
    final completed = plan.activities.where((a) => a.status == ActivityStatus.completed).length;
    final progress = plan.activities.isNotEmpty ? completed / plan.activities.length : 0.0;
    final daysSinceSowing = DateTime.now().difference(plan.sowDate).inDays;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plan.title, style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold)),
            SizedBox(height: screenHeight * 0.005),
            Text(_tr('diary_day_of_plan').replaceFirst('{days}', daysSinceSowing.toString())),
            SizedBox(height: screenHeight * 0.015),
            LinearProgressIndicator(
              value: progress,
              minHeight: screenHeight * 0.015,
              borderRadius: BorderRadius.circular(4),
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_tr('diary_progress')),
                Text('${(progress * 100).toStringAsFixed(0)}%'),
              ],
            ),
            Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullCalendarScreen(plan: plan),
                    ),
                  );
                },
                child: Text(_tr('diary_view_full_calendar')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, double screenWidth) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700], size: screenWidth * 0.06),
        SizedBox(width: screenWidth * 0.02),
        Text(title, style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
