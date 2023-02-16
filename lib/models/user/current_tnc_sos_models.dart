// To parse this JSON data, do
//
//     final currentTncSos = currentTncSosFromJson(jsonString);

import 'dart:convert';

CurrentTncSos currentTncSosFromJson(String str) => CurrentTncSos.fromJson(json.decode(str));

String currentTncSosToJson(CurrentTncSos data) => json.encode(data.toJson());

class CurrentTncSos {
    CurrentTncSos({
        required this.status,
        required this.count,
        required this.data,
        required this.message,
    });

    factory CurrentTncSos.fromJson(Map<String, dynamic> json) => CurrentTncSos(
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
        this.sos,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        sos: json["sos"] == null ? null : List<So>.from(json["sos"].map((x) => So.fromJson(x))),
    );

    List<So>? sos;

    Map<String, dynamic> toJson() => {
        "sos": sos == null ? null : List<dynamic>.from(sos!.map((x) => x.toJson())),
    };
}

class So {
    So({
        required this.sosId,
        required this.userId,
        required this.userName,
        required this.avatar,
        required this.problem,
        required this.sosStatus,
        this.createdAt,
        this.tuStep2,
        this.tuStep3,
        this.tuStep4,
        this.tuStep5,
        this.tuStep6,
        this.tuStep7,
        this.tuStep8,
        this.tuSc,
    });

    factory So.fromJson(Map<String, dynamic> json) => So(
        sosId: json["sos_id"],
        userId: json["user_id"],
        userName: json["user_name"],
        avatar: json["avatar"],
        problem: json["problem"],
        sosStatus: json["sos_status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        tuStep2: json["tu_step2"] == null ? null : DateTime.parse(json["tu_step2"]),
        tuStep3: json["tu_step3"] == null ? null : DateTime.parse(json["tu_step3"]),
        tuStep4: json["tu_step4"] == null ? null : DateTime.parse(json["tu_step4"]),
        tuStep5: json["tu_step5"] == null ? null : DateTime.parse(json["tu_step5"]),
        tuStep6: json["tu_step6"] == null ? null : DateTime.parse(json["tu_step6"]),
        tuStep7: json["tu_step7"] == null ? null : DateTime.parse(json["tu_step7"]),
        tuStep8: json["tu_step8"] == null ? null : DateTime.parse(json["tu_step8"]),
        tuSc: json["tu_sc"] == null ? null : DateTime.parse(json["tu_sc"]),
    );

    String avatar;
    DateTime? createdAt;
    String problem;
    String sosId;
    String sosStatus;
    DateTime? tuSc;
    DateTime? tuStep2;
    DateTime? tuStep3;
    DateTime? tuStep4;
    DateTime? tuStep5;
    DateTime? tuStep6;
    DateTime? tuStep7;
    DateTime? tuStep8;
    String userId;
    String userName;

    Map<String, dynamic> toJson() => {
        "sos_id": sosId,
        "user_id": userId,
        "user_name": userName,
        "avatar": avatar,
        "problem": problem,
        "sos_status": sosStatus,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "tu_step2": tuStep2 == null ? null : tuStep2!.toIso8601String(),
        "tu_step3": tuStep3 == null ? null : tuStep3!.toIso8601String(),
        "tu_step4": tuStep4 == null ? null : tuStep4!.toIso8601String(),
        "tu_step5": tuStep5 == null ? null : tuStep5!.toIso8601String(),
        "tu_step6": tuStep6 == null ? null : tuStep6!.toIso8601String(),
        "tu_step7": tuStep7 == null ? null : tuStep7!.toIso8601String(),
        "tu_step8": tuStep8 == null ? null : tuStep8!.toIso8601String(),
        "tu_sc": tuSc == null ? null : tuSc!.toIso8601String(),
    };
}
