// To parse this JSON data, do
//
//     final myClub = myClubFromJson(jsonString);

import 'dart:convert';

MyClub myClubFromJson(String str) => MyClub.fromJson(json.decode(str));

String myClubToJson(MyClub data) => json.encode(data.toJson());

class MyClub {
    MyClub({
        required this.status,
        required this.count,
        required this.data,
        required this.message,
    });

    bool status;
    int count;
    Data data;
    String message;

    factory MyClub.fromJson(Map<String, dynamic> json) => MyClub(
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
        this.myClub,
    });

    List<MyClubElement>? myClub;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        myClub: json["my_club"] == null ? [] : List<MyClubElement>.from(json["my_club"]!.map((x) => MyClubElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "my_club": myClub == null ? [] : List<dynamic>.from(myClub!.map((x) => x.toJson())),
    };
}

class MyClubElement {
    MyClubElement({
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

    factory MyClubElement.fromJson(Map<String, dynamic> json) => MyClubElement(
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
