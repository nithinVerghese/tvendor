// To parse this JSON data, do
//
//     final viewCartModel = viewCartModelFromJson(jsonString);

import 'dart:convert';

ServiceModel viewCartModelFromJson(String str) => ServiceModel.fromJson(json.decode(str));

String viewCartModelToJson(ServiceModel data) => json.encode(data.toJson());

class ServiceModel {
  ServiceModel({
    this.status,
    this.message,
    this.totalInCart,
    this.totalAddedServices,
    this.results,
  });

  bool status;
  String message;
  String totalInCart;
  String totalAddedServices;
  List<ServiceResult> results;

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    status: json["status"],
    message: json["message"],
    totalInCart: json["totalInCart"],
    totalAddedServices: json["totalAddedServices"],
    results: List<ServiceResult>.from(json["results"].map((x) => ServiceResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "totalInCart": totalInCart,
    "totalAddedServices": totalAddedServices,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class ServiceResult {
  ServiceResult({
    this.type,
    this.categoryNameEn,
    this.categoryNameAr,
    this.services,
  });

  int type;
  String categoryNameEn;
  String categoryNameAr;
  List<Service> services;

  factory ServiceResult.fromJson(Map<String, dynamic> json) => ServiceResult(
    type: json["type"],
    categoryNameEn: json["category_name_en"],
    categoryNameAr: json["category_name_ar"],
    services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "category_name_en": categoryNameEn,
    "category_name_ar": categoryNameAr,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
  };
}

class Service {
  Service({
    this.serviceId,
    this.serviceNameEn,
    this.serviceNameAr,
    this.serviceFee,
    this.expressServiceFee,
    this.expressService,
    this.governmentFee,
    this.expressGovernmentFee,
    this.expressServiceTime,
    this.serviceTime,
    this.serviceType,
    this.maxQuantity,
    this.needName,
    this.showExpressService,
    this.quantity,
    this.expressSelected,
    this.documents,
  });

  int serviceId;
  String serviceNameEn;
  String serviceNameAr;
  String serviceFee;
  String expressServiceFee;
  String expressService;
  String governmentFee;
  String expressGovernmentFee;
  int expressServiceTime;
  int serviceTime;
  String serviceType;
  int maxQuantity;
  String needName;
  String showExpressService;
  int quantity;
  String expressSelected;
  List<Document> documents;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    serviceId: json["service_id"],
    serviceNameEn: json["service_name_en"],
    serviceNameAr: json["service_name_ar"],
    serviceFee: json["service_fee"],
    expressServiceFee: json["express_service_fee"],
    expressService: json["express_service"],
    governmentFee: json["government_fee"],
    expressGovernmentFee: json["express_government_fee"],
    expressServiceTime: json["express_service_time"],
    serviceTime: json["service_time"],
    serviceType: json["service_type"],
    maxQuantity: json["max_quantity"],
    needName: json["need_name"],
    showExpressService: json["show_express_service"],
    quantity: json["quantity"],
    expressSelected: json["express_selected"],
    // documents: List<Document>.from(json["documents"].map((x) => Document.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "service_id": serviceId,
    "service_name_en": serviceNameEn,
    "service_name_ar": serviceNameAr,
    "service_fee": serviceFee,
    "express_service_fee": expressServiceFee,
    "express_service": expressService,
    "government_fee": governmentFee,
    "express_government_fee": expressGovernmentFee,
    "express_service_time": expressServiceTime,
    "service_time": serviceTime,
    "service_type": serviceType,
    "max_quantity": maxQuantity,
    "need_name": needName,
    "show_express_service": showExpressService,
    "quantity": quantity,
    "express_selected": expressSelected,
    "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
  };
}

class Document {
  Document({
    this.documentNameEn,
    this.documentNameAr,
  });

  String documentNameEn;
  String documentNameAr;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    documentNameEn: json["document_name_en"],
    documentNameAr: json["document_name_ar"],
  );

  Map<String, dynamic> toJson() => {
    "document_name_en": documentNameEn,
    "document_name_ar": documentNameAr,
  };
}
