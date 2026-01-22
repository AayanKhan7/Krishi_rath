import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:krishi_rath/services/localization_service.dart';

class PlantScannerScreen extends StatefulWidget {
  const PlantScannerScreen({super.key});

  @override
  State<PlantScannerScreen> createState() => _PlantScannerScreenState();
}

class _PlantScannerScreenState extends State<PlantScannerScreen> {
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      _navigateToReport();
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      _navigateToReport();
    }
  }

  void _navigateToReport() {
    if (_selectedImage == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiseaseReportScreen(imageFile: _selectedImage!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pest_detection_title')),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(tr('pest_detection_subtitle'),
                style: TextStyle(fontSize: 17.sp)),
            SizedBox(height: 16.h),
            _buildCameraViewfinder(context, tr),
            SizedBox(height: 16.h),
            _buildInstructions(context, tr),
            SizedBox(height: 24.h),
            _buildActionButtons(tr),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraViewfinder(BuildContext context, String Function(String) tr) {
    return Card(
      color: Colors.grey[800],
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text('AI Ready'),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Chip(
                    label: Text('HD Quality'),
                    backgroundColor: Colors.blue,
                    labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.camera_alt_outlined,
                      size: 56.sp, color: Colors.white70),
                  SizedBox(height: 6.h),
                  Text(tr('pest_detection_viewfinder_title'),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp)),
                  SizedBox(height: 3.h),
                  Text(
                    tr('pest_detection_viewfinder_subtitle'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructions(BuildContext context, String Function(String) tr) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('pest_detection_instructions_title'),
              style: TextStyle(
                  fontSize: 17.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            _buildInstructionPoint(tr('pest_detection_instruction_1')),
            _buildInstructionPoint(tr('pest_detection_instruction_2')),
            _buildInstructionPoint(tr('pest_detection_instruction_3')),
            _buildInstructionPoint(tr('pest_detection_instruction_4')),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 15.sp)),
          Expanded(child: Text(text, style: TextStyle(fontSize: 15.sp))),
        ],
      ),
    );
  }

  Widget _buildActionButtons(String Function(String) tr) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _captureImage,
          icon: const Icon(Icons.camera_alt),
          label: Text(tr('pest_detection_capture_button')),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 52.h),
            textStyle: TextStyle(fontSize: 17.sp),
          ),
        ),
        SizedBox(height: 10.h),
        Text('Or', style: TextStyle(fontSize: 15.sp)),
        TextButton.icon(
          onPressed: _uploadImage,
          icon: const Icon(Icons.upload_file),
          label: Text(tr('pest_detection_upload_button'),
              style: TextStyle(fontSize: 17.sp)),
        ),
      ],
    );
  }
}

class DiseaseReportScreen extends StatelessWidget {
  final File imageFile;

  const DiseaseReportScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('Pest Detection Report')),
        backgroundColor: Colors.green.shade600,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Image Preview
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.file(imageFile, height: 200.h, fit: BoxFit.cover),
              ),
            ),

            SizedBox(height: 20.h),

            /// Report Heading
            Text(
              tr('Disease Report'),
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),

            /// Disease Card
            Card(
              color: Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.red, size: 28.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        '⚠️ ${tr("Detected Disease")}: Leaf Blight',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            /// Solution Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline,
                            color: Colors.green, size: 26.sp),
                        SizedBox(width: 8.w),
                        Text(
                          tr('Suggested Solutions'),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    /// Solutions List
                    _buildSolutionPoint(
                        '- Spray organic fungicide', Colors.green.shade700),
                    _buildSolutionPoint(
                        '- Remove infected leaves', Colors.green.shade700),
                    _buildSolutionPoint('- Maintain proper field sanitation',
                        Colors.green.shade700),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionPoint(String text, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16.sp, color: color, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}