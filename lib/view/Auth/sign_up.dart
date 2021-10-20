import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/view/Auth/sign_in.dart';
import 'package:takhlees_v/widget/LinedButton.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widget/RaisedGradientButton.dart';

class SignUp extends StatelessWidget {
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
  String deviceID = "";
  String device = '';
  final prefs =  SharedPreferences.getInstance();


  Future<String> _getDeviceFromSharedPref() async{
    final prefs = await SharedPreferences.getInstance();
    final DeviceID = prefs.getString("DeviceID");
    if(DeviceID == null){
      return " ";
    }
    deviceID = DeviceID;
    log.d(deviceID);
    return DeviceID;
  }


  final log = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 3,
        lineLength: 50,
        colors: true,
        printEmojis: true,
        printTime: false,
      )
  );

  @override
  Widget build(BuildContext context) {
    log.d("SignUp");
    _getDeviceFromSharedPref();
    return Column (
      children: <Widget>[
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment(0.0, 0),
                  padding: EdgeInsets.fromLTRB(0.0, 20, 0.0, 0.0),
                  child: Image.asset(
                    'assets/takhlees_logo_transparent_wordmark.png',
                    height: 50,
                  ),
                ),


                //---SVG Image
                Container(
                  alignment: Alignment(0.0, 0),
                  padding: EdgeInsets.fromLTRB(0.0, 20, 0.0, 0.0),
                  child: SvgPicture.asset(
                    'assets/Illustration.svg',
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.contain,
                    // height: 180,
                    // width: 227,
                  ),
                ),

                //---Title
                // Container(
                //   padding: EdgeInsets.fromLTRB(0.0, 54, 0.0, 0.0),
                //   child: Text(
                //     '''Create your account''',
                //     style: TextStyle(
                //         fontSize: 32,
                //         fontFamily: FontStrings.Fieldwork16_Bold,
                //         fontWeight: FontWeight.bold,
                //         color: Color(0xff212156)),
                //   ),
                // ),
                //
                // //---SubTitle
                // Container(
                //   padding: EdgeInsets.fromLTRB(20.0, 12, 20.0, 0.0),
                //   child: Text(
                //     '''For creating your Driver account you have to fill in Google form and once admin approves your account, you can log in.''',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //         fontSize: 16,
                //         fontFamily: FontStrings.Roboto_Regular,
                //         fontWeight: FontWeight.normal,
                //         color: Color(0xff888B8D)),
                //   ),
                // ),
                // Container(
                //   child: Column(children: <Widget>[
                //
                //     //Logo
                //
                //   ]),
                // ),
              ],),
          ),
        ),
        SizedBox(height: 20,),
        Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Container(
                child: Text(
                  '''Create your account''',
                  style:
                  Theme.of(context).textTheme.headline4.copyWith(
                    fontFamily: FontStrings.Fieldwork16_Bold,
                    color:Color(0xff212156),),
                  // TextStyle(
                  //     fontSize: 32,
                  //     fontFamily: FontStrings.Fieldwork16_Bold,
                  //     fontWeight: FontWeight.bold,
                  //     color: Color(0xff212156)),
                ),
              ),

              //---SubTitle
              SizedBox(
                width: 400,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20.0, 12, 20.0, 0.0),
                  child: Text(
                    '''For creating your Driver account you have to fill in Google form and once admin approves your account, you can log in.''',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                      fontFamily: FontStrings.Roboto_Regular,
                      color:Color(0xff888B8D),),

                    // TextStyle(
                    //     fontSize: 16,
                    //     fontFamily: FontStrings.Roboto_Regular,
                    //     fontWeight: FontWeight.normal,
                    //     color: Color(0xff888B8D)),
                  ),
                ),
              ),
              // Container(
              //   // margin: EdgeInsets.all(20),
              //   child: TextFormField(
              //     keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              //     controller: mobileNumberCon,
              //     // initialValue: 'Mobile Number',
              //     decoration: InputDecoration(
              //       hintText: 'Mobile Number',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //     ),
              //     style: TextStyle(
              //       fontFamily: FontStrings.Roboto_Regular,
              //       fontSize: 14,
              //     ),
              //   ),
              // ),

              Padding(padding: EdgeInsets.only(top: 24)),

              SizedBox(
                width: 300,
                child: RaisedGradientButton(
                    child: Text(
                      'Sign Up with Takhlees form',
                      style: TextStyle(color: Colors.white,fontFamily: FontStrings.Fieldwork10_Regular, fontSize: 16),
                    ),
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xffC1282D), Color(0xffF15B29)],
                    ),
                    onPressed: () async {
                      String _url = 'https://dev.takhlees.app/register/vendor-register.html';
                      await launch("$_url");
                      // getOTP(phone, device, deviceID.toString(), "4657890876456787");
                    }
                ),
              ),

              Padding(padding: EdgeInsets.only(top: 14)),

              SizedBox(
                width: 300,
                child: LinedButton(
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xff212156),
                              fontFamily: FontStrings.Fieldwork10_Regular,
                              fontSize: 16),
                        ),
                        Text(
                          ' Sign In',
                          textAlign: TextAlign.center,
                          style:
                          Theme.of(context).textTheme.subtitle2.copyWith(
                              fontFamily: FontStrings.Fieldwork10_Regular,
                              color:Color(0xffC1282D),),
                          // TextStyle(
                          //     color: Color(0xffC1282D),
                          //     fontFamily: FontStrings.Fieldwork10_Regular,
                          //     fontSize: 16),
                        ),

                      ],
                    ),
                    color: Color(0xffC1282D),
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                        return SignIn();
                      }));
                    }
                ),
              ),
              SizedBox(height: 40,)
            ],
          ),
        ),
      ],
    );
  }
}
