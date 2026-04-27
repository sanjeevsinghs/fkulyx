import 'dart:convert';

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

JoinGroupModel joinGroupModelFromJson(String str) =>
    JoinGroupModel.fromJson(json.decode(str));

String joinGroupModelToJson(JoinGroupModel data) => json.encode(data.toJson());

class JoinGroupModel {
  bool? success;
  Data? data;
  String? message;

  JoinGroupModel({this.success, this.data, this.message});

  factory JoinGroupModel.fromJson(Map<String, dynamic> json) => JoinGroupModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  bool? isJoined;
  Member? member;

  Data({this.isJoined, this.member});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    isJoined: json["isJoined"],
    member: json["member"] == null ? null : Member.fromJson(json["member"]),
  );

  Map<String, dynamic> toJson() => {
    "isJoined": isJoined,
    "member": member?.toJson(),
  };
}

class Member {
  String? id;
  AtedBy? createdBy;
  AtedBy? updatedBy;
  bool? isDeleted;
  bool? isActive;
  GroupId? groupId;
  UserId? userId;
  String? role;
  DateTime? joinedAt;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  dynamic leavedAt;
  dynamic deletedAt;
  dynamic deletedBy;

  Member({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.isDeleted,
    this.isActive,
    this.groupId,
    this.userId,
    this.role,
    this.joinedAt,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.leavedAt,
    this.deletedAt,
    this.deletedBy,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json["_id"],
    createdBy: json["createdBy"] == null
        ? null
        : AtedBy.fromJson(json["createdBy"]),
    updatedBy: json["updatedBy"] == null
        ? null
        : AtedBy.fromJson(json["updatedBy"]),
    isDeleted: json["isDeleted"],
    isActive: json["isActive"],
    groupId: json["groupId"] == null ? null : GroupId.fromJson(json["groupId"]),
    userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
    role: json["role"],
    joinedAt: json["joinedAt"] == null
        ? null
        : DateTime.parse(json["joinedAt"]),
    status: json["status"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    leavedAt: json["leavedAt"],
    deletedAt: json["deletedAt"],
    deletedBy: json["deletedBy"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "createdBy": createdBy?.toJson(),
    "updatedBy": updatedBy?.toJson(),
    "isDeleted": isDeleted,
    "isActive": isActive,
    "groupId": groupId?.toJson(),
    "userId": userId?.toJson(),
    "role": role,
    "joinedAt": joinedAt?.toIso8601String(),
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "leavedAt": leavedAt,
    "deletedAt": deletedAt,
    "deletedBy": deletedBy,
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
    roles: json["roles"] == null
        ? []
        : List<String>.from(json["roles"]!.map((x) => x)),
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

class GroupId {
  String? id;
  String? name;
  String? coverImage;
  String? description;
  String? groupType;

  GroupId({
    this.id,
    this.name,
    this.coverImage,
    this.description,
    this.groupType,
  });

  factory GroupId.fromJson(Map<String, dynamic> json) => GroupId(
    id: json["_id"],
    name: json["name"],
    coverImage: json["coverImage"],
    description: json["description"],
    groupType: json["groupType"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "coverImage": coverImage,
    "description": description,
    "groupType": groupType,
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
