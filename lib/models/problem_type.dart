// To parse this JSON data, do
//
//     final problemType = problemTypeFromJson(jsonString);

import 'dart:convert';

ProblemType problemTypeFromJson(String str) => ProblemType.fromJson(json.decode(str));

String problemTypeToJson(ProblemType data) => json.encode(data.toJson());

class ProblemType {
    ProblemType({
        required this.status,
        required this.data,
    });

    bool status;
    Data data;

    factory ProblemType.fromJson(Map<String, dynamic> json) => ProblemType(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        required this.problemTypeAll,
    });

    List<ProblemTypeAll> problemTypeAll;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        problemTypeAll: List<ProblemTypeAll>.from(json["problem_type_all"].map((x) => ProblemTypeAll.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "problem_type_all": List<dynamic>.from(problemTypeAll.map((x) => x.toJson())),
    };
}

class ProblemTypeAll {
    ProblemTypeAll({
        required this.id,
        required this.name,
        required this.image,
    });

    String id;
    String name;
    String image;

    factory ProblemTypeAll.fromJson(Map<String, dynamic> json) => ProblemTypeAll(
        id: json["id"],
        name: json["name"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
    };
}
