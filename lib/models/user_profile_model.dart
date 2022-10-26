// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
    UserProfile({
        required this.status,
        required this.data,
        required this.message,
    });

    bool status;
    Data data;
    String message;

    factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
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
        required this.myProfile,
    });

    MyProfile myProfile;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        myProfile: MyProfile.fromJson(json["my_profile"]),
    );

    Map<String, dynamic> toJson() => {
        "my_profile": myProfile.toJson(),
    };
}

class MyProfile {
    MyProfile({
        required this.id,
        required this.name,
        this.tel,
        required this.email,
        this.cardId,
        required this.role,
        required this.avatar,
        required this.address,
    });

    String id;
    String name;
    dynamic tel;
    String email;
    dynamic cardId;
    String role;
    String avatar;
    String address;

    factory MyProfile.fromJson(Map<String, dynamic> json) => MyProfile(
        id: json["id"],
        name: json["name"],
        tel: json["tel"],
        email: json["email"],
        cardId: json["card_id"],
        role: json["role"],
        avatar: json["avatar"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tel": tel,
        "email": email,
        "card_id": cardId,
        "role": role,
        "avatar": avatar,
        "address": address,
    };
}
