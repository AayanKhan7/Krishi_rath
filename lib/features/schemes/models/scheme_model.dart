class Scheme {
  final String id;
  final String name;
  final String description;
  final String provider; // e.g., "Government of India"
  final String category;
  final List<String> eligibility;
  final List<String> benefits;
  final String deadline;
  bool isSaved;

  Scheme({
    required this.id,
    required this.name,
    required this.description,
    required this.provider,
    required this.category,
    required this.eligibility,
    required this.benefits,
    required this.deadline,
    this.isSaved = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'provider': provider,
      'category': category,
      'eligibility': eligibility,
      'benefits': benefits,
      'deadline': deadline,
      'isSaved': isSaved,
    };
  }

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      provider: json['provider'],
      category: json['category'],
      eligibility: List<String>.from(json['eligibility'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      deadline: json['deadline'],
      isSaved: json['isSaved'] ?? false,
    );
  }
}
