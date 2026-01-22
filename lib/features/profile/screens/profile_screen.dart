import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi_rath/services/localization_service.dart';

// 1. Converted to StatefulWidget
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 2. Added state variables
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _locationController;

  // Store initial values to reset on cancel
  final String _initialName = 'Raj Kumar';
  final String _initialLocation = 'Nashik, Maharashtra';

  // Helper to get initials
  String _getInitials(String name) {
    String initials = '';
    if (name.isNotEmpty) {
      final parts = name.split(' ');
      if (parts.length >= 2) {
        initials = parts[0][0] + parts[1][0]; // "RK"
      } else {
        initials = parts[0].substring(0, 1); // "R"
      }
    }
    return initials.toUpperCase();
  }

  // 3. Initialize controllers in initState
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _initialName);
    _locationController = TextEditingController(text: _initialLocation);
  }

  // 4. Dispose controllers
  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('profile_title')),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Chip(
              backgroundColor: Colors.white.withOpacity(0.3),
              label: Text('Online', style: TextStyle(color: Colors.white, fontSize: 12.sp)),
              avatar: Icon(Icons.wifi, color: Colors.white, size: 16.sp),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          _buildHeader(context), // This method is now dynamic
          _buildSection(
            context,
            title: tr('profile_farm_info'),
            child: _buildFarmInfoGrid(),
          ),
          _buildSection(
            context,
            title: tr('profile_offline_capability'),
            child: _buildOfflineInfo(),
          ),
          _buildSettingsList(context),
          _buildSection(
            context,
            title: tr('profile_contact_info'),
            child: _buildContactInfo(),
          ),
          _buildSection(
            context,
            title: tr('profile_emergency_contacts'),
            child: _buildEmergencyContacts(),
          ),
          _buildSignOutButton(context),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // 5. _buildHeader is now dynamic based on _isEditing
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.white.withOpacity(0.8),
            child: Text(
              // Use controller text to get initials, so it updates on save
              _getInitials(_nameController.text),
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Conditional Name Widget ---
                _isEditing
                    ? _buildEditableTextField(
                  _nameController,
                  TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : Text(
                  _nameController.text, // Read from controller
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        color: Colors.white70, size: 16.sp),
                    SizedBox(width: 4.w),
                    // --- Conditional Location Widget ---
                    _isEditing
                        ? Expanded(
                      child: _buildEditableTextField(
                        _locationController,
                        TextStyle(color: Colors.white70, fontSize: 14.sp),
                      ),
                    )
                        : Text(
                      _locationController.text, // Read from controller
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 6. Dynamic Edit/Save/Cancel Buttons
          _isEditing ? _buildEditButtons() : _buildViewButtons(),
        ],
      ),
    );
  }

  // Helper for a clean text field
  Widget _buildEditableTextField(
      TextEditingController controller, TextStyle style) {
    return TextField(
      controller: controller,
      style: style,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
      ),
    );
  }

  // 7. Button logic widgets
  Widget _buildViewButtons() {
    return IconButton(
      icon: Icon(Icons.edit, color: Colors.white, size: 24.sp),
      onPressed: () {
        setState(() {
          _isEditing = true;
        });
      },
    );
  }

  Widget _buildEditButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- Save Button ---
        IconButton(
          icon: Icon(Icons.save, color: Colors.white, size: 24.sp),
          onPressed: () {
            setState(() {
              // Here you would call your API or update your state management
              // For now, we just exit edit mode. The controllers
              // already hold the new values.
              _isEditing = false;
            });
          },
        ),
        // --- Cancel Button ---
        IconButton(
          icon: Icon(Icons.cancel, color: Colors.white70, size: 24.sp),
          onPressed: () {
            setState(() {
              // Reset text to initial values
              _nameController.text = _initialName;
              _locationController.text = _initialLocation;
              _isEditing = false;
            });
          },
        ),
      ],
    );
  }

  // --- All other helper methods remain the same ---
  // (Moved inside the State class so they can access `tr`)

  Widget _buildSection(BuildContext context,
      {required String title, required Widget child}) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
              TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildFarmInfoGrid() {
    final tr = localizationService.translate;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      mainAxisSpacing: 8.h,
      crossAxisSpacing: 8.w,
      children: [
        _buildInfoItem(tr('profile_farm_size'), '5.2 acres'),
        _buildInfoItem(tr('profile_experience'), '15 years'),
        _buildInfoItem(tr('profile_primary_language'), 'Hindi'),
        _buildInfoItem(tr('profile_member_since'), 'January 2024'),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
        SizedBox(height: 4.h),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
      ],
    );
  }

  Widget _buildOfflineInfo() {
    final tr = localizationService.translate;
    return Column(
      children: [
        Text(tr('profile_offline_desc'), style: TextStyle(fontSize: 14.sp)),
        SizedBox(height: 12.h),
        Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(child: Text(tr('profile_offline_cta'), style: TextStyle(fontSize: 14.sp))),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          _buildSettingsItem(
            context,
            icon: Icons.settings,
            titleKey: 'profile_settings',
            subtitleKey: 'profile_settings_desc',
          ),
          Divider(height: 1.h, indent: 16.w, endIndent: 16.w),
          _buildSettingsItem(
            context,
            icon: Icons.download_for_offline,
            titleKey: 'profile_offline_data',
            subtitleKey: 'profile_offline_data_desc',
          ),
          Divider(height: 1.h, indent: 16.w, endIndent: 16.w),
          _buildSettingsItem(
            context,
            icon: Icons.help_outline,
            titleKey: 'profile_help_support',
            subtitleKey: 'profile_help_support_desc',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context,
      {required IconData icon,
        required String titleKey,
        required String subtitleKey}) {
    final tr = localizationService.translate;
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600], size: 24.sp),
      title: Text(tr(titleKey), style: TextStyle(fontSize: 16.sp)),
      subtitle: Text(tr(subtitleKey), style: TextStyle(fontSize: 13.sp)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
      onTap: () {},
    );
  }

  Widget _buildContactInfo() {
    final tr = localizationService.translate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem(tr('profile_primary_contact'), '+91 98765 43210'),
        SizedBox(height: 8.h),
        _buildInfoItem(tr('profile_email'), 'raj.kumar@example.com'),
      ],
    );
  }

  Widget _buildEmergencyContacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem('Agriculture Officer', '+91 98765 12345'),
        SizedBox(height: 8.h),
        _buildInfoItem('Veterinary Doctor', '+91 98765 67890'),
        SizedBox(height: 8.h),
        _buildInfoItem('Helpline', '1800-180-1551'),
      ],
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    final tr = localizationService.translate;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      child: Center(
        child: TextButton.icon(
          onPressed: () {},
          icon: Icon(Icons.exit_to_app, color: Colors.red, size: 20.sp),
          label: Text(
            tr('profile_sign_out'),
            style: TextStyle(color: Colors.red, fontSize: 16.sp),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(12.w),
          ),
        ),
      ),
    );
  }
}
