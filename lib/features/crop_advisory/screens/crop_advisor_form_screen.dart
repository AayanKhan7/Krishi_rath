// crop_advisor_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:krishi_rath/common/widgets/bilingual_text.dart';
import 'package:krishi_rath/features/crop_advisory/screens/personalized_plan_screen.dart';
import 'package:krishi_rath/services/localization_service.dart';

class CropAdvisorFormScreen extends StatefulWidget {
  const CropAdvisorFormScreen({super.key});

  @override
  State<CropAdvisorFormScreen> createState() => _CropAdvisorFormScreenState();
}

class _CropAdvisorFormScreenState extends State<CropAdvisorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _areaController = TextEditingController();
  String? _selectedSoilType;
  String? _selectedIrrigation;
  bool _isRecommendationGenerated = false;

  String _tr(String key) => localizationService.translate(key);

  final List<Map<String, dynamic>> soilTypes = [
    {'key': 'soil_loamy', 'name': 'Loamy Soil', 'image': 'assets/soils/loamy_soil.jpg'},
    {'key': 'soil_sandy', 'name': 'Sandy Soil', 'image': 'assets/soils/sandy_soil.jpg'},
    {'key': 'soil_clay', 'name': 'Clay Soil', 'image': 'assets/soils/clay_soil.jpg'},
    {'key': 'soil_silty', 'name': 'Silty Soil', 'image': 'assets/soils/silty_soil.jpg'},
    {'key': 'soil_peaty', 'name': 'Peaty Soil', 'image': 'assets/soils/peaty_soil.jpg'},
    {'key': 'soil_chalky', 'name': 'Chalky Soil', 'image': 'assets/soils/chalky_soil.jpg'},
  ];

  String? _validateArea(String? value) {
    if (value == null || value.isEmpty) return _tr('validation_land_area_required');
    final number = double.tryParse(value);
    if (number == null) return _tr('validation_land_area_number');
    if (number <= 0) return _tr('validation_land_area_positive');
    return null;
  }

  String? _validateSoilType(String? value) {
    if (value == null || value.isEmpty) return _tr('validation_soil_type_required');
    return null;
  }

  String? _validateIrrigation(String? value) {
    if (value == null || value.isEmpty) return _tr('validation_irrigation_required');
    return null;
  }

  void _getRecommendation() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() => _isRecommendationGenerated = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('recommendation_success')), backgroundColor: Colors.green),
      );
    }
  }

  void _navigateToPlan() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PersonalizedPlanScreen(
            landArea: _areaController.text,
            soilType: _selectedSoilType ?? _tr('not_selected'),
            irrigationType: _selectedIrrigation ?? _tr('not_selected'),
          ),
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _areaController.clear();
    _selectedSoilType = null;
    _selectedIrrigation = null;
    setState(() => _isRecommendationGenerated = false);
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('crop_advisor_form_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetForm,
            tooltip: _tr('reset_form_tooltip'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _tr('crop_advisor_form_land_details'),
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              _buildTextField(
                label: _tr('crop_advisor_form_land_area'),
                hint: _tr('crop_advisor_form_hint_area'),
                controller: _areaController,
                validator: _validateArea,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20.h),
              _buildSoilTypeDropdown(),
              SizedBox(height: 20.h),
              _buildIrrigationDropdown(),
              SizedBox(height: 30.h),
              ElevatedButton(
                onPressed: _getRecommendation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  textStyle: TextStyle(fontSize: 16.sp),
                ),
                child: Text(
                  _tr('crop_advisor_form_get_recommendation'),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16.h),
              if (_isRecommendationGenerated)
                OutlinedButton(
                  onPressed: _resetForm,
                  style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16.h)),
                  child: Text(_tr('reset_form_button')),
                ),
              SizedBox(height: 16.h),
              if (_isRecommendationGenerated)
                ElevatedButton(
                  onPressed: _navigateToPlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    textStyle: TextStyle(fontSize: 16.sp),
                  ),
                  child: Text(
                    _tr('crop_advisor_form_get_plan'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              if (_isRecommendationGenerated) ...[
                const SizedBox(height: 24),
                Card(
                  color: Colors.grey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _tr('form_summary'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('${_tr('crop_advisor_form_land_area')}: ${_areaController.text} ${_tr('acres_unit')}'),
                        Text('${_tr('crop_advisor_form_soil_type')}: ${_getSelectedSoilName()}'),
                        Text('${_tr('crop_advisor_form_irrigation_type')}: ${_selectedIrrigation ?? _tr('not_selected')}'),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildSoilTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_tr('crop_advisor_form_soil_type'), style: const TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          initialValue: _selectedSoilType,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
          hint: Text(_tr('crop_advisor_form_hint_soil')),
          items: soilTypes.map((soil) {
            return DropdownMenuItem<String>(
              value: soil['key'],
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      image: DecorationImage(
                        image: AssetImage(soil['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(_tr(soil['key'])),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() => _selectedSoilType = newValue);
          },
          validator: _validateSoilType,
        ),
      ],
    );
  }

  Widget _buildIrrigationDropdown() {
    final irrigationMethods = [
      _tr('irrigation_drip'),
      _tr('irrigation_sprinkler'),
      _tr('irrigation_canal'),
      _tr('irrigation_flood'),
      _tr('irrigation_rainfed')
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_tr('crop_advisor_form_irrigation_type'), style: const TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          initialValue: _selectedIrrigation,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
          hint: Text(_tr('crop_advisor_form_hint_irrigation')),
          items: irrigationMethods.map((method) {
            return DropdownMenuItem<String>(
              value: method,
              child: Text(method),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() => _selectedIrrigation = newValue);
          },
          validator: _validateIrrigation,
        ),
      ],
    );
  }

  String _getSelectedSoilName() {
    if (_selectedSoilType == null) return _tr('not_selected');
    final soil = soilTypes.firstWhere(
          (s) => s['key'] == _selectedSoilType,
      orElse: () => {'key': '', 'name': _tr('not_selected')},
    );
    return _tr(soil['key']);
  }
}
