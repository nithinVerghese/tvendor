// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    this.status,
    this.message,
    this.results,
  });

  bool status;
  String message;
  List<CategoryResult> results;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    status: json["status"],
    message: json["message"],
    results: List<CategoryResult>.from(json["results"].map((x) => CategoryResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class CategoryResult {
  CategoryResult({
    this.id,
    this.nameEn,
    this.nameAr,
    this.clearanceOrPickup,
  });

  int id;
  String nameEn;
  String nameAr;
  String clearanceOrPickup;

  factory CategoryResult.fromJson(Map<String, dynamic> json) => CategoryResult(
    id: json["id"],
    nameEn: json["name_en"],
    nameAr: json["name_ar"],
    clearanceOrPickup: json["clearance_or_pickup"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_en": nameEn,
    "name_ar": nameAr,
    "clearance_or_pickup": clearanceOrPickup,
  };
}
