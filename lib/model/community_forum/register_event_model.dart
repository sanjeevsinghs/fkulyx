import 'dart:convert';

RegisterEventModel registerEventModelFromJson(String str) =>
    RegisterEventModel.fromJson(json.decode(str));

String registerEventModelToJson(RegisterEventModel data) =>
    json.encode(data.toJson());

class RegisterEventModel {
  bool? success;
  Data? data;
  String? message;

  RegisterEventModel({this.success, this.data, this.message});

  factory RegisterEventModel.fromJson(Map<String, dynamic> json) =>
      RegisterEventModel(
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
  String? id;
  String? eventId;
  AtedBy? userId;
  String? status;
  DateTime? registeredAt;
  DateTime? checkedInAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Data({
    this.id,
    this.eventId,
    this.userId,
    this.status,
    this.registeredAt,
    this.checkedInAt,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    eventId: json["eventId"],
    userId: json["userId"] == null ? null : AtedBy.fromJson(json["userId"]),
    status: json["status"],
    registeredAt: json["registeredAt"] == null
        ? null
        : DateTime.parse(json["registeredAt"]),
    checkedInAt: json["checkedInAt"] == null
        ? null
        : DateTime.parse(json["checkedInAt"]),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "eventId": eventId,
    "userId": userId?.toJson(),
    "status": status,
    "registeredAt": registeredAt?.toIso8601String(),
    "checkedInAt": checkedInAt?.toIso8601String(),
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
    roles: json["roles"] == null ? [] : List<String>.from(json["roles"]),
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
    "roles": roles == null ? [] : List<dynamic>.from(roles!),
    "bio": bio,
    "followersCount": followersCount,
    "followingCount": followingCount,
  };
}
