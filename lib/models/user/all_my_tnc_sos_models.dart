// To parse this JSON data, do
//
//     final allMyTncSos = allMyTncSosFromJson(jsonString);

import 'dart:convert';

AllMyTncSos allMyTncSosFromJson(String str) =>
    AllMyTncSos.fromJson(json.decode(str));

String allMyTncSosToJson(AllMyTncSos data) => json.encode(data.toJson());

class AllMyTncSos {
  AllMyTncSos({
    required this.status,
    required this.count,
    required this.data,
    required this.message,
  });

  bool status;
  int count;
  Data data;
  String message;

  factory AllMyTncSos.fromJson(Map<String, dynamic> json) => AllMyTncSos(
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
    this.sos,
  });

  List<So>? sos;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        sos: json["sos"] == null
            ? null
            : List<So>.from(json["sos"].map((x) => So.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sos": sos == null
            ? null
            : List<dynamic>.from(sos!.map((x) => x.toJson())),
      };
}

class So {
  So({
    required this.sosId,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.imageIncident,
    required this.problem,
    required this.sosStatus,
    required this.createdAt,
    this.tuStep1,
    this.tuStep2,
    this.tuStep3,
    this.tuStep4,
    this.tuStep5,
    this.tuStep6,
    this.tuStep7,
    this.tuStep8,
    this.tuSc,
    this.tuPrice2,
    this.tuUserDeal2,
  });

  String sosId;
  String userId;
  String userName;
  String avatar;
  List<ImageIncident> imageIncident;
  String problem;
  String sosStatus;
  DateTime createdAt;
  DateTime? tuStep1;
  DateTime? tuStep2;
  DateTime? tuStep3;
  DateTime? tuStep4;
  DateTime? tuStep5;
  DateTime? tuStep6;
  DateTime? tuStep7;
  DateTime? tuStep8;
  DateTime? tuSc;
  dynamic tuPrice2;
  dynamic tuUserDeal2;

  factory So.fromJson(Map<String, dynamic> json) => So(
        sosId: json["sos_id"],
        userId: json["user_id"],
        userName: json["user_name"],
        avatar: json["avatar"],
        imageIncident: List<ImageIncident>.from(
            json["image_incident"].map((x) => ImageIncident.fromJson(x))),
        problem: json["problem"],
        sosStatus: json["sos_status"],
        createdAt: DateTime.parse(json["created_at"]),
        tuStep1:
            json["tu_step1"] == null ? null : DateTime.parse(json["tu_step1"]),
        tuStep2:
            json["tu_step2"] == null ? null : DateTime.parse(json["tu_step2"]),
        tuStep3:
            json["tu_step3"] == null ? null : DateTime.parse(json["tu_step3"]),
        tuStep4:
            json["tu_step4"] == null ? null : DateTime.parse(json["tu_step4"]),
        tuStep5:
            json["tu_step5"] == null ? null : DateTime.parse(json["tu_step5"]),
        tuStep6:
            json["tu_step6"] == null ? null : DateTime.parse(json["tu_step6"]),
        tuStep7:
            json["tu_step7"] == null ? null : DateTime.parse(json["tu_step7"]),
        tuStep8:
            json["tu_step8"] == null ? null : DateTime.parse(json["tu_step8"]),
        tuSc: json["tu_sc"] == null ? null : DateTime.parse(json["tu_sc"]),
        tuPrice2: json["tu_price2"],
        tuUserDeal2: json["tu_user_deal2"],
      );

  Map<String, dynamic> toJson() => {
        "sos_id": sosId,
        "user_id": userId,
        "user_name": userName,
        "avatar": avatar,
        "image_incident":
            List<dynamic>.from(imageIncident.map((x) => x.toJson())),
        "problem": problem,
        "sos_status": sosStatus,
        "created_at": createdAt.toIso8601String(),
        "tu_step1": tuStep1 == null ? null : tuStep1!.toIso8601String(),
        "tu_step2": tuStep2 == null ? null : tuStep2!.toIso8601String(),
        "tu_step3": tuStep3 == null ? null : tuStep3!.toIso8601String(),
        "tu_step4": tuStep4 == null ? null : tuStep4!.toIso8601String(),
        "tu_step5": tuStep5 == null ? null : tuStep5!.toIso8601String(),
        "tu_step6": tuStep6 == null ? null : tuStep6!.toIso8601String(),
        "tu_step7": tuStep7 == null ? null : tuStep7!.toIso8601String(),
        "tu_step8": tuStep8 == null ? null : tuStep8!.toIso8601String(),
        "tu_sc": tuSc == null ? null : tuSc!.toIso8601String(),
        "tu_price2": tuPrice2,
        "tu_user_deal2": tuUserDeal2,
      };
}

class ImageIncident {
  ImageIncident({
    required this.id,
    required this.image,
  });

  String id;
  String image;

  factory ImageIncident.fromJson(Map<String, dynamic> json) => ImageIncident(
        id: json["id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}
