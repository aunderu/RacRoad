
// To parse this JSON data, do
//
//     final allMyCar = allMyCarFromJson(jsonString);

import 'dart:convert';

AllMyCar allMyCarFromJson(String str) => AllMyCar.fromJson(json.decode(str));

String allMyCarToJson(AllMyCar data) => json.encode(data.toJson());

class AllMyCar {
  AllMyCar({
    required this.status,
    required this.data,
    required this.message,
  });

  bool status;
  Data data;
  String message;

  factory AllMyCar.fromJson(Map<String, dynamic> json) => AllMyCar(
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
    required this.mycarData,
  });

  List<MycarDatum> mycarData;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        mycarData: List<MycarDatum>.from(
            json["mycar_data"].map((x) => MycarDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mycar_data": List<dynamic>.from(mycarData.map((x) => x.toJson())),
      };
}

class MycarDatum {
  MycarDatum({
    required this.mycarId,
    required this.carNo,
    required this.carBrand,
    required this.ownerName,
    required this.carProfile,
  });

  String mycarId;
  String carNo;
  String carBrand;
  String ownerName;
  String carProfile;

  factory MycarDatum.fromJson(Map<String, dynamic> json) => MycarDatum(
        mycarId: json["mycar_id"],
        carNo: json["car_no"],
        carBrand: json["car_brand"],
        ownerName: json["owner_name"],
        carProfile: json["car_profile"],
      );

  Map<String, dynamic> toJson() => {
        "mycar_id": mycarId,
        "car_no": carNo,
        "car_brand": carBrand,
        "owner_name": ownerName,
        "car_profile": carProfile,
      };
}
