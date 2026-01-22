import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi_rath/features/diary/models/diary_entry_model.dart';
import 'package:krishi_rath/features/diary/services/diary_entry_service.dart';
import 'package:uuid/uuid.dart';

class CreateDiaryEntryForm extends StatefulWidget {
  final Function(DiaryEntry) onEntryCreated;
  final DiaryEntry? existingEntry;

  const CreateDiaryEntryForm({
    super.key,
    required this.onEntryCreated,
    this.existingEntry,
  });

  @override
  State<CreateDiaryEntryForm> createState() => _CreateDiaryEntryFormState();
}

class _CreateDiaryEntryFormState extends State<CreateDiaryEntryForm> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _cropNameController;
  late TextEditingController _weatherController;
  late TextEditingController _soilMoistureController;
  final DiaryEntryService _diaryService = DiaryEntryService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingEntry?.title ?? '');
    _contentController = TextEditingController(text: widget.existingEntry?.content ?? '');
    _cropNameController = TextEditingController(text: widget.existingEntry?.cropName ?? '');
    _weatherController = TextEditingController(text: widget.existingEntry?.weather ?? '');
    _soilMoistureController = TextEditingController(
      text: widget.existingEntry?.soilMoisture?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _cropNameController.dispose();
    _weatherController.dispose();
    _soilMoistureController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty ||
        _cropNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final soilMoisture = double.tryParse(_soilMoistureController.text);

      if (widget.existingEntry != null) {
        // Update existing entry
        final updatedEntry = DiaryEntry(
          id: widget.existingEntry!.id,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          cropName: _cropNameController.text.trim(),
          createdAt: widget.existingEntry!.createdAt,
          updatedAt: DateTime.now(),
          weather: _weatherController.text.trim().isEmpty ? null : _weatherController.text.trim(),
          soilMoisture: soilMoisture,
          tags: widget.existingEntry!.tags,
          isSaved: widget.existingEntry!.isSaved,
        );

        await _diaryService.updateEntry(updatedEntry.id, updatedEntry);
        widget.onEntryCreated(updatedEntry);
      } else {
        // Create new entry
        final newEntry = DiaryEntry(
          id: const Uuid().v4(),
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          cropName: _cropNameController.text.trim(),
          createdAt: DateTime.now(),
          weather: _weatherController.text.trim().isEmpty ? null : _weatherController.text.trim(),
          soilMoisture: soilMoisture,
          tags: [],
        );

        await _diaryService.createEntry(newEntry);
        widget.onEntryCreated(newEntry);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingEntry != null ? 'Entry updated!' : 'Entry created!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingEntry != null ? 'Edit Entry' : 'New Diary Entry'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Field
            Text(
              'Title *',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _titleController,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: 'Enter entry title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                prefixIcon: const Icon(Icons.title),
              ),
            ),
            SizedBox(height: 16.h),

            // Crop Name Field
            Text(
              'Crop Name *',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _cropNameController,
              decoration: InputDecoration(
                hintText: 'e.g., Wheat, Rice, Cotton',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                prefixIcon: const Icon(Icons.agriculture),
              ),
            ),
            SizedBox(height: 16.h),

            // Weather Field
            Text(
              'Weather Conditions',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _weatherController,
              decoration: InputDecoration(
                hintText: 'e.g., Sunny, Rainy, Cloudy',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                prefixIcon: const Icon(Icons.cloud),
              ),
            ),
            SizedBox(height: 16.h),

            // Soil Moisture Field
            Text(
              'Soil Moisture (%)',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _soilMoistureController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'e.g., 65.5',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                prefixIcon: const Icon(Icons.opacity),
              ),
            ),
            SizedBox(height: 16.h),

            // Content Field
            Text(
              'Content *',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _contentController,
              maxLines: 8,
              maxLength: 2000,
              decoration: InputDecoration(
                hintText: 'Write your diary entry...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                prefixIcon: const Icon(Icons.description),
              ),
            ),
            SizedBox(height: 24.h),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  widget.existingEntry != null ? 'Update Entry' : 'Create Entry',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
