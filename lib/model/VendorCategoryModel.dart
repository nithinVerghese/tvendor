// To parse this JSON data, do
//
//     final servicesModel = servicesModelFromJson(jsonString);

import 'dart:convert';

VendorCategoryModel servicesModelFromJson(String str) => VendorCategoryModel.fromJson(json.decode(str));

String servicesModelToJson(VendorCategoryModel data) => json.encode(data.toJson());

class VendorCategoryModel {
  VendorCategoryModel({
    this.status,
    this.message,
    this.totalInCart,
    this.results,
  });

  bool status;
  String message;
  var totalInCart;
  List<NewServiceResult> results;

  factory VendorCategoryModel.fromJson(Map<String, dynamic> json) => VendorCategoryModel(
    status: json["status"],
    message: json["message"],
    totalInCart: json["totalInCart"],
    results: List<NewServiceResult>.from(json["results"].map((x) => NewServiceResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "totalInCart": totalInCart,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class NewServiceResult {
  NewServiceResult({
    this.type,
    this.openContainer,
    this.categoryNameEn,
    this.categoryNameAr,
    this.services,
  });

  int type;
  String openContainer;
  String categoryNameEn;
  String categoryNameAr;
  List<Service> services;

  factory NewServiceResult.fromJson(Map<String, dynamic> json) => NewServiceResult(
    type: json["type"],
    openContainer: json["open_container"],
    categoryNameEn: json["category_name_en"],
    categoryNameAr: json["category_name_ar"],
    services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "open_container": openContainer,
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
    this.showExpressService,
    this.needName,
    this.maxQuantity,
    this.quantity,
    this.nameList,
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
  String showExpressService;
  String needName;
  int maxQuantity;
  int quantity;
  List<NameList> nameList;
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
    showExpressService: json["show_express_service"],
    needName: json["need_name"],
    maxQuantity: json["max_quantity"],
    quantity: json["quantity"],
    nameList: json["name_list"] == null ? null : List<NameList>.from(json["name_list"].map((x) => NameList.fromJson(x))),
    expressSelected: json["express_selected"],
    documents: List<Document>.from(json["documents"].map((x) => Document.fromJson(x))),
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
    "show_express_service": showExpressService,
    "need_name": needName,
    "max_quantity": maxQuantity,
    "quantity": quantity,
    "name_list": nameList == null ? null : List<dynamic>.from(nameList.map((x) => x.toJson())),
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

class NameList {
  NameList({
    this.name,
    this.docNumber,
  });

  String name;
  String docNumber;

  factory NameList.fromJson(Map<String, dynamic> json) => NameList(
    name: json["name"],
    docNumber: json["doc_number"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "doc_number": docNumber,
  };
}
