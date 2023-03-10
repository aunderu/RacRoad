// To parse this JSON data, do
//
//     final allClubModel = allClubModelFromJson(jsonString);

import 'dart:convert';

AllClubModel allClubModelFromJson(String str) => AllClubModel.fromJson(json.decode(str));

String allClubModelToJson(AllClubModel data) => json.encode(data.toJson());

class AllClubModel {
    AllClubModel({
        required this.status,
        required this.count,
        required this.data,
        required this.message,
    });

    bool status;
    int count;
    Data data;
    String message;

    factory AllClubModel.fromJson(Map<String, dynamic> json) => AllClubModel(
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
        required this.clubApprove,
    });

    List<ClubApprove> clubApprove;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        clubApprove: List<ClubApprove>.from(json["club_approve"].map((x) => ClubApprove.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "club_approve": List<dynamic>.from(clubApprove.map((x) => x.toJson())),
    };
}

class ClubApprove {
    ClubApprove({
        required this.id,
        required this.clubName,
        required this.clubZone,
        required this.description,
        required this.clubProfile,
        required this.status,
        required this.admin,
    });

    String id;
    String clubName;
    String clubZone;
    String description;
    String clubProfile;
    String status;
    String admin;

    factory ClubApprove.fromJson(Map<String, dynamic> json) => ClubApprove(
        id: json["id"],
        clubName: json["club_name"],
        clubZone: json["club_zone"],
        description: json["description"],
        clubProfile: json["club_profile"],
        status: json["status"],
        admin: json["admin"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "club_name": clubName,
        "club_zone": clubZone,
        "description": description,
        "club_profile": clubProfile,
        "status": status,
        "admin": admin,
    };
}
