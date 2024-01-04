// To parse this JSON data, do
//
//     final postInClubModel = postInClubModelFromJson(jsonString);

import 'dart:convert';

PostInClubModel postInClubModelFromJson(String str) =>
    PostInClubModel.fromJson(json.decode(str));

String postInClubModelToJson(PostInClubModel data) =>
    json.encode(data.toJson());

class PostInClubModel {
  PostInClubModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory PostInClubModel.fromJson(Map<String, dynamic> json) =>
      PostInClubModel(
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
    required this.club,
    required this.post,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        club: json["club"] == null ? null : Club.fromJson(json["club"]),
        post: json["post"] == null
            ? []
            : List<Post>.from(json["post"]!.map((x) => Post.fromJson(x))),
      );

  Club? club;
  List<Post> post;

  Map<String, dynamic> toJson() => {
        "club": club?.toJson(),
        "post": List<dynamic>.from(post.map((x) => x.toJson())),
      };
}

class Club {
  Club({
    this.clubId,
    this.userId,
    this.clubName,
    this.clubZone,
    this.clubProfile,
    this.description,
    this.status,
    this.spAdmin,
    this.createdAt,
    this.updatedAt,
  });

  factory Club.fromJson(Map<String, dynamic> json) => Club(
        clubId: json["club_id"],
        userId: json["user_id"],
        clubName: json["club_name"],
        clubZone: json["club_zone"],
        clubProfile: json["club_profile"],
        description: json["description"],
        status: json["status"],
        spAdmin: json["sp_admin"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  String? clubId;
  String? clubName;
  String? clubProfile;
  String? clubZone;
  DateTime? createdAt;
  String? description;
  String? spAdmin;
  String? status;
  DateTime? updatedAt;
  String? userId;

  Map<String, dynamic> toJson() => {
        "club_id": clubId,
        "user_id": userId,
        "club_name": clubName,
        "club_zone": clubZone,
        "club_profile": clubProfile,
        "description": description,
        "status": status,
        "sp_admin": spAdmin,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Post {
  Post({
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

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        description: json["description"],
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
  String owner;
  String ownerAvatar;
  DateTime postDate;

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