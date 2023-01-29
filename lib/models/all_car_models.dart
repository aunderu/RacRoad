// To parse this JSON data, do
//
//     final allCarModel = allCarModelFromJson(jsonString);

import 'dart:convert';

AllCarModel allCarModelFromJson(String str) => AllCarModel.fromJson(json.decode(str));

String allCarModelToJson(AllCarModel data) => json.encode(data.toJson());

class AllCarModel {
    AllCarModel({
        required this.status,
        required this.data,
        required this.message,
    });

    factory AllCarModel.fromJson(Map<String, dynamic> json) => AllCarModel(
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
        required this.carData,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        carData: List<CarDatum>.from(json["car_data"].map((x) => CarDatum.fromJson(x))),
    );

    List<CarDatum> carData;

    Map<String, dynamic> toJson() => {
        "car_data": List<dynamic>.from(carData.map((x) => x.toJson())),
    };
}

class CarDatum {
    CarDatum({
        required this.carId,
        required this.brand,
        required this.model,
        required this.makeover,
        required this.subversion,
        required this.fuel,
        required this.brakeFluid,
        required this.powerOil,
        required this.engineOil,
        required this.brakePads,
        required this.carTire,
        required this.battery,
        required this.air,
        required this.createdAt,
        required this.updatedAt,
    });

    factory CarDatum.fromJson(Map<String, dynamic> json) => CarDatum(
        carId: json["car_id"],
        brand: json["brand"],
        model: json["model"],
        makeover: json["makeover"],
        subversion: json["subversion"],
        fuel: json["fuel"],
        brakeFluid: json["brake_fluid"],
        powerOil: json["power_oil"],
        engineOil: json["engine_oil"],
        brakePads: json["brake_pads"],
        carTire: json["car_tire"],
        battery: json["battery"],
        air: json["air"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    String air;
    String battery;
    String brakeFluid;
    String brakePads;
    String brand;
    String carId;
    String carTire;
    DateTime createdAt;
    String engineOil;
    String fuel;
    String makeover;
    String model;
    String powerOil;
    String subversion;
    DateTime updatedAt;

    Map<String, dynamic> toJson() => {
        "car_id": carId,
        "brand": brand,
        "model": model,
        "makeover": makeover,
        "subversion": subversion,
        "fuel": fuel,
        "brake_fluid": brakeFluid,
        "power_oil": powerOil,
        "engine_oil": engineOil,
        "brake_pads": brakePads,
        "car_tire": carTire,
        "battery": battery,
        "air": air,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
