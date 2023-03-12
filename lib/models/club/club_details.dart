// To parse this JSON data, do
//
//     final clubDetailsModel = clubDetailsModelFromJson(jsonString);

import 'dart:convert';

ClubDetailsModel clubDetailsModelFromJson(String str) => ClubDetailsModel.fromJson(json.decode(str));

String clubDetailsModelToJson(ClubDetailsModel data) => json.encode(data.toJson());

class ClubDetailsModel {
    ClubDetailsModel({
        required this.status,
        required this.data,
        required this.message,
    });

    bool status;
    Data data;
    String message;

    factory ClubDetailsModel.fromJson(Map<String, dynamic> json) => ClubDetailsModel(
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
        required this.statusMember,
        required this.clubMember,
        required this.adminId,
        required this.adminClub,
        required this.adminAvatar,
        required this.clubApproveDetail,
        required this.userInMyClub,
        required this.tags,
    });

    String statusMember;
    int clubMember;
    String adminId;
    String adminClub;
    String adminAvatar;
    ClubApproveDetail clubApproveDetail;
    List<UserInMyClub> userInMyClub;
    List<Tag> tags;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        statusMember: json["status_member"],
        clubMember: json["club_member"],
        adminId: json["admin_id"],
        adminClub: json["admin_club"],
        adminAvatar: json["admin_avatar"],
        clubApproveDetail: ClubApproveDetail.fromJson(json["club_approve_detail"]),
        userInMyClub: List<UserInMyClub>.from(json["user_in_my_club"].map((x) => UserInMyClub.fromJson(x))),
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status_member": statusMember,
        "club_member": clubMember,
        "admin_id": adminId,
        "admin_club": adminClub,
        "admin_avatar": adminAvatar,
        "club_approve_detail": clubApproveDetail.toJson(),
        "user_in_my_club": List<dynamic>.from(userInMyClub.map((x) => x.toJson())),
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
        required this.adminId,
        required this.admin,
    });

    String id;
    String clubName;
    String clubZone;
    String description;
    String clubProfile;
    String status;
    String adminId;
    String admin;

    factory ClubApproveDetail.fromJson(Map<String, dynamic> json) => ClubApproveDetail(
        id: json["id"],
        clubName: json["club_name"],
        clubZone: json["club_zone"],
        description: json["description"],
        clubProfile: json["club_profile"],
        status: json["status"],
        adminId: json["admin_id"],
        admin: json["admin"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "club_name": clubName,
        "club_zone": clubZone,
        "description": description,
        "club_profile": clubProfile,
        "status": status,
        "admin_id": adminId,
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

class UserInMyClub {
    UserInMyClub({
        required this.memcId,
        required this.userId,
        required this.name,
        required this.type,
        required this.status,
        required this.avatar,
    });

    String memcId;
    String userId;
    String name;
    String type;
    String status;
    String avatar;

    factory UserInMyClub.fromJson(Map<String, dynamic> json) => UserInMyClub(
        memcId: json["memc_id"],
        userId: json["user_id"],
        name: json["name"],
        type: json["type"],
        status: json["status"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "memc_id": memcId,
        "user_id": userId,
        "name": name,
        "type": type,
        "status": status,
        "avatar": avatar,
    };
}
