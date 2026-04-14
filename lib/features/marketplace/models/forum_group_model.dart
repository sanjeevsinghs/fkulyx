class ForumGroup {
  static const String _apiOrigin = 'https://api.kuilyx.com';

  final String id;
  final String name;
  final String groupType;
  final String location;
  final String description;
  final String image;
  final int memberCount;
  final bool isJoined;
  final bool isRequested;

  const ForumGroup({
    required this.id,
    required this.name,
    required this.groupType,
    required this.location,
    required this.description,
    required this.image,
    required this.memberCount,
    required this.isJoined,
    required this.isRequested,
  });

  factory ForumGroup.fromJson(Map<String, dynamic> json) {
    final rawLocation = json['location'];
    final locationText = rawLocation is String && rawLocation.trim().isNotEmpty
        ? rawLocation
        : 'Location not available';

    return ForumGroup(
      id: _asString(json['_id']),
      name: _asString(json['name'], fallback: 'Unnamed Group'),
      groupType: _asString(json['groupType'], fallback: 'Community Group'),
      location: locationText,
      description: _asString(
        json['description'],
        fallback: 'No description available',
      ),
      image: _normalizeImagePath(
        _asString(json['coverImage'], fallback: _asString(json['image'])),
      ),
      memberCount: _asInt(json['memberCount']),
      isJoined: json['isJoined'] == true,
      isRequested: json['isRequested'] == true,
    );
  }

  static String _asString(dynamic value, {String fallback = ''}) {
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }

    return fallback;
  }

  static int _asInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _normalizeImagePath(String path) {
    if (path.isEmpty) {
      return '';
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    if (path.startsWith('/')) {
      return '$_apiOrigin$path';
    }

    return path;
  }
}
