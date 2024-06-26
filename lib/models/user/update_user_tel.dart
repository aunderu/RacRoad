// To parse this JSON data, do
//
//     final updateUserTel = updateUserTelFromJson(jsonString);

import 'dart:convert';

UpdateUserTel updateUserTelFromJson(String str) => UpdateUserTel.fromJson(json.decode(str));

String updateUserTelToJson(UpdateUserTel data) => json.encode(data.toJson());

class UpdateUserTel {
    bool status;
    List<dynamic> data;
    String message;

    UpdateUserTel({
        required this.status,
        required this.data,
        required this.message,
    });

    factory UpdateUserTel.fromJson(Map<String, dynamic> json) => UpdateUserTel(
        status: json["status"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x)),
        "message": message,
    };
}
