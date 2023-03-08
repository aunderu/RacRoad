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

    bool status;
    Data data;
    String message;

    factory ClubDetails.fromJson(Map<String, dynamic> json) => ClubDetails(
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
        required this.clubApproveDetail,
        required this.clubDirector,
        required this.clubMember,
        required this.tags,
    });

    ClubApproveDetail clubApproveDetail;
    List<dynamic> clubDirector;
    List<dynamic> clubMember;
    List<Tag> tags;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        clubApproveDetail: ClubApproveDetail.fromJson(json["club_approve_detail"]),
        clubDirector: List<dynamic>.from(json["club_director"].map((x) => x)),
        clubMember: List<dynamic>.from(json["club_member"].map((x) => x)),
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "club_approve_detail": clubApproveDetail.toJson(),
        "club_director": List<dynamic>.from(clubDirector.map((x) => x)),
        "club_member": List<dynamic>.from(clubMember.map((x) => x)),
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
    };
}

class ClubApproveDetail {
    ClubApproveDetail({
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

    factory ClubApproveDetail.fromJson(Map<String, dynamic> json) => ClubApproveDetail(
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

class Tag {
    Tag({
        required this.tags,
    });

    String tags;

    factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        tags: json["tags"],
    );

    Map<String, dynamic> toJson() => {
        "tags": tags,
    };
}
