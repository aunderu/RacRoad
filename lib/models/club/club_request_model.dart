// To parse this JSON data, do
//
//     final clubRequestModel = clubRequestModelFromJson(jsonString);

import 'dart:convert';

ClubRequestModel clubRequestModelFromJson(String str) => ClubRequestModel.fromJson(json.decode(str));

String clubRequestModelToJson(ClubRequestModel data) => json.encode(data.toJson());

class ClubRequestModel {
    ClubRequestModel({
        required this.status,
        required this.count,
        required this.data,
        required this.message,
    });

    bool status;
    int count;
    Data data;
    String message;

    factory ClubRequestModel.fromJson(Map<String, dynamic> json) => ClubRequestModel(
        status: json["status"],
        count: json["count"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "count": count,
        "data": data.toJson(),
        "message": message,
    };
}

class Data {
    Data({
        required this.requestMyClub,
    });

    List<RequestMyClub> requestMyClub;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        requestMyClub: List<RequestMyClub>.from(json["request_my_club"].map((x) => RequestMyClub.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "request_my_club": List<dynamic>.from(requestMyClub.map((x) => x.toJson())),
    };
}

class RequestMyClub {
    RequestMyClub({
        required this.memcId,
        required this.userId,
        required this.name,
        required this.ownerAvatar,
    });

    String memcId;
    String userId;
    String name;
    String ownerAvatar;

    factory RequestMyClub.fromJson(Map<String, dynamic> json) => RequestMyClub(
        memcId: json["memc_id"],
        userId: json["user_id"],
        name: json["name"],
        ownerAvatar: json["owner_avatar"],
    );

    Map<String, dynamic> toJson() => {
        "memc_id": memcId,
        "user_id": userId,
        "name": name,
        "owner_avatar": ownerAvatar,
    };
}
