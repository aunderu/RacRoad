// To parse this JSON data, do
//
//     final clubPostModel = clubPostModelFromJson(jsonString);

import 'dart:convert';

ClubPostModel clubPostModelFromJson(String str) => ClubPostModel.fromJson(json.decode(str));

String clubPostModelToJson(ClubPostModel data) => json.encode(data.toJson());

class ClubPostModel {
    ClubPostModel({
        required this.status,
        required this.count,
        required this.data,
        required this.message,
    });

    bool status;
    int count;
    Data data;
    String message;

    factory ClubPostModel.fromJson(Map<String, dynamic> json) => ClubPostModel(
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
        required this.myClubPost,
    });

    List<MyClubPost> myClubPost;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        myClubPost: List<MyClubPost>.from(json["my_club_post"].map((x) => MyClubPost.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "my_club_post": List<dynamic>.from(myClubPost.map((x) => x.toJson())),
    };
}

class MyClubPost {
    MyClubPost({
        required this.id,
        required this.description,
        required this.owner,
        required this.ownerAvatar,
        required this.clubId,
        required this.clubName,
        required this.postDate,
        required this.imagePost,
    });

    String id;
    String description;
    String owner;
    String ownerAvatar;
    String clubId;
    String clubName;
    DateTime postDate;
    List<ImagePost> imagePost;

    factory MyClubPost.fromJson(Map<String, dynamic> json) => MyClubPost(
        id: json["id"],
        description: json["description"],
        owner: json["owner"],
        ownerAvatar: json["owner_avatar"],
        clubId: json["club_id"],
        clubName: json["club_name"],
        postDate: DateTime.parse(json["post_date"]),
        imagePost: List<ImagePost>.from(json["image_post"].map((x) => ImagePost.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "owner": owner,
        "owner_avatar": ownerAvatar,
        "club_id": clubId,
        "club_name": clubName,
        "post_date": postDate.toIso8601String(),
        "image_post": List<dynamic>.from(imagePost.map((x) => x.toJson())),
    };
}

class ImagePost {
    ImagePost({
        required this.id,
        required this.image,
    });

    String id;
    String image;

    factory ImagePost.fromJson(Map<String, dynamic> json) => ImagePost(
        id: json["id"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
    };
}
