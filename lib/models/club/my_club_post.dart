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
        this.description,
        required this.owner,
        required this.ownerAvatar,
        required this.clubId,
        required this.clubName,
        required this.postDate,
        required this.imagePost,
        required this.coComment,
        required this.comment,
        required this.coLike,
        required this.like,
    });

    String id;
    String? description;
    String owner;
    String ownerAvatar;
    String clubId;
    String clubName;
    DateTime postDate;
    List<ImagePost> imagePost;
    int coComment;
    List<Comment> comment;
    int coLike;
    List<Comment> like;

    factory MyClubPost.fromJson(Map<String, dynamic> json) => MyClubPost(
        id: json["id"],
        description: json["description"],
        owner: json["owner"],
        ownerAvatar: json["owner_avatar"],
        clubId: json["club_id"],
        clubName: json["club_name"],
        postDate: DateTime.parse(json["post_date"]),
        imagePost: List<ImagePost>.from(json["image_post"].map((x) => ImagePost.fromJson(x))),
        coComment: json["co_comment"],
        comment: List<Comment>.from(json["comment"].map((x) => Comment.fromJson(x))),
        coLike: json["co_like"],
        like: List<Comment>.from(json["like"].map((x) => Comment.fromJson(x))),
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
        "co_comment": coComment,
        "comment": List<dynamic>.from(comment.map((x) => x.toJson())),
        "co_like": coLike,
        "like": List<dynamic>.from(like.map((x) => x.toJson())),
    };
}

class Comment {
    Comment({
        required this.id,
        required this.owner,
        required this.ownerAvatar,
        this.comment,
        this.status,
    });

    String id;
    String owner;
    String ownerAvatar;
    String? comment;
    String? status;

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        owner: json["owner"],
        ownerAvatar: json["owner_avatar"],
        comment: json["comment"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "owner": owner,
        "owner_avatar": ownerAvatar,
        "comment": comment,
        "status": status,
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
