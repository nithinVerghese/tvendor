import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/Constants/ApiStrings.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/stringConst.dart';
import 'package:path/path.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:takhlees_v/widget/dialogBox/optionalDialog.dart';
import 'package:takhlees_v/widget/snackBar.dart';

bool checkBoxValue = true;

class AddEmployeeProfile extends StatefulWidget {
  @override
  _AddEmployeeProfileState createState() => _AddEmployeeProfileState();
}

class _AddEmployeeProfileState extends State<AddEmployeeProfile> {

  @override
  void initState() {
    print('------------------------------AddEmployeeProfile------------------------');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        brightness: Brightness.light,
        elevation: 0,
        leading: IconButton(
        icon: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xff212156),), onPressed: () { Navigator.pop(context); },
        )
        ),
        title: Text(
          'Add employee',
          style: Theme.of(context).textTheme.headline6.copyWith(
              fontFamily: FontStrings.Fieldwork10_Regular,
              fontWeight: FontWeight.normal,
              color: Color(0xff212156)
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
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
  final log = Logger(
      printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 3,
    lineLength: 50,
    colors: true,
    printEmojis: true,
    printTime: false,
  ));


  Dio.Dio dio = new Dio.Dio();

  File imageFile;
  File cprFront;
  File cprBack;
  File cprReader;
  File profilePic;
  String auth;

  final nameCon = new TextEditingController();
  final cprCon = new TextEditingController();
  final cprExpCon = new TextEditingController();
  final emailCon = new TextEditingController();
  final phoneCon = new TextEditingController();

  _openGallary(BuildContext context) async {
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
      log.d("Path" + imageFile.path + "\nname:" + fileName);
      // Response response =
      //     await dio.post(StringConst.BaseURL + ApiStrings.imageUpload,
      //         data: formData,
      //         options: Options(headers: {
      //           "Accept": "application/json",
      //           "Authorization": "Bearer " + auth,
      //         }));

      // log.d("res:   " + response.toString());
    } catch (e) {
      log.e(e);
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

    try {
      String fileName = basename(pic.path);
      // String fileName = pic.path.split("/").last;
      Dio.FormData formData = new Dio.FormData.fromMap({
        "file":
            await Dio.MultipartFile.fromFile(imageFile.path, filename: fileName),
      });
      log.d("Path" + imageFile.path + "\nname:" + fileName);
      Dio.Response response =
          await dio.post(ApiStrings.BaseURL + ApiStrings.imageUpload,
              data: formData,
              options: Options(headers: {
                "Accept": "application/json",
                "Authorization": "Bearer " + auth,
              }));

      log.d("res:   " + response.toString());
    } catch (e) {
      log.e(e);
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a choice"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text('Gallery'),
                    onTap: () {
                      _openGallary(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8)),
                  GestureDetector(
                    child: Text('Camera'),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _isImageNull() {
    if (imageFile == null) {
      return CircleAvatar(
        radius: 100,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: new SizedBox(
            child: Image.asset(
              'assets/add photo btn.png',
              width: 300,
              height: 300,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(10),
        child: CircleAvatar(
          radius: 100,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: new SizedBox(
              child: Image.file(
                imageFile,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {


    String name;
    String cpr;
    String email;

    FocusNode _focusNode1 = FocusNode();

    final FocusNode _nodeText1 = FocusNode();
    final FocusNode _nodeText11 = FocusNode();
    final FocusNode _nodeText12 = FocusNode();
    final FocusNode _nodeText13 = FocusNode();
    final FocusNode _nodeText14 = FocusNode();

    /// Creates the [KeyboardActionsConfig] to hook up the fields
    /// and their focus nodes to our [FormKeyboardActions].
    KeyboardActionsConfig _buildConfig(BuildContext context) {
      return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: true,
        actions: [
          KeyboardActionsItem(
            focusNode: _nodeText1,
          ),
          KeyboardActionsItem(
            focusNode: _nodeText11,
          ),
          KeyboardActionsItem(
            focusNode: _nodeText12,
          ),
          KeyboardActionsItem(
            focusNode: _nodeText13,
          ),
          KeyboardActionsItem(
            focusNode: _nodeText14,
          ),
        ],
      );
    }

    return KeyboardActions(
      config: _buildConfig(context),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            GestureDetector(
              onTap: () {
                // _showChoiceDialog(context);

                Get.bottomSheet(Container(
                  child: Container(
                    child: Wrap(
                      children: [
                        GestureDetector(
                          onTap:(){
                            // _openCamera1(context);
                            _loadPicker(ImageSource.camera,'profilePic');

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
                            // openGallery(context);
                            _loadPicker(ImageSource.gallery,'profilePic');
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
              child:profilePic.isNull?Container(
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: new SizedBox(
                      child: Image.asset(
                        'assets/add photo btn.png',
                        width: 300,
                        height: 300,
                      ),
                    ),
                  ),
                ),
              ):Container(
                  child: Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: FileImage(profilePic),
                    ),
                  ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Column(
              children: [
                //name text field
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xff0A95A0),
                        style: BorderStyle.solid,
                        width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 16),
                        child: Text(
                          'Name',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff404243)),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 0, left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: TextField(
                                  focusNode: _nodeText1,
                                  keyboardType: TextInputType.name,
                                  controller: nameCon,
                                  cursorColor: Color(0xff0A95A0),
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: 'Enter your name'),
                                  style: TextStyle(
                                    color: Color(0xff212156),
                                    fontFamily: FontStrings.Roboto_Regular,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0, left: 16, right: 0),
                                child: SvgPicture.asset(
                                  "assets/user.svg",
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),

                //cpr text field
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xff0A95A0),
                        style: BorderStyle.solid,
                        width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 16),
                        child: Text(
                          'CPR',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff404243)),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 0, left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: TextField(
                                  focusNode: _nodeText11,
                                  keyboardType: TextInputType.phone,
                                  controller: cprCon,
                                  cursorColor: Color(0xff0A95A0),
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: 'Enter your CPR ID'),
                                  style: TextStyle(
                                      color: Color(0xff212156),
                                      fontFamily: FontStrings.Roboto_Regular
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(top: 0, left: 16, right: 0),
                              //   child: SvgPicture.asset(
                              //     "assets/card.svg",
                              //     width: 25,
                              //     height: 25,
                              //   ),
                              // ),
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),

                //cpr Expired text field
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xff0A95A0),
                        style: BorderStyle.solid,
                        width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 16),
                        child: Text(
                          'Expired CPR date',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff404243)),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 0, left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: TextField(
                                  focusNode: _nodeText12,
                                  keyboardType: TextInputType.datetime,
                                  controller: cprExpCon,
                                  cursorColor: Color(0xff0A95A0),
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: 'DD/MM/YYYY'),
                                  style: TextStyle(
                                      color: Color(0xff212156),
                                      fontFamily: FontStrings.Roboto_Regular
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(top: 0, left: 16, right: 0),
                              //   child: SvgPicture.asset(
                              //     "assets/card.svg",
                              //     width: 25,
                              //     height: 25,
                              //   ),
                              // ),
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),

                //email text field
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xff0A95A0),
                        style: BorderStyle.solid,
                        width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 16),
                        child: Text(
                          'Email',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff404243)),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 0, left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: TextField(
                                  focusNode: _nodeText13,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailCon,
                                  cursorColor: Color(0xff0A95A0),
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: 'Enter your email'),
                                  style: TextStyle(
                                      color: Color(0xff212156),
                                      fontFamily: FontStrings.Roboto_Regular
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0, left: 16, right: 0),
                                child: SvgPicture.asset(
                                  "assets/mail.svg",
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),

                //phone text field
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xff0A95A0),
                        style: BorderStyle.solid,
                        width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 16),
                        child: Text(
                          'Phone number',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff404243)),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 0, left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: TextField(
                                  focusNode: _nodeText14,
                                  keyboardType: TextInputType.phone,
                                  controller: phoneCon,
                                  cursorColor: Color(0xff0A95A0),
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: 'Enter your phone number'),
                                  style: TextStyle(
                                      color: Color(0xff212156),
                                      fontFamily: FontStrings.Roboto_Regular
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0, left: 16, right: 0),
                                child: SvgPicture.asset(
                                  "assets/Phone.svg",
                                  color: Color(0xff888B8D),
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),



            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("EMPLOYEE CPR (BOTH SIDE)",
                          style: Theme.of(context).textTheme.caption.copyWith(
                            fontFamily: FontStrings.Roboto_SemiBold,
                            fontWeight: FontWeight.bold,
                            color:Color(0xFF404243),),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        alignment: Alignment.centerLeft,
                        child: Text("*",
                          style: Theme.of(context).textTheme.caption.copyWith(
                            fontFamily: FontStrings.Roboto_SemiBold,
                            fontWeight: FontWeight.bold,
                            color:Color(0xFFF15B29),),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Get.bottomSheet(Container(
                      child: Container(
                        child: Wrap(
                          children: [
                            GestureDetector(
                              onTap:(){
                                // _openCamera1(context);
                                _loadPicker(ImageSource.camera,"cprFront");

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
                                // openGallery(context);
                                _loadPicker(ImageSource.gallery,"cprFront");
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
                  child: cprFront.isNull?
                    Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            color: Color(0xFFDDDEDE),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/empty image.svg',
                        ),
                      ),
                    ):
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.width / 2.5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(cprFront,
                      fit: BoxFit.cover,
                      )
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.all(10.0)),
                GestureDetector(
                  onTap: (){
                    Get.bottomSheet(Container(
                      child: Container(
                        child: Wrap(
                          children: [
                            GestureDetector(
                              onTap:(){
                                // _openCamera1(context);
                                _loadPicker(ImageSource.camera,"cprBack");
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
                                // openGallary1(context);
                                _loadPicker(ImageSource.gallery,'cprBack');
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
                  child: cprBack.isNull?
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Color(0xFFDDDEDE),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/empty image.svg',
                      ),
                    ),
                  ):
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.width / 2.5,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(cprBack,
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),

            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("CPR CARD READER OF THE EMPLOYEE",
                          style: Theme.of(context).textTheme.caption.copyWith(
                            fontFamily: FontStrings.Roboto_SemiBold,
                            fontWeight: FontWeight.bold,
                            color:Color(0xFF404243),),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        alignment: Alignment.centerLeft,
                        child: Text("*",
                          style: Theme.of(context).textTheme.caption.copyWith(
                            fontFamily: FontStrings.Roboto_SemiBold,
                            fontWeight: FontWeight.bold,
                            color:Color(0xFFF15B29),),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            GestureDetector(
              onTap: (){
                Get.bottomSheet(Container(
                  child: Container(
                    child: Wrap(
                      children: [
                        GestureDetector(
                          onTap:(){
                            // _openCamera1(context);
                            _loadPicker(ImageSource.camera,'cprReader');
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
                            // openGallary1(context);
                            _loadPicker(ImageSource.gallery,'cprReader');
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
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: cprReader.isNull?
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: MediaQuery.of(context).size.width / 2.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Color(0xFFDDDEDE),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/empty image.svg',
                    ),
                  ),
                ):
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: MediaQuery.of(context).size.width / 2.5,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(cprReader,
                        fit: BoxFit.cover,
                      )
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),

            RaisedGradientButton(
              onPressed: () {
                log.d(checkBoxValue.toString());
                if (checkBoxValue) {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return HomeScreen();
                  // }));

                  final String name1 = nameCon.text;
                  final String cpr1 = cprCon.text;
                  final String email1 = emailCon.text;

                  print('cprFront: $cprFront');
                  print('cprBack: $cprBack');
                  print('cprReader: $cprReader');
                  print('profilePic: $profilePic');
                  print('nameCon: ${nameCon.text}');
                  print('emailCon: ${emailCon.text}');
                  print('phoneCon: ${phoneCon.text}');
                  print('cprCon: ${cprCon.text}');
                  print('cprExpCon: ${cprExpCon.text}');

                  if((cprFront == null)||
                      (cprBack == null)||
                      (cprReader == null)||
                      (profilePic == null)||
                      (nameCon.text == '')||
                      (emailCon.text == '')||
                      (phoneCon.text == '')||
                      (cprCon.text == '')||
                      (cprExpCon.text == '')
                  ){
                    if(cprFront == null){
                      getSnackBar(null,'Add CPR Front');
                    }
                    if(cprBack == null){
                      getSnackBar(null,'Add CPR Back');
                    }
                    if(cprReader == null){
                      getSnackBar(null,'Add CPR Reader');
                    }
                    if(profilePic == null){
                      getSnackBar(null,'Add Profile Pic');
                    }
                    if(nameCon.text == ''){
                      getSnackBar(null,'Enter name');
                    }
                    if(emailCon.text == ''){
                      getSnackBar(null,'Enter email');
                    }
                    if(phoneCon.text == ''){
                      getSnackBar(null,'Enter phone number');
                    }
                    if(cprCon.text == ''){
                      getSnackBar(null,'Enter CPR number');
                    }
                    if(cprExpCon.text == ''){
                      getSnackBar(null,'Enter CPR expiry date');
                    }
                  }else{
                    hitApi(context,cprFront,cprBack,cprReader,profilePic,nameCon.text,emailCon.text,phoneCon.text,cprCon.text,cprExpCon.text);
                  }

                  // hitApi(context,cprFront,cprBack,cprReader,profilePic,nameCon.text,emailCon.text,phoneCon.text,cprCon.text,cprExpCon.text);
                  // hitAPI(context,name1,email1,cpr1);

                  // Scaffold.of(context).showSnackBar(SnackBar(
                  //   behavior: SnackBarBehavior.floating,
                  //   content: Text("name : $name\ncpr : $cpr\nemail : $email"),
                  // ));
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text("Accept the Terms and Conditions"),
                  ));
                }
              },
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xffC1282D),
                  Color(0xffF15B29)
                ],
              ),
              child: Text(
                "Finish",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: FontStrings.Fieldwork10_Regular,
                    fontSize: 16),
              ),
            ),
            SizedBox(
              height: 16,
            ),

          ],
        ),
      ),
    );
  }

  _loadPicker(ImageSource source , String type)async{

    File pic = await ImagePicker.pickImage(
        source: source, maxHeight: 800, maxWidth: 600);
    if(pic != null){
      _cropper(pic,type);
    }
  }

  _cropper(File image , String type)async{
    File crop = await ImageCropper.cropImage(sourcePath: image.path);
    if(crop != null){
      print('nameCon : ${nameCon.text}');
      switch(type) {
        case "cprFront": {
          // statements;
          setState(() {
            cprFront = crop;
            print(imageFile);
            Get.back();
          });
        }
        break;

        case "cprBack": {
          //statements;
          cprBack = crop;
          setState(() {
            print(imageFile);
          });
          Get.back();
        }
        break;

        case "cprReader": {
          //statements;
          cprReader = crop;
          setState(() {
            print(imageFile);
          });
          Get.back();
        }
        break;

        case "profilePic": {
          profilePic = crop;
          //statements;
          setState(() {

            print(imageFile);

          });
          Get.back();
        }
        break;
      }
    }
  }

  hitApi(BuildContext context, 
      File cprFront, 
      File cprBack, 
      File cprReader, 
      File profilePic,
      String name,
      String email,
      String phone,
      String cpr,
      String cprExpiryDate,
      ) async {


    // if(cprFront.isNull){
    //   getSnackBar(null, 'Add CPR front');
    // }
    //
    // if(cprBack.isNull){
    //   getSnackBar(null, 'Add CPR back');
    // }
    // if(cprReader.isNull){
    //   getSnackBar(null, 'Add CPR Reader');
    // }
    // if(profilePic.isNull){
    //   getSnackBar(null, 'Add Profile Picture');
    // }
    // if(name.isNull){
    //   getSnackBar(null, 'Enter name');
    // }
    // if(email.isNull){
    //   getSnackBar(null, 'Enter email');
    // }else{
    //   bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    //   if(emailValid){
    //     getSnackBar(null, 'Enter valid email');
    //   }
    // }
    // if(phone.isNull){
    //   getSnackBar(null, 'Enter phone number');
    // }else{
    //   bool phoneValidation = RegExp(r'(^(?:[+0]9)?[0-9]{8}$)').hasMatch(phone);
    //   if(phoneValidation){
    //     getSnackBar(null, 'Enter valid phone number');
    //   }
    // }
    //
    // if(cpr.isNull){
    //   getSnackBar(null, 'Enter CPR');
    // }else{
    //   bool phoneValidation = RegExp(r'(^[0-9]{9}$)').hasMatch(phone);
    //   if(phoneValidation){
    //     getSnackBar(null, 'Enter valid CPR');
    //   }
    // }
    // if(cprExpiryDate.isNull){
    //   getSnackBar(null, 'Enter valid CPR Expiry Date');
    // }





    final prefs = await SharedPreferences.getInstance();
    final DeviceID = prefs.getString("DeviceID");
    auth = prefs.getString("token");

    try {
      // String fileName = basename(pic.path);
      showLoading('');
      String cprFrontPath = basename(cprFront.path);
      String cprBackPath = basename(cprBack.path);
      String cprReaderPath = basename(cprReader.path);
      String profilePicPath = basename(profilePic.path);


      // String fileName = pic.path.split("/").last;
      Dio.FormData formData = new Dio.FormData.fromMap({
        "name": name,
        "email": email,
        "phone": phone,
        "cpr": cpr,
        "cpr_expiry_date": cprExpiryDate,
        "cpr_front_page": await Dio.MultipartFile.fromFile(cprFront.path, filename: cprFrontPath),
        "cpr_back_page": await Dio.MultipartFile.fromFile(cprBack.path, filename: cprBackPath),
        "cpr_card_reader": await Dio.MultipartFile.fromFile(cprReader.path, filename: cprReaderPath),
        "profile_photo": await Dio.MultipartFile.fromFile(profilePic.path, filename: profilePicPath),
      });
      // log.d("Path" + imageFile.path + "\nname:" + fileName);
      Dio.Response response =
      await dio.post(ApiStrings.BaseURL + ApiStrings.addEmployee,
          data: formData,
          options: Dio.Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer " + auth,
          }));
      // log.d("res:   " + response.toString());

      print('response status : ${response.data['status']}');
      print('response status : ${response.data['message']}');

      if((response.data['message']).contains('Added Successfully!!')){
        hideLoading();
        Navigator.pop(context,true);
      }else{
        hideLoading();
      }

      // contains


      Get.snackbar(null,
          response.data['message'],
          snackPosition:SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.white);
      // Get.back();
    }
    catch (e) {
      print('----------\n$e\n-------------------');
      Get.snackbar(null,
          "$e",
          snackPosition:SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.white);
    }
  }


}
