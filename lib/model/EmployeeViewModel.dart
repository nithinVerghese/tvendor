// To parse this JSON data, do
//
//     final employeeViewModel = employeeViewModelFromJson(jsonString);

import 'dart:convert';

EmployeeViewModel employeeViewModelFromJson(String str) => EmployeeViewModel.fromJson(json.decode(str));

String employeeViewModelToJson(EmployeeViewModel data) => json.encode(data.toJson());

class EmployeeViewModel {
  EmployeeViewModel({
    this.status,
    this.message,
    this.result,
  });

  bool status;
  String message;
  EmployeeViewResult result;

  factory EmployeeViewModel.fromJson(Map<String, dynamic> json) => EmployeeViewModel(
    status: json["status"],
    message: json["message"],
    result: EmployeeViewResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result.toJson(),
  };
}

class EmployeeViewResult {
  EmployeeViewResult({
    this.userId,
    this.name,
    this.phone,
    this.email,
    this.cpr,
    this.cprExpiryDate,
    this.cprFrontPage,
    this.cprBackPage,
    this.cprCardReader,
    this.profilePhotoPath,
    this.profilePhotoUrl,
  });

  String userId;
  String name;
  String phone;
  String email;
  String cpr;
  DateTime cprExpiryDate;
  String cprFrontPage;
  String cprBackPage;
  String cprCardReader;
  String profilePhotoPath;
  String profilePhotoUrl;

  factory EmployeeViewResult.fromJson(Map<String, dynamic> json) => EmployeeViewResult(
    userId: json["user_id"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    cpr: json["cpr"],
    cprExpiryDate: DateTime.parse(json["cpr_expiry_date"]),
    cprFrontPage: json["cpr_front_page"],
    cprBackPage: json["cpr_back_page"],
    cprCardReader: json["cpr_card_reader"],
    profilePhotoPath: json["profile_photo_path"],
    profilePhotoUrl: json["profile_photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "phone": phone,
    "email": email,
    "cpr": cpr,
    "cpr_expiry_date": "${cprExpiryDate.year.toString().padLeft(4, '0')}-${cprExpiryDate.month.toString().padLeft(2, '0')}-${cprExpiryDate.day.toString().padLeft(2, '0')}",
    "cpr_front_page": cprFrontPage,
    "cpr_back_page": cprBackPage,
    "cpr_card_reader": cprCardReader,
    "profile_photo_path": profilePhotoPath,
    "profile_photo_url": profilePhotoUrl,
  };
}
