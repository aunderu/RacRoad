// To parse this JSON data, do
//
//     final newFeedModel = newFeedModelFromJson(jsonString);

import 'dart:convert';

NewFeedModel newFeedModelFromJson(String str) =>
    NewFeedModel.fromJson(json.decode(str));

String newFeedModelToJson(NewFeedModel data) => json.encode(data.toJson());

class NewFeedModel {
  NewFeedModel({
    required this.status,
    required this.count,
    required this.data,
    required this.message,
  });

  factory NewFeedModel.fromJson(Map<String, dynamic> json) => NewFeedModel(
        status: json["status"],
        count: json["count"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  int count;
  Data data;
  String message;
  bool status;

  Map<String, dynamic> toJson() => {
        "status": status,
        "count": count,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    required this.postInMyClubJoin,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        postInMyClubJoin: List<PostInMyClubJoin>.from(
            json["post_in_my_club_join"]
                .map((x) => PostInMyClubJoin.fromJson(x))),
      );

  List<PostInMyClubJoin> postInMyClubJoin;

  Map<String, dynamic> toJson() => {
        "post_in_my_club_join":
            List<dynamic>.from(postInMyClubJoin.map((x) => x.toJson())),
      };
}

class PostInMyClubJoin {
  PostInMyClubJoin({
    required this.id,
    this.description,
    required this.ownerId,
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

  factory PostInMyClubJoin.fromJson(Map<String, dynamic> json) =>
      PostInMyClubJoin(
        id: json["id"],
        description: json["description"],
        ownerId: json["user_id"],
        owner: json["owner"],
        ownerAvatar: json["owner_avatar"],
        clubId: json["club_id"],
        clubName: json["club_name"],
        postDate: DateTime.parse(json["post_date"]),
        imagePost: List<ImagePost>.from(
            json["image_post"].map((x) => ImagePost.fromJson(x))),
        coComment: json["co_comment"],
        comment:
            List<Comment>.from(json["comment"].map((x) => Comment.fromJson(x))),
        coLike: json["co_like"],
        like: List<Comment>.from(json["like"].map((x) => Comment.fromJson(x))),
      );

  String clubId;
  String clubName;
  int coComment;
  int coLike;
  List<Comment> comment;
  String? description;
  String id;
  List<ImagePost> imagePost;
  List<Comment> like;
  String ownerId;
  String owner;
  String ownerAvatar;
  DateTime postDate;

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "user_id": ownerId,
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
    required this.userId,
    required this.owner,
    required this.ownerAvatar,
    this.comment,
    this.status,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        userId: json["user_id"],
        owner: json["owner"],
        ownerAvatar: json["owner_avatar"],
        comment: json["comment"],
        status: json["status"],
      );

  String? comment;
  String id;
  String owner;
  String ownerAvatar;
  String? status;
  String userId;

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
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

  factory ImagePost.fromJson(Map<String, dynamic> json) => ImagePost(
        id: json["id"],
        image: json["image"],
      );

  String id;
  String image;

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}
