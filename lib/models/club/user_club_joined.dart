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
        required this.userId,
        required this.name,
        required this.clubId,
        required this.clubName,
        this.type,
        required this.status,
    });

    String memcId;
    String userId;
    String name;
    String clubId;
    String clubName;
    String? type;
    String status;

    factory MyClubJoin.fromJson(Map<String, dynamic> json) => MyClubJoin(
        memcId: json["memc_id"],
        userId: json["user_id"],
        name: json["name"],
        clubId: json["club_id"],
        clubName: json["club_name"],
        type: json["type"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "memc_id": memcId,
        "user_id": userId,
        "name": name,
        "club_id": clubId,
        "club_name": clubName,
        "type": type,
        "status": status,
    };
}
