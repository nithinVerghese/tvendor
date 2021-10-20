import 'dart:convert';
import 'dart:io';

// import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/Constants/ApiStrings.dart';
// import 'package:takhlees/Utils/logger.dart';
// import 'package:takhlees/model/ServicesModel.dart';

class AddToCartController {
  Future<dynamic> fetchServices(
    String vendorServiceId,
    String quantity,
      String expressDelivery,
      String nameList,
  ) async {
    var responseJson;
    try {
      final jobsListAPIUrl = ApiStrings.BaseURL + ApiStrings.addToCart;
      final prefs = await SharedPreferences.getInstance();
      String auth = prefs.getString("token");
      final deviceID = prefs.getString("DeviceID");
      final response = await http.post(jobsListAPIUrl, headers: {
        "Authorization": "Bearer " + auth,
        "Accept": "application/json",
      }, body: {
        "vendor_service_id": vendorServiceId,
        "quantity": quantity,
        "device_id": deviceID,
        "express_delivery": expressDelivery,
        "name_list":nameList
      });
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
