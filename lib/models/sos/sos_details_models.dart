// To parse this JSON data, do
//
//     final sosDetails = sosDetailsFromJson(jsonString);

import 'dart:convert';

SosDetails sosDetailsFromJson(String str) =>
    SosDetails.fromJson(json.decode(str));

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
    required this.imgIncident,
    this.tncData,
    this.imgBfwork,
    this.imgAfwork,
    this.qrCode,
    this.userSlip,
    this.racroadSlip,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        sos: Sos.fromJson(json["sos"]),
        imgIncident:
            List<Img>.from(json["img_incident"].map((x) => Img.fromJson(x))),
        imgBfwork: json["img_bfwork"] == null
            ? []
            : List<Img>.from(json["img_bfwork"]!.map((x) => Img.fromJson(x))),
        imgAfwork: json["img_afwork"] == null
            ? []
            : List<Img>.from(json["img_afwork"]!.map((x) => Img.fromJson(x))),
        qrCode: json["qr_code"] == null
            ? []
            : List<dynamic>.from(json["qr_code"]!.map((x) => x)),
        userSlip: json["user_slip"] == null
            ? []
            : List<Img>.from(json["user_slip"]!.map((x) => Img.fromJson(x))),
        racroadSlip: json["racroad_slip"] == null
            ? []
            : List<Img>.from(json["racroad_slip"]!.map((x) => Img.fromJson(x))),
      );

  List<Img>? imgAfwork;
  List<Img>? imgBfwork;
  List<Img> imgIncident;
  dynamic qrCode;
  List<Img>? racroadSlip;
  Sos sos;
  List<TncDatum>? tncData;
  List<Img>? userSlip;

  Map<String, dynamic> toJson() => {
        "sos": sos.toJson(),
        "img_incident": List<dynamic>.from(imgIncident.map((x) => x.toJson())),
        "img_bfwork": imgBfwork == null
            ? []
            : List<dynamic>.from(imgBfwork!.map((x) => x.toJson())),
        "img_afwork": imgAfwork == null
            ? []
            : List<dynamic>.from(imgAfwork!.map((x) => x.toJson())),
        "qr_code":
            qrCode == null ? [] : List<dynamic>.from(qrCode!.map((x) => x)),
        "user_slip": userSlip == null
            ? []
            : List<dynamic>.from(userSlip!.map((x) => x.toJson())),
        "racroad_slip": racroadSlip == null
            ? []
            : List<dynamic>.from(racroadSlip!.map((x) => x.toJson())),
      };
}

class Img {
  Img({
    required this.id,
    required this.image,
  });

  factory Img.fromJson(Map<String, dynamic> json) => Img(
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

class Sos {
  Sos({
    required this.sosId,
    required this.problem,
    required this.userId,
    required this.userName,
    required this.userTel,
    required this.avatar,
    this.crimeScene,
    this.problemDetail,
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
    this.tncDescription,
    this.repairPrice2,
    this.repairDetail2,
    this.price2Status,
    this.userDeal2,
    this.qrId,
    this.qrName,
    this.qrNumber,
    this.qrType,
    this.qrStatus,
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
    this.tuPrice2,
    this.tuUserDeal2,
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
        tncDescription: json["tnc_description"],
        repairPrice2: json["repair_price2"],
        repairDetail2: json["repair_detail2"],
        price2Status: json["price2_status"],
        userDeal2: json["user_deal2"],
        qrId: json["qr_id"],
        qrName: json["qr_name"],
        qrNumber: json["qr_number"],
        qrType: json["qr_type"],
        qrStatus: json["qr_status"],
        rate: json["rate"],
        review: json["review"],
        sosStatus: json["sos_status"],
        sosCheck: json["sos_check"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        tuStep1: DateTime.parse(json["tu_step1"]),
        tuStep2:
            json["tu_step2"] == null ? null : DateTime.parse(json["tu_step2"]),
        tuStep3:
            json["tu_step3"] == null ? null : DateTime.parse(json["tu_step3"]),
        tuUrd: json["tu_urd"] == null ? null : DateTime.parse(json["tu_urd"]),
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
        tuPrice2: json["tu_price2"] == null
            ? null
            : DateTime.parse(json["tu_price2"]),
        tuUserDeal2: json["tu_user_deal2"] == null
            ? null
            : DateTime.parse(json["tu_user_deal2"]),
      );

  String avatar;
  DateTime createdAt;
  dynamic crimeScene;
  String latitude;
  String location;
  String longitude;
  String? price2Status;
  String problem;
  String? problemDetail;
  String? qrId;
  String? qrName;
  String? qrNumber;
  String? qrType;
  String? qrStatus;
  dynamic rate;
  String? repairDetail;
  String? repairDetail2;
  dynamic repairPrice;
  String? repairPrice2;
  dynamic review;
  dynamic sosCheck;
  String sosId;
  String sosStatus;
  dynamic tncAvatar;
  dynamic tncDeal;
  String? tncDescription;
  dynamic tncId;
  dynamic tncName;
  dynamic tncStatus;
  DateTime? tuPrice2;
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
  DateTime? tuUserDeal2;
  DateTime updatedAt;
  dynamic userDeal;
  String? userDeal2;
  String userId;
  String userName;
  String userTel;

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
        "tnc_description": tncDescription,
        "repair_price2": repairPrice2,
        "repair_detail2": repairDetail2,
        "price2_status": price2Status,
        "user_deal2": userDeal2,
        "qr_id": qrId,
        "qr_name": qrName,
        "qr_number": qrNumber,
        "qr_type": qrType,
        "qr_status": qrStatus,
        "rate": rate,
        "review": review,
        "sos_status": sosStatus,
        "sos_check": sosCheck,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "tu_step1": tuStep1.toIso8601String(),
        "tu_step2": tuStep2 == null ? null : tuStep2!.toIso8601String(),
        "tu_step3": tuStep3 == null ? null : tuStep3!.toIso8601String(),
        "tu_step4": tuStep4 == null ? null : tuStep4!.toIso8601String(),
        "tu_step5": tuStep5 == null ? null : tuStep5!.toIso8601String(),
        "tu_step6": tuStep6 == null ? null : tuStep6!.toIso8601String(),
        "tu_step7": tuStep7 == null ? null : tuStep7!.toIso8601String(),
        "tu_step8": tuStep8 == null ? null : tuStep8!.toIso8601String(),
        "tu_sc": tuSc == null ? null : tuSc!.toIso8601String(),
        "tu_price2": tuPrice2 == null ? null : tuPrice2!.toIso8601String(),
        "tu_user_deal2":
            tuUserDeal2 == null ? null : tuUserDeal2!.toIso8601String(),
      };
}

class TncDatum {
  TncDatum({
    required this.tncId,
    this.tncName,
    required this.name,
    required this.avatar,
    required this.serviceZone,
    required this.status,
  });

  factory TncDatum.fromJson(Map<String, dynamic> json) => TncDatum(
        tncId: json["tnc_id"],
        tncName: json["tnc_name"],
        name: json["name"],
        avatar: json["avatar"],
        serviceZone: json["service_zone"],
        status: json["status"],
      );

  String avatar;
  String name;
  String serviceZone;
  String status;
  String tncId;
  String? tncName;

  Map<String, dynamic> toJson() => {
        "tnc_id": tncId,
        "tnc_name": tncName,
        "name": name,
        "avatar": avatar,
        "service_zone": serviceZone,
        "status": status,
      };
}
