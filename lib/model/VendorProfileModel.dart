// To parse this JSON data, do
//
//     final vendorProfileModel = vendorProfileModelFromJson(jsonString);

import 'dart:convert';

VendorProfileModel vendorProfileModelFromJson(String str) => VendorProfileModel.fromJson(json.decode(str));

String vendorProfileModelToJson(VendorProfileModel data) => json.encode(data.toJson());

class VendorProfileModel {
  VendorProfileModel({
    this.status,
    this.message,
    this.result,
  });

  bool status;
  String message;
  ProfileResult result;

  factory VendorProfileModel.fromJson(Map<String, dynamic> json) => VendorProfileModel(
    status: json["status"],
    message: json["message"],
    result: ProfileResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result.toJson(),
  };
}

class ProfileResult {
  ProfileResult({
    this.name,
    this.email,
    this.phone,
    this.notification,
    this.availableNow,
    this.role,
    this.companyNameEn,
    this.companyNameAr,
    this.profilePhotoPath,
    this.profilePhotoUrl,
  });

  String name;
  String email;
  String phone;
  String notification;
  String availableNow;
  String role;
  String companyNameEn;
  String companyNameAr;
  dynamic profilePhotoPath;
  String profilePhotoUrl;

  factory ProfileResult.fromJson(Map<String, dynamic> json) => ProfileResult(
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    notification: json["notification"],
    availableNow: json["available_now"],
    role: json["role"],
    companyNameEn: json["company_name_en"],
    companyNameAr: json["company_name_ar"],
    profilePhotoPath: json["profile_photo_path"],
    profilePhotoUrl: json["profile_photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "notification": notification,
    "available_now": availableNow,
    "role": role,
    "company_name_en": companyNameEn,
    "company_name_ar": companyNameAr,
    "profile_photo_path": profilePhotoPath,
    "profile_photo_url": profilePhotoUrl,
  };
}
