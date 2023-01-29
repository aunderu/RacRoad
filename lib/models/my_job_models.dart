// To parse this JSON data, do
//
//     final myJob = myJobFromJson(jsonString);

import 'dart:convert';

MyJob myJobFromJson(String str) => MyJob.fromJson(json.decode(str));

String myJobToJson(MyJob data) => json.encode(data.toJson());

class MyJob {
    MyJob({
        required this.status,
        required this.data,
        required this.message,
    });

    factory MyJob.fromJson(Map<String, dynamic> json) => MyJob(
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
        required this.myTechnician,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        myTechnician: List<MyTechnician>.from(json["my_technician"].map((x) => MyTechnician.fromJson(x))),
    );

    List<MyTechnician> myTechnician;

    Map<String, dynamic> toJson() => {
        "my_technician": List<dynamic>.from(myTechnician.map((x) => x.toJson())),
    };
}

class MyTechnician {
    MyTechnician({
        required this.tncId,
        required this.name,
        required this.tncName,
        required this.serviceZone,
        required this.status,
    });

    factory MyTechnician.fromJson(Map<String, dynamic> json) => MyTechnician(
        tncId: json["tnc_id"],
        name: json["name"],
        tncName: json["tnc_name"],
        serviceZone: json["service_zone"],
        status: json["status"],
    );

    String name;
    String serviceZone;
    String status;
    String tncId;
    String tncName;

    Map<String, dynamic> toJson() => {
        "tnc_id": tncId,
        "name": name,
        "tnc_name": tncName,
        "service_zone": serviceZone,
        "status": status,
    };
}
