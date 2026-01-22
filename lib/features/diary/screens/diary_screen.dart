import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20.h,
            left: 20.w,
            right: 20.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _tr('diary_details_for').replaceFirst('{activity}', activity.title),
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: expensesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _tr('diary_expenses'),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.currency_rupee),
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: _tr('diary_add_notes'),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.note),
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48.h),
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
                SizedBox(height: 24.h),
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            children: [
              _buildSectionHeader(_tr('diary_my_crop_plans'), Icons.eco_outlined),
              SizedBox(height: 8.h),
              ...allPlans.map((plan) => _buildAtAGlanceCard(context, plan)),
              SizedBox(height: 24.h),
              _buildSectionHeader(_tr('diary_upcoming_tasks'), Icons.today),
              SizedBox(height: 8.h),
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

  Widget _buildAtAGlanceCard(BuildContext context, CropPlan plan) {
    final completed = plan.activities.where((a) => a.status == ActivityStatus.completed).length;
    final progress = plan.activities.isNotEmpty ? completed / plan.activities.length : 0.0;
    final daysSinceSowing = DateTime.now().difference(plan.sowDate).inDays;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plan.title, style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.h),
            Text(_tr('diary_day_of_plan').replaceFirst('{days}', daysSinceSowing.toString())),
            SizedBox(height: 12.h),
            LinearProgressIndicator(
              value: progress,
              minHeight: 12.h,
              borderRadius: BorderRadius.circular(4.r),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_tr('diary_progress')),
                Text('${(progress * 100).toStringAsFixed(0)}%'),
              ],
            ),
            const Divider(),
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700], size: 22.sp),
        SizedBox(width: 8.w),
        Text(title, style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
