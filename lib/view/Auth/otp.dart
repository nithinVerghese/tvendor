import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/controller/AuthController/LoginController.dart';
import 'package:takhlees_v/controller/AuthController/OtpController.dart';
import 'package:takhlees_v/view/HomeScreen/OrderBottomBarIndex.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:takhlees_v/widget/snackBar.dart';

import '../VendorWorkTime.dart';

class Otp extends StatelessWidget {
  final mobileNumber;
  Otp(this.mobileNumber);
  @override
  Widget build(BuildContext context) {
    var p = mobileNumber.toString();
    print('-----$p');
    return Scaffold(
      body: SafeArea(
        child: new AppBody(p),
      ),
    );
  }
}

class AppBody extends StatefulWidget {
  final mobileNumber;

  AppBody(this.mobileNumber);

  // AppBody({Key key, @required this.DataphoneNumber}) : super(key: key);
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  // StoredMobileNumber getPhoneNumber = new StoredMobileNumber();
  var data;
  final otpCon = new TextEditingController();
  var phoneNumber;
  FocusNode _focusNode1 = FocusNode();

  final log = Logger(
      printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 3,
    lineLength: 50,
    colors: true,
    printEmojis: true,
    printTime: false,
  ));

  final otpApi = OtpController();
  final loginApi = LoginController();

  Future<void> _tokenAndRole(String token, String role, String serviceAdded) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('role', role);
    prefs.setString('service_added', serviceAdded);
    prefs.setString('signIn', 'true');
  }

  @override
  Widget build(BuildContext context) {
    phoneNumber = widget.mobileNumber;
    print('-----------------------otp----------------------------');
    return KeyboardActions(
      config: KeyboardActionsConfig(
          actions: [KeyboardActionsItem(focusNode: _focusNode1)]),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Stack(
                children: [
                  Container(
                    // alignment: Alignment(1.0, 1.0),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      // color: Colors.white,
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  Container(
                    child: Column(children: <Widget>[
                      Container(
                        alignment: Alignment(0.0, 0),
                        padding: EdgeInsets.fromLTRB(0.0, 90, 0.0, 0.0),
                        child: Image.asset(
                          'assets/takhlees_logo_transparent_wordmark.png',
                          height: 40,
                        ),
                      ),
                      Container(
                        alignment: Alignment(0.0, 0),
                        padding: EdgeInsets.fromLTRB(0.0, 40, 0.0, 0.0),
                        child: Image.asset(
                          'assets/Illustration.png',
                          height: 170,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 54, 0.0, 0.0),
                        child: Text(
                          '''Enter SMS Code''',
                          style: TextStyle(
                              fontSize: 32,
                              fontFamily: FontStrings.Fieldwork10_Regular,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff212156)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              // margin: EdgeInsets.all(20),
                              child: TextFormField(
                                // initialValue: 'Mobile Number',
                                keyboardType: TextInputType.phone,
                                focusNode: _focusNode1,
                                controller: otpCon,
                                decoration: InputDecoration(
                                  hintText: 'Enter the OTP code received by SMS',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                style: TextStyle(
                                  fontFamily: FontStrings.Roboto_Regular,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            RaisedGradientButton(
                              onPressed: () {
                                final String otp = otpCon.text;
                                // getSnackBar(null, otp);
                                print("OTP:   $otp");
                                var phoneNumber = widget.mobileNumber;
                                print('---------$phoneNumber');

                                hitOtpAPI(phoneNumber, otp, '13234324553354');
                                // log.d(phoneNumber);
                                // verifyOTP(phoneNumber, otp, "Android",
                                //     "112345678765", "4657890876456787");
                              },
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xffC1282D),
                                  Color(0xffF15B29)
                                ],
                              ),
                              child: Text(
                                'Proceed With Sign In',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: FontStrings.Fieldwork10_Regular,
                                    fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Did’t receive the verification OTP code? ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                        fontFamily: FontStrings.Roboto_SemiBold,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF212156),
                                      ),
                                  // TextStyle(
                                  //     fontFamily: FontStrings.Roboto_SemiBold,
                                  //     color: Color(0xFF888B8D)
                                  // ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    hitLoginAPI(widget.mobileNumber.toString());
                                  },
                                  child: Text(
                                    " Resend again",
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          fontFamily: FontStrings.Roboto_SemiBold,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFC1282D),
                                        ),
                                    // TextStyle(
                                    //     fontFamily: FontStrings.Roboto_SemiBold,
                                    //     color: Color(0xFF888B8D)
                                    // ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void hitOtpAPI(String phone, String otp, String token) {
    otpApi.fetchServices(phone.toString(), otp, token).then((result) {
      print("******$result");
      if (result["status"] == true) {
        print('------------token = ${result["token"]}');
        print('------------role = ${result["role"]}');
        _tokenAndRole(result["token"], result["role"], result['service_added']);
        print('-------------------${result["role"]}');
        if (result["role"] == 'Admin') {
          if(result["service_added"] != 'Yes'){
            Get.offAll(VendorWorkTime());
          }else{
            Get.offAll(OrderBottomBarIndex());
          }
        } else {
          Get.offAll(OrderBottomBarIndex());
        }
      } else {
        print("******$result");
        print("------ $result");
        Get.snackbar(null, result["message"],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black54,
            colorText: Colors.white);
      }
    }, onError: (error) {
      print("******${error.hashCode}");
      print('-----------------------\n${error.toString()}');
      Get.snackbar(null, error.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.white);
    });
  }

  void hitLoginAPI(var phone) {
    loginApi.fetchServices(phone.toString()).then((result) {
      if (result["status"] == true) {
        Get.snackbar(null, result["message"],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black54,
            colorText: Colors.white);
        // Navigator.push(context, MaterialPageRoute(
        //   builder: (context) => Otp(phone),
        //   // builder: (context) => HomeScreen(),
        // ),);
      } else {
        Get.snackbar(null, result["message"],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black54,
            colorText: Colors.white);
      }
    }, onError: (error) {
      print('-----------------------\n${error.toString()}');
      Get.snackbar(null, error.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.white);
    });
  }
}
