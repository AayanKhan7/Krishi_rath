import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi_rath/features/schemes/models/scheme_model.dart';
import 'package:krishi_rath/features/schemes/services/scheme_service.dart';
import 'package:krishi_rath/features/common/screens/saved_items_screen.dart';
import 'package:krishi_rath/services/localization_service.dart';

class SchemesScreen extends StatefulWidget {
  const SchemesScreen({super.key});

  @override
  State<SchemesScreen> createState() => _SchemesScreenState();
}

class _SchemesScreenState extends State<SchemesScreen> {
  final SchemeService _schemeService = SchemeService();

  void _toggleSaveScheme(Scheme scheme) async {
    if (scheme.isSaved) {
      await _schemeService.unsaveScheme(scheme.id);
    } else {
      await _schemeService.saveScheme(scheme.id);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('schemes_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedItemsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Scheme>>(
        future: _schemeService.getSchemes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final schemes = snapshot.data ?? [];
          
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            children: [
              Text(
                tr('schemes_subtitle'),
                style: TextStyle(fontSize: 17.sp),
              ),
              SizedBox(height: 16.h),
              // Scheme cards
              ...schemes.map((scheme) => _buildSchemeCard(scheme)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSchemeCard(Scheme scheme) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    scheme.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    scheme.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: scheme.isSaved ? Colors.green : null,
                  ),
                  onPressed: () => _toggleSaveScheme(scheme),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Chip(
              label: Text(scheme.category, style: TextStyle(fontSize: 12.sp)),
              backgroundColor: Colors.blue[50],
            ),
            SizedBox(height: 12.h),
            Text(
              scheme.description,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(Icons.business, size: 16.sp, color: Colors.grey),
                SizedBox(width: 4.w),
                Text(
                  scheme.provider,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            if (scheme.deadline.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Text(
                    'Deadline: ${scheme.deadline}',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                ],
              ),
            SizedBox(height: 12.h),
            ExpansionTile(
              title: const Text('Eligibility'),
              tilePadding: EdgeInsets.zero,
              children: scheme.eligibility.map((e) => ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(e),
                dense: true,
              )).toList(),
            ),
            ExpansionTile(
              title: const Text('Benefits'),
              tilePadding: EdgeInsets.zero,
              children: scheme.benefits.map((b) => ListTile(
                leading: const Icon(Icons.star, color: Colors.orange),
                title: Text(b),
                dense: true,
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
