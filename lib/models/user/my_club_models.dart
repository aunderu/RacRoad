// To parse this JSON data, do
//
//     final myClub = myClubFromJson(jsonString);

import 'dart:convert';

MyClub myClubFromJson(String str) => MyClub.fromJson(json.decode(str));

String myClubToJson(MyClub data) => json.encode(data.toJson());

class MyClub {
  MyClub({
    required this.status,
    required this.data,
    required this.message,
  });

  factory MyClub.fromJson(Map<String, dynamic> json) => MyClub(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Data data;
  String message;
  bool status;

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    required this.clubAll,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        clubAll: List<ClubAll>.from(
            json["club_all"].map((x) => ClubAll.fromJson(x))),
      );

  List<ClubAll> clubAll;

  Map<String, dynamic> toJson() => {
        "club_all": List<dynamic>.from(clubAll.map((x) => x.toJson())),
      };
}

class ClubAll {
  ClubAll({
    required this.id,
    required this.clubName,
    required this.clubZone,
    required this.status,
    required this.admin,
  });

  factory ClubAll.fromJson(Map<String, dynamic> json) => ClubAll(
        id: json["id"],
        clubName: json["club_name"],
        clubZone: json["club_zone"],
        status: json["status"],
        admin: json["admin"],
      );

  String admin;
  String clubName;
  String clubZone;
  String id;
  String status;

  Map<String, dynamic> toJson() => {
        "id": id,
        "club_name": clubName,
        "club_zone": clubZone,
        "status": status,
        "admin": admin,
      };
}
