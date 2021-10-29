import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';

// ignore: must_be_immutable
class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  var language;
  var selectedLanguage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedLanguage();
  }


  String isServicePresent = "";
  final nameCon = new TextEditingController();
  final phoneCon = new TextEditingController();
  final emailCon = new TextEditingController();

  _multi(context) {
    return MediaQuery.of(context).size.height * 0.01;
  }


  var engEnable = false;
  var arEnable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: selectedLanguage == 'en'?const Icon(
                Icons.arrow_back_ios_rounded,
                color: Color(0xff212156),
              ):const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xff212156),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        backgroundColor: Colors.white,
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'language'.tr,
            style: Theme.of(context).textTheme.headline6.copyWith(
              fontFamily:selectedLanguage == 'en'?FontStrings.Fieldwork10_Regular:FontStrings.Tajawal_Medium,
              color:Color(0xff212156),),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    engEnable = true;
                    arEnable = false;
                    _language('en');
                    setState(() {});
                    Get.updateLocale(Locale('en'));
                    Get.back();
                  },
                    child: languageSelector("English",engEnable)),
                GestureDetector(
                    onTap: (){
                      engEnable = false;
                      arEnable = true;
                      _language('ar');
                      setState(() {});
                      Get.updateLocale(Locale('ar'));
                      Get.back();
                    },
                    child: languageSelector("Arabic",arEnable)),
              ],
            )
          ],
        ),
      ),
    );
  }
  
  Widget languageSelector(String name, bool enable){
    return Container(
      padding:
      EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: UIColor.baseColorWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0.3,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text(
                name,
                style:   Theme.of(context).textTheme.bodyText2.copyWith(
                    fontFamily: FontStrings.Fieldwork10_Regular,
                    color: Color(0xff212156)
                ),

                // TextStyle(
                //     fontSize: Dimens.space14 * _multi(context),
                //     fontFamily: FontStrings.Roboto_Regular,
                //     color: Color(0xFF4D4F51)),
              ),
            ),
          ),
          Container(
            child:
            enable ? SvgPicture.asset(
              'assets/on.svg',
              allowDrawingOutsideViewBox: true,
            ): SvgPicture.asset(
              'assets/off.svg',
              allowDrawingOutsideViewBox: true,
            ),
            padding: EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }
  Future<void> _language(String language) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', language);
  }
  Future<void> _selectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    selectedLanguage = prefs.getString('language');
    if(selectedLanguage == 'en'){
      engEnable = true;
      arEnable = false;
    }else{
      engEnable = false;
      arEnable = true;
    }
    setState(() {});
  }
}
