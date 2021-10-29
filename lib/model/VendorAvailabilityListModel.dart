// To parse this JSON data, do
//
//     final vendorAvailabilityListModel = vendorAvailabilityListModelFromJson(jsonString);

import 'dart:convert';

VendorAvailabilityListModel vendorAvailabilityListModelFromJson(String str) => VendorAvailabilityListModel.fromJson(json.decode(str));

String vendorAvailabilityListModelToJson(VendorAvailabilityListModel data) => json.encode(data.toJson());

class VendorAvailabilityListModel {
  VendorAvailabilityListModel({
    this.status,
    this.message,
    this.result,
  });

  bool status;
  String message;
  VendorAvailableResult result;

  factory VendorAvailabilityListModel.fromJson(Map<String, dynamic> json) => VendorAvailabilityListModel(
    status: json["status"],
    message: json["message"],
    result: VendorAvailableResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result.toJson(),
  };
}

class VendorAvailableResult {
  VendorAvailableResult({
    this.availableDay,
    this.available,
  });

  String availableDay;
  Available available;

  factory VendorAvailableResult.fromJson(Map<String, dynamic> json) => VendorAvailableResult(
    availableDay: json["available_day"],
    available: Available.fromJson(json["available"]),
  );

  Map<String, dynamic> toJson() => {
    "available_day": availableDay,
    "available": available.toJson(),
  };
}

class Available {
  Available({
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  });

  Day sunday;
  Day monday;
  Day tuesday;
  Day wednesday;
  Day thursday;
  Day friday;
  Day saturday;

  factory Available.fromJson(Map<String, dynamic> json) => Available(
    sunday: Day.fromJson(json["Sunday"]),
    monday: Day.fromJson(json["Monday"]),
    tuesday: Day.fromJson(json["Tuesday"]),
    wednesday: Day.fromJson(json["Wednesday"]),
    thursday: Day.fromJson(json["Thursday"]),
    friday: Day.fromJson(json["Friday"]),
    saturday: Day.fromJson(json["Saturday"]),
  );

  Map<String, dynamic> toJson() => {
    "Sunday": sunday.toJson(),
    "Monday": monday.toJson(),
    "Tuesday": tuesday.toJson(),
    "Wednesday": wednesday.toJson(),
    "Thursday": thursday.toJson(),
    "Friday": friday.toJson(),
    "Saturday": saturday.toJson(),
  };
}

class Day {
  Day({
    this.day,
    this.workingHours,
  });

  String day;
  List<WorkingHour> workingHours;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    day: json["day"],
    workingHours: List<WorkingHour>.from(json["working_hours"].map((x) => WorkingHour.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "working_hours": List<dynamic>.from(workingHours.map((x) => x.toJson())),
  };
}

class WorkingHour {
  WorkingHour({
    this.id,
    this.time,
  });

  int id;
  String time;

  factory WorkingHour.fromJson(Map<String, dynamic> json) => WorkingHour(
    id: json["id"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "time": time,
  };
}
