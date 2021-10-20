import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/controller/Profile/VendorProfileOTPController.dart';
import 'package:takhlees_v/controller/Profile/VendorProfileUpdateController.dart';
import 'package:takhlees_v/view/HomeScreen/SettingsScreen.dart';
import 'package:takhlees_v/view/HomeScreen/SettingsBottomBarIndex.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:takhlees_v/widget/snackBar.dart';

// ignore: must_be_immutable
class PrivateInformationScreen extends StatefulWidget {

  final String name;
  final String emailID;
  final String phone;
  // final int cpr;

  PrivateInformationScreen(this.name,this.emailID,this.phone);

  @override
  _PrivateInformationScreenState createState() => _PrivateInformationScreenState();
}

class _PrivateInformationScreenState extends State<PrivateInformationScreen> {

  @override
  void initState() {
    print('------------------------------PrivateInformationScreen------------------------');
    // TODO: implement initState
    super.initState();

    phoneCon.text = widget.phone;
    emailCon.text = widget.emailID;

  }


  String isServicePresent = "";
  String otpStatus  = "";

  final nameCon = new TextEditingController();
  final phoneCon = new TextEditingController();
  final emailCon = new TextEditingController();
  final codeCon = new TextEditingController();
  final otpController = VendorProfileOTPController();
  final profileUpdateController = VendorProfileUpdateController();

  _multi(context){
    return MediaQuery.of(context).size.height * 0.01;
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

    // phoneCon.text = widget.phone;
    // emailCon.text = widget.emailID;


    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        brightness: Brightness.light,
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
        title: Text("Private information",
        style: Theme.of(context).textTheme.headline6.copyWith(
            fontFamily: FontStrings.Fieldwork10_Regular,
            color: Color(0xff212156)
        ),),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 24,right: 24,top: 40),
                child: KeyboardActions(
                  config: KeyboardActionsConfig(
                      actions: [
                        KeyboardActionsItem(focusNode: _focusNode1)
                      ]
                  ),
                  child: Column(
                    children: [
                      // _textField("Full Name",nameCon,"Enter Name",TextInputType.name),
                      // SizedBox(height: 12,),
                      _textField("Email",emailCon,"Email",TextInputType.emailAddress),
                      SizedBox(height: 12,),
                      _textField("Mobile Phone",phoneCon,"Mobile Phone",TextInputType.numberWithOptions(signed: true, decimal: true)),
                    ],
                  ),
                ),
              ),
            ),
            _footer(),
          ],
        ),
      ),
    );
  }
  Widget _footer(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: RaisedGradientButton(
              child: Text(
                'Save',
                style: TextStyle(
                    color: Colors
                        .white,
                    fontFamily: FontStrings
                        .Fieldwork10_Regular,
                    fontSize:
                    16),
              ),
              gradient:
              LinearGradient(
                colors: <Color>[
                  Color(
                      0xffC1282D),
                  Color(
                      0xffF15B29)
                ],
              ),
              onPressed: () {
                int phone = int.parse(phoneCon.text);
                if('$phone'.length == 8)
                  {
                    hitOTP('$phone');
                    serviceTypesDialog(context,widget.name,emailCon.text,phoneCon.text);
                  }else{
                  getSnackBar(null, 'Enter a valid phone number');
                }

              }),
        ),
      ],
    );
  }

  Widget _textField(String _label,_controller,String _hint,TextInputType type,){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
            color: UIColor.darkBlue, style: BorderStyle.solid, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 16),
            child: Text(
              _label,
              style: TextStyle(
                  fontSize: Dimens.space14 * _multi(context),
                  fontWeight: FontWeight.normal,
                  fontFamily: FontStrings.Roboto_Regular,
                  color: Color(0xFF404243)),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 0, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: TextField(
                      keyboardType: type,
                      controller: _controller,
                      cursorColor: Color(0xff0A95A0),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: _hint),
                      style: TextStyle(
                        color: Color(0xff212156),
                        fontFamily: FontStrings.Roboto_Regular,
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
  Widget _textField1(String _label,_controller,String _hint,TextInputType type,FocusNode fNode){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
            color: UIColor.darkBlue, style: BorderStyle.solid, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 16),
            child: Text(
              _label,
              style: TextStyle(
                  fontSize: Dimens.space14 * _multi(context),
                  fontWeight: FontWeight.normal,
                  fontFamily: FontStrings.Roboto_Regular,
                  color: Color(0xFF404243)),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 0, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: TextField(
                      focusNode: fNode,
                      keyboardType: type,
                      controller: _controller,
                      cursorColor: Color(0xff0A95A0),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: _hint),
                      style: TextStyle(
                        color: Color(0xff212156),
                        fontFamily: FontStrings.Roboto_Regular,
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
  Widget _textField2(String _label,_controller,String _hint,TextInputType type,FocusNode fNode){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
            color: UIColor.darkBlue, style: BorderStyle.solid, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 16),
            child: Text(
              _label,
              style: TextStyle(
                  fontSize: Dimens.space14 * _multi(context),
                  fontWeight: FontWeight.normal,
                  fontFamily: FontStrings.Roboto_Regular,
                  color: Color(0xFF404243)),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 0, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: TextField(
                      focusNode: fNode,
                      keyboardType: type,
                      controller: _controller,
                      cursorColor: Color(0xff0A95A0),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: _hint),
                      style: TextStyle(
                        color: Color(0xff212156),
                        fontFamily: FontStrings.Roboto_Regular,
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  void hitOTP(String _mobileNumber){
    otpController.fetchServices(_mobileNumber).then((result){
      if(result["status"] == true){
        otpStatus = "";
        Get.snackbar(null,
            result["message"],
            snackPosition:SnackPosition.BOTTOM,
            backgroundColor: Colors.black54,
            colorText: Colors.white);
      }else{
        otpStatus = result["message"];
        Get.snackbar(null,
            otpStatus,
            snackPosition:SnackPosition.BOTTOM,
            backgroundColor: Colors.black54,
            colorText: Colors.white);
      }
    }, onError: (error){
      otpStatus = error.toString();
      Get.snackbar(null,
          otpStatus,
          snackPosition:SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.white);
    });
  }

  void hitProfileUpdate(String name, String email, String phone, String otpCode){
    print('\nname: $name,\nemail: $email,\nphone: $phone,\notpCode: $otpCode');
    profileUpdateController.fetchServices(name, email, phone, otpCode).then(
        (result) {
      if (result["status"] == true) {
        isServicePresent = "";
        print('======${result["status"]}');
        print('======${result["message"]}');
        setState(() {});
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return SettingsScreen();
        // }));
        Get.offAll(SettingsBottomBarIndex());
      } else {
        isServicePresent = result["message"];
        setState(() {});
        print('--------${result["message"]}');
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      print('--------${isServicePresent}');
      setState(() {});
    }
    );
  }

  void serviceTypesDialog(context,String name,String email,String phone){
    FocusNode _focusNode1  = FocusNode();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return  KeyboardActions(
          config: KeyboardActionsConfig(
              actions: [
                KeyboardActionsItem(focusNode: _focusNode1),
              ]
          ),
          child: Container(
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
                                    focusNode: _focusNode1,
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
                                          // print('--------rrrrrr');
                                          // Navigator.pop(context);
                                          hitProfileUpdate(name,email,phone,codeCon.text);
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
                                              // fontWeight: FontWeight.bold
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
          ),
        );
      },
    );
  }


}



