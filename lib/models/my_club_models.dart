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

  bool status;
  Data data;
  String message;

  factory MyClub.fromJson(Map<String, dynamic> json) => MyClub(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

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

  List<ClubAll> clubAll;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        clubAll: List<ClubAll>.from(
            json["club_all"].map((x) => ClubAll.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "club_all": List<dynamic>.from(clubAll.map((x) => x.toJson())),
      };
}

class ClubAll {
  ClubAll({
    required this.id,
    required this.clubName,
    required this.clubZone,
    required this.admin,
  });

  String id;
  String clubName;
  String clubZone;
  String admin;

  factory ClubAll.fromJson(Map<String, dynamic> json) => ClubAll(
        id: json["id"],
        clubName: json["club_name"],
        clubZone: json["club_zone"],
        admin: json["admin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "club_name": clubName,
        "club_zone": clubZone,
        "admin": admin,
      };
}
