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

  // Function to show the modal
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
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Details for: ${activity.title}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: expensesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Expenses (e.g., 500)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Add Notes',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
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
                child: const Text('Save Details'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('diary_title')),
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
            return const Center(child: Text('No crop plans found.'));
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
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSectionHeader('My Crop Plans', Icons.eco_outlined),
              ...allPlans.map((plan) => _buildAtAGlanceCard(context, plan)),
              const SizedBox(height: 24),
              _buildSectionHeader(tr('diary_todays_tasks'), Icons.today),
              const SizedBox(height: 8),
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
                }).toList()
              else
                const Center(child: Text('No tasks scheduled for today. Relax!')),
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plan.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Day $daysSinceSowing of plan'),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Progress'),
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
                child: const Text('View Full Calendar →'),
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
        Icon(icon, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}