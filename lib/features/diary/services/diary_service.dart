import 'package:flutter/material.dart';
import 'package:krishi_rath/features/diary/models/diary_models.dart';

// In a real app, this service would interact with a database like Firebase Firestore.
class DiaryService {
  final List<CropPlan> _plans = [];

  Future<List<CropPlan>> getPlans() async {
    if (_plans.isEmpty) {
      _plans.add(_createSoybeanPlan());
      _plans.add(_createCottonPlan());
    }
    await Future.delayed(const Duration(milliseconds: 300));
    return _plans;
  }

  Future<void> updateActivityStatus(String planId, String activityId, ActivityStatus status) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final plan = _plans.firstWhere((p) => p.id == planId);
    final activity = plan.activities.firstWhere((act) => act.id == activityId);
    activity.status = status;
  }

  Future<void> updateActivityDetails(String planId, String activityId, double expenses, String notes) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final plan = _plans.firstWhere((p) => p.id == planId);
    final activity = plan.activities.firstWhere((act) => act.id == activityId);
    activity.expenses = expenses;
    activity.notes = notes;
  }

  // Mock data for Plan 1 with steps
  CropPlan _createSoybeanPlan() {
    final sowDate = DateTime.now().subtract(const Duration(days: 5));
    return CropPlan(
      id: 'plan_soybean_A',
      title: 'Soybean - Field A',
      cropName: 'Soybean',
      sowDate: sowDate,
      activities: [
        Activity(
            id: 'soy_prep',
            title: 'Land Preparation',
            icon: Icons.compress,
            scheduledDate: sowDate,
            status: ActivityStatus.completed,
            steps: [
              '1. Perform one deep ploughing with a moldboard plough.',
              '2. Follow with two rounds of harrowing for a fine tilth.',
              '3. Apply 5 tons of Farmyard Manure per acre.'
            ]),
        Activity(
            id: 'soy_sow',
            title: 'Sowing',
            icon: Icons.eco,
            scheduledDate: sowDate.add(const Duration(days: 1)),
            status: ActivityStatus.completed,
            expenses: 1500,
            notes: 'Used high-quality seeds.',
            steps: [
              '1. Treat seeds with fungicide and Rhizobium culture.',
              '2. Use a seed drill for sowing.',
              '3. Maintain row-to-row spacing of 45 cm.'
            ]),
        Activity(
            id: 'soy_fert',
            title: 'Apply Basal Fertilizer',
            icon: Icons.science_outlined,
            scheduledDate: DateTime.now(), // Today's Task
            steps: [
              '1. Mix NPK fertilizer at a ratio of 20:60:40 kg/hectare.',
              '2. Apply the mixture evenly across the field before sowing.',
              '3. Do not let the fertilizer come in direct contact with seeds.'
            ]),
        Activity(
            id: 'soy_weed',
            title: 'Manual Weeding',
            icon: Icons.grass,
            scheduledDate: DateTime.now().add(const Duration(days: 7)),
            steps: ['1. Remove weeds by hand or using a hand hoe.', '2. Ensure you do not damage the crop roots.']),
        Activity(
            id: 'soy_harvest',
            title: 'Harvesting Window',
            icon: Icons.agriculture,
            scheduledDate: DateTime.now().add(const Duration(days: 30)),
            steps: ['1. Harvest when 95% of pods have matured.', '2. Cut the plants at the base.']),
      ],
    );
  }

  // Mock data for Plan 2 with steps
  CropPlan _createCottonPlan() {
    final sowDate = DateTime.now().subtract(const Duration(days: 10));
    return CropPlan(
      id: 'plan_cotton_B',
      title: 'Cotton - Field B',
      cropName: 'Cotton',
      sowDate: sowDate,
      activities: [
        Activity(id: 'cot_prep', title: 'Land Preparation', icon: Icons.compress, scheduledDate: sowDate, status: ActivityStatus.completed, steps: []),
        Activity(id: 'cot_sow', title: 'Sowing', icon: Icons.eco, scheduledDate: sowDate.add(const Duration(days: 1)), status: ActivityStatus.completed, steps: []),
        Activity(
            id: 'cot_irrigate',
            title: 'First Irrigation',
            icon: Icons.water_drop,
            scheduledDate: DateTime.now(), // Today's Task
            steps: [
              '1. Apply light irrigation, about 5-6 cm deep.',
              '2. Ensure water does not stagnate in the field.',
              '3. The next irrigation will depend on soil moisture.'
            ]),
        Activity(
            id: 'cot_pest',
            title: 'Scout for Pests',
            icon: Icons.bug_report,
            scheduledDate: DateTime.now().add(const Duration(days: 5)),
            steps: ['1. Check for pests like aphids and jassids.', '2. Look under the leaves.']),
        Activity(
            id: 'cot_harvest',
            title: 'Harvesting Window',
            icon: Icons.agriculture,
            scheduledDate: DateTime.now().add(const Duration(days: 45)),
            steps: []),
      ],
    );
  }
}