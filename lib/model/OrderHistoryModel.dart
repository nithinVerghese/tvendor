// To parse this JSON data, do
//
//     final orderHistoryModel = orderHistoryModelFromJson(jsonString);

import 'dart:convert';

OrderHistoryModel orderHistoryModelFromJson(String str) => OrderHistoryModel.fromJson(json.decode(str));

String orderHistoryModelToJson(OrderHistoryModel data) => json.encode(data.toJson());

class OrderHistoryModel {
  OrderHistoryModel({
    this.status,
    this.message,
    this.total,
    this.result,
  });

  bool status;
  String message;
  int total;
  List<OrderHistoryResult> result;

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) => OrderHistoryModel(
    status: json["status"],
    message: json["message"],
    total: json["total"],
    result: List<OrderHistoryResult>.from(json["result"].map((x) => OrderHistoryResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "total": total,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class OrderHistoryResult {
  OrderHistoryResult({
    this.orderId,
    this.quantity,
    this.needDelivery,
    this.isExpressService,
    this.employeeName,
    this.profilePhotoPath,
    this.orderDate,
    this.status,
    this.services,
  });

  String orderId;
  var quantity;
  String needDelivery;
  String isExpressService;
  String employeeName;
  String profilePhotoPath;
  String orderDate;
  String status;
  List<Service> services;

  factory OrderHistoryResult.fromJson(Map<String, dynamic> json) => OrderHistoryResult(
    orderId: json["order_id"],
    quantity: json["quantity"],
    needDelivery: json["need_delivery"],
    isExpressService: json["is_express_service"],
    employeeName: json["employee_name"],
    profilePhotoPath: json["profile_photo_path"],
    orderDate: json["order_date"],
    status: json["status"],
    services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "quantity": quantity,
    "need_delivery": needDelivery,
    "is_express_service": isExpressService,
    "employee_name": employeeName,
    "profile_photo_path": profilePhotoPath,
    "order_date": orderDate,
    "status": status,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
  };
}

class Service {
  Service({
    this.serviceNameEn,
    this.serviceNameAr,
    this.categoryNameEn,
    this.categoryNameAr,
    this.serviceType,
  });

  String serviceNameEn;
  String serviceNameAr;
  String categoryNameEn;
  String categoryNameAr;
  String serviceType;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    serviceNameEn: json["service_name_en"],
    serviceNameAr: json["service_name_ar"],
    categoryNameEn: json["category_name_en"],
    categoryNameAr: json["category_name_ar"],
    serviceType: json["service_type"],
  );

  Map<String, dynamic> toJson() => {
    "service_name_en": serviceNameEn,
    "service_name_ar": serviceNameAr,
    "category_name_en": categoryNameEn,
    "category_name_ar": categoryNameAr,
    "service_type": serviceType,
  };
}
