// To parse this JSON data, do
//
//     final myPosts = myPostsFromJson(jsonString);

import 'dart:convert';

MyPosts myPostsFromJson(String str) => MyPosts.fromJson(json.decode(str));

String myPostsToJson(MyPosts data) => json.encode(data.toJson());

class MyPosts {
    MyPosts({
        required this.status,
        required this.count,
        required this.data,
        required this.message,
    });

    bool status;
    int count;
    Data data;
    String message;

    factory MyPosts.fromJson(Map<String, dynamic> json) => MyPosts(
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
        required this.myPost,
    });

    List<MyPost> myPost;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        myPost: List<MyPost>.from(json["my_post"].map((x) => MyPost.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "my_post": List<dynamic>.from(myPost.map((x) => x.toJson())),
    };
}

class MyPost {
    MyPost({
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

    factory MyPost.fromJson(Map<String, dynamic> json) => MyPost(
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
