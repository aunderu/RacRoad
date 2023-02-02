// To parse this JSON data, do
//
//     final allMyCar = allMyCarFromJson(jsonString);

import 'dart:convert';

AllMyCar allMyCarFromJson(String str) => AllMyCar.fromJson(json.decode(str));

String allMyCarToJson(AllMyCar data) => json.encode(data.toJson());

class AllMyCar {
    AllMyCar({
        this.status,
        this.data,
        this.message,
    });

    factory AllMyCar.fromJson(Map<String, dynamic> json) => AllMyCar(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
    );

    Data? data;
    String? message;
    bool? status;

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
    };
}

class Data {
    Data({
        this.mycarData,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        mycarData: json["mycar_data"] == null ? [] : List<MycarDatum>.from(json["mycar_data"]!.map((x) => MycarDatum.fromJson(x))),
    );

    List<MycarDatum>? mycarData;

    Map<String, dynamic> toJson() => {
        "mycar_data": mycarData == null ? [] : List<dynamic>.from(mycarData!.map((x) => x.toJson())),
    };
}

class MycarDatum {
    MycarDatum({
        this.mycarId,
        this.carBrand,
        this.carModel,
        this.carMakeover,
        this.carSubversion,
        this.carFuel,
        this.ownerName,
        this.carProfile,
    });

    factory MycarDatum.fromJson(Map<String, dynamic> json) => MycarDatum(
        mycarId: json["mycar_id"],
        carBrand: json["car_brand"],
        carModel: json["car_model"],
        carMakeover: json["car_makeover"],
        carSubversion: json["car_subversion"],
        carFuel: json["car_fuel"],
        ownerName: json["owner_name"],
        carProfile: json["car_profile"],
    );

    String? carBrand;
    String? carFuel;
    String? carMakeover;
    String? carModel;
    String? carSubversion;
    String? mycarId;
    String? ownerName;
    String? carProfile;

    Map<String, dynamic> toJson() => {
        "mycar_id": mycarId,
        "car_brand": carBrand,
        "car_model": carModel,
        "car_makeover": carMakeover,
        "car_subversion": carSubversion,
        "car_fuel": carFuel,
        "owner_name": ownerName,
        "car_profile": carProfile,
    };
}
