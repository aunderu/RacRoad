// To parse this JSON data, do
//
//     final userClubNotJoined = userClubNotJoinedFromJson(jsonString);

import 'dart:convert';

UserClubNotJoined userClubNotJoinedFromJson(String str) => UserClubNotJoined.fromJson(json.decode(str));

String userClubNotJoinedToJson(UserClubNotJoined data) => json.encode(data.toJson());

class UserClubNotJoined {
    UserClubNotJoined({
        required this.status,
        required this.count,
        required this.data,
        required this.message,
    });

    bool status;
    int count;
    Data data;
    String message;

    factory UserClubNotJoined.fromJson(Map<String, dynamic> json) => UserClubNotJoined(
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
        required this.clubNotJoin,
    });

    List<ClubNotJoin> clubNotJoin;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        clubNotJoin: List<ClubNotJoin>.from(json["club_not_join"].map((x) => ClubNotJoin.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "club_not_join": List<dynamic>.from(clubNotJoin.map((x) => x.toJson())),
    };
}

class ClubNotJoin {
    ClubNotJoin({
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

    factory ClubNotJoin.fromJson(Map<String, dynamic> json) => ClubNotJoin(
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
