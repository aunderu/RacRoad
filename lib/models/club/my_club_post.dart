// To parse this JSON data, do
//
//     final myClubPosts = myClubPostsFromJson(jsonString);

import 'dart:convert';

MyClubPosts myClubPostsFromJson(String str) => MyClubPosts.fromJson(json.decode(str));

String myClubPostsToJson(MyClubPosts data) => json.encode(data.toJson());

class MyClubPosts {
    MyClubPosts({
        required this.status,
        required this.count,
        required this.data,
        required this.message,
    });

    bool status;
    int count;
    Data data;
    String message;

    factory MyClubPosts.fromJson(Map<String, dynamic> json) => MyClubPosts(
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
        required this.ownerAvatar,
        required this.avatar,
        required this.clubId,
        required this.clubName,
        required this.imagePost,
    });

    String id;
    String description;
    String ownerAvatar;
    String avatar;
    String clubId;
    String clubName;
    List<ImagePost> imagePost;

    factory MyClubPost.fromJson(Map<String, dynamic> json) => MyClubPost(
        id: json["id"],
        description: json["description"],
        ownerAvatar: json["owner_avatar"],
        avatar: json["avatar"],
        clubId: json["club_id"],
        clubName: json["club_name"],
        imagePost: List<ImagePost>.from(json["image_post"].map((x) => ImagePost.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "owner_avatar": ownerAvatar,
        "avatar": avatar,
        "club_id": clubId,
        "club_name": clubName,
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
