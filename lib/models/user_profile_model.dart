// To parse this JSON data, do
//
//     final myProfile = myProfileFromJson(jsonString);

import 'dart:convert';

MyProfile myProfileFromJson(String str) => MyProfile.fromJson(json.decode(str));

String myProfileToJson(MyProfile data) => json.encode(data.toJson());

class MyProfile {
  MyProfile({
    required this.status,
    required this.data,
    required this.message,
  });

  factory MyProfile.fromJson(Map<String, dynamic> json) => MyProfile(
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
    required this.myProfile,
    required this.interest,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        myProfile: MyProfileClass.fromJson(json["my_profile"]),
        interest: List<dynamic>.from(json["interest"].map((x) => x)),
      );

  List<dynamic> interest;
  MyProfileClass myProfile;

  Map<String, dynamic> toJson() => {
        "my_profile": myProfile.toJson(), 
        "interest": List<dynamic>.from(interest.map((x) => x)),
      };
}

class MyProfileClass {
  MyProfileClass({
    required this.id,
    required this.name,
    required this.tel,
    required this.email,
    this.cardId,
    required this.role,
    required this.avatar,
    required this.address,
    this.county,
    this.road,
    this.alley,
    this.houseNumber,
    this.groupNo,
    this.subDistrict,
    this.district,
    this.province,
    this.zipCode,
  });

  factory MyProfileClass.fromJson(Map<String, dynamic> json) => MyProfileClass(
        id: json["id"],
        name: json["name"],
        tel: json["tel"],
        email: json["email"],
        cardId: json["card_id"],
        role: json["role"],
        avatar: json["avatar"],
        address: json["address"],
        county: json["county"],
        road: json["road"],
        alley: json["alley"],
        houseNumber: json["house_number"],
        groupNo: json["group_no"],
        subDistrict: json["sub_district"],
        district: json["district"],
        province: json["province"],
        zipCode: json["ZIP_code"],
      );

  String address;
  dynamic alley;
  String avatar;
  dynamic cardId;
  dynamic county;
  dynamic district;
  String email;
  dynamic groupNo;
  dynamic houseNumber;
  String id;
  String name;
  dynamic province;
  dynamic road;
  String role;
  dynamic subDistrict;
  dynamic tel;
  dynamic zipCode;

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tel": tel,
        "email": email,
        "card_id": cardId,
        "role": role,
        "avatar": avatar,
        "address": address,
        "county": county,
        "road": road,
        "alley": alley,
        "house_number": houseNumber,
        "group_no": groupNo,
        "sub_district": subDistrict,
        "district": district,
        "province": province,
        "ZIP_code": zipCode,
      };
}
