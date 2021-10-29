// To parse this JSON data, do
//
//     final viewCartModel = viewCartModelFromJson(jsonString);

import 'dart:convert';

ViewCartModel viewCartModelFromJson(String str) => ViewCartModel.fromJson(json.decode(str));

String viewCartModelToJson(ViewCartModel data) => json.encode(data.toJson());

class ViewCartModel {
    ViewCartModel({
        this.status,
        this.message,
        this.result,
    });

    bool status;
    String message;
    ViewCartResult result;

    factory ViewCartModel.fromJson(Map<String, dynamic> json) => ViewCartModel(
        status: json["status"],
        message: json["message"],
        result: ViewCartResult.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result.toJson(),
    };
}

class ViewCartResult {
    ViewCartResult({
        this.needsDelivery,
        this.services,
    });

    String needsDelivery;
    List<ViewCartService> services;

    factory ViewCartResult.fromJson(Map<String, dynamic> json) => ViewCartResult(
        needsDelivery: json["needs_delivery"],
        services: List<ViewCartService>.from(json["services"].map((x) => ViewCartService.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "needs_delivery": needsDelivery,
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
    };
}

class ViewCartService {
    ViewCartService({
        this.serviceId,
        this.serviceNameEn,
        this.serviceNameAr,
        this.governmentFee,
        this.serviceTime,
        this.expressGovernmentFee,
        this.expressServiceTime,
        this.serviceType,
        this.serviceFee,
        this.expressServiceFee,
        this.expressService,
        this.quantity,
        this.expressSelected,
        this.documents,
    });

    int serviceId;
    String serviceNameEn;
    String serviceNameAr;
    String governmentFee;
    int serviceTime;
    String expressGovernmentFee;
    int expressServiceTime;
    String serviceType;
    String serviceFee;
    String expressServiceFee;
    String expressService;
    int quantity;
    String expressSelected;
    List<Document> documents;

    factory ViewCartService.fromJson(Map<String, dynamic> json) => ViewCartService(
        serviceId: json["service_id"],
        serviceNameEn: json["service_name_en"],
        serviceNameAr: json["service_name_ar"],
        governmentFee: json["government_fee"],
        serviceTime: json["service_time"],
        expressGovernmentFee: json["express_government_fee"],
        expressServiceTime: json["express_service_time"],
        serviceType: json["service_type"],
        serviceFee: json["service_fee"],
        expressServiceFee: json["express_service_fee"],
        expressService: json["express_service"],
        quantity: json["quantity"],
        expressSelected: json["express_selected"],
        documents: List<Document>.from(json["documents"].map((x) => Document.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "service_id": serviceId,
        "service_name_en": serviceNameEn,
        "service_name_ar": serviceNameAr,
        "government_fee": governmentFee,
        "service_time": serviceTime,
        "express_government_fee": expressGovernmentFee,
        "express_service_time": expressServiceTime,
        "service_type": serviceType,
        "service_fee": serviceFee,
        "express_service_fee": expressServiceFee,
        "express_service": expressService,
        "quantity": quantity,
        "express_selected": expressSelected,
        "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
    };
}

class Document {
    Document({
        this.documentNameEn,
        this.documentNameAr,
        this.documentId,
    });

    String documentNameEn;
    String documentNameAr;
    var documentId;

    factory Document.fromJson(Map<String, dynamic> json) => Document(
        documentNameEn: json["document_name_en"],
        documentNameAr: json["document_name_ar"],
        documentId: json["document_id"],
    );

    Map<String, dynamic> toJson() => {
        "document_name_en": documentNameEn,
        "document_name_ar": documentNameAr,
        "document_id": documentId,
    };
}
