import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi_rath/features/community/models/community_post_model.dart';
import 'package:krishi_rath/features/community/services/community_service.dart';
import 'package:krishi_rath/services/localization_service.dart';
import 'package:uuid/uuid.dart';

class CreatePostForm extends StatefulWidget {
  final Function(CommunityPost) onPostCreated;
  final CommunityPost? existingPost;

  const CreatePostForm({
    super.key,
    required this.onPostCreated,
    this.existingPost,
  });

  @override
  State<CreatePostForm> createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final CommunityService _communityService = CommunityService();
  String _selectedCategory = 'Crops';
  bool _isLoading = false;

  final List<String> categories = ['Crops', 'Tips', 'Government', 'Questions', 'Success Stories'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingPost?.title ?? '');
    _contentController = TextEditingController(text: widget.existingPost?.content ?? '');
    if (widget.existingPost != null) {
      _selectedCategory = widget.existingPost!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizationService.translate('community_form_error'))),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.existingPost != null) {
        // Update existing post
        final updatedPost = CommunityPost(
          id: widget.existingPost!.id,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          authorName: widget.existingPost!.authorName,
          authorLocation: widget.existingPost!.authorLocation,
          authorId: widget.existingPost!.authorId,
          createdAt: widget.existingPost!.createdAt,
          updatedAt: DateTime.now(),
          category: _selectedCategory,
          mediaUrls: widget.existingPost!.mediaUrls,
          likes: widget.existingPost!.likes,
          comments: widget.existingPost!.comments,
          isSaved: widget.existingPost!.isSaved,
        );

        await _communityService.updatePost(updatedPost.id, updatedPost);
        widget.onPostCreated(updatedPost);
      } else {
        // Create new post
        final newPost = CommunityPost(
          id: const Uuid().v4(),
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          authorName: 'Current User',
          authorLocation: 'Your Location',
          authorId: 'current_user',
          createdAt: DateTime.now(),
          category: _selectedCategory,
        );

        await _communityService.createPost(newPost);
        widget.onPostCreated(newPost);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingPost != null ? 'Post updated!' : 'Post created!'),
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
        title: Text(widget.existingPost != null ? 'Edit Post' : 'Create Post'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Field
            Text(
              'Title',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _titleController,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: 'Enter post title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                prefixIcon: const Icon(Icons.title),
              ),
            ),
            SizedBox(height: 16.h),

            // Category Selection
            Text(
              'Category',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedCategory,
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            SizedBox(height: 16.h),

            // Content Field
            Text(
              'Content',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _contentController,
              maxLines: 8,
              maxLength: 2000,
              decoration: InputDecoration(
                hintText: 'Share your experience, tips, or questions...',
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
                  widget.existingPost != null ? 'Update Post' : 'Create Post',
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
