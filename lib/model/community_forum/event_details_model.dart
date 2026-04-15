// To parse this JSON data, do
//
//     final eventDetalsModel = eventDetalsModelFromJson(jsonString);

import 'dart:convert';

EventDetalsModel eventDetalsModelFromJson(String str) => EventDetalsModel.fromJson(json.decode(str));

String eventDetalsModelToJson(EventDetalsModel data) => json.encode(data.toJson());

class EventDetalsModel {
    bool? success;
    Data? data;
    String? message;
    int? statusCode;

    EventDetalsModel({
        this.success,
        this.data,
        this.message,
        this.statusCode,
    });

    factory EventDetalsModel.fromJson(Map<String, dynamic> json) => EventDetalsModel(
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
    String? coverImage;
    String? eventType;
    String? eventFormat;
    Location? location;
    String? timezone;
    DateTime? startDateTime;
    String? zoomUrl;
    String? description;
    int? attendeeCount;
    int? shares;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? v;
    bool? isRegistered;
    bool? isFollowing;

    Data({
        this.id,
        this.createdBy,
        this.updatedBy,
        this.isDeleted,
        this.isActive,
        this.name,
        this.coverImage,
        this.eventType,
        this.eventFormat,
        this.location,
        this.timezone,
        this.startDateTime,
        this.zoomUrl,
        this.description,
        this.attendeeCount,
        this.shares,
        this.createdAt,
        this.updatedAt,
        this.v,
        this.isRegistered,
        this.isFollowing,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        createdBy: json["createdBy"] == null ? null : AtedBy.fromJson(json["createdBy"]),
        updatedBy: json["updatedBy"] == null ? null : AtedBy.fromJson(json["updatedBy"]),
        isDeleted: json["isDeleted"],
        isActive: json["isActive"],
        name: json["name"],
        coverImage: json["coverImage"],
        eventType: json["eventType"],
        eventFormat: json["eventFormat"],
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
        timezone: json["timezone"],
        startDateTime: json["startDateTime"] == null ? null : DateTime.parse(json["startDateTime"]),
        zoomUrl: json["zoomUrl"],
        description: json["description"],
        attendeeCount: json["attendeeCount"],
        shares: json["shares"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        isRegistered: json["isRegistered"],
        isFollowing: json["isFollowing"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "createdBy": createdBy?.toJson(),
        "updatedBy": updatedBy?.toJson(),
        "isDeleted": isDeleted,
        "isActive": isActive,
        "name": name,
        "coverImage": coverImage,
        "eventType": eventType,
        "eventFormat": eventFormat,
        "location": location?.toJson(),
        "timezone": timezone,
        "startDateTime": startDateTime?.toIso8601String(),
        "zoomUrl": zoomUrl,
        "description": description,
        "attendeeCount": attendeeCount,
        "shares": shares,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "isRegistered": isRegistered,
        "isFollowing": isFollowing,
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

class Location {
    String? city;
    String? address;
    String? pincode;
    String? state;

    Location({
        this.city,
        this.address,
        this.pincode,
        this.state,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        city: json["city"],
        address: json["address"],
        pincode: json["pincode"],
        state: json["state"],
    );

    Map<String, dynamic> toJson() => {
        "city": city,
        "address": address,
        "pincode": pincode,
        "state": state,
    };
}
