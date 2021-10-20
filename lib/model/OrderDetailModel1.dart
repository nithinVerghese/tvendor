// To parse this JSON data, do
//
//     final bookDeliverySlotModel = bookDeliverySlotModelFromJson(jsonString);

import 'dart:convert';

OrderDetailModel1 orderDetailModel1FromJson(String str) => OrderDetailModel1.fromJson(json.decode(str));

String orderDetailModel1ToJson(OrderDetailModel1 data) => json.encode(data.toJson());

class OrderDetailModel1 {
  OrderDetailModel1({
    this.status,
    this.message,
    this.result,
  });

  bool status;
  String message;
  OrderDetailResult1 result;

  factory OrderDetailModel1.fromJson(Map<String, dynamic> json) => OrderDetailModel1(
    status: json["status"],
    message: json["message"],
    result: OrderDetailResult1.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result.toJson(),
  };
}

class OrderDetailResult1 {
  OrderDetailResult1({
    this.orderId,
    this.status,
    this.needDelivery,
    this.isExpressService,
    this.orderDate,
    this.completedOn,
    this.estimatedCompletedTime,
    this.totalAmount,
    this.totalVat,
    this.paymentMethod,
    this.totalServices,
    this.services,
    this.consumerDetails,
    this.pickupNotes,
    this.deliveryNotes,
    this.rating,
    this.review,
    this.pickupDate,
    this.pickupAddress,
    this.pickupAddressId,
    this.deliveryDate,
    this.deliveryAddress,
    this.deliveryAddressId,
    this.driverDetail,
    this.employeeDetail,
  });

  String orderId;
  String status;
  String needDelivery;
  String isExpressService;
  String orderDate;
  String completedOn;
  int estimatedCompletedTime;
  String totalAmount;
  String totalVat;
  String paymentMethod;
  int totalServices;
  List<ResultService> services;
  ConsumerDetails consumerDetails;
  dynamic pickupNotes;
  dynamic deliveryNotes;
  var rating;
  dynamic review;
  String pickupDate;
  String pickupAddress;
  int pickupAddressId;
  String deliveryDate;
  String deliveryAddress;
  int deliveryAddressId;
  List<DriverDetail> driverDetail;
  ConsumerDetails employeeDetail;

  factory OrderDetailResult1.fromJson(Map<String, dynamic> json) => OrderDetailResult1(
    orderId: json["order_id"],
    status: json["status"],
    needDelivery: json["need_delivery"],
    isExpressService: json["is_express_service"],
    orderDate: json["order_date"],
    completedOn: json["completed_on"],
    estimatedCompletedTime: json["estimated_completed_time"],
    totalAmount: json["total_amount"],
    totalVat: json["total_vat"],
    paymentMethod: json["payment_method"],
    totalServices: json["total_services"],
    services: List<ResultService>.from(json["services"].map((x) => ResultService.fromJson(x))),
    consumerDetails: ConsumerDetails.fromJson(json["consumer_details"]),
    pickupNotes: json["pickup_notes"],
    deliveryNotes: json["delivery_notes"],
    rating: json["rating"],
    review: json["review"],
    pickupDate: json["pickup_date"],
    pickupAddress: json["pickup_address"],
    pickupAddressId: json["pickup_address_id"],
    deliveryDate: json["delivery_date"],
    deliveryAddress: json["delivery_address"],
    deliveryAddressId: json["delivery_address_id"],
    driverDetail: List<DriverDetail>.from(json["driver_detail"].map((x) => DriverDetail.fromJson(x))),
    employeeDetail: ConsumerDetails.fromJson(json["employee_detail"]),
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "status": status,
    "need_delivery": needDelivery,
    "is_express_service": isExpressService,
    "order_date": orderDate,
    "completed_on": completedOn,
    "estimated_completed_time": estimatedCompletedTime,
    "total_amount": totalAmount,
    "total_vat": totalVat,
    "payment_method": paymentMethod,
    "total_services": totalServices,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
    "consumer_details": consumerDetails.toJson(),
    "pickup_notes": pickupNotes,
    "delivery_notes": deliveryNotes,
    "rating": rating,
    "review": review,
    "pickup_date": pickupDate,
    "pickup_address": pickupAddress,
    "pickup_address_id": pickupAddressId,
    "delivery_date": deliveryDate,
    "delivery_address": deliveryAddress,
    "delivery_address_id": deliveryAddressId,
    "driver_detail": List<dynamic>.from(driverDetail.map((x) => x.toJson())),
    "employee_detail": employeeDetail.toJson(),
  };
}

class ConsumerDetails {
  ConsumerDetails({
    this.userId,
    this.consumerName,
    this.phone,
    this.email,
    this.profilePhotoPath,
    this.employeeName,
  });

  int userId;
  String consumerName;
  String phone;
  String email;
  String profilePhotoPath;
  String employeeName;

  factory ConsumerDetails.fromJson(Map<String, dynamic> json) => ConsumerDetails(
    userId: json["user_id"],
    consumerName: json["consumer_name"] == null ? null : json["consumer_name"],
    phone: json["phone"],
    email: json["email"],
    profilePhotoPath: json["profile_photo_path"],
    employeeName: json["employee_name"] == null ? null : json["employee_name"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "consumer_name": consumerName == null ? null : consumerName,
    "phone": phone,
    "email": email,
    "profile_photo_path": profilePhotoPath,
    "employee_name": employeeName == null ? null : employeeName,
  };
}

class DriverDetail {
  DriverDetail({
    this.name,
    this.email,
    this.phone,
    this.profilePhotoPath,
  });

  String name;
  String email;
  String phone;
  String profilePhotoPath;

  factory DriverDetail.fromJson(Map<String, dynamic> json) => DriverDetail(
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    profilePhotoPath: json["profile_photo_path"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "profile_photo_path": profilePhotoPath,
  };
}

class ResultService {
  ResultService({
    this.itemId,
    this.serviceNameEn,
    this.serviceNameAr,
    this.name,
    this.documentId,
    this.serviceType,
    this.maxQuantity,
    this.needName,
    this.showExpressService,
    this.serviceFee,
    this.governmentFee,
    this.serviceTime,
    this.quantity,
    this.itemStatus,
    this.subTotal,
    this.documentNameEn,
    this.documentNameAr,
    this.serviceForm,
    this.requestedServices,
  });

  int itemId;
  String serviceNameEn;
  String serviceNameAr;
  String name;
  String documentId;
  String serviceType;
  int maxQuantity;
  String needName;
  String showExpressService;
  String serviceFee;
  String governmentFee;
  int serviceTime;
  int quantity;
  String itemStatus;
  String subTotal;
  String documentNameEn;
  String documentNameAr;
  List<ServiceForm> serviceForm;
  List<RequestedService> requestedServices;

  factory ResultService.fromJson(Map<String, dynamic> json) => ResultService(
    itemId: json["item_id"],
    serviceNameEn: json["service_name_en"],
    serviceNameAr: json["service_name_ar"],
    name: json["name"],
    documentId: json["document_id"],
    serviceType: json["service_type"],
    maxQuantity: json["max_quantity"],
    needName: json["need_name"],
    showExpressService: json["show_express_service"],
    serviceFee: json["service_fee"],
    governmentFee: json["government_fee"],
    serviceTime: json["service_time"],
    quantity: json["quantity"],
    itemStatus: json["item_status"],
    subTotal: json["sub_total"],
    documentNameEn: json["document_name_en"],
    documentNameAr: json["document_name_ar"],
    serviceForm: List<ServiceForm>.from(json["service_form"].map((x) => ServiceForm.fromJson(x))),
    requestedServices: List<RequestedService>.from(json["requested_services"].map((x) => RequestedService.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "service_name_en": serviceNameEn,
    "service_name_ar": serviceNameAr,
    "name": name,
    "document_id": documentId,
    "service_type": serviceType,
    "max_quantity": maxQuantity,
    "need_name": needName,
    "show_express_service": showExpressService,
    "service_fee": serviceFee,
    "government_fee": governmentFee,
    "service_time": serviceTime,
    "quantity": quantity,
    "item_status": itemStatus,
    "sub_total": subTotal,
    "document_name_en": documentNameEn,
    "document_name_ar": documentNameAr,
    "service_form": List<dynamic>.from(serviceForm.map((x) => x.toJson())),
    "requested_services": List<dynamic>.from(requestedServices.map((x) => x.toJson())),
  };
}

class RequestedService {
  RequestedService({
    this.reason,
    this.orderDate,
    this.status,
    this.services,
  });

  String reason;
  String orderDate;
  String status;
  List<RequestedServiceService> services;

  factory RequestedService.fromJson(Map<String, dynamic> json) => RequestedService(
    reason: json["reason"],
    orderDate: json["order_date"],
    status: json["status"],
    services: List<RequestedServiceService>.from(json["services"].map((x) => RequestedServiceService.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "reason": reason,
    "order_date": orderDate,
    "status": status,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
  };
}

class RequestedServiceService {
  RequestedServiceService({
    this.serviceNameEn,
    this.serviceNameAr,
    this.serviceType,
    this.serviceTime,
    this.serviceFee,
    this.governmentFee,
    this.quantity,
    this.documentNameEn,
    this.documentNameAr,
  });

  String serviceNameEn;
  String serviceNameAr;
  String serviceType;
  int serviceTime;
  String serviceFee;
  String governmentFee;
  int quantity;
  String documentNameEn;
  String documentNameAr;

  factory RequestedServiceService.fromJson(Map<String, dynamic> json) => RequestedServiceService(
    serviceNameEn: json["service_name_en"],
    serviceNameAr: json["service_name_ar"],
    serviceType: json["service_type"],
    serviceTime: json["service_time"],
    serviceFee: json["service_fee"],
    governmentFee: json["government_fee"],
    quantity: json["quantity"],
    documentNameEn: json["document_name_en"],
    documentNameAr: json["document_name_ar"],
  );

  Map<String, dynamic> toJson() => {
    "service_name_en": serviceNameEn,
    "service_name_ar": serviceNameAr,
    "service_type": serviceType,
    "service_time": serviceTime,
    "service_fee": serviceFee,
    "government_fee": governmentFee,
    "quantity": quantity,
    "document_name_en": documentNameEn,
    "document_name_ar": documentNameAr,
  };
}

class ServiceForm {
  ServiceForm({
    this.serviceForm,
  });

  String serviceForm;

  factory ServiceForm.fromJson(Map<String, dynamic> json) => ServiceForm(
    serviceForm: json["service_form"],
  );

  Map<String, dynamic> toJson() => {
    "service_form": serviceForm,
  };
}
