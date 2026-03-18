class Lesson {
  final String id;
  final String title;
  final String subtitle;
  final double progress;

  Lesson({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      progress: (json['progress'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'progress': progress,
    };
  }
}
