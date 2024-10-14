// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

InformationModel welcomeFromJson(String str) =>
    InformationModel.fromJson(json.decode(str));

String welcomeToJson(InformationModel data) => json.encode(data.toJson());

class InformationModel {
  String fullName;
  String workHours;
  int sickLeave;
  String personalLeave;
  String vacationLeave;
  String offsiteWork;
  String nonWorkingDays;
  String id;
  DateTime createdAt;
  DateTime updatedAt;

  InformationModel({
    required this.fullName,
    required this.workHours,
    required this.sickLeave,
    required this.personalLeave,
    required this.vacationLeave,
    required this.offsiteWork,
    required this.nonWorkingDays,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InformationModel.fromJson(Map<String, dynamic> json) =>
      InformationModel(
        fullName: json["fullName"],
        workHours: json["workHours"],
        sickLeave: json["sickLeave"],
        personalLeave: json["personalLeave"],
        vacationLeave: json["vacationLeave"],
        offsiteWork: json["offsiteWork"],
        nonWorkingDays: json["nonWorkingDays"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "workHours": workHours,
        "sickLeave": sickLeave,
        "personalLeave": personalLeave,
        "vacationLeave": vacationLeave,
        "offsiteWork": offsiteWork,
        "nonWorkingDays": nonWorkingDays,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
