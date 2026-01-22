import 'package:krishi_rath/features/community/models/community_post_model.dart';

class CommunityService {
  static final CommunityService _instance = CommunityService._internal();
  final List<CommunityPost> _posts = [];
  final List<CommunityPost> _savedPosts = [];

  factory CommunityService() {
    return _instance;
  }

  CommunityService._internal() {
    _initializeSamplePosts();
  }

  void _initializeSamplePosts() {
    _posts.addAll([
      CommunityPost(
        id: '1',
        title: 'Wheat Crop Issue',
        content: 'My wheat crop is showing yellow leaves. What should I do?',
        authorName: 'Ramesh Kumar',
        authorLocation: 'Pune, Maharashtra',
        authorId: 'user_1',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        category: 'Crops',
        likes: 12,
        comments: 8,
      ),
      CommunityPost(
        id: '2',
        title: 'Organic Pest Control',
        content: 'I use neem oil mixed with soap water for pest control. Very effective and organic!',
        authorName: 'Sunita Devi',
        authorLocation: 'Nashik, Maharashtra',
        authorId: 'user_2',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        category: 'Tips',
        likes: 28,
        comments: 15,
      ),
      CommunityPost(
        id: '3',
        title: 'PM-KISAN Update',
        content: 'PM-KISAN installment received today. ₹2000 credited to account. Check your status!',
        authorName: 'Mohan Singh',
        authorLocation: 'Akola, Maharashtra',
        authorId: 'user_3',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        category: 'Government',
        likes: 45,
        comments: 22,
      ),
    ]);
  }

  // Create
  Future<CommunityPost> createPost(CommunityPost post) async {
    _posts.add(post);
    return post;
  }

  // Read
  Future<List<CommunityPost>> getPosts() async {
    return _posts;
  }

  Future<List<CommunityPost>> getPostsByCategory(String category) async {
    return _posts.where((post) => post.category == category).toList();
  }

  Future<CommunityPost?> getPostById(String id) async {
    try {
      return _posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }

  // Update
  Future<bool> updatePost(String id, CommunityPost updatedPost) async {
    try {
      final index = _posts.indexWhere((post) => post.id == id);
      if (index != -1) {
        _posts[index] = updatedPost;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Delete
  Future<bool> deletePost(String id) async {
    try {
      _posts.removeWhere((post) => post.id == id);
      _savedPosts.removeWhere((post) => post.id == id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Save/Bookmark
  Future<bool> savePost(String postId) async {
    try {
      final post = await getPostById(postId);
      if (post != null) {
        post.isSaved = true;
        if (!_savedPosts.any((p) => p.id == postId)) {
          _savedPosts.add(post);
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> unsavePost(String postId) async {
    try {
      final post = await getPostById(postId);
      if (post != null) {
        post.isSaved = false;
        _savedPosts.removeWhere((p) => p.id == postId);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<CommunityPost>> getSavedPosts() async {
    return _savedPosts;
  }

  Future<bool> likePost(String postId) async {
    try {
      final post = await getPostById(postId);
      if (post != null) {
        post.likes++;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
