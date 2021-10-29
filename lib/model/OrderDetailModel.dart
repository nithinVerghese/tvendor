// // To parse this JSON data, do
// //
// //     final orderDetailModel = orderDetailModelFromJson(jsonString);
//
// import 'dart:convert';
//
// OrderDetailModel orderDetailModelFromJson(String str) => OrderDetailModel.fromJson(json.decode(str));
//
// String orderDetailModelToJson(OrderDetailModel data) => json.encode(data.toJson());
//
// class OrderDetailModel {
//   OrderDetailModel({
//     this.status,
//     this.message,
//     this.result,
//   });
//
//   bool status;
//   String message;
//   OrderDetailResult result;
//
//   factory OrderDetailModel.fromJson(Map<String, dynamic> json) => OrderDetailModel(
//     status: json["status"],
//     message: json["message"],
//     result: OrderDetailResult.fromJson(json["result"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "result": result.toJson(),
//   };
// }
//
// class OrderDetailResult {
//   OrderDetailResult({
//     this.orderId,
//     this.status,
//     this.needDelivery,
//     this.orderDate,
//     this.totalAmount,
//     this.totalVat,
//     this.paymentMethod,
//     this.totalServices,
//     this.services,
//     this.consumerDetails,
//     this.pickupNotes,
//     this.pickupAddress,
//     this.pickupAddressId,
//   });
//
//   String orderId;
//   String status;
//   String needDelivery;
//   String orderDate;
//   String totalAmount;
//   String totalVat;
//   String paymentMethod;
//   int totalServices;
//   List<Service> services;
//   ConsumerDetails consumerDetails;
//   dynamic pickupNotes;
//   String pickupAddress;
//   int pickupAddressId;
//
//   factory OrderDetailResult.fromJson(Map<String, dynamic> json) => OrderDetailResult(
//     orderId: json["order_id"],
//     status: json["status"],
//     needDelivery: json["need_delivery"],
//     orderDate: json["order_date"],
//     totalAmount: json["total_amount"],
//     totalVat: json["total_vat"],
//     paymentMethod: json["payment_method"],
//     totalServices: json["total_services"],
//     services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
//     consumerDetails: ConsumerDetails.fromJson(json["consumer_details"]),
//     pickupNotes: json["pickup_notes"],
//     pickupAddress: json["pickup_address"],
//     pickupAddressId: json["pickup_address_id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "order_id": orderId,
//     "status": status,
//     "need_delivery": needDelivery,
//     "order_date": orderDate,
//     "total_amount": totalAmount,
//     "total_vat": totalVat,
//     "payment_method": paymentMethod,
//     "total_services": totalServices,
//     "services": List<dynamic>.from(services.map((x) => x.toJson())),
//     "consumer_details": consumerDetails.toJson(),
//     "pickup_notes": pickupNotes,
//     "pickup_address": pickupAddress,
//     "pickup_address_id": pickupAddressId,
//   };
// }
//
// class ConsumerDetails {
//   ConsumerDetails({
//     this.userId,
//     this.consumerName,
//     this.phone,
//     this.email,
//     this.profilePhotoPath,
//   });
//
//   int userId;
//   String consumerName;
//   String phone;
//   String email;
//   String profilePhotoPath;
//
//   factory ConsumerDetails.fromJson(Map<String, dynamic> json) => ConsumerDetails(
//     userId: json["user_id"],
//     consumerName: json["consumer_name"],
//     phone: json["phone"],
//     email: json["email"],
//     profilePhotoPath: json["profile_photo_path"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "user_id": userId,
//     "consumer_name": consumerName,
//     "phone": phone,
//     "email": email,
//     "profile_photo_path": profilePhotoPath,
//   };
// }
//
// class Service {
//   Service({
//     this.itemId,
//     this.serviceNameEn,
//     this.serviceNameAr,
//     this.serviceType,
//     this.serviceFee,
//     this.governmentFee,
//     this.serviceTime,
//     this.quantity,
//     this.subTotal,
//     this.documentNameEn,
//     this.documentNameAr,
//     this.serviceForm,
//   });
//
//   int itemId;
//   String serviceNameEn;
//   String serviceNameAr;
//   String serviceType;
//   String serviceFee;
//   String governmentFee;
//   int serviceTime;
//   int quantity;
//   int subTotal;
//   String documentNameEn;
//   String documentNameAr;
//   List<dynamic> serviceForm;
//
//   factory Service.fromJson(Map<String, dynamic> json) => Service(
//     itemId: json["item_id"],
//     serviceNameEn: json["service_name_en"],
//     serviceNameAr: json["service_name_ar"],
//     serviceType: json["service_type"],
//     serviceFee: json["service_fee"],
//     governmentFee: json["government_fee"],
//     serviceTime: json["service_time"],
//     quantity: json["quantity"],
//     subTotal: json["sub_total"],
//     documentNameEn: json["document_name_en"],
//     documentNameAr: json["document_name_ar"],
//     serviceForm: List<dynamic>.from(json["service_form"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "item_id": itemId,
//     "service_name_en": serviceNameEn,
//     "service_name_ar": serviceNameAr,
//     "service_type": serviceType,
//     "service_fee": serviceFee,
//     "government_fee": governmentFee,
//     "service_time": serviceTime,
//     "quantity": quantity,
//     "sub_total": subTotal,
//     "document_name_en": documentNameEn,
//     "document_name_ar": documentNameAr,
//     "service_form": List<dynamic>.from(serviceForm.map((x) => x)),
//   };
// }
//
//
//
//
//
//
//


// To parse this JSON data, do
//
//     final orderDetailModel = orderDetailModelFromJson(jsonString);

import 'dart:convert';

OrderDetailModel orderDetailModelFromJson(String str) => OrderDetailModel.fromJson(json.decode(str));

String orderDetailModelToJson(OrderDetailModel data) => json.encode(data.toJson());

class OrderDetailModel {
  OrderDetailModel({
    this.status,
    this.message,
    this.result,
  });

  bool status;
  String message;
  OrderDetailResult result;

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) => OrderDetailModel(
    status: json["status"],
    message: json["message"],
    result: OrderDetailResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result.toJson(),
  };
}

class OrderDetailResult {
  OrderDetailResult({
    this.orderId,
    this.status,
    this.needDelivery,
    this.orderDate,
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
  });

  String orderId;
  String status;
  String needDelivery;
  String orderDate;
  int estimatedCompletedTime;
  String totalAmount;
  String totalVat;
  String paymentMethod;
  int totalServices;
  List<Service> services;
  ConsumerDetails consumerDetails;
  dynamic pickupNotes;
  dynamic deliveryNotes;
  dynamic rating;
  dynamic review;
  String pickupDate;
  String pickupAddress;
  int pickupAddressId;
  String deliveryDate;
  String deliveryAddress;
  int deliveryAddressId;

  factory OrderDetailResult.fromJson(Map<String, dynamic> json) => OrderDetailResult(
    orderId: json["order_id"],
    status: json["status"],
    needDelivery: json["need_delivery"],
    orderDate: json["order_date"],
    estimatedCompletedTime: json["estimated_completed_time"],
    totalAmount: json["total_amount"],
    totalVat: json["total_vat"],
    paymentMethod: json["payment_method"],
    totalServices: json["total_services"],
    services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
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
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "status": status,
    "need_delivery": needDelivery,
    "order_date": orderDate,
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
  };
}

class ConsumerDetails {
  ConsumerDetails({
    this.userId,
    this.consumerName,
    this.phone,
    this.email,
    this.profilePhotoPath,
  });

  int userId;
  String consumerName;
  String phone;
  String email;
  String profilePhotoPath;

  factory ConsumerDetails.fromJson(Map<String, dynamic> json) => ConsumerDetails(
    userId: json["user_id"],
    consumerName: json["consumer_name"],
    phone: json["phone"],
    email: json["email"],
    profilePhotoPath: json["profile_photo_path"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "consumer_name": consumerName,
    "phone": phone,
    "email": email,
    "profile_photo_path": profilePhotoPath,
  };
}

class Service {
  Service({
    this.itemId,
    this.serviceNameEn,
    this.serviceNameAr,
    this.name,
    this.needName,
    this.documentID,
    this.serviceType,
    this.serviceFee,
    this.governmentFee,
    this.serviceTime,
    this.quantity,
    this.itemStatus,
    this.subTotal,
    this.documentNameEn,
    this.documentNameAr,
    this.serviceForm,
  });

  int itemId;
  String serviceNameEn;
  String serviceNameAr;
  String name;
  String needName;
  String documentID;
  String serviceType;
  String serviceFee;
  String governmentFee;
  int serviceTime;
  int quantity;
  String itemStatus;
  var subTotal;
  String documentNameEn;
  String documentNameAr;
  List<dynamic> serviceForm;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    itemId: json["item_id"],
    serviceNameEn: json["service_name_en"],
    serviceNameAr: json["service_name_ar"],
    name: json["name"],
    needName: json["need_name"],
    documentID: json["document_id"],
    serviceType: json["service_type"],
    serviceFee: json["service_fee"],
    governmentFee: json["government_fee"],
    serviceTime: json["service_time"],
    quantity: json["quantity"],
    itemStatus: json["item_status"],
    subTotal: json["sub_total"],
    documentNameEn: json["document_name_en"],
    documentNameAr: json["document_name_ar"],
    serviceForm: List<dynamic>.from(json["service_form"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "service_name_en": serviceNameEn,
    "service_name_ar": serviceNameAr,
    "name": name,
    "need_name": needName,
    "document_id": documentID,
    "service_type": serviceType,
    "service_fee": serviceFee,
    "government_fee": governmentFee,
    "service_time": serviceTime,
    "quantity": quantity,
    "itemStatus": itemStatus,
    "sub_total": subTotal,
    "document_name_en": documentNameEn,
    "document_name_ar": documentNameAr,
    "service_form": List<dynamic>.from(serviceForm.map((x) => x)),
  };
}







