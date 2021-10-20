// To parse this JSON data, do
//
//     final reportModel = reportModelFromJson(jsonString);

import 'dart:convert';

ReportModel reportModelFromJson(String str) => ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
  ReportModel({
    this.status,
    this.message,
    this.total,
    this.result,
  });

  bool status;
  String message;
  int total;
  List<ReportResult> result;

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    status: json["status"],
    message: json["message"],
    total: json["total"],
    result: List<ReportResult>.from(json["result"].map((x) => ReportResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "total": total,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class ReportResult {
  ReportResult({
    this.orderId,
    this.quantity,
    this.serviceNameEn,
    this.serviceNameAr,
    this.serviceCharge,
    this.employeeName,
    this.serviceDate,
  });

  String orderId;
  int quantity;
  String serviceNameEn;
  String serviceNameAr;
  int serviceCharge;
  String employeeName;
  String serviceDate;

  factory ReportResult.fromJson(Map<String, dynamic> json) => ReportResult(
    orderId: json["order_id"],
    quantity: json["quantity"],
    serviceNameEn: json["service_name_en"],
    serviceNameAr: json["service_name_ar"],
    serviceCharge: json["service_charge"],
    employeeName: json["employee_name"],
    serviceDate: json["service_date"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "quantity": quantity,
    "service_name_en": serviceNameEn,
    "service_name_ar": serviceNameAr,
    "service_charge": serviceCharge,
    "employee_name": employeeName,
    "service_date": serviceDate,
  };
}
