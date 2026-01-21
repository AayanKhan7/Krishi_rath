import 'package:flutter/material.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.04;
    final verticalSpacing = screenHeight * 0.02;
    final iconSize = screenWidth * 0.15;
    final cardPadding = screenWidth * 0.04;
    final buttonHeight = screenHeight * 0.065;
    final buttonFontSize = screenWidth * 0.045;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('pest_detection_title')),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(tr('pest_detection_subtitle'),
                style: TextStyle(fontSize: screenWidth * 0.045)),
            SizedBox(height: verticalSpacing),
            _buildCameraViewfinder(context, tr, iconSize, cardPadding),
            SizedBox(height: verticalSpacing),
            _buildInstructions(context, tr, screenWidth),
            SizedBox(height: verticalSpacing * 1.5),
            _buildActionButtons(tr, buttonHeight, buttonFontSize),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraViewfinder(BuildContext context, String Function(String) tr,
      double iconSize, double cardPadding) {
    return Card(
      color: Colors.grey[800],
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
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
                      size: iconSize, color: Colors.white70),
                  SizedBox(height: iconSize * 0.1),
                  Text(tr('pest_detection_viewfinder_title'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  SizedBox(height: iconSize * 0.05),
                  Text(
                    tr('pest_detection_viewfinder_subtitle'),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
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

  Widget _buildInstructions(BuildContext context, String Function(String) tr, double screenWidth) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('pest_detection_instructions_title'),
              style: TextStyle(
                  fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenWidth * 0.02),
            _buildInstructionPoint(tr('pest_detection_instruction_1'), screenWidth),
            _buildInstructionPoint(tr('pest_detection_instruction_2'), screenWidth),
            _buildInstructionPoint(tr('pest_detection_instruction_3'), screenWidth),
            _buildInstructionPoint(tr('pest_detection_instruction_4'), screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionPoint(String text, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: screenWidth * 0.04)),
          Expanded(child: Text(text, style: TextStyle(fontSize: screenWidth * 0.04))),
        ],
      ),
    );
  }

  Widget _buildActionButtons(String Function(String) tr, double buttonHeight, double fontSize) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _captureImage,
          icon: const Icon(Icons.camera_alt),
          label: Text(tr('pest_detection_capture_button')),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, buttonHeight),
            textStyle: TextStyle(fontSize: fontSize),
          ),
        ),
        SizedBox(height: buttonHeight * 0.2),
        Text('Or', style: TextStyle(fontSize: fontSize * 0.9)),
        TextButton.icon(
          onPressed: _uploadImage,
          icon: const Icon(Icons.upload_file),
          label: Text(tr('pest_detection_upload_button'),
              style: TextStyle(fontSize: fontSize)),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Image Preview
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(imageFile, height: 200, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 20),

            /// Report Heading
            Text(
              tr('Disease Report'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            /// Disease Card
            Card(
              color: Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.red, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '⚠️ ${tr("Detected Disease")}: Leaf Blight',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Solution Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline,
                            color: Colors.green, size: 26),
                        const SizedBox(width: 8),
                        Text(
                          tr('Suggested Solutions'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

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
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: color, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}