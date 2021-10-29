import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/view/Settings/ManageService/ManageService.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:get/get.dart';
import 'CompanyInformationScreen.dart';
import 'Employees/EmployeesScreen.dart';
import 'ManageWorkTime/ManageWorkTime.dart';
import 'Report.dart';

// ignore: must_be_immutable
class EditSettingsScreen extends StatefulWidget {

  // final String name;
  // final String emailID;
  // final String phone;
  // final int cpr;

  // PrivateInformationScreen(this.name,this.emailID,this.phone,this.cpr);

  @override
  _EditSettingsScreenState createState() => _EditSettingsScreenState();
}

class _EditSettingsScreenState extends State<EditSettingsScreen> {




  @override
  void initState() {
    print('------------------------------EditSettingsScreen------------------------');
    _selectedLanguage();
    // TODO: implement initState
    super.initState();
  }


  String isServicePresent = "";
  String otpStatus  = "";
  var selectedLanguage;

  final nameCon = new TextEditingController();
  final phoneCon = new TextEditingController();
  final emailCon = new TextEditingController();
  final codeCon = new TextEditingController();

  _multi(context){
    return MediaQuery.of(context).size.height * 0.01;
  }

  Future<void> _selectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    selectedLanguage = prefs.getString('language');
    setState(() {});
    print('-------------$selectedLanguage');
  }

  FocusNode _focusNode1 = FocusNode();

  @override
  Widget build(BuildContext context) {

    // nameCon.text = widget.name;
    // emailCon.text = widget.emailID;
    // phoneCon.text = widget.phone;

    FocusNode _focusNode  = FocusNode();
    FocusNode _focusNode1  = FocusNode();
    FocusNode _focusNode2  = FocusNode();



    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded,
                color: Color(0xff212156),),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),

        // Icon(Icons.arrow_back_ios_rounded,
        //     color: Color(0xff212156),),
        backgroundColor: Colors.white,
        title: Text("Settings".tr,
        style: Theme.of(context).textTheme.headline6.copyWith(
            // fontFamily: FontStrings.Fieldwork10_Regular,
            fontFamily:selectedLanguage == 'en'?FontStrings.Fieldwork10_Regular:FontStrings.Tajawal_Bold,
            color: Color(0xff212156)
        ),),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: KeyboardActions(
                config: KeyboardActionsConfig(
                    actions: [
                      KeyboardActionsItem(focusNode: _focusNode1)
                    ]
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    title(context,'COMPANY'),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return CompanyInformationScreen();
                            }));
                      },
                      child: Container(
                          padding: EdgeInsets.only(left: 24,right: 24),
                          decoration: BoxDecoration(
                            color: UIColor.baseColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 0.3,
                                blurRadius: 1,
                                offset:
                                Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: _item('Company information'.tr)),
                    ),
                    SizedBox(height: 12,),
                    Container(
                        padding: EdgeInsets.only(left: 24,right: 24),
                        decoration: BoxDecoration(
                          color: UIColor.baseColorWhite,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 0.3,
                              blurRadius: 1,
                              offset:
                              Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return ManageWorkTime();
                                      }));
                                }, child: _item('Work schedule'.tr)),
                            GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return ManageService();
                                    }));
                              },
                                child: _item('Manage services'.tr)
                            ),
                            GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return Report();
                                    }));
                              },
                                child: _item('Report'.tr)),
                            GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return EmployeesScreen();
                                    }));
                              },
                                child: _item('Team members'.tr)
                            ),
                            // _item('Saved Cards'.tr),
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget title(context,String title){
    return Container(
      padding: EdgeInsets.only(left: 24,right: 24,top: 8,bottom: 8),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment:selectedLanguage == 'en' ? Alignment.centerLeft:Alignment.centerRight,
              child: Text("GENERAL".tr,
                style: Theme.of(context).textTheme.caption.copyWith(
                  // fontFamily: FontStrings.Roboto_SemiBold,
                  fontFamily:selectedLanguage == 'en'?FontStrings.Roboto_SemiBold:FontStrings.Tajawal_Medium,
                  fontWeight: FontWeight.bold,
                  color:Color(0xFF888B8D),),
                // TextStyle(
                //     fontFamily: FontStrings.Roboto_SemiBold,
                //     color: Color(0xFF888B8D)
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(String itemName){
    return  Container(
      padding: EdgeInsets.only(top: 10,bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding:selectedLanguage == 'en' ? EdgeInsets.only(top:0):EdgeInsets.only(top:5),
              child: Text(itemName,
                style: TextStyle(
                    // fontFamily: FontStrings.Roboto_Regular,
                    fontFamily:selectedLanguage == 'en'?FontStrings.Roboto_Regular:FontStrings.Tajawal_Medium,
                    color: Color(0xFF404243)
                ),
              ),
            ),
          ),
          selectedLanguage == 'en' ? Icon(Icons.chevron_right_outlined,
            color: Color(0xFF404243),
          ):Icon(Icons.chevron_left_outlined,
            color: Color(0xFF404243),
          ),
        ],
      ),
    );
  }


  void serviceTypesDialog(context,String name,String email,String phone,String cpr){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.all(26),
                    child: Container(
                      padding: EdgeInsets.only(left: 0,right: 0,top: 20,bottom: 0),
                        decoration: BoxDecoration(
                          color: Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 8,),
                            Text(
                              'Mobile phone verification',
                              style: TextStyle(
                                fontSize: Dimens.space20*_multi(context),
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              'Enter the code from SMS',
                              style: TextStyle(
                                  fontSize: Dimens.space18*_multi(context),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              margin: EdgeInsets.only(left: 20,right: 20,top: 10),
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.black12, style: BorderStyle.solid, width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: TextField(
                                  controller: codeCon,
                                  maxLines: 1,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Color(0xff0A95A0),
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: "Code"),
                                  style: TextStyle(
                                    color: Color(0xff212156),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black12, style: BorderStyle.solid, width: 0.5),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10)
                                          ),
                                        ),
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Color(0xFF007AFF),
                                              fontSize:
                                                  Dimens.space18 * _multi(context)),
                                        ),
                                        padding: EdgeInsets.only(top:20,bottom: 20),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        // int phone = int.parse(phoneCon.text);
                                        int otpCode = int.parse(codeCon.text);
                                        print('--------rrrrrr');
                                        Navigator.pop(context);
                                        // hitProfileUpdate(name,email,phone,cpr,'$otpCode');
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black12, style: BorderStyle.solid, width: 0.5),
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          "Update",
                                          style: TextStyle(
                                            color: Color(0xFF007AFF),
                                              fontSize: Dimens.space18 * _multi(context),
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        padding: EdgeInsets.only(top:20,bottom: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }


}



