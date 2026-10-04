class Note {
  final String title;
  final String description;
  final String category;

  Note({
    required this.title,
    required this.description,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
    );
  }
}