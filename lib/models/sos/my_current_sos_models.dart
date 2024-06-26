// To parse this JSON data, do
//
//     final myCurrentSos = myCurrentSosFromJson(jsonString);

import 'dart:convert';

MyCurrentSos myCurrentSosFromJson(String str) =>
    MyCurrentSos.fromJson(json.decode(str));

String myCurrentSosToJson(MyCurrentSos data) => json.encode(data.toJson());

class MyCurrentSos {
  MyCurrentSos({
    required this.status,
    required this.count,
    required this.message,
    required this.data,
  });

  bool status;
  int count;
  String message;
  Data data;

  factory MyCurrentSos.fromJson(Map<String, dynamic> json) => MyCurrentSos(
        status: json["status"],
        count: json["count"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "count": count,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.mySosInProgress,
  });

  List<MySosInProgress> mySosInProgress;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        mySosInProgress: List<MySosInProgress>.from(
            json["my_sos_in_progress"].map((x) => MySosInProgress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "my_sos_in_progress":
            List<dynamic>.from(mySosInProgress.map((x) => x.toJson())),
      };
}

class MySosInProgress {
  MySosInProgress({
    required this.sosId,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.imageIncident,
    required this.problem,
    required this.sosStatus,
    required this.createdAt,
    required this.tuStep1,
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
  List<dynamic> imageIncident;
  String problem;
  String sosStatus;
  DateTime createdAt;
  DateTime tuStep1;
  dynamic tuStep2;
  dynamic tuStep3;
  dynamic tuStep4;
  dynamic tuStep5;
  dynamic tuStep6;
  dynamic tuStep7;
  dynamic tuStep8;
  dynamic tuSc;
  dynamic tuPrice2;
  dynamic tuUserDeal2;

  factory MySosInProgress.fromJson(Map<String, dynamic> json) =>
      MySosInProgress(
        sosId: json["sos_id"],
        userId: json["user_id"],
        userName: json["user_name"],
        avatar: json["avatar"],
        imageIncident: List<dynamic>.from(json["image_incident"].map((x) => x)),
        problem: json["problem"],
        sosStatus: json["sos_status"],
        createdAt: DateTime.parse(json["created_at"]),
        tuStep1: DateTime.parse(json["tu_step1"]),
        tuStep2: json["tu_step2"],
        tuStep3: json["tu_step3"],
        tuStep4: json["tu_step4"],
        tuStep5: json["tu_step5"],
        tuStep6: json["tu_step6"],
        tuStep7: json["tu_step7"],
        tuStep8: json["tu_step8"],
        tuSc: json["tu_sc"],
        tuPrice2: json["tu_price2"],
        tuUserDeal2: json["tu_user_deal2"],
      );

  Map<String, dynamic> toJson() => {
        "sos_id": sosId,
        "user_id": userId,
        "user_name": userName,
        "avatar": avatar,
        "image_incident": List<dynamic>.from(imageIncident.map((x) => x)),
        "problem": problem,
        "sos_status": sosStatus,
        "created_at": createdAt.toIso8601String(),
        "tu_step1": tuStep1.toIso8601String(),
        "tu_step2": tuStep2,
        "tu_step3": tuStep3,
        "tu_step4": tuStep4,
        "tu_step5": tuStep5,
        "tu_step6": tuStep6,
        "tu_step7": tuStep7,
        "tu_step8": tuStep8,
        "tu_sc": tuSc,
        "tu_price2": tuPrice2,
        "tu_user_deal2": tuUserDeal2,
      };
}
