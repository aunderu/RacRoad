// To parse this JSON data, do
//
//     final sosDetails = sosDetailsFromJson(jsonString);

import 'dart:convert';

SosDetails sosDetailsFromJson(String str) => SosDetails.fromJson(json.decode(str));

// List<SosDetails> sosDetailsFromJson(String str) => List<SosDetails>.from(
//     json.decode(str).map((x) => SosDetails.fromJson(x)).toList());

String sosDetailsToJson(SosDetails data) => json.encode(data.toJson());

class SosDetails {
    SosDetails({
        required this.status,
        required this.data,
        required this.message,
    });

    factory SosDetails.fromJson(Map<String, dynamic> json) => SosDetails(
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
        required this.sos,
        this.imgIncident,
        this.imgBfwork,
        this.imgAfwork,
        this.qrCode,
        this.userSlip,
        this.racroadSlip,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        sos: Sos.fromJson(json["sos"]),
        imgIncident: json["img_incident"] == null ? null : List<ImgAfwork>.from(json["img_incident"].map((x) => ImgAfwork.fromJson(x))),
        imgBfwork: json["img_bfwork"] == null ? null : List<ImgAfwork>.from(json["img_bfwork"].map((x) => ImgAfwork.fromJson(x))),
        imgAfwork: json["img_afwork"] == null ? null : List<ImgAfwork>.from(json["img_afwork"].map((x) => ImgAfwork.fromJson(x))),
        qrCode: json["qr_code"] == null ? null : List<ImgAfwork>.from(json["qr_code"].map((x) => ImgAfwork.fromJson(x))),
        userSlip: json["user_slip"] == null ? null : List<ImgAfwork>.from(json["user_slip"].map((x) => ImgAfwork.fromJson(x))),
        racroadSlip: json["racroad_slip"] == null ? null : List<ImgAfwork>.from(json["racroad_slip"].map((x) => ImgAfwork.fromJson(x))),
    );

    List<ImgAfwork>? imgAfwork;
    List<ImgAfwork>? imgBfwork;
    List<ImgAfwork>? imgIncident;
    List<ImgAfwork>? qrCode;
    List<ImgAfwork>? racroadSlip;
    Sos sos;
    List<ImgAfwork>? userSlip;

    Map<String, dynamic> toJson() => {
        "sos": sos.toJson(),
        "img_incident": imgIncident == null ? null : List<dynamic>.from(imgIncident!.map((x) => x.toJson())),
        "img_bfwork": imgBfwork == null ? null : List<dynamic>.from(imgBfwork!.map((x) => x.toJson())),
        "img_afwork": imgAfwork == null ? null : List<dynamic>.from(imgAfwork!.map((x) => x.toJson())),
        "qr_code": qrCode == null ? null : List<dynamic>.from(qrCode!.map((x) => x.toJson())),
        "user_slip": userSlip == null ? null : List<dynamic>.from(userSlip!.map((x) => x.toJson())),
        "racroad_slip": racroadSlip == null ? null : List<dynamic>.from(racroadSlip!.map((x) => x.toJson())),
    };
}

class ImgAfwork {
    ImgAfwork({
        required this.id,
        required this.image,
    });

    factory ImgAfwork.fromJson(Map<String, dynamic> json) => ImgAfwork(
        id: json["id"],
        image: json["image"]
    );

    String id;
    String image;

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
    };
}

class Sos {
    Sos({
        required this.sosId,
        required this.problem,
        required this.userId,
        required this.userName,
        this.userTel,
        required this.avatar,
        this.crimeScene,
        required this.problemDetail,
        required this.location,
        required this.latitude,
        required this.longitude,
        this.repairPrice,
        this.repairDetail,
        this.userDeal,
        this.tncId,
        this.tncName,
        this.tncAvatar,
        this.tncStatus,
        this.tncDeal,
        this.rate,
        this.review,
        required this.sosStatus,
        this.sosCheck,
        required this.createdAt,
        required this.updatedAt,
        required this.tuStep1,
        this.tuStep2,
        this.tuStep3,
        this.tuUrd,
        this.tuStep4,
        this.tuStep5,
        this.tuStep6,
        this.tuStep7,
        this.tuStep8,
        this.tuSc,
    });

    factory Sos.fromJson(Map<String, dynamic> json) => Sos(
        sosId: json["sos_id"],
        problem: json["problem"],
        userId: json["user_id"],
        userName: json["user_name"],
        userTel: json["user_tel"],
        avatar: json["avatar"],
        crimeScene: json["crime_scene"],
        problemDetail: json["problem_detail"],
        location: json["location"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        repairPrice: json["repair_price"],
        repairDetail: json["repair_detail"],
        userDeal: json["user_deal"],
        tncId: json["tnc_id"],
        tncName: json["tnc_name"],
        tncAvatar: json["tnc_avatar"],
        tncStatus: json["tnc_status"],
        tncDeal: json["tnc_deal"],
        rate: json["rate"],
        review: json["review"],
        sosStatus: json["sos_status"],
        sosCheck: json["sos_check"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        tuStep1: DateTime.parse(json["tu_step1"]),
        tuStep2: json["tu_step2"] == null ? null : DateTime.parse(json["tu_step2"]),
        tuStep3: json["tu_step3"] == null ? null : DateTime.parse(json["tu_step3"]),
        tuUrd: json["tu_urd"] == null ? null : DateTime.parse(json["tu_urd"]),
        tuStep4: json["tu_step4"] == null ? null : DateTime.parse(json["tu_step4"]),
        tuStep5: json["tu_step5"] == null ? null : DateTime.parse(json["tu_step5"]),
        tuStep6: json["tu_step6"] == null ? null : DateTime.parse(json["tu_step6"]),
        tuStep7: json["tu_step7"] == null ? null : DateTime.parse(json["tu_step7"]),
        tuStep8: json["tu_step8"] == null ? null : DateTime.parse(json["tu_step8"]),
        tuSc: json["tu_sc"] == null ? null : DateTime.parse(json["tu_sc"]),
    );

    String avatar;
    DateTime createdAt;
    dynamic crimeScene;
    String latitude;
    String location;
    String longitude;
    String problem;
    String problemDetail;
    String? rate;
    String? repairDetail;
    String? repairPrice;
    String? review;
    String? sosCheck;
    String sosId;
    String sosStatus;
    String? tncAvatar;
    dynamic tncDeal;
    String? tncId;
    String? tncName;
    String? tncStatus;
    DateTime? tuSc;
    DateTime tuStep1;
    DateTime? tuStep2;
    DateTime? tuStep3;
    DateTime? tuStep4;
    DateTime? tuStep5;
    DateTime? tuStep6;
    DateTime? tuStep7;
    DateTime? tuStep8;
    DateTime? tuUrd;
    DateTime updatedAt;
    String? userDeal;
    String userId;
    String userName;
    dynamic userTel;

    Map<String, dynamic> toJson() => {
        "sos_id": sosId,
        "problem": problem,
        "user_id": userId,
        "user_name": userName,
        "user_tel": userTel,
        "avatar": avatar,
        "crime_scene": crimeScene,
        "problem_detail": problemDetail,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "repair_price": repairPrice,
        "repair_detail": repairDetail,
        "user_deal": userDeal,
        "tnc_id": tncId,
        "tnc_name": tncName,
        "tnc_avatar": tncAvatar,
        "tnc_status": tncStatus,
        "tnc_deal": tncDeal,
        "rate": rate,
        "review": review,
        "sos_status": sosStatus,
        "sos_check": sosCheck,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "tu_step1": tuStep1.toIso8601String(),
        "tu_step2": tuStep2 == null ? null : tuStep2!.toIso8601String(),
        "tu_step3": tuStep3 == null ? null : tuStep3!.toIso8601String(),
        "tu_urd": tuUrd == null ? null : tuUrd!.toIso8601String(),
        "tu_step4": tuStep4 == null ? null : tuStep4!.toIso8601String(),
        "tu_step5": tuStep5 == null ? null : tuStep5!.toIso8601String(),
        "tu_step6": tuStep6 == null ? null : tuStep6!.toIso8601String(),
        "tu_step7": tuStep7 == null ? null : tuStep7!.toIso8601String(),
        "tu_step8": tuStep8 == null ? null : tuStep8!.toIso8601String(),
        "tu_sc": tuSc == null ? null : tuSc!.toIso8601String(),
    };
}
