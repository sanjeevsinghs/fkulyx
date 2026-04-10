class ForumPost {
  final String id;
  final String title;
  final String content;
  final String image;
  final List<String>? tags;
  final int views;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isUpVote;
  final bool isDownVote;
  final bool isFollow;
  final String authorName;
  final String authorTitle;
  final String authorImage;
  final String repostedBy;
  final String repostedByImage;
  final DateTime? createdAt;
  final DateTime? repostedAt;

  ForumPost({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.tags,
    required this.views,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.isUpVote,
    required this.isDownVote,
    required this.isFollow,
    required this.authorName,
    required this.authorTitle,
    required this.authorImage,
    required this.repostedBy,
    required this.repostedByImage,
    required this.createdAt,
    required this.repostedAt,
  });

  List<String> get safeTags => tags ?? const <String>[];

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    final createdBy =
        (json['createdBy'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final media = (json['media'] as List?) ?? const [];
    final mediaImage = media.isNotEmpty && media.first is Map<String, dynamic>
        ? (media.first as Map<String, dynamic>)['url']?.toString()
        : null;

    final createdAt = _parseDateTime(json['createdAt']);
    final repostedAt = _parseDateTime(json['repostedAt']);
    final authorFullName = [
      createdBy['firstName']?.toString().trim() ?? '',
      createdBy['lastName']?.toString().trim() ?? '',
    ].where((part) => part.isNotEmpty).join(' ');

    return ForumPost(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      image: json['image']?.toString().trim().isNotEmpty == true
          ? json['image'].toString()
          : (mediaImage ?? ''),
      tags: _parseTags(json['tags']),
      views: (json['views'] as num?)?.toInt() ?? 0,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      comments: (json['commentsCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] == true,
      isUpVote: json['isUpVote'] == true,
      isDownVote: json['isDownVote'] == true,
      isFollow: json['isFollow'] == true,
      authorName: authorFullName.isNotEmpty
          ? authorFullName
          : (createdBy['username']?.toString() ?? 'Unknown'),
      authorTitle: _formatTimeAgo(createdAt),
      authorImage: createdBy['profileImage']?.toString() ?? '',
      repostedBy:
          (json['repostedBy'] as Map<String, dynamic>?)?['username']
              ?.toString() ??
          '',
      repostedByImage:
          json['repostedByImage']?.toString() ??
          (json['repostedBy'] as Map<String, dynamic>?)?['profileImageUrl']
              ?.toString() ??
          '',
      createdAt: createdAt,
      repostedAt: repostedAt,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value.toString());
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

  static String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Just now';
    }

    final now = DateTime.now().toUtc();
    final input = dateTime.toUtc();
    final difference = now.difference(input);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    if (difference.inDays < 30) return '${difference.inDays ~/ 7}w ago';
    if (difference.inDays < 365) return '${difference.inDays ~/ 30}mo ago';
    return '${difference.inDays ~/ 365}y ago';
  }
}
