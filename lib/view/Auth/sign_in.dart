import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:logger/logger.dart';
import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/controller/AuthController/LoginController.dart';
import 'package:takhlees_v/view/Auth/otp.dart';
import 'package:takhlees_v/view/Auth/sign_up.dart';
import 'package:takhlees_v/widget/LinedButton.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: new AppBody(),
      ),
    );
  }
}

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  var _mobileNumber;
  final mobileNumberCon = new TextEditingController();
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

  final loginApi = LoginController();

  @override
  void initState() {
    // TODO: implement initState
    _loginCheck('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log.d(
        "------------------------------------SignIN------------------------------");
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
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      //----Logo
                      Container(
                        alignment: Alignment(0.0, 0),
                        padding: EdgeInsets.fromLTRB(0.0, 50, 0.0, 0.0),
                        child: Image.asset(
                          'assets/takhlees_logo_transparent_wordmark.png',
                          height: 50,
                        ),
                      ),

                      //---SVG Image
                      Container(
                        alignment: Alignment(0.0, 0),
                        padding: EdgeInsets.fromLTRB(0.0, 40, 0.0, 0.0),
                        child: SvgPicture.asset(
                          'assets/Illustration.svg',
                          height: 180,
                          width: 227,
                        ),
                      ),

                      Container(
                        alignment: Alignment(0.0, 0),
                        padding: EdgeInsets.fromLTRB(0.0, 40, 0.0, 0.0),
                        child: Text(
                          '''Welcome back''',
                          style: TextStyle(
                              fontSize: 32,
                              fontFamily: FontStrings.Fieldwork16_Bold,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff212156)),
                        ),
                      ),

                      //---Subtitle
                      SizedBox(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20.0, 12, 20.0, 0.0),
                          child: Text(
                            '''Enter your mobile number and we’ll
  send you an OTP code to register.''',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: FontStrings.Roboto_Regular,
                                fontWeight: FontWeight.normal,
                                color: Color(0xff888B8D)),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 24,
                      ),

                      SizedBox(
                        width: 300,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                // margin: EdgeInsets.all(20),
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  // numberWithOptions(
                                  //     signed: true, decimal: true),
                                  controller: mobileNumberCon,
                                  focusNode: _focusNode1,
                                  // initialValue: 'Mobile Number',
                                  decoration: InputDecoration(
                                    hintText: 'Mobile Number',
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
                              Padding(padding: EdgeInsets.only(top: 24)),
                              RaisedGradientButton(
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily:
                                            FontStrings.Fieldwork10_Regular,
                                        fontSize: 16),
                                  ),
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xffC1282D),
                                      Color(0xffF15B29)
                                    ],
                                  ),
                                  onPressed: () {
                                    final String phone = mobileNumberCon.text;
                                    hitLoginAPI(int.parse(phone));
                                  }),
                              Padding(padding: EdgeInsets.only(top: 14)),
                              LinedButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Dont have an account? ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xff212156),
                                            fontFamily:
                                                FontStrings.Fieldwork10_Regular,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        ' Sign Up',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xffC1282D),
                                            fontFamily:
                                                FontStrings.Fieldwork10_Regular,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  color: Color(0xffC1282D),
                                  onPressed: () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return SignUp();
                                    }));
                                  })
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    //   Column (
    //   children: <Widget>[
    //     Expanded(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Container(
    //             child: Column(children: <Widget>[
    //
    //               //----Logo
    //               Container(
    //                 alignment: Alignment(0.0, 0),
    //                 padding: EdgeInsets.fromLTRB(0.0, 20, 0.0, 0.0),
    //                 child: Image.asset(
    //                   'assets/takhlees_logo_transparent_wordmark.png',
    //                   height: 50,
    //                 ),
    //               ),
    //
    //               //---SVG Image
    //               Container(
    //                 alignment: Alignment(0.0, 0),
    //                 padding: EdgeInsets.fromLTRB(0.0, 20, 0.0, 0.0),
    //                 child: SvgPicture.asset(
    //                   'assets/Illustration.svg',
    //                   allowDrawingOutsideViewBox: true,
    //                   fit: BoxFit.contain,
    //                 ),
    //               ),
    //               SizedBox(height: 10,),
    //             ]),
    //           ),
    //         ],
    //       ),
    //     ),
    //     Container(
    //       padding: EdgeInsets.fromLTRB(30.0, 10, 30.0, 10.0),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: <Widget>[
    //
    //           //---Title
    //           Container(
    //             alignment: Alignment(0.0, 0),
    //             child: Text(
    //               '''Welcome back''',
    //               style: Theme.of(context).textTheme.headline4.copyWith(
    //                 fontFamily: FontStrings.Fieldwork16_Bold,
    //                 color:Color(0xff212156),),
    //             ),
    //           ),
    //
    //           //---Subtitle
    //           Container(
    //             padding: EdgeInsets.fromLTRB(20.0, 12, 20.0, 0.0),
    //             child: Text(
    //               '''Enter your mobile number and we’ll send you an OTP code to log in.''',
    //               textAlign: TextAlign.center,
    //               style: Theme.of(context).textTheme.subtitle2.copyWith(
    //                 fontFamily: FontStrings.Roboto_Regular,
    //                 color:Color(0xff888B8D),),
    //
    //               // TextStyle(
    //               //     fontSize: 16,
    //               //     fontFamily: FontStrings.Roboto_Regular,
    //               //     fontWeight: FontWeight.normal,
    //               //     color: Color(0xff888B8D)),
    //             ),
    //           ),
    //           Padding(padding: EdgeInsets.only(top: 24)),
    //           Container(
    //             // margin: EdgeInsets.all(20),
    //             child: TextFormField(
    //               keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
    //               controller: mobileNumberCon,
    //               // initialValue: 'Mobile Number',
    //               decoration: InputDecoration(
    //                 hintText: 'Mobile Number',
    //                 border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(10.0),
    //                 ),
    //               ),
    //               style: TextStyle(
    //                 fontFamily: FontStrings.Roboto_Regular,
    //                 fontSize: 14,
    //               ),
    //             ),
    //           ),
    //
    //           Padding(padding: EdgeInsets.only(top: 24)),
    //
    //           RaisedGradientButton(
    //               child: Text(
    //                 'Sign In',
    //                 style: TextStyle(color: Colors.white,fontFamily: FontStrings.Fieldwork10_Regular, fontSize: 16),
    //               ),
    //               gradient: LinearGradient(
    //                 colors: <Color>[Color(0xffC1282D), Color(0xffF15B29)],
    //               ),
    //               onPressed: (){
    //                 final String phone = mobileNumberCon.text;
    //                 hitLoginAPI(int.parse(phone));
    //                 // getOTP(phone, Platform.operatingSystem, "", "4657890876456787");
    //                 // Navigator.push(context, MaterialPageRoute(
    //                 //   builder: (context) => Otp('mobileNumber'),
    //                 //   // builder: (context) => HomeScreen(),
    //                 // ),);
    //                 log.d("$phone");
    //               }
    //           ),
    //
    //           Padding(padding: EdgeInsets.only(top: 14)),
    //
    //           LinedButton(
    //               child: Row(
    //                 mainAxisAlignment:
    //                 MainAxisAlignment.center,
    //                 children: [
    //                   Text(
    //                     'Dont have an account? ',
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                         color: Color(0xff212156),
    //                         fontFamily: FontStrings.Fieldwork10_Regular,
    //                         fontSize: 16),
    //                   ),
    //                   Text(
    //                     ' Sign Up',
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                         color: Color(0xffC1282D),
    //                         fontFamily: FontStrings.Fieldwork10_Regular,
    //                         fontSize: 16),
    //                   ),
    //                 ],
    //               ),
    //               color: Color(0xffC1282D),
    //               onPressed: (){
    //                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
    //                   return SignUp();
    //                 }));
    //               }
    //           )
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }

  void hitLoginAPI(int phone) {
    loginApi.fetchServices(phone.toString()).then((result) {
      if (result["status"] == true) {
        Get.snackbar(null, result["message"],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black54,
            colorText: Colors.white);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Otp(phone),
            // builder: (context) => HomeScreen(),
          ),
        );
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

  Future<void> _loginCheck(String status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('status', status);
  }
}
