// To parse this JSON data, do
//
//     final myCarDetails = myCarDetailsFromJson(jsonString);

import 'dart:convert';

MyCarDetails myCarDetailsFromJson(String str) => MyCarDetails.fromJson(json.decode(str));

String myCarDetailsToJson(MyCarDetails data) => json.encode(data.toJson());

class MyCarDetails {
    MyCarDetails({
        this.status,
        this.data,
        this.message,
    });

    bool? status;
    Data? data;
    String? message;

    factory MyCarDetails.fromJson(Map<String, dynamic> json) => MyCarDetails(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
    };
}

class Data {
    Data({
        this.mycarDetail,
    });

    MycarDetail? mycarDetail;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        mycarDetail: json["mycar_detail"] == null ? null : MycarDetail.fromJson(json["mycar_detail"]),
    );

    Map<String, dynamic> toJson() => {
        "mycar_detail": mycarDetail?.toJson(),
    };
}

class MycarDetail {
    MycarDetail({
        this.mycarId,
        this.carNo,
        this.carBrand,
        this.carModel,
        this.carMakeover,
        this.carSubversion,
        this.carFuel,
        this.ownerName,
        this.carProfile,
    });

    String? mycarId;
    String? carNo;
    String? carBrand;
    String? carModel;
    String? carMakeover;
    String? carSubversion;
    String? carFuel;
    String? ownerName;
    String? carProfile;

    factory MycarDetail.fromJson(Map<String, dynamic> json) => MycarDetail(
        mycarId: json["mycar_id"],
        carNo: json["car_no"],
        carBrand: json["car_brand"],
        carModel: json["car_model"],
        carMakeover: json["car_makeover"],
        carSubversion: json["car_subversion"],
        carFuel: json["car_fuel"],
        ownerName: json["owner_name"],
        carProfile: json["car_profile"],
    );

    Map<String, dynamic> toJson() => {
        "mycar_id": mycarId,
        "car_no": carNo,
        "car_brand": carBrand,
        "car_model": carModel,
        "car_makeover": carMakeover,
        "car_subversion": carSubversion,
        "car_fuel": carFuel,
        "owner_name": ownerName,
        "car_profile": carProfile,
    };
}
