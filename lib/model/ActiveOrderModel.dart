// To parse this JSON data, do
//
//     final activeOrderModel = activeOrderModelFromJson(jsonString);

import 'dart:convert';

ActiveOrderModel activeOrderModelFromJson(String str) => ActiveOrderModel.fromJson(json.decode(str));

String activeOrderModelToJson(ActiveOrderModel data) => json.encode(data.toJson());

class ActiveOrderModel {
  ActiveOrderModel({
    this.status,
    this.message,
    this.total,
    this.result,
  });

  bool status;
  String message;
  int total;
  List<ActiveOrderResult> result;

  factory ActiveOrderModel.fromJson(Map<String, dynamic> json) => ActiveOrderModel(
    status: json["status"],
    message: json["message"],
    total: json["total"],
    result: List<ActiveOrderResult>.from(json["result"].map((x) => ActiveOrderResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "total": total,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class ActiveOrderResult {
  ActiveOrderResult({
    this.orderId,
    this.needDelivery,
    this.isExpressService,
    this.employeeName,
    this.profilePhotoPath,
    this.orderDate,
    this.status,
    this.quantity,
    this.daysLeft,
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
  String daysLeft;
  List<Service> services;

  factory ActiveOrderResult.fromJson(Map<String, dynamic> json) => ActiveOrderResult(
    orderId: json["order_id"],
    needDelivery: json["need_delivery"],
    isExpressService: json["is_express_service"],
    employeeName: json["employee_name"],
    profilePhotoPath: json["profile_photo_path"],
    orderDate: json["order_date"],
    status: json["status"],
    quantity: json["quantity"],
    daysLeft: json["daysLeft"],
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
    "daysLeft": daysLeft,
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
    this.serviceTime,
    this.expressServiceTime,
    this.quantity,
  });

  String serviceNameEn;
  String serviceNameAr;
  String categoryNameEn;
  String categoryNameAr;
  String serviceType;
  int serviceTime;
  int expressServiceTime;
  String quantity;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    serviceNameEn: json["service_name_en"],
    serviceNameAr: json["service_name_ar"],
    categoryNameEn: json["category_name_en"],
    categoryNameAr: json["category_name_ar"],
    serviceType: json["service_type"],
    serviceTime: json["service_time"],
    expressServiceTime: json["express_service_time"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "service_name_en": serviceNameEn,
    "service_name_ar": serviceNameAr,
    "category_name_en": categoryNameEn,
    "category_name_ar": categoryNameAr,
    "service_type": serviceType,
    "service_time": serviceTime,
    "express_service_time": expressServiceTime,
    "quantity": quantity,
  };
}
