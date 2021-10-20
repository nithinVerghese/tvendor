// To parse this JSON data, do
//
//     final vendorList = vendorListFromJson(jsonString);

import 'dart:convert';

VendorList vendorListFromJson(String str) => VendorList.fromJson(json.decode(str));

String vendorListToJson(VendorList data) => json.encode(data.toJson());

class VendorList {
  VendorList({
    this.status,
    this.message,
    this.result,
  });

  bool status;
  String message;
  List<Result> result;

  factory VendorList.fromJson(Map<String, dynamic> json) => VendorList(
    status: json["status"],
    message: json["message"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.id,
    this.companyNameEn,
    this.companyNameAr,
    this.crNumber,
    this.flatOrShopNumber,
    this.blockNumber,
    this.roadNumber,
    this.logo,
    this.hasExpressDelivery,
    this.minimumOrderAmount,
    this.rating,
    this.totalWorksCompleted,
    this.status,
    this.availableNow,
    this.clearance,
    this.pickup,
    this.locationEn,
    this.locationAr,
    this.distance,
  });

  int id;
  String companyNameEn;
  String companyNameAr;
  String crNumber;
  String flatOrShopNumber;
  String blockNumber;
  String roadNumber;
  String logo;
  String hasExpressDelivery;
  String minimumOrderAmount;
  String rating;
  int totalWorksCompleted;
  String status;
  String availableNow;
  String clearance;
  String pickup;
  String locationEn;
  String locationAr;
  double distance;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    companyNameEn: json["company_name_en"],
    companyNameAr: json["company_name_ar"],
    crNumber: json["cr_number"],
    flatOrShopNumber: json["flat_or_shop_number"],
    blockNumber: json["block_number"],
    roadNumber: json["road_number"],
    logo: json["logo"],
    hasExpressDelivery: json["has_express_delivery"],
    minimumOrderAmount: json["minimum_order_amount"],
    rating: json["rating"],
    totalWorksCompleted: json["total_works_completed"],
    status: json["status"],
    availableNow: json["available_now"],
    clearance: json["clearance"],
    pickup: json["pickup"],
    locationEn: json["location_en"],
    locationAr: json["location_ar"],
    distance: json["distance"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_name_en": companyNameEn,
    "company_name_ar": companyNameAr,
    "cr_number": crNumber,
    "flat_or_shop_number": flatOrShopNumber,
    "block_number": blockNumber,
    "road_number": roadNumber,
    "logo": logo,
    "has_express_delivery": hasExpressDelivery,
    "minimum_order_amount": minimumOrderAmount,
    "rating": rating,
    "total_works_completed": totalWorksCompleted,
    "status": status,
    "available_now": availableNow,
    "clearance": clearance,
    "pickup": pickup,
    "location_en": locationEn,
    "location_ar": locationAr,
    "distance": distance,
  };
}
