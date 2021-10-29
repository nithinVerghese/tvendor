// To parse this JSON data, do
//
//     final companyDetailModel = companyDetailModelFromJson(jsonString);

import 'dart:convert';

CompanyDetailModel companyDetailModelFromJson(String str) => CompanyDetailModel.fromJson(json.decode(str));

String companyDetailModelToJson(CompanyDetailModel data) => json.encode(data.toJson());

class CompanyDetailModel {
  CompanyDetailModel({
    this.status,
    this.message,
    this.result,
  });

  bool status;
  String message;
  VendorResult result;

  factory CompanyDetailModel.fromJson(Map<String, dynamic> json) => CompanyDetailModel(
    status: json["status"],
    message: json["message"],
    result: VendorResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result.toJson(),
  };
}

class VendorResult {
  VendorResult({
    this.companyNameEn,
    this.companyNameAr,
    this.crNumber,
    this.flatOrShopNumber,
    this.blockNumber,
    this.roadNumber,
    this.buildingNumber,
    this.logo,
  });

  String companyNameEn;
  String companyNameAr;
  String crNumber;
  var flatOrShopNumber;
  var blockNumber;
  var roadNumber;
  var buildingNumber;
  String logo;

  factory VendorResult.fromJson(Map<String, dynamic> json) => VendorResult(
    companyNameEn: json["company_name_en"],
    companyNameAr: json["company_name_ar"],
    crNumber: json["cr_number"],
    flatOrShopNumber: json["flat_or_shop_number"],
    blockNumber: json["block_number"],
    roadNumber: json["road_number"],
    buildingNumber: json["building_number"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "company_name_en": companyNameEn,
    "company_name_ar": companyNameAr,
    "cr_number": crNumber,
    "flat_or_shop_number": flatOrShopNumber,
    "block_number": blockNumber,
    "road_number": roadNumber,
    "building_number": buildingNumber,
    "logo": logo,
  };
}
