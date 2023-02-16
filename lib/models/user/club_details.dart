// To parse this JSON data, do
//
//     final clubDetails = clubDetailsFromJson(jsonString);

import 'dart:convert';

ClubDetails clubDetailsFromJson(String str) => ClubDetails.fromJson(json.decode(str));

String clubDetailsToJson(ClubDetails data) => json.encode(data.toJson());

class ClubDetails {
    ClubDetails({
        required this.status,
        required this.data,
        required this.message,
    });

    factory ClubDetails.fromJson(Map<String, dynamic> json) => ClubDetails(
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
        required this.clubApproveDetail,
        required this.clubDirector,
        required this.tags,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        clubApproveDetail: ClubApproveDetail.fromJson(json["club_approve_detail"]),
        clubDirector: List<ClubDirector>.from(json["club_director"].map((x) => ClubDirector.fromJson(x))),
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
    );

    ClubApproveDetail clubApproveDetail;
    List<ClubDirector> clubDirector;
    List<Tag> tags;

    Map<String, dynamic> toJson() => {
        "club_approve_detail": clubApproveDetail.toJson(),
        "club_director": List<dynamic>.from(clubDirector.map((x) => x.toJson())),
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
    };
}

class ClubApproveDetail {
    ClubApproveDetail({
        required this.id,
        required this.clubName,
        required this.clubZone,
        required this.description,
        required this.admin,
    });

    factory ClubApproveDetail.fromJson(Map<String, dynamic> json) => ClubApproveDetail(
        id: json["id"],
        clubName: json["club_name"],
        clubZone: json["club_zone"],
        description: json["description"],
        admin: json["admin"],
    );

    String admin;
    String clubName;
    String clubZone;
    String description;
    String id;

    Map<String, dynamic> toJson() => {
        "id": id,
        "club_name": clubName,
        "club_zone": clubZone,
        "description": description,
        "admin": admin,
    };
}

class ClubDirector {
    ClubDirector({
        required this.name,
    });

    factory ClubDirector.fromJson(Map<String, dynamic> json) => ClubDirector(
        name: json["name"],
    );

    String name;

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}

class Tag {
    Tag({
        required this.tags,
    });

    factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        tags: json["tags"],
    );

    String tags;

    Map<String, dynamic> toJson() => {
        "tags": tags,
    };
}
