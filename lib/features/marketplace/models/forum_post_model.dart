class ForumPost {
  final String id;
  final String createdBy;
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
    required this.createdBy,
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

  ForumPost copyWith({
    String? id,
    String? title,
    String? createdBy,
    String? content,
    String? image,
    List<String>? tags,
    int? views,
    int? likes,
    int? comments,
    bool? isLiked,
    bool? isUpVote,
    bool? isDownVote,
    bool? isFollow,
    String? authorName,
    String? authorTitle,
    String? authorImage,
    String? repostedBy,
    String? repostedByImage,
    DateTime? createdAt,
    DateTime? repostedAt,
  }) {
    return ForumPost(
      id: id ?? this.id,
      title: title ?? this.title,
      createdBy: createdBy ?? this.createdBy,
      content: content ?? this.content,
      image: image ?? this.image,
      tags: tags ?? this.tags,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
      isUpVote: isUpVote ?? this.isUpVote,
      isDownVote: isDownVote ?? this.isDownVote,
      isFollow: isFollow ?? this.isFollow,
      authorName: authorName ?? this.authorName,
      authorTitle: authorTitle ?? this.authorTitle,
      authorImage: authorImage ?? this.authorImage,
      repostedBy: repostedBy ?? this.repostedBy,
      repostedByImage: repostedByImage ?? this.repostedByImage,
      createdAt: createdAt ?? this.createdAt,
      repostedAt: repostedAt ?? this.repostedAt,
    );
  }

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
      createdBy:
          createdBy['_id']?.toString() ?? createdBy['id']?.toString() ?? '',
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

// // To parse this JSON data, do
// //
// //     final welcome = welcomeFromJson(jsonString);

// import 'dart:convert';

// Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

// String welcomeToJson(Welcome data) => json.encode(data.toJson());

// class Welcome {
//     bool? success;
//     Data? data;
//     String? message;
//     int? statusCode;

//     Welcome({
//         this.success,
//         this.data,
//         this.message,
//         this.statusCode,
//     });

//     factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
//         success: json["success"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//         message: json["message"],
//         statusCode: json["statusCode"],
//     );

//     Map<String, dynamic> toJson() => {
//         "success": success,
//         "data": data?.toJson(),
//         "message": message,
//         "statusCode": statusCode,
//     };
// }

// class Data {
//     List<Item>? items;
//     int? total;
//     int? page;
//     int? limit;
//     int? totalPages;

//     Data({
//         this.items,
//         this.total,
//         this.page,
//         this.limit,
//         this.totalPages,
//     });

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
//         total: json["total"],
//         page: json["page"],
//         limit: json["limit"],
//         totalPages: json["totalPages"],
//     );

//     Map<String, dynamic> toJson() => {
//         "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
//         "total": total,
//         "page": page,
//         "limit": limit,
//         "totalPages": totalPages,
//     };
// }

// class Item {
//     String? id;
//     AtedBy? createdBy;
//     AtedBy? updatedBy;
//     bool? isDeleted;
//     bool? isActive;
//     String? title;
//     List<Media>? media;
//     List<String>? tags;
//     int? views;
//     int? likes;
//     List<String>? likedBy;
//     int? upVotes;
//     int? downVotes;
//     List<String>? upVotedBy;
//     List<dynamic>? downVotedBy;
//     int? commentsCount;
//     int? repostCount;
//     int? shares;
//     Status? status;
//     List<Poll>? polls;
//     DateTime? createdAt;
//     DateTime? updatedAt;
//     int? v;
//     DateTime? sortAt;
//     RepostedBy? repostedBy;
//     String? repostedByImage;
//     DateTime? repostedAt;
//     String? image;
//     bool? isLiked;
//     bool? isUpVote;
//     bool? isDownVote;
//     bool? isFollow;
//     String? content;

//     Item({
//         this.id,
//         this.createdBy,
//         this.updatedBy,
//         this.isDeleted,
//         this.isActive,
//         this.title,
//         this.media,
//         this.tags,
//         this.views,
//         this.likes,
//         this.likedBy,
//         this.upVotes,
//         this.downVotes,
//         this.upVotedBy,
//         this.downVotedBy,
//         this.commentsCount,
//         this.repostCount,
//         this.shares,
//         this.status,
//         this.polls,
//         this.createdAt,
//         this.updatedAt,
//         this.v,
//         this.sortAt,
//         this.repostedBy,
//         this.repostedByImage,
//         this.repostedAt,
//         this.image,
//         this.isLiked,
//         this.isUpVote,
//         this.isDownVote,
//         this.isFollow,
//         this.content,
//     });

//     factory Item.fromJson(Map<String, dynamic> json) => Item(
//         id: json["_id"],
//         createdBy: json["createdBy"] == null ? null : AtedBy.fromJson(json["createdBy"]),
//         updatedBy: json["updatedBy"] == null ? null : AtedBy.fromJson(json["updatedBy"]),
//         isDeleted: json["isDeleted"],
//         isActive: json["isActive"],
//         title: json["title"],
//         media: json["media"] == null ? [] : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
//         tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
//         views: json["views"],
//         likes: json["likes"],
//         likedBy: json["likedBy"] == null ? [] : List<String>.from(json["likedBy"]!.map((x) => x)),
//         upVotes: json["upVotes"],
//         downVotes: json["downVotes"],
//         upVotedBy: json["upVotedBy"] == null ? [] : List<String>.from(json["upVotedBy"]!.map((x) => x)),
//         downVotedBy: json["downVotedBy"] == null ? [] : List<dynamic>.from(json["downVotedBy"]!.map((x) => x)),
//         commentsCount: json["commentsCount"],
//         repostCount: json["repostCount"],
//         shares: json["shares"],
//         status: statusValues.map[json["status"]]!,
//         polls: json["polls"] == null ? [] : List<Poll>.from(json["polls"]!.map((x) => Poll.fromJson(x))),
//         createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//         sortAt: json["sortAt"] == null ? null : DateTime.parse(json["sortAt"]),
//         repostedBy: json["repostedBy"] == null ? null : RepostedBy.fromJson(json["repostedBy"]),
//         repostedByImage: json["repostedByImage"],
//         repostedAt: json["repostedAt"] == null ? null : DateTime.parse(json["repostedAt"]),
//         image: json["image"],
//         isLiked: json["isLiked"],
//         isUpVote: json["isUpVote"],
//         isDownVote: json["isDownVote"],
//         isFollow: json["isFollow"],
//         content: json["content"],
//     );

//     Map<String, dynamic> toJson() => {
//         "_id": id,
//         "createdBy": createdBy?.toJson(),
//         "updatedBy": updatedBy?.toJson(),
//         "isDeleted": isDeleted,
//         "isActive": isActive,
//         "title": title,
//         "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
//         "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
//         "views": views,
//         "likes": likes,
//         "likedBy": likedBy == null ? [] : List<dynamic>.from(likedBy!.map((x) => x)),
//         "upVotes": upVotes,
//         "downVotes": downVotes,
//         "upVotedBy": upVotedBy == null ? [] : List<dynamic>.from(upVotedBy!.map((x) => x)),
//         "downVotedBy": downVotedBy == null ? [] : List<dynamic>.from(downVotedBy!.map((x) => x)),
//         "commentsCount": commentsCount,
//         "repostCount": repostCount,
//         "shares": shares,
//         "status": statusValues.reverse[status],
//         "polls": polls == null ? [] : List<dynamic>.from(polls!.map((x) => x.toJson())),
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "__v": v,
//         "sortAt": sortAt?.toIso8601String(),
//         "repostedBy": repostedBy?.toJson(),
//         "repostedByImage": repostedByImage,
//         "repostedAt": repostedAt?.toIso8601String(),
//         "image": image,
//         "isLiked": isLiked,
//         "isUpVote": isUpVote,
//         "isDownVote": isDownVote,
//         "isFollow": isFollow,
//         "content": content,
//     };
// }

// class AtedBy {
//     Id? id;
//     Username? username;
//     FirstName? firstName;
//     LastName? lastName;
//     Email? email;
//     String? profileImage;
//     String? coverImage;
//     List<Role>? roles;
//     Bio? bio;
//     int? followersCount;
//     int? followingCount;

//     AtedBy({
//         this.id,
//         this.username,
//         this.firstName,
//         this.lastName,
//         this.email,
//         this.profileImage,
//         this.coverImage,
//         this.roles,
//         this.bio,
//         this.followersCount,
//         this.followingCount,
//     });

//     factory AtedBy.fromJson(Map<String, dynamic> json) => AtedBy(
//         id: idValues.map[json["_id"]]!,
//         username: usernameValues.map[json["username"]]!,
//         firstName: firstNameValues.map[json["firstName"]]!,
//         lastName: lastNameValues.map[json["lastName"]]!,
//         email: emailValues.map[json["email"]]!,
//         profileImage: json["profileImage"],
//         coverImage: json["coverImage"],
//         roles: json["roles"] == null ? [] : List<Role>.from(json["roles"]!.map((x) => roleValues.map[x]!)),
//         bio: bioValues.map[json["bio"]]!,
//         followersCount: json["followersCount"],
//         followingCount: json["followingCount"],
//     );

//     Map<String, dynamic> toJson() => {
//         "_id": idValues.reverse[id],
//         "username": usernameValues.reverse[username],
//         "firstName": firstNameValues.reverse[firstName],
//         "lastName": lastNameValues.reverse[lastName],
//         "email": emailValues.reverse[email],
//         "profileImage": profileImage,
//         "coverImage": coverImage,
//         "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => roleValues.reverse[x])),
//         "bio": bioValues.reverse[bio],
//         "followersCount": followersCount,
//         "followingCount": followingCount,
//     };
// }

// enum Bio {
//     EMPTY,
//     STRING
// }

// final bioValues = EnumValues({
//     "": Bio.EMPTY,
//     "string": Bio.STRING
// });

// enum Email {
//     ARVIND_GMAIL_COM,
//     KUNAL_GMAIL_COM,
//     NICEV34290_LEALKING_COM
// }

// final emailValues = EnumValues({
//     "arvind@gmail.com": Email.ARVIND_GMAIL_COM,
//     "kunal@gmail.com": Email.KUNAL_GMAIL_COM,
//     "nicev34290@lealking.com": Email.NICEV34290_LEALKING_COM
// });

// enum FirstName {
//     ARVIND,
//     KUNAL,
//     YAJ
// }

// final firstNameValues = EnumValues({
//     "arvind": FirstName.ARVIND,
//     "Kunal": FirstName.KUNAL,
//     "yaj": FirstName.YAJ
// });

// enum Id {
//     THE_6932_A70_F5_FE19_BF71_A05_DA88,
//     THE_6953_BF58_BFBB5_DA8_C0_C18_B50,
//     THE_69_D48_C99_D0430438_AFA03_B0_A
// }

// final idValues = EnumValues({
//     "6932a70f5fe19bf71a05da88": Id.THE_6932_A70_F5_FE19_BF71_A05_DA88,
//     "6953bf58bfbb5da8c0c18b50": Id.THE_6953_BF58_BFBB5_DA8_C0_C18_B50,
//     "69d48c99d0430438afa03b0a": Id.THE_69_D48_C99_D0430438_AFA03_B0_A
// });

// enum LastName {
//     OJHA,
//     SHARMA,
//     WR
// }

// final lastNameValues = EnumValues({
//     "ojha": LastName.OJHA,
//     "Sharma": LastName.SHARMA,
//     "wr": LastName.WR
// });

// enum Role {
//     CHEF,
//     RESTAURANT,
//     USER
// }

// final roleValues = EnumValues({
//     "chef": Role.CHEF,
//     "restaurant": Role.RESTAURANT,
//     "user": Role.USER
// });

// enum Username {
//     ARVINDOJHA,
//     ERERE,
//     KUNU
// }

// final usernameValues = EnumValues({
//     "arvindojha": Username.ARVINDOJHA,
//     "erere": Username.ERERE,
//     "kunu": Username.KUNU
// });

// class Media {
//     Type? type;
//     String? url;
//     MimeType? mimeType;
//     String? originalName;
//     int? size;
//     String? key;
//     Bucket? bucket;

//     Media({
//         this.type,
//         this.url,
//         this.mimeType,
//         this.originalName,
//         this.size,
//         this.key,
//         this.bucket,
//     });

//     factory Media.fromJson(Map<String, dynamic> json) => Media(
//         type: typeValues.map[json["type"]]!,
//         url: json["url"],
//         mimeType: mimeTypeValues.map[json["mimeType"]]!,
//         originalName: json["originalName"],
//         size: json["size"],
//         key: json["key"],
//         bucket: bucketValues.map[json["bucket"]]!,
//     );

//     Map<String, dynamic> toJson() => {
//         "type": typeValues.reverse[type],
//         "url": url,
//         "mimeType": mimeTypeValues.reverse[mimeType],
//         "originalName": originalName,
//         "size": size,
//         "key": key,
//         "bucket": bucketValues.reverse[bucket],
//     };
// }

// enum Bucket {
//     KULUXDEV
// }

// final bucketValues = EnumValues({
//     "kuluxdev": Bucket.KULUXDEV
// });

// enum MimeType {
//     IMAGE_JPEG,
//     IMAGE_PNG
// }

// final mimeTypeValues = EnumValues({
//     "image/jpeg": MimeType.IMAGE_JPEG,
//     "image/png": MimeType.IMAGE_PNG
// });

// enum Type {
//     IMAGE
// }

// final typeValues = EnumValues({
//     "image": Type.IMAGE
// });

// class Poll {
//     String? question;
//     List<Option>? options;
//     bool? allowMultipleSelections;
//     bool? isActive;
//     String? id;
//     int? totalVotes;

//     Poll({
//         this.question,
//         this.options,
//         this.allowMultipleSelections,
//         this.isActive,
//         this.id,
//         this.totalVotes,
//     });

//     factory Poll.fromJson(Map<String, dynamic> json) => Poll(
//         question: json["question"],
//         options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
//         allowMultipleSelections: json["allowMultipleSelections"],
//         isActive: json["isActive"],
//         id: json["_id"],
//         totalVotes: json["totalVotes"],
//     );

//     Map<String, dynamic> toJson() => {
//         "question": question,
//         "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
//         "allowMultipleSelections": allowMultipleSelections,
//         "isActive": isActive,
//         "_id": id,
//         "totalVotes": totalVotes,
//     };
// }

// class Option {
//     String? text;
//     int? voteCount;
//     List<dynamic>? voters;
//     List<dynamic>? media;
//     int? percentage;

//     Option({
//         this.text,
//         this.voteCount,
//         this.voters,
//         this.media,
//         this.percentage,
//     });

//     factory Option.fromJson(Map<String, dynamic> json) => Option(
//         text: json["text"],
//         voteCount: json["voteCount"],
//         voters: json["voters"] == null ? [] : List<dynamic>.from(json["voters"]!.map((x) => x)),
//         media: json["media"] == null ? [] : List<dynamic>.from(json["media"]!.map((x) => x)),
//         percentage: json["percentage"],
//     );

//     Map<String, dynamic> toJson() => {
//         "text": text,
//         "voteCount": voteCount,
//         "voters": voters == null ? [] : List<dynamic>.from(voters!.map((x) => x)),
//         "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
//         "percentage": percentage,
//     };
// }

// class RepostedBy {
//     String? userId;
//     String? username;
//     int? repostCount;
//     String? createdAt;
//     String? profileImageUrl;

//     RepostedBy({
//         this.userId,
//         this.username,
//         this.repostCount,
//         this.createdAt,
//         this.profileImageUrl,
//     });

//     factory RepostedBy.fromJson(Map<String, dynamic> json) => RepostedBy(
//         userId: json["userId"],
//         username: json["username"],
//         repostCount: json["repostCount"],
//         createdAt: json["createdAt"],
//         profileImageUrl: json["profileImageUrl"],
//     );

//     Map<String, dynamic> toJson() => {
//         "userId": userId,
//         "username": username,
//         "repostCount": repostCount,
//         "createdAt": createdAt,
//         "profileImageUrl": profileImageUrl,
//     };
// }

// enum Status {
//     ACTIVE
// }

// final statusValues = EnumValues({
//     "active": Status.ACTIVE
// });

// class EnumValues<T> {
//     Map<String, T> map;
//     late Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//             reverseMap = map.map((k, v) => MapEntry(v, k));
//             return reverseMap;
//     }
// }
