import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/view/Auth/sign_up.dart';
import 'package:takhlees_v/view/HomeScreen/OrderBottomBarIndex.dart';
import 'package:takhlees_v/view/VendorWorkTime.dart';
import 'package:get/get.dart';
import 'Translat.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.init(
      "4cf3e2f6-ad09-4bfa-af03-cd32d29220e7",
      iOSSettings: {
        OSiOSSettings.autoPrompt: true,
        OSiOSSettings.inAppLaunchUrl: true
      }
  );
  OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    translations: Translat(),
    locale: Locale('en'),
    fallbackLocale: Locale('en'),
  ));

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white, // Color for Android
      statusBarBrightness: Brightness.light // Dark == white status bar -- for IOS.
  ));
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _language = 'en';

  Future<void> _getId() async {
    final prefs = await SharedPreferences.getInstance();
    var deviceInfo = DeviceInfoPlugin();
    await prefs.setString("Device", Platform.operatingSystem);
    await prefs.setString("playerID", Platform.operatingSystem);

    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      await prefs.setString("DeviceID", iosDeviceInfo.identifierForVendor.toString());

      // return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      await prefs.setString("DeviceID",androidDeviceInfo.androidId);
      // return androidDeviceInfo.androidId; // unique ID on Android
    }
    print('--------------------------------------------------');
    print('deviceID --> ${prefs.getString("DeviceID")}');
    print('deviceID --> ${prefs.getString("Device")}');
    print('token --> ${prefs.getString("token")}');
    print('role --> ${prefs.getString("role")}');
    print('--------------------------------------------------');
  }

  Future<void> _loginCheck() async{
    final prefs = await SharedPreferences.getInstance();
    var status ;
    status = prefs.getString("status");
    print('---------${prefs.getString('signIn')}');

    if(prefs.getString('signIn').toString() == null){
      prefs.setString('signIn', 'false');
    }
    if(prefs.getString('signIn')=='true'){
      if(prefs.getString('service_added') == 'Yes'){
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => OrderBottomBarIndex(),
        ),);
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => VendorWorkTime(),
        ),);
      }
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => SignUp(),
      ),);
    }
    }

  @override
  void initState() {
    // TODO: implement initState
    _getId();
    // Get.updateLocale(Locale(_language));
    language();

    Future.delayed(
      Duration(seconds: 3),(){
      _loginCheck();
    },
    );
    super.initState();
  }

  Future<void> languaged() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language');
    setState(() {
    });
    print('------------------------_language $_language');
    Get.updateLocale(Locale(_language));
  }

  Future<void> language() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language');
    if(_language == null){
      _language = 'en';
      prefs.setString('language', _language);
    }
    setState(() {
    });
    print('------------------------_language $_language');
    Get.updateLocale(Locale(_language));
  }

  @override
  Widget build(BuildContext context) {
    print('---------------- main -------------------');
    return Scaffold(
      body: Center(
          child:Padding(
            padding: EdgeInsets.fromLTRB(50.0, 0, 50, 0.0),
            child: Image(
              image: AssetImage('assets/takhlees_logo_transparent_wordmark.png'),
            ),
          )
      ),
    );
  }
}
