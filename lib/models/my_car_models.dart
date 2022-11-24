// To parse this JSON data, do
//
//     final myCar = myCarFromJson(jsonString);

import 'dart:convert';

MyCar myCarFromJson(String str) => MyCar.fromJson(json.decode(str));

String myCarToJson(MyCar data) => json.encode(data.toJson());

class MyCar {
    MyCar({
        required this.status,
        required this.data,
        required this.message,
    });

    bool status;
    Data data;
    String message;

    factory MyCar.fromJson(Map<String, dynamic> json) => MyCar(
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

    List<dynamic> mycarData;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        mycarData: List<dynamic>.from(json["mycar_data"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "mycar_data": List<dynamic>.from(mycarData.map((x) => x)),
    };
}
