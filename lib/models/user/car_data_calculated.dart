// To parse this JSON data, do
//
//     final carDataCal = carDataCalFromJson(jsonString);

import 'dart:convert';

CarDataCal carDataCalFromJson(String str) => CarDataCal.fromJson(json.decode(str));

String carDataCalToJson(CarDataCal data) => json.encode(data.toJson());

class CarDataCal {
    CarDataCal({
        required this.status,
        required this.data,
        required this.message,
    });

    bool status;
    Data data;
    String message;

    factory CarDataCal.fromJson(Map<String, dynamic> json) => CarDataCal(
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
        this.brakeOilCal,
        this.powerOilCal,
        this.engineOilCal,
        this.brakePadsCal,
        this.carTireCal,
        this.airCal,
        this.batteryCal,
        this.gearOilCal,
        this.cleanHsCal,
        this.changeAfCal,
    });

    Cal? brakeOilCal;
    Cal? powerOilCal;
    Cal? engineOilCal;
    Cal? brakePadsCal;
    Cal? carTireCal;
    Cal? airCal;
    Cal? batteryCal;
    Cal? gearOilCal;
    Cal? cleanHsCal;
    Cal? changeAfCal;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        brakeOilCal: json["brake_oil_cal"] == null ? null : Cal.fromJson(json["brake_oil_cal"]),
        powerOilCal: json["power_oil_cal"] == null ? null : Cal.fromJson(json["power_oil_cal"]),
        engineOilCal: json["engine_oil_cal"] == null ? null : Cal.fromJson(json["engine_oil_cal"]),
        brakePadsCal: json["brake_pads_cal"] == null ? null : Cal.fromJson(json["brake_pads_cal"]),
        carTireCal: json["car_tire_cal"] == null ? null : Cal.fromJson(json["car_tire_cal"]),
        airCal: json["air_cal"] == null ? null : Cal.fromJson(json["air_cal"]),
        batteryCal: json["battery_cal"] == null ? null : Cal.fromJson(json["battery_cal"]),
        gearOilCal: json["gear_oil_cal"] == null ? null : Cal.fromJson(json["gear_oil_cal"]),
        cleanHsCal: json["clean_hs_cal"] == null ? null : Cal.fromJson(json["clean_hs_cal"]),
        changeAfCal: json["change_af_cal"] == null ? null : Cal.fromJson(json["change_af_cal"]),
    );

    Map<String, dynamic> toJson() => {
        "brake_oil_cal": brakeOilCal?.toJson(),
        "power_oil_cal": powerOilCal?.toJson(),
        "engine_oil_cal": engineOilCal?.toJson(),
        "brake_pads_cal": brakePadsCal?.toJson(),
        "car_tire_cal": carTireCal?.toJson(),
        "air_cal": airCal?.toJson(),
        "battery_cal": batteryCal?.toJson(),
        "gear_oil_cal": gearOilCal?.toJson(),
        "clean_hs_cal": cleanHsCal?.toJson(),
        "change_af_cal": changeAfCal?.toJson(),
    };
}

class Cal {
    Cal({
        this.dateSet,
        this.mileNow,
        this.mileNext,
        this.dateUpgradeSet,
        this.dateUpgradeNow,
        this.dateUpgradeNext,
        this.dateAll,
        this.dateNext,
        this.dateRemain,
        this.dateAllAvg,
        this.dateNextAvg,
        this.dateRemainAvg,
    });

    DateTime? dateSet;
    String? mileNow;
    String? mileNext;
    DateTime? dateUpgradeSet;
    DateTime? dateUpgradeNow;
    DateTime? dateUpgradeNext;
    int? dateAll;
    int? dateNext;
    int? dateRemain;
    double? dateAllAvg;
    double? dateNextAvg;
    double? dateRemainAvg;

    factory Cal.fromJson(Map<String, dynamic> json) => Cal(
        dateSet: json["date_set"] == null ? null : DateTime.parse(json["date_set"]),
        mileNow: json["mile_now"],
        mileNext: json["mile_next"],
        dateUpgradeSet: json["date_upgrade_set"] == null ? null : DateTime.parse(json["date_upgrade_set"]),
        dateUpgradeNow: json["date_upgrade_now"] == null ? null : DateTime.parse(json["date_upgrade_now"]),
        dateUpgradeNext: json["date_upgrade_next"] == null ? null : DateTime.parse(json["date_upgrade_next"]),
        dateAll: json["date_all"],
        dateNext: json["date_next"],
        dateRemain: json["date_remain"],
        dateAllAvg: json["date_all_avg"]?.toDouble(),
        dateNextAvg: json["date_next_avg"]?.toDouble(),
        dateRemainAvg: json["date_remain_avg"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "date_set": dateSet?.toIso8601String(),
        "mile_now": mileNow,
        "mile_next": mileNext,
        "date_upgrade_set": "${dateUpgradeSet!.year.toString().padLeft(4, '0')}-${dateUpgradeSet!.month.toString().padLeft(2, '0')}-${dateUpgradeSet!.day.toString().padLeft(2, '0')}",
        "date_upgrade_now": "${dateUpgradeNow!.year.toString().padLeft(4, '0')}-${dateUpgradeNow!.month.toString().padLeft(2, '0')}-${dateUpgradeNow!.day.toString().padLeft(2, '0')}",
        "date_upgrade_next": "${dateUpgradeNext!.year.toString().padLeft(4, '0')}-${dateUpgradeNext!.month.toString().padLeft(2, '0')}-${dateUpgradeNext!.day.toString().padLeft(2, '0')}",
        "date_all": dateAll,
        "date_next": dateNext,
        "date_remain": dateRemain,
        "date_all_avg": dateAllAvg,
        "date_next_avg": dateNextAvg,
        "date_remain_avg": dateRemainAvg,
    };
}
