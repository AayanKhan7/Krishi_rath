import 'package:flutter/material.dart';
import 'package:krishi_rath/services/localization_service.dart';

class ForumPost extends StatelessWidget {
  final String userName;
  final String userLocation;
  final String postTime;
  final String tagKey;
  final String voiceNoteDuration;
  final String postText;
  final int likes;
  final int comments;
  final Color avatarColor;

  const ForumPost({
    super.key,
    required this.userName,
    required this.userLocation,
    required this.postTime,
    required this.tagKey,
    required this.voiceNoteDuration,
    required this.postText,
    required this.likes,
    required this.comments,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    final tr = localizationService.translate;
    final initials = userName.split(' ').map((e) => e[0]).take(2).join();

    final screenWidth = MediaQuery.of(context).size.width;

    // Adaptive sizes
    final double padding = screenWidth * 0.04;
    final double avatarRadius = screenWidth * 0.07;
    final double spacing = screenWidth * 0.03;
    final double titleFontSize = screenWidth * 0.045;
    final double subtitleFontSize = screenWidth * 0.035;
    final double iconSize = screenWidth * 0.06;
    final double chipFontSize = screenWidth * 0.035;
    final double voicePlayerHeight = screenWidth * 0.1;

    return Card(
      margin: EdgeInsets.symmetric(vertical: padding / 2),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              initials,
              tr,
              avatarRadius,
              spacing,
              titleFontSize,
              subtitleFontSize,
              chipFontSize,
            ),
            SizedBox(height: padding),
            _buildVoicePlayer(context, iconSize, voicePlayerHeight),
            SizedBox(height: spacing / 2),
            Text(postText, style: TextStyle(fontSize: subtitleFontSize)),
            SizedBox(height: padding),
            _buildFooter(iconSize, subtitleFontSize, spacing),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      String initials,
      String Function(String) tr,
      double avatarRadius,
      double spacing,
      double titleFontSize,
      double subtitleFontSize,
      double chipFontSize,
      ) {
    return Row(
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: avatarColor,
          child: Text(initials,
              style: TextStyle(color: Colors.white, fontSize: titleFontSize)),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: titleFontSize)),
              Text('$userLocation • $postTime',
                  style: TextStyle(color: Colors.grey, fontSize: subtitleFontSize)),
            ],
          ),
        ),
        Chip(
          label: Text(tr(tagKey), style: TextStyle(fontSize: chipFontSize)),
          backgroundColor: Colors.grey[200],
          padding: EdgeInsets.symmetric(horizontal: spacing / 2),
        ),
      ],
    );
  }

  Widget _buildVoicePlayer(BuildContext context, double iconSize, double height) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: height * 0.2, vertical: height * 0.15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Row(
        children: [
          Icon(Icons.play_arrow, color: Theme.of(context).primaryColor, size: iconSize),
          Expanded(
            child: SizedBox(
              height: height * 0.25,
              child: LinearProgressIndicator(value: 0.3),
            ),
          ),
          SizedBox(width: height * 0.2),
          Text(voiceNoteDuration, style: TextStyle(fontSize: height * 0.25)),
        ],
      ),
    );
  }

  Widget _buildFooter(double iconSize, double fontSize, double spacing) {
    return Row(
      children: [
        _buildStat(Icons.thumb_up_outlined, likes.toString(), iconSize, fontSize),
        SizedBox(width: spacing),
        _buildStat(Icons.comment_outlined, comments.toString(), iconSize, fontSize),
      ],
    );
  }

  Widget _buildStat(IconData icon, String count, double iconSize, double fontSize) {
    return Row(
      children: [
        Icon(icon, size: iconSize, color: Colors.grey),
        SizedBox(width: iconSize * 0.25),
        Text(count, style: TextStyle(fontSize: fontSize)),
      ],
    );
  }
}
