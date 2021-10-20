import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/Constants/ApiStrings.dart';

class OtpController {
  Future<dynamic> fetchServices(
      String phone,
      String otpCode,
      String fcmToken,
      ) async {
    print('----0-0-00-0----$phone $otpCode');
    var responseJson;
    try {
      var status = await OneSignal.shared.getPermissionSubscriptionState();
      var playerId = status.subscriptionStatus.userId;
      final apiURL = ApiStrings.BaseURL + ApiStrings.loginOTP;
      final prefs = await SharedPreferences.getInstance();
      String device = prefs.getString("Device");
      final deviceID = prefs.getString("DeviceID");
      final response = await http.post(apiURL, headers: {
        "Accept": "application/json",
      }, body: {
        // "phone": phone,
        "phone": phone,
        "otp_code": otpCode,
        "device": device,
        "device_id": deviceID,
        "fcm_token": playerId,
      });
      print('''
"phone": $phone,
"otp_code": $otpCode,
"device": $device,
"device_id": $deviceID,
"fcm_token": $playerId,
      ''');
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        throw ("Something went wrong");
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode :${response.statusCode}');
    }
  }
}

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}