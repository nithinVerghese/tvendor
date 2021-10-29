// To parse this JSON data, do
//
//     final employeeListModel = employeeListModelFromJson(jsonString);

import 'dart:convert';

EmployeeListModel employeeListModelFromJson(String str) => EmployeeListModel.fromJson(json.decode(str));

String employeeListModelToJson(EmployeeListModel data) => json.encode(data.toJson());

class EmployeeListModel {
  EmployeeListModel({
    this.status,
    this.message,
    this.result,
  });

  bool status;
  String message;
  List<EmployeeListResult> result;

  factory EmployeeListModel.fromJson(Map<String, dynamic> json) => EmployeeListModel(
    status: json["status"],
    message: json["message"],
    result: List<EmployeeListResult>.from(json["result"].map((x) => EmployeeListResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class EmployeeListResult {
  EmployeeListResult({
    this.userId,
    this.name,
    this.cpr,
    this.profilePhotoPath,
    this.profilePhotoUrl,
  });

  String userId;
  String name;
  String cpr;
  String profilePhotoPath;
  String profilePhotoUrl;

  factory EmployeeListResult.fromJson(Map<String, dynamic> json) => EmployeeListResult(
    userId: json["user_id"],
    name: json["name"],
    cpr: json["cpr"],
    profilePhotoPath: json["profile_photo_path"],
    profilePhotoUrl: json["profile_photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "cpr": cpr,
    "profile_photo_path": profilePhotoPath,
    "profile_photo_url": profilePhotoUrl,
  };
}
