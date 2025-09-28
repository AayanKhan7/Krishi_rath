import 'package:flutter/material.dart';

// Represents a complete plan for a single crop/plot
class CropPlan {
  final String id;
  final String title; // e.g., "Soybean - Field A"
  final String cropName;
  final DateTime sowDate;
  final List<Activity> activities;
  String status;

  CropPlan({
    required this.id,
    required this.title,
    required this.cropName,
    required this.sowDate,
    required this.activities,
    this.status = 'Active',
  });
}

// Represents a single task within a CropPlan
enum ActivityStatus { pending, completed }

class Activity {
  final String id;
  final String title;
  final IconData icon;
  final DateTime scheduledDate;
  final List<String> steps; // New field for instructions
  ActivityStatus status;
  double expenses;
  String notes;

  Activity({
    required this.id,
    required this.title,
    required this.icon,
    required this.scheduledDate,
    this.steps = const [], // Initialize with an empty list
    this.status = ActivityStatus.pending,
    this.expenses = 0.0,
    this.notes = '',
  });
}