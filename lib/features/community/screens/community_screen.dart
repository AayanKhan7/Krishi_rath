import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi_rath/features/community/models/community_post_model.dart';
import 'package:krishi_rath/features/community/services/community_service.dart';
import 'package:krishi_rath/features/community/widgets/create_post_form.dart';
import 'package:krishi_rath/features/common/screens/saved_items_screen.dart';
import 'package:krishi_rath/services/localization_service.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final CommunityService _communityService = CommunityService();
  String _selectedCategory = 'All';

  String _tr(String key) => localizationService.translate(key);

  Future<List<CommunityPost>> _getFilteredPosts() async {
    if (_selectedCategory == 'All') {
      return await _communityService.getPosts();
    }
    return await _communityService.getPostsByCategory(_selectedCategory);
  }

  void _showCreatePostForm({CommunityPost? post}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CreatePostForm(
        existingPost: post,
        onPostCreated: (newPost) {
          setState(() {});
        },
      ),
    );
  }

  void _deletePost(CommunityPost post) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _communityService.deletePost(post.id);
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post deleted successfully')),
        );
      }
    }
  }

  void _toggleSavePost(CommunityPost post) async {
    if (post.isSaved) {
      await _communityService.unsavePost(post.id);
    } else {
      await _communityService.savePost(post.id);
    }
    setState(() {});
  }

  void _toggleLikePost(CommunityPost post) async {
    await _communityService.likePost(post.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('community_title')),
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
      body: Column(
        children: [
          // Category Filter
          SizedBox(
            height: 50.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              children: [
                _buildCategoryChip('All'),
                _buildCategoryChip('Crops'),
                _buildCategoryChip('Tips'),
                _buildCategoryChip('Government'),
                _buildCategoryChip('Questions'),
                _buildCategoryChip('Success Stories'),
              ],
            ),
          ),
          const Divider(height: 1),
          // Posts List
          Expanded(
            child: FutureBuilder<List<CommunityPost>>(
              future: _getFilteredPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final posts = snapshot.data ?? [];
                
                if (posts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.forum_outlined, size: 64.sp, color: Colors.grey),
                        SizedBox(height: 16.h),
                        Text(
                          'No posts yet',
                          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Be the first to share!',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return _buildPostCard(post);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePostForm(),
        icon: const Icon(Icons.add),
        label: const Text('Create Post'),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        selectedColor: Colors.green[100],
        checkmarkColor: Colors.green,
      ),
    );
  }

  Widget _buildPostCard(CommunityPost post) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(
                    post.authorName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        post.authorLocation,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Edit'),
                      onTap: () {
                        Future.delayed(Duration.zero, () {
                          _showCreatePostForm(post: post);
                        });
                      },
                    ),
                    PopupMenuItem(
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      onTap: () => _deletePost(post),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // Category
            Chip(
              label: Text(post.category, style: TextStyle(fontSize: 12.sp)),
              backgroundColor: Colors.blue[50],
              labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
            ),
            SizedBox(height: 12.h),
            // Title
            Text(
              post.title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            // Content
            Text(
              post.content,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            // Actions
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.likes > 0 ? Icons.favorite : Icons.favorite_border,
                    color: post.likes > 0 ? Colors.red : null,
                  ),
                  onPressed: () => _toggleLikePost(post),
                ),
                Text('${post.likes}'),
                SizedBox(width: 16.w),
                const Icon(Icons.comment_outlined),
                SizedBox(width: 4.w),
                Text('${post.comments}'),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: post.isSaved ? Colors.green : null,
                  ),
                  onPressed: () => _toggleSavePost(post),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
