// To parse this JSON data, do
//
//     final userLogin = userLoginFromJson(jsonString);

import 'dart:convert';

UserLogin userLoginFromJson(String str) => UserLogin.fromJson(json.decode(str));

String userLoginToJson(UserLogin data) => json.encode(data.toJson());

class UserLogin {
  UserLogin({
    required this.status,
    required this.data,
    required this.message,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
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
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.appleId,
    required this.role,
    required this.type,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        avatar: json["avatar"],
        appleId: json["apple_id"],
        role: json["role"],
        type: json["type"],
      );

  String email;
  String id;
  String name;
  String? avatar;
  String? appleId;
  String role;
  String type;

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "avatar": avatar,
        "apple_id": appleId,
        "role": role,
        "type": type,
      };
}
