class CommunityPost {
  final String id;
  String title;
  String content;
  final String authorName;
  final String authorLocation;
  final String authorId;
  final DateTime createdAt;
  DateTime? updatedAt;
  String category;
  List<String>? mediaUrls;
  int likes;
  int comments;
  bool isSaved;

  CommunityPost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.authorLocation,
    required this.authorId,
    required this.createdAt,
    this.updatedAt,
    required this.category,
    this.mediaUrls,
    this.likes = 0,
    this.comments = 0,
    this.isSaved = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'authorName': authorName,
      'authorLocation': authorLocation,
      'authorId': authorId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'category': category,
      'mediaUrls': mediaUrls,
      'likes': likes,
      'comments': comments,
      'isSaved': isSaved,
    };
  }

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      authorName: json['authorName'],
      authorLocation: json['authorLocation'],
      authorId: json['authorId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      category: json['category'],
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      isSaved: json['isSaved'] ?? false,
    );
  }
}
