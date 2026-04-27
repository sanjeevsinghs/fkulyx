// To parse this JSON data, do
//
//     final groupDetailsModel = groupDetailsModelFromJson(jsonString);

import 'dart:convert';

GroupDetailsModel groupDetailsModelFromJson(String str) => GroupDetailsModel.fromJson(json.decode(str));

String groupDetailsModelToJson(GroupDetailsModel data) => json.encode(data.toJson());

class GroupDetailsModel {
    bool? success;
    Data? data;
    String? message;
    int? statusCode;

    GroupDetailsModel({
        this.success,
        this.data,
        this.message,
        this.statusCode,
    });

    factory GroupDetailsModel.fromJson(Map<String, dynamic> json) => GroupDetailsModel(
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
    String? name;
    String? image;
    String? coverImage;
    String? description;
    List<String>? categories;
    String? rules;
    String? groupType;
    bool? inviteMembers;
    bool? reviewPosts;
    List<String>? groupAdmin;
    int? memberCount;
    String? status;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? v;
    bool? isPinned;
    bool? isJoined;
    bool? isRequested;

    Data({
        this.id,
        this.createdBy,
        this.updatedBy,
        this.isDeleted,
        this.isActive,
        this.name,
        this.image,
        this.coverImage,
        this.description,
        this.categories,
        this.rules,
        this.groupType,
        this.inviteMembers,
        this.reviewPosts,
        this.groupAdmin,
        this.memberCount,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.v,
        this.isPinned,
        this.isJoined,
        this.isRequested,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        createdBy: json["createdBy"] == null ? null : AtedBy.fromJson(json["createdBy"]),
        updatedBy: json["updatedBy"] == null ? null : AtedBy.fromJson(json["updatedBy"]),
        isDeleted: json["isDeleted"],
        isActive: json["isActive"],
        name: json["name"],
        image: json["image"],
        coverImage: json["coverImage"],
        description: json["description"],
        categories: json["categories"] == null ? [] : List<String>.from(json["categories"]!.map((x) => x)),
        rules: json["rules"],
        groupType: json["groupType"],
        inviteMembers: json["inviteMembers"],
        reviewPosts: json["reviewPosts"],
        groupAdmin: json["groupAdmin"] == null ? [] : List<String>.from(json["groupAdmin"]!.map((x) => x)),
        memberCount: json["memberCount"],
        status: json["status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        isPinned: json["isPinned"],
        isJoined: json["isJoined"],
        isRequested: json["isRequested"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "createdBy": createdBy?.toJson(),
        "updatedBy": updatedBy?.toJson(),
        "isDeleted": isDeleted,
        "isActive": isActive,
        "name": name,
        "image": image,
        "coverImage": coverImage,
        "description": description,
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x)),
        "rules": rules,
        "groupType": groupType,
        "inviteMembers": inviteMembers,
        "reviewPosts": reviewPosts,
        "groupAdmin": groupAdmin == null ? [] : List<dynamic>.from(groupAdmin!.map((x) => x)),
        "memberCount": memberCount,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "isPinned": isPinned,
        "isJoined": isJoined,
        "isRequested": isRequested,
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
