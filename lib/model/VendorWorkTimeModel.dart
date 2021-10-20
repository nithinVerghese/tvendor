// To parse this JSON data, do
//
//     final vendorWorkTimeModel = vendorWorkTimeModelFromJson(jsonString);

import 'dart:convert';

VendorWorkTimeModel vendorWorkTimeModelFromJson(String str) => VendorWorkTimeModel.fromJson(json.decode(str));

String vendorWorkTimeModelToJson(VendorWorkTimeModel data) => json.encode(data.toJson());

class VendorWorkTimeModel {
  VendorWorkTimeModel({
    this.status,
    this.message,
    this.result,
  });

  bool status;
  String message;
  Result result;

  factory VendorWorkTimeModel.fromJson(Map<String, dynamic> json) => VendorWorkTimeModel(
    status: json["status"],
    message: json["message"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result.toJson(),
  };
}

class Result {
  Result({
    this.availableDay,
    this.available,
  });

  String availableDay;
  Available available;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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
    this.saturday,
  });

  Day sunday;
  Day monday;
  Day tuesday;
  Day wednesday;
  Day thursday;
  Day saturday;

  factory Available.fromJson(Map<String, dynamic> json) => Available(
    sunday: Day.fromJson(json["Sunday"]),
    monday: Day.fromJson(json["Monday"]),
    tuesday: Day.fromJson(json["Tuesday"]),
    wednesday: Day.fromJson(json["Wednesday"]),
    thursday: Day.fromJson(json["Thursday"]),
    saturday: Day.fromJson(json["Saturday"]),
  );

  Map<String, dynamic> toJson() => {
    "Sunday": sunday.toJson(),
    "Monday": monday.toJson(),
    "Tuesday": tuesday.toJson(),
    "Wednesday": wednesday.toJson(),
    "Thursday": thursday.toJson(),
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
