class MealPlan {
  final String id;
  final String day;
  final List<String> items;

  MealPlan({
    required this.id,
    required this.day,
    required this.items,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'] as String,
      day: json['day'] as String,
      items: List<String>.from(json['items'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'items': items,
    };
  }
}
