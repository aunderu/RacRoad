// To parse this JSON data, do
//
//     final userClubJoined = userClubJoinedFromJson(jsonString);

import 'dart:convert';

UserClubJoined userClubJoinedFromJson(String str) => UserClubJoined.fromJson(json.decode(str));

String userClubJoinedToJson(UserClubJoined data) => json.encode(data.toJson());

class UserClubJoined {
    UserClubJoined({
        required this.status,
        required this.count,
        required this.data,
        required this.message,
    });

    bool status;
    int count;
    Data data;
    String message;

    factory UserClubJoined.fromJson(Map<String, dynamic> json) => UserClubJoined(
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
        required this.myClubJoin,
    });

    List<MyClubJoin> myClubJoin;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        myClubJoin: List<MyClubJoin>.from(json["my_club_join"].map((x) => MyClubJoin.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "my_club_join": List<dynamic>.from(myClubJoin.map((x) => x.toJson())),
    };
}

class MyClubJoin {
    MyClubJoin({
        required this.memcId,
        required this.id,
        required this.clubName,
        required this.clubZone,
        required this.description,
        required this.clubProfile,
        required this.status,
        required this.admin,
    });

    String memcId;
    String id;
    String clubName;
    String clubZone;
    String description;
    String clubProfile;
    String status;
    String admin;

    factory MyClubJoin.fromJson(Map<String, dynamic> json) => MyClubJoin(
        memcId: json["memc_id"],
        id: json["id"],
        clubName: json["club_name"],
        clubZone: json["club_zone"],
        description: json["description"],
        clubProfile: json["club_profile"],
        status: json["status"],
        admin: json["admin"],
    );

    Map<String, dynamic> toJson() => {
        "memc_id": memcId,
        "id": id,
        "club_name": clubName,
        "club_zone": clubZone,
        "description": description,
        "club_profile": clubProfile,
        "status": status,
        "admin": admin,
    };
}
