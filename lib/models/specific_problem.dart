// To parse this JSON data, do
//
//     final specificProblem = specificProblemFromJson(jsonString);

import 'dart:convert';

SpecificProblem specificProblemFromJson(String str) =>
    SpecificProblem.fromJson(json.decode(str));

String specificProblemToJson(SpecificProblem data) =>
    json.encode(data.toJson());

class SpecificProblem {
  SpecificProblem({
    required this.status,
    required this.data,
  });

  bool status;
  Data data;

  factory SpecificProblem.fromJson(Map<String, dynamic> json) =>
      SpecificProblem(
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
    required this.problemInProblemType,
    required this.problemName,
  });

  List<ProblemInProblemType> problemInProblemType;
  String problemName;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        problemInProblemType: List<ProblemInProblemType>.from(
            json["problem_in_problem_type"]
                .map((x) => ProblemInProblemType.fromJson(x))),
        problemName: json["problem_name"],
      );

  Map<String, dynamic> toJson() => {
        "problem_in_problem_type":
            List<dynamic>.from(problemInProblemType.map((x) => x.toJson())),
        "problem_name": problemName,
      };
}

class ProblemInProblemType {
  ProblemInProblemType({
    required this.problem,
  });

  String problem;

  factory ProblemInProblemType.fromJson(Map<String, dynamic> json) =>
      ProblemInProblemType(
        problem: json["problem"],
      );

  Map<String, dynamic> toJson() => {
        "problem": problem,
      };
}
