import 'dart:io';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/Constants/ApiStrings.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/controller/Profile/CompanyDetailController.dart';
import 'package:takhlees_v/controller/Profile/CompanyDetailUpdateController.dart';
import 'package:takhlees_v/model/CompanyDetailModel.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: must_be_immutable
class CompanyInformationScreen extends StatefulWidget {

  // final String name;
  // final String emailID;
  // final String phone;
  // final int cpr;

  // PrivateInformationScreen(this.name,this.emailID,this.phone,this.cpr);

  @override
  _CompanyInformationScreenState createState() => _CompanyInformationScreenState();
}

class _CompanyInformationScreenState extends State<CompanyInformationScreen> {

  final companyInfo = CompanyDetailController();
  final companyInfoUpdate = CompanyDetailUpdateController();
  var companyModel = VendorResult();
  var logo = '';
  var companyName = '';
  var crNumber = '';
  var flatOrShopNumber = '';
  var blockNumber = '';
  var roadNumber = '';
  var buildingNumber = '';
  Dio.Dio dio = new Dio.Dio();
  File imageFile;
  String auth;

  @override
  void initState() {
    print('------------------------------CompanyInformationScreen------------------------');
    hitProfile();
    // TODO: implement initState

    // print('flatOrShopNumber $flatOrShopNumber');
    // print('buildingNumber $buildingNumber');
    // print('blockNumber $blockNumber');
    // print('roadNumber $roadNumber');

    // flatCon.text = flatOrShopNumber;
    // buildingCon.text = buildingNumber;
    // blockCon.text = blockNumber;
    // roadCon.text = roadNumber;

    super.initState();
  }




  String isServicePresent = "";
  String otpStatus  = "";

  final nameCon = new TextEditingController();
  final buildingCon = new TextEditingController();
  final flatCon = new TextEditingController();
  final blockCon = new TextEditingController();
  final roadCon = new TextEditingController();
  final codeCon = new TextEditingController();

  _multi(BuildContext context){
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
        title: Text("Company information",
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
                      // _profilePic('https://cdn.logo.com/hotlink-ok/logo-social.png',context),
                      // _profilePic('$logo',context),
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(Container(
                            child: Container(
                              // color: Colors.white,
                              // height: 100,
                              child: Wrap(
                                children: [
                                  // SizedBox(height: 20,),
                                  // ListTile(
                                  //   leading: Icon(Icons.camera_alt),
                                  //   title: Text('Camera'),
                                  // ),
                                  // SizedBox(height: 20,),
                                  // ListTile(
                                  //   leading: Icon(Icons.camera_alt),
                                  //   title: Text('Camera'),
                                  // ),
                                  GestureDetector(
                                    onTap:(){
                                      _openCamera(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(left:8.0,right: 8,bottom: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius
                                                  .circular(10),
                                              topRight: Radius
                                                  .circular(10),
                                              bottomLeft: Radius
                                                  .circular(10),
                                              bottomRight:
                                              Radius
                                                  .circular(
                                                  10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withOpacity(
                                                  0.2),
                                              spreadRadius: 0.3,
                                              blurRadius: 1,
                                              offset: Offset(0,
                                                  1), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.all(15),
                                        child: Row(
                                          children: [
                                            Icon(Icons.camera_alt,color:Colors.black54),
                                            Expanded(child: Container(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('Camera',style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  fontFamily: FontStrings.Fieldwork10_Regular,
                                                  color:Colors.black54
                                              ),),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      openGallary(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(left:8.0,right: 8,),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius
                                                  .circular(10),
                                              topRight: Radius
                                                  .circular(10),
                                              bottomLeft: Radius
                                                  .circular(10),
                                              bottomRight:
                                              Radius
                                                  .circular(
                                                  10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withOpacity(
                                                  0.2),
                                              spreadRadius: 0.3,
                                              blurRadius: 1,
                                              offset: Offset(0,
                                                  1), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.all(15),
                                        child: Row(
                                          children: [
                                            Icon(Icons.collections,color:Colors.black54),
                                            Expanded(child: Container(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('Gallery',style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  fontFamily: FontStrings.Fieldwork10_Regular,
                                                  color:Colors.black54
                                              ),),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: ()=>Get.back(),
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius
                                                  .circular(10),
                                              topRight: Radius
                                                  .circular(10),
                                              bottomLeft: Radius
                                                  .circular(10),
                                              bottomRight:
                                              Radius
                                                  .circular(
                                                  10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withOpacity(
                                                  0.2),
                                              spreadRadius: 0.3,
                                              blurRadius: 1,
                                              offset: Offset(0,
                                                  1), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.all(15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              // padding: const EdgeInsets.all(0),
                                              child: Center(
                                                child: Text('Cancel',textAlign: TextAlign.center ,style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                    fontFamily: FontStrings.Fieldwork10_Regular,
                                                    color: Colors.red
                                                ),),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 25,
                                  ),
                                ],
                              ),
                            ),
                          ));
                        },
                        child: Container(child:_isImageNull(('$logo'),context)
                        ),
                      ),
                      // _textField("Full Name",nameCon,"Enter Name",TextInputType.name),
                      SizedBox(height: 24,),
                      Text('$companyName',style: Theme.of(context).textTheme.headline5.copyWith(
                        fontFamily: FontStrings.Fieldwork10_Regular,
                        color: UIColor.darkBlue
                      ),),
                      SizedBox(height: 8,),
                      Text('CR: $crNumber',style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontFamily: FontStrings.Roboto_Regular,
                          color: UIColor.darkBlue
                      ),),
                      SizedBox(height: 32,),
                      _textField("Flat/Shop Number",flatCon,"Flat/Shop Number",TextInputType.streetAddress,context),
                      SizedBox(height: 16,),
                      _textField("Building Number",buildingCon,"Building Number",TextInputType.streetAddress,context),
                      SizedBox(height: 16,),
                      _textField("Block Number",blockCon,"Block Number",TextInputType.streetAddress,context),
                      SizedBox(height: 16,),
                      _textField("Road Number",roadCon,"Road Number",TextInputType.streetAddress,context),
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
  Widget _profilePic(String URL,context){
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        URL != null?CircleAvatar(
          radius: 60,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: new SizedBox(
              child: Image.network(URL,
                fit: BoxFit.cover,
                height: Dimens.space140 * _multi(context),
                width: Dimens.space140 * _multi(context),
              ),
            ),
          ),
        ):CircleAvatar(
          radius: 60,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: new SizedBox(
              child: Image.asset("assets/emptyPhoto.svg"),
            ),
          ),
        ),
        SvgPicture.asset(
          'assets/add photo.svg',
          allowDrawingOutsideViewBox: true,
        ),
      ],
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
                int phone = int.parse(buildingCon.text);
                // hitOTP('${phone}');
                hitProfileUpdate(flatCon.text,blockCon.text,roadCon.text,buildingCon.text);
                // serviceTypesDialog(context,nameCon.text,flatCon.text,buildingCon.text,'123');
              }),
        ),
      ],
    );
  }
  Widget _textField(String _label,_controller,String _hint,TextInputType type, BuildContext context){
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

  // void hitOTP(String _mobileNumber){
  //   otpController1.fetchServices(_mobileNumber).then((result){
  //     if(result["status"] == true){
  //       otpStatus = "";
  //       Fluttertoast.showToast(
  //           msg: result["message"],
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIos: 1,
  //           backgroundColor: Colors.black45,
  //           textColor: Colors.white);
  //     }else{
  //       otpStatus = result["message"];
  //       Fluttertoast.showToast(
  //           msg: result["message"],
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIos: 1,
  //           backgroundColor: Colors.black45,
  //           textColor: Colors.white);
  //     }
  //   }, onError: (error){
  //     otpStatus = error.toString();
  //     Fluttertoast.showToast(
  //         msg: error.toString(),
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIos: 1,
  //         backgroundColor: Colors.black45,
  //         textColor: Colors.white);
  //   });
  // }

  void hitProfile(){
    companyInfo.fetchServices().then(
        (result) {
      if (result["status"] == true) {
        isServicePresent = "";
        print('======${result["status"]}');
        print('======${result["message"]}');
        companyModel = CompanyDetailModel.fromJson(result).result;
        print('${companyModel.toJson()}');
        logo = companyModel.logo;
        companyName = companyModel.companyNameEn;
        crNumber = companyModel.crNumber;
        flatOrShopNumber = companyModel.flatOrShopNumber.toString();
        blockNumber = companyModel.blockNumber.toString();
        buildingNumber = companyModel.buildingNumber.toString();
        roadNumber = companyModel.roadNumber.toString();

        print('flatOrShopNumber $flatOrShopNumber');
        print('buildingNumber $buildingNumber');
        print('blockNumber $blockNumber');
        print('roadNumber $roadNumber');

        flatCon.text = flatOrShopNumber;
        buildingCon.text = buildingNumber;
        blockCon.text = blockNumber;
        roadCon.text = roadNumber;

        setState(() {});
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return SettingsScreen();
        // }));
        // Navigator.pop(context,true);
      } else {
        isServicePresent = result["message"];
        setState(() {});
        print('--------${result["message"]}');
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      print('--------${isServicePresent}');
      setState(() {});
    });
  }
  void hitProfileUpdate(var flatOrShopNumber, var blockNumber, var roadNumber,
      var buildingNumber){
    print('flatOrShopNumber: $flatOrShopNumber \nblockNumber: $blockNumber\nroadNumber: $roadNumber \nbuildingNumber: $buildingNumber');
    companyInfoUpdate.fetchServices(
        flatOrShopNumber,
        blockNumber,
        roadNumber,
        buildingNumber
    ).then(
        (result) {
      if (result["status"] == true) {
        print('--------------${result["message"]}');
        isServicePresent = "";
          Get.snackbar(null,
              result["message"],
              snackPosition:SnackPosition.BOTTOM,
              backgroundColor: Colors.black54,
              colorText: Colors.white);
        // print('======${result["status"]}');
        // print('======${result["message"]}');
        // companyModel = CompanyDetailModel.fromJson(result).result;
        // print('${companyModel.toJson()}');
        // logo = companyModel.logo;
        // companyName = companyModel.companyNameEn;
        // crNumber = companyModel.crNumber;
        // flatOrShopNumber = companyModel.flatOrShopNumber.toString();
        // blockNumber = companyModel.blockNumber.toString();
        // roadNumber = companyModel.roadNumber.toString();
        setState(() {});
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return SettingsScreen();
        // }));
        // Navigator.pop(context,true);
      } else {
        isServicePresent = result["message"];
        setState(() {});
          Get.snackbar(null,
              isServicePresent,
              snackPosition:SnackPosition.BOTTOM,
              backgroundColor: Colors.black54,
              colorText: Colors.white);
        print('--------${result["message"]}');
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      setState(() {});
      print('--------$isServicePresent');
        Get.snackbar(null,
            isServicePresent,
            snackPosition:SnackPosition.BOTTOM,
            backgroundColor: Colors.black54,
            colorText: Colors.white);
    });
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

  openGallary(BuildContext context) async {
    final pic = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 600);

    this.setState(() {
      imageFile = pic;
      print(imageFile);
      Navigator.of(context).pop();
    });

    final prefs = await SharedPreferences.getInstance();
    final DeviceID = prefs.getString("DeviceID");
    auth = prefs.getString("token");

    try {
      String fileName = basename(pic.path);
      // String fileName = pic.path.split("/").last;
      Dio.FormData formData = new Dio.FormData.fromMap({
        "file":
        await Dio.MultipartFile.fromFile(imageFile.path, filename: fileName),
      });
      // log.d("Path" + imageFile.path + "\nname:" + fileName);
      Dio.Response response =
      await dio.post(ApiStrings.BaseURL + ApiStrings.vendorLogoUpdate,
          data: formData,
          options: Dio.Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer " + auth,
          }));
      // log.d("res:   " + response.toString());
      Get.snackbar(null,
          response.data['message'],
          snackPosition:SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.white);
    }
    catch (e) {
      print('----------\n$e\n-------------------');
    }
  }
  _openCamera(BuildContext context) async {
    final pic = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 600);
    this.setState(() {
      imageFile = pic;
      print(imageFile);
    });
    Navigator.of(context).pop();

    final prefs = await SharedPreferences.getInstance();
    final DeviceID = prefs.getString("DeviceID");
    final Device = prefs.getString("Device");
    auth = prefs.getString("token");

    print('------------URL ${ApiStrings.BaseURL + ApiStrings.vendorProfileImageUpload}');
    print('------------auth :  Bearer $auth');
    try {
      String fileName = basename(pic.path);
      // String fileName = pic.path.split("/").last;
      Dio.FormData formData = new Dio.FormData.fromMap({
        "file":
        await Dio.MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      // log.d("Path" + imageFile.path + "\nname:" + fileName);
      Dio.Response response =
      await dio.post(ApiStrings.BaseURL + ApiStrings.vendorProfileImageUpload,
          data: formData,
          options: Dio.Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer " + auth,
          }));

      print('------------response $response');

      // log.d("res:   " + response.toString());
    } catch (e) {
      print('----------\n$e\n-------------------');
      // log.e(e);
    }
  }
  Widget _isImageNull(String URL,BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        imageFile == null
            ?
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: new SizedBox(
              child: Stack(
                children: <Widget>[
                  Center(child: CircularProgressIndicator(
                    // backgroundColor: UIColor.baseGradientLight,
                    valueColor:AlwaysStoppedAnimation<Color>(UIColor.baseGradientLight),
                  )),
                  Center(
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: URL,
                      fit: BoxFit.cover,
                      height: Dimens.space140 * _multi(context),
                      width: Dimens.space140 * _multi(context),
                    ),
                  ),
                ],
              ),
              // FadeInImage.assetNetwork(
              //   placeholder: 'assets/loading.gif',
              //   image: URL,
              //   fit: BoxFit.fill,
              //   height: Dimens.space140 * _multi(context),
              //   width: Dimens.space140 * _multi(context),
              // )
              // Image.network(
              //   URL,
              //   fit: BoxFit.cover,
              //   height: Dimens.space140 * _multi(context),
              //   width: Dimens.space140 * _multi(context),
              // ),
            ),
          ),
        )
            : CircleAvatar(
          radius: 60,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: new SizedBox(
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
                height: Dimens.space140 * _multi(context),
                width: Dimens.space140 * _multi(context),
              ),
            ),
          ),
        ),
        SvgPicture.asset(
          'assets/add photo.svg',
          allowDrawingOutsideViewBox: true,
        ),
      ],
    );
  }

}



