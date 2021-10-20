// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

NewCategoriesModel categoriesModelFromJson(String str) => NewCategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(NewCategoriesModel data) => json.encode(data.toJson());

class NewCategoriesModel {
  NewCategoriesModel({
    this.status,
    this.message,
    this.totalInCart,
    this.results,
  });

  bool status;
  String message;
  int totalInCart;
  List<NewCategoryResult> results;

  factory NewCategoriesModel.fromJson(Map<String, dynamic> json) => NewCategoriesModel(
    status: json["status"],
    message: json["message"],
    totalInCart: json["totalInCart"],
    results: List<NewCategoryResult>.from(json["results"].map((x) => NewCategoryResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "totalInCart": totalInCart,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class NewCategoryResult {
  NewCategoryResult({
    this.id,
    this.nameEn,
    this.nameAr,
    this.clearanceOrPickup,
    this.isInCart,
  });

  int id;
  String nameEn;
  String nameAr;
  String clearanceOrPickup;
  String isInCart;

  factory NewCategoryResult.fromJson(Map<String, dynamic> json) => NewCategoryResult(
    id: json["id"],
    nameEn: json["name_en"],
    nameAr: json["name_ar"],
    clearanceOrPickup: json["clearance_or_pickup"],
    isInCart: json["isInCart"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_en": nameEn,
    "name_ar": nameAr,
    "clearance_or_pickup": clearanceOrPickup,
    "isInCart": isInCart,
  };
}
