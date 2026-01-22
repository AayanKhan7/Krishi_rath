import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi_rath/features/community/widgets/forum_post.dart';
import 'package:krishi_rath/services/localization_service.dart';

class CommunityForumScreen extends StatelessWidget {
  const CommunityForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adaptive sizes
    final double padding = screenWidth * 0.04;
    final double iconSize = screenWidth * 0.1;
    final double titleFontSize = screenWidth * 0.045;
    final double subtitleFontSize = screenWidth * 0.035;
    final double chipHeight = screenHeight * 0.05;
    final double chipSpacing = screenWidth * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('community_title')),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, size: iconSize * 0.6),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(padding),
        children: [
          _buildFilterChips(tr, chipHeight, chipSpacing, titleFontSize),
          SizedBox(height: padding),
          _buildShareExperienceCard(context, tr, iconSize, titleFontSize, subtitleFontSize, padding),
          SizedBox(height: padding),
          // Example Forum Posts
          const ForumPost(
            userName: 'Ramesh Kumar',
            userLocation: 'Pune, Maharashtra',
            postTime: '2 hours ago',
            tagKey: 'community_tag_crops',
            voiceNoteDuration: '45s',
            postText:
            'My wheat crop is showing yellow leaves. What should I do?',
            likes: 12,
            comments: 8,
            avatarColor: Colors.green,
          ),
          const ForumPost(
            userName: 'Sunita Devi',
            userLocation: 'Nashik, Maharashtra',
            postTime: '4 hours ago',
            tagKey: 'community_tag_tips',
            voiceNoteDuration: '1m 20s',
            postText:
            'I use neem oil mixed with soap water for pest control. Very effective and organic!',
            likes: 28,
            comments: 15,
            avatarColor: Colors.orange,
          ),
          const ForumPost(
            userName: 'Mohan Singh',
            userLocation: 'Akola, Maharashtra',
            postTime: '6 hours ago',
            tagKey: 'community_tag_govt',
            voiceNoteDuration: '2m 10s',
            postText:
            'PM-KISAN installment received today. ₹2000 credited to account. Check your status!',
            likes: 45,
            comments: 22,
            avatarColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(String Function(String) tr, double height, double spacing, double fontSize) {
    return SizedBox(
      height: height,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(tr('updates_tab_all'), isSelected: true, fontSize: fontSize, height: height, spacing: spacing),
          _buildFilterChip('🌾', fontSize: fontSize, height: height, spacing: spacing),
          _buildFilterChip('📞', fontSize: fontSize, height: height, spacing: spacing),
          _buildFilterChip('💡', fontSize: fontSize, height: height, spacing: spacing),
          _buildFilterChip('🏛️', fontSize: fontSize, height: height, spacing: spacing),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false, required double fontSize, required double height, required double spacing}) {
    return Padding(
      padding: EdgeInsets.only(right: spacing),
      child: Chip(
        label: Text(label, style: TextStyle(fontSize: fontSize)),
        backgroundColor: isSelected ? Colors.green[100] : Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height / 2),
          side: BorderSide(
            color: isSelected ? Colors.green : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildShareExperienceCard(BuildContext context, String Function(String) tr,
      double iconSize, double titleFontSize, double subtitleFontSize, double padding) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            Icon(Icons.mic, color: Theme.of(context).primaryColor, size: iconSize),
            SizedBox(height: padding / 2),
            Text(
              tr('community_share_experience'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: padding / 4),
            Text(
              tr('community_share_experience_subtitle'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: subtitleFontSize, color: Colors.grey),
            ),
            SizedBox(height: padding),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              child: Text(tr('community_record_button'), style: TextStyle(fontSize: subtitleFontSize)),
            ),
          ],
        ),
      ),
    );
  }
}
