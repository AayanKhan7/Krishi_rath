import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi_rath/features/community/services/community_service.dart';
import 'package:krishi_rath/features/diary/services/diary_entry_service.dart';
import 'package:krishi_rath/features/schemes/services/scheme_service.dart';

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key});

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CommunityService _communityService = CommunityService();
  final DiaryEntryService _diaryService = DiaryEntryService();
  final SchemeService _schemeService = SchemeService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Items'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Posts'),
            Tab(text: 'Diary'),
            Tab(text: 'Schemes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSavedPostsTab(),
          _buildSavedDiaryTab(),
          _buildSavedSchemesTab(),
        ],
      ),
    );
  }

  Widget _buildSavedPostsTab() {
    return FutureBuilder(
      future: _communityService.getSavedPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 60.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                Text(
                  'No saved posts yet',
                  style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final posts = snapshot.data!;
        return ListView.builder(
          itemCount: posts.length,
          padding: EdgeInsets.all(12.w),
          itemBuilder: (context, index) {
            final post = posts[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12.h),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${post.authorName} • ${post.authorLocation}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark),
                          color: Colors.amber,
                          onPressed: () {
                            _communityService.unsavePost(post.id);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      post.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 12.h),
                    Chip(
                      label: Text(post.category),
                      backgroundColor: Colors.green[100],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSavedDiaryTab() {
    return FutureBuilder(
      future: _diaryService.getSavedEntries(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 60.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                Text(
                  'No saved diary entries yet',
                  style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final entries = snapshot.data!;
        return ListView.builder(
          itemCount: entries.length,
          padding: EdgeInsets.all(12.w),
          itemBuilder: (context, index) {
            final entry = entries[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12.h),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.title,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                entry.cropName,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark),
                          color: Colors.amber,
                          onPressed: () {
                            _diaryService.unsaveEntry(entry.id);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      entry.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        if (entry.weather != null) ...[
                          Icon(Icons.cloud, size: 16.sp),
                          SizedBox(width: 4.w),
                          Text(entry.weather!, style: TextStyle(fontSize: 12.sp)),
                          SizedBox(width: 12.w),
                        ],
                        if (entry.soilMoisture != null) ...[
                          Icon(Icons.opacity, size: 16.sp),
                          SizedBox(width: 4.w),
                          Text('${entry.soilMoisture}%', style: TextStyle(fontSize: 12.sp)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSavedSchemesTab() {
    return FutureBuilder(
      future: _schemeService.getSavedSchemes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 60.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                Text(
                  'No saved schemes yet',
                  style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final schemes = snapshot.data!;
        return ListView.builder(
          itemCount: schemes.length,
          padding: EdgeInsets.all(12.w),
          itemBuilder: (context, index) {
            final scheme = schemes[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12.h),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scheme.name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                scheme.provider,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark),
                          color: Colors.amber,
                          onPressed: () {
                            _schemeService.unsaveScheme(scheme.id);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      scheme.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 8.w,
                      children: [
                        Chip(
                          label: Text(scheme.category),
                          backgroundColor: Colors.blue[100],
                          labelStyle: TextStyle(fontSize: 12.sp),
                        ),
                        Chip(
                          label: Text('Deadline: ${scheme.deadline}'),
                          backgroundColor: Colors.red[100],
                          labelStyle: TextStyle(fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
