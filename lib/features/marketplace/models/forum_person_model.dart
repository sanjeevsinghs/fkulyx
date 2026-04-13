class ForumPerson {
  final String id;
  final String name;
  final String role;
  final String location;
  final String image;
  final bool isFollow;
  final List<String> tags;

  ForumPerson({
    required this.id,
    required this.name,
    required this.role,
    required this.location,
    required this.image,
    required this.isFollow,
    required this.tags,
  });

  ForumPerson copyWith({
    String? id,
    String? name,
    String? role,
    String? location,
    String? image,
    bool? isFollow,
    List<String>? tags,
  }) {
    return ForumPerson(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      location: location ?? this.location,
      image: image ?? this.image,
      isFollow: isFollow ?? this.isFollow,
      tags: tags ?? this.tags,
    );
  }

  factory ForumPerson.fromJson(Map<String, dynamic> json) {
    final role = _resolveRole(json['roles']);
    return ForumPerson(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? (json['username']?.toString() ?? ''),
      role: role,
      location: '@${json['username']?.toString() ?? ''}',
      image: _resolveProfileImage(json['profileImage']),
      isFollow: json['isFollow'] == true,
      tags: _parseTags(json['tags']),
    );
  }

  static String _resolveRole(dynamic rolesRaw) {
    if (rolesRaw is List && rolesRaw.isNotEmpty) {
      return rolesRaw.first.toString();
    }
    return 'user';
  }

  static String _resolveProfileImage(dynamic imageRaw) {
    if (imageRaw == null) {
      return '';
    }

    if (imageRaw is String) {
      return imageRaw;
    }

    if (imageRaw is Map<String, dynamic>) {
      return imageRaw['url']?.toString() ?? '';
    }

    return '';
  }

  static List<String> _parseTags(dynamic rawTags) {
    if (rawTags == null) {
      return const <String>[];
    }

    if (rawTags is List) {
      return rawTags
          .where((tag) => tag != null)
          .map((tag) => tag.toString().trim())
          .where((tag) => tag.isNotEmpty)
          .toList();
    }

    if (rawTags is String) {
      final tag = rawTags.trim();
      return tag.isEmpty ? const <String>[] : <String>[tag];
    }

    return const <String>[];
  }
}
