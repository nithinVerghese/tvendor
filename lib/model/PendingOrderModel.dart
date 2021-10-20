// To parse this JSON data, do
//
//     final pendingOrderModel = pendingOrderModelFromJson(jsonString);

import 'dart:convert';

PendingOrderModel pendingOrderModelFromJson(String str) => PendingOrderModel.fromJson(json.decode(str));

String pendingOrderModelToJson(PendingOrderModel data) => json.encode(data.toJson());

class PendingOrderModel {
  PendingOrderModel({
    this.status,
    this.message,
    this.total,
    this.result,
  });

  bool status;
  String message;
  int total;
  List<PendingOrderResult> result;

  factory PendingOrderModel.fromJson(Map<String, dynamic> json) => PendingOrderModel(
    status: json["status"],
    message: json["message"],
    total: json["total"],
    result: List<PendingOrderResult>.from(json["result"].map((x) => PendingOrderResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "total": total,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class PendingOrderResult {
  PendingOrderResult({
    this.orderId,
    this.needDelivery,
    this.isExpressService,
    this.employeeName,
    this.profilePhotoPath,
    this.orderDate,
    this.status,
    this.quantity,
    this.services,
  });

  String orderId;
  String needDelivery;
  String isExpressService;
  String employeeName;
  String profilePhotoPath;
  String orderDate;
  String status;
  int quantity;
  List<Service> services;

  factory PendingOrderResult.fromJson(Map<String, dynamic> json) => PendingOrderResult(
    orderId: json["order_id"],
    needDelivery: json["need_delivery"],
    isExpressService: json["is_express_service"],
    employeeName: json["employee_name"],
    profilePhotoPath: json["profile_photo_path"],
    orderDate: json["order_date"],
    status: json["status"],
    quantity: json["quantity"],
    services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "need_delivery": needDelivery,
    "is_express_service": isExpressService,
    "employee_name": employeeName,
    "profile_photo_path": profilePhotoPath,
    "order_date": orderDate,
    "status": status,
    "quantity": quantity,
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
    this.quantity,
  });

  String serviceNameEn;
  String serviceNameAr;
  String categoryNameEn;
  String categoryNameAr;
  String serviceType;
  String quantity;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    serviceNameEn: json["service_name_en"],
    serviceNameAr: json["service_name_ar"],
    categoryNameEn: json["category_name_en"],
    categoryNameAr: json["category_name_ar"],
    serviceType: json["service_type"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "service_name_en": serviceNameEn,
    "service_name_ar": serviceNameAr,
    "category_name_en": categoryNameEn,
    "category_name_ar": categoryNameAr,
    "service_type": serviceType,
    "quantity": quantity,
  };
}
