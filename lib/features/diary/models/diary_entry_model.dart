class DiaryEntry {
  final String id;
  String title;
  String content;
  String cropName;
  final DateTime createdAt;
  DateTime? updatedAt;
  String? weather;
  double? soilMoisture;
  List<String>? tags;
  bool isSaved;

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.cropName,
    required this.createdAt,
    this.updatedAt,
    this.weather,
    this.soilMoisture,
    this.tags,
    this.isSaved = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'cropName': cropName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'weather': weather,
      'soilMoisture': soilMoisture,
      'tags': tags,
      'isSaved': isSaved,
    };
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      cropName: json['cropName'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      weather: json['weather'],
      soilMoisture: json['soilMoisture'],
      tags: List<String>.from(json['tags'] ?? []),
      isSaved: json['isSaved'] ?? false,
    );
  }
}
