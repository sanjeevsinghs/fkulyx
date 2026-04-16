// To parse this JSON data, do
//
//     final postDetailsModel = postDetailsModelFromJson(jsonString);

import 'dart:convert';

PostDetailsModel postDetailsModelFromJson(String str) => PostDetailsModel.fromJson(json.decode(str));

String postDetailsModelToJson(PostDetailsModel data) => json.encode(data.toJson());

class PostDetailsModel {
    bool? success;
    Data? data;
    String? message;
    int? statusCode;

    PostDetailsModel({
        this.success,
        this.data,
        this.message,
        this.statusCode,
    });

    factory PostDetailsModel.fromJson(Map<String, dynamic> json) => PostDetailsModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
        statusCode: json["statusCode"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
        "statusCode": statusCode,
    };
}

class Data {
    String? id;
    AtedBy? createdBy;
    AtedBy? updatedBy;
    bool? isDeleted;
    bool? isActive;
    String? title;
    List<Media>? media;
    List<dynamic>? tags;
    int? views;
    int? likes;
    List<dynamic>? likedBy;
    int? upVotes;
    int? downVotes;
    List<dynamic>? upVotedBy;
    List<String>? downVotedBy;
    int? commentsCount;
    int? repostCount;
    int? shares;
    String? status;
    List<dynamic>? polls;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? v;
    DateTime? sortAt;
    RepostedBy? repostedBy;
    dynamic repostedByImage;
    DateTime? repostedAt;
    bool? isLiked;
    bool? isUpVote;
    bool? isDownVote;
    List<Comment>? comments;
    String? image;

    Data({
        this.id,
        this.createdBy,
        this.updatedBy,
        this.isDeleted,
        this.isActive,
        this.title,
        this.media,
        this.tags,
        this.views,
        this.likes,
        this.likedBy,
        this.upVotes,
        this.downVotes,
        this.upVotedBy,
        this.downVotedBy,
        this.commentsCount,
        this.repostCount,
        this.shares,
        this.status,
        this.polls,
        this.createdAt,
        this.updatedAt,
        this.v,
        this.sortAt,
        this.repostedBy,
        this.repostedByImage,
        this.repostedAt,
        this.isLiked,
        this.isUpVote,
        this.isDownVote,
        this.comments,
        this.image,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        createdBy: json["createdBy"] == null ? null : AtedBy.fromJson(json["createdBy"]),
        updatedBy: json["updatedBy"] == null ? null : AtedBy.fromJson(json["updatedBy"]),
        isDeleted: json["isDeleted"],
        isActive: json["isActive"],
        title: json["title"],
        media: json["media"] == null ? [] : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
        tags: json["tags"] == null ? [] : List<dynamic>.from(json["tags"]!.map((x) => x)),
        views: json["views"],
        likes: json["likes"],
        likedBy: json["likedBy"] == null ? [] : List<dynamic>.from(json["likedBy"]!.map((x) => x)),
        upVotes: json["upVotes"],
        downVotes: json["downVotes"],
        upVotedBy: json["upVotedBy"] == null ? [] : List<dynamic>.from(json["upVotedBy"]!.map((x) => x)),
        downVotedBy: json["downVotedBy"] == null ? [] : List<String>.from(json["downVotedBy"]!.map((x) => x)),
        commentsCount: json["commentsCount"],
        repostCount: json["repostCount"],
        shares: json["shares"],
        status: json["status"],
        polls: json["polls"] == null ? [] : List<dynamic>.from(json["polls"]!.map((x) => x)),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        sortAt: json["sortAt"] == null ? null : DateTime.parse(json["sortAt"]),
        repostedBy: json["repostedBy"] == null ? null : RepostedBy.fromJson(json["repostedBy"]),
        repostedByImage: json["repostedByImage"],
        repostedAt: json["repostedAt"] == null ? null : DateTime.parse(json["repostedAt"]),
        isLiked: json["isLiked"],
        isUpVote: json["isUpVote"],
        isDownVote: json["isDownVote"],
        comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "createdBy": createdBy?.toJson(),
        "updatedBy": updatedBy?.toJson(),
        "isDeleted": isDeleted,
        "isActive": isActive,
        "title": title,
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "views": views,
        "likes": likes,
        "likedBy": likedBy == null ? [] : List<dynamic>.from(likedBy!.map((x) => x)),
        "upVotes": upVotes,
        "downVotes": downVotes,
        "upVotedBy": upVotedBy == null ? [] : List<dynamic>.from(upVotedBy!.map((x) => x)),
        "downVotedBy": downVotedBy == null ? [] : List<dynamic>.from(downVotedBy!.map((x) => x)),
        "commentsCount": commentsCount,
        "repostCount": repostCount,
        "shares": shares,
        "status": status,
        "polls": polls == null ? [] : List<dynamic>.from(polls!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "sortAt": sortAt?.toIso8601String(),
        "repostedBy": repostedBy?.toJson(),
        "repostedByImage": repostedByImage,
        "repostedAt": repostedAt?.toIso8601String(),
        "isLiked": isLiked,
        "isUpVote": isUpVote,
        "isDownVote": isDownVote,
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "image": image,
    };
}

class Comment {
    String? id;
    AtedBy? createdBy;
    AtedBy? updatedBy;
    bool? isDeleted;
    bool? isActive;
    String? postId;
    UserId? userId;
    ParentCommentId? parentCommentId;
    String? content;
    int? likes;
    List<dynamic>? likedBy;
    int? dislikes;
    List<dynamic>? dislikedBy;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? v;

    Comment({
        this.id,
        this.createdBy,
        this.updatedBy,
        this.isDeleted,
        this.isActive,
        this.postId,
        this.userId,
        this.parentCommentId,
        this.content,
        this.likes,
        this.likedBy,
        this.dislikes,
        this.dislikedBy,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["_id"],
        createdBy: json["createdBy"] == null ? null : AtedBy.fromJson(json["createdBy"]),
        updatedBy: json["updatedBy"] == null ? null : AtedBy.fromJson(json["updatedBy"]),
        isDeleted: json["isDeleted"],
        isActive: json["isActive"],
        postId: json["postId"],
        userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
        parentCommentId: json["parentCommentId"] == null ? null : ParentCommentId.fromJson(json["parentCommentId"]),
        content: json["content"],
        likes: json["likes"],
        likedBy: json["likedBy"] == null ? [] : List<dynamic>.from(json["likedBy"]!.map((x) => x)),
        dislikes: json["dislikes"],
        dislikedBy: json["dislikedBy"] == null ? [] : List<dynamic>.from(json["dislikedBy"]!.map((x) => x)),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "createdBy": createdBy?.toJson(),
        "updatedBy": updatedBy?.toJson(),
        "isDeleted": isDeleted,
        "isActive": isActive,
        "postId": postId,
        "userId": userId?.toJson(),
        "parentCommentId": parentCommentId?.toJson(),
        "content": content,
        "likes": likes,
        "likedBy": likedBy == null ? [] : List<dynamic>.from(likedBy!.map((x) => x)),
        "dislikes": dislikes,
        "dislikedBy": dislikedBy == null ? [] : List<dynamic>.from(dislikedBy!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
    };
}

class AtedBy {
    String? id;
    String? username;
    String? firstName;
    String? lastName;
    String? email;
    String? profileImage;
    String? coverImage;
    List<String>? roles;
    String? bio;
    int? followersCount;
    int? followingCount;

    AtedBy({
        this.id,
        this.username,
        this.firstName,
        this.lastName,
        this.email,
        this.profileImage,
        this.coverImage,
        this.roles,
        this.bio,
        this.followersCount,
        this.followingCount,
    });

    factory AtedBy.fromJson(Map<String, dynamic> json) => AtedBy(
        id: json["_id"],
        username: json["username"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        profileImage: json["profileImage"],
        coverImage: json["coverImage"],
        roles: json["roles"] == null ? [] : List<String>.from(json["roles"]!.map((x) => x)),
        bio: json["bio"],
        followersCount: json["followersCount"],
        followingCount: json["followingCount"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "profileImage": profileImage,
        "coverImage": coverImage,
        "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x)),
        "bio": bio,
        "followersCount": followersCount,
        "followingCount": followingCount,
    };
}

class ParentCommentId {
    String? id;
    String? userId;
    String? content;
    DateTime? createdAt;

    ParentCommentId({
        this.id,
        this.userId,
        this.content,
        this.createdAt,
    });

    factory ParentCommentId.fromJson(Map<String, dynamic> json) => ParentCommentId(
        id: json["_id"],
        userId: json["userId"],
        content: json["content"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "content": content,
        "createdAt": createdAt?.toIso8601String(),
    };
}

class UserId {
    String? id;
    String? username;
    String? firstName;
    String? lastName;
    dynamic profileImage;

    UserId({
        this.id,
        this.username,
        this.firstName,
        this.lastName,
        this.profileImage,
    });

    factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        username: json["username"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profileImage: json["profileImage"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "profileImage": profileImage,
    };
}

class Media {
    String? type;
    String? url;
    String? mimeType;
    String? originalName;
    int? size;
    String? key;
    String? bucket;

    Media({
        this.type,
        this.url,
        this.mimeType,
        this.originalName,
        this.size,
        this.key,
        this.bucket,
    });

    factory Media.fromJson(Map<String, dynamic> json) => Media(
        type: json["type"],
        url: json["url"],
        mimeType: json["mimeType"],
        originalName: json["originalName"],
        size: json["size"],
        key: json["key"],
        bucket: json["bucket"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "url": url,
        "mimeType": mimeType,
        "originalName": originalName,
        "size": size,
        "key": key,
        "bucket": bucket,
    };
}

class RepostedBy {
    String? userId;
    String? username;
    dynamic profileImageUrl;
    int? repostCount;
    String? createdAt;

    RepostedBy({
        this.userId,
        this.username,
        this.profileImageUrl,
        this.repostCount,
        this.createdAt,
    });

    factory RepostedBy.fromJson(Map<String, dynamic> json) => RepostedBy(
        userId: json["userId"],
        username: json["username"],
        profileImageUrl: json["profileImageUrl"],
        repostCount: json["repostCount"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "username": username,
        "profileImageUrl": profileImageUrl,
        "repostCount": repostCount,
        "createdAt": createdAt,
    };
}
