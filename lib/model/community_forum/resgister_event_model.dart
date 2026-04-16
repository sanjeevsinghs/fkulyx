// To parse this JSON data, do
//
//     final eventRegisterModel = eventRegisterModelFromJson(jsonString);

import 'dart:convert';

RegisterEventModel registerEventModelFromJson(String str) => RegisterEventModel.fromJson(json.decode(str));

String registerEventModelToJson(RegisterEventModel data) => json.encode(data.toJson());

class RegisterEventModel {
    bool? success;
    Data? data;
    String? message;
    int? statusCode;

    RegisterEventModel({
        this.success,
        this.data,
        this.message,
        this.statusCode,
    });

    factory RegisterEventModel.fromJson(Map<String, dynamic> json) => RegisterEventModel(
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
    String? createdBy;
    String? updatedBy;
    bool? isDeleted;
    bool? isActive;
    String? eventId;
    String? userId;
    String? status;
    String? id;
    DateTime? registeredAt;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? v;

    Data({
        this.createdBy,
        this.updatedBy,
        this.isDeleted,
        this.isActive,
        this.eventId,
        this.userId,
        this.status,
        this.id,
        this.registeredAt,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        isDeleted: json["isDeleted"],
        isActive: json["isActive"],
        eventId: json["eventId"],
        userId: json["userId"],
        status: json["status"],
        id: json["_id"],
        registeredAt: json["registeredAt"] == null ? null : DateTime.parse(json["registeredAt"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "isDeleted": isDeleted,
        "isActive": isActive,
        "eventId": eventId,
        "userId": userId,
        "status": status,
        "_id": id,
        "registeredAt": registeredAt?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
    };
}
