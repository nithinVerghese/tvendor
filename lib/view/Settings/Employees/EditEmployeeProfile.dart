import 'dart:io';
import 'dart:typed_data';
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
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/Constants/ApiStrings.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/Constants/stringConst.dart';
import 'package:path/path.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:takhlees_v/controller/Profile/EmployeeViewController.dart';
import 'package:takhlees_v/model/EmployeeViewModel.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:takhlees_v/widget/dialogBox/optionalDialog.dart';
import 'package:transparent_image/transparent_image.dart';

bool checkBoxValue = true;

class EditEmployeeProfile extends StatefulWidget {

  final String userId;

  const EditEmployeeProfile({Key key, this.userId}) : super(key: key);

  @override
  _EditEmployeeProfileState createState() => _EditEmployeeProfileState();
}

class _EditEmployeeProfileState extends State<EditEmployeeProfile> {

  @override
  void initState() {
    print('------------------------------EditEmployeeProfile------------------------');
    print('${widget.userId}');
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
            color: Color(0xff212156),), onPressed: () {
          // onBack();

            Navigator.pop(context,'true');
            },
        )
        ),
        title: Text(
          'Edit employee',
          style: Theme.of(context).textTheme.headline6.copyWith(
              fontFamily: FontStrings.Fieldwork10_Regular,
              fontWeight: FontWeight.normal,
              color: Color(0xff212156)
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: new AppBody(userId: widget.userId,),
      ),
    );
  }
}

class AppBody extends StatefulWidget {
  final String userId;

  const AppBody({Key key, this.userId}) : super(key: key);
  @override
  _AppBodyState createState() => _AppBodyState();
}


class _AppBodyState extends State<AppBody> {
  bool isLoading = false;

  final employeeViewController = EmployeeViewController();
  var employeeViewResultModel = EmployeeViewResult();


  @override
  void initState() {
    // TODO: implement initState
    // onBack();
    hitViewAPI(widget.userId);
    print('---$cprFront');
    print('---$cprBack');
    print('---$cprReader');
    print('---$profilePic');
    super.initState();
  }

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

  final nameCon = new TextEditingController();
  final cprCon = new TextEditingController();
  final cprExpCon = new TextEditingController();
  final emailCon = new TextEditingController();
  final phoneCon = new TextEditingController();

  bool isUpload = false;

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

    Widget _profilePic(String URL,context){
      return URL != null?
      CircleAvatar(
        radius: 30,
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
                      height: 300,
                      width: 300,
                    ),
                  ),
                ],
              )

            // Image.network(URL,
            //   fit: BoxFit.cover,
            //   height: Dimens.space140 * _multi(context),
            //   width: Dimens.space140 * _multi(context),
            // ),
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
      );
    }

    return KeyboardActions(
      config: _buildConfig(context),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: isLoading? Center(child: CircularProgressIndicator(),):Column(
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
                child: Center(
                  child: CircleAvatar(
                    radius: 100,
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
                                  image: employeeViewResultModel.profilePhotoPath,
                                  fit: BoxFit.cover,
                                  height: 300,
                                  width: 300,
                                ),
                              ),
                            ],
                          )

                        // Image.network(URL,
                        //   fit: BoxFit.cover,
                        //   height: Dimens.space140 * _multi(context),
                        //   width: Dimens.space140 * _multi(context),
                        // ),
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
                                      hintText: 'Enter your CPR expired date'),
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
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(employeeViewResultModel.cprFrontPage,
                          fit: BoxFit.cover,
                        )
                    ),
                  ):
                    // Container(
                    //     width: MediaQuery.of(context).size.width / 2.5,
                    //     height: MediaQuery.of(context).size.width / 2.5,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    //         color: Color(0xFFDDDEDE),
                    //   ),
                    //   child: Center(
                    //     child: SvgPicture.asset(
                    //       'assets/empty image.svg',
                    //     ),
                    //   ),
                    // ):
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
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(employeeViewResultModel.cprBackPage,
                          fit: BoxFit.cover,
                        )
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
                child: cprReader == null?
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: MediaQuery.of(context).size.width / 2.5,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(employeeViewResultModel.cprCardReader,
                        fit: BoxFit.cover,
                      )
                  ),
                )
                    :
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

                  print('----$cprReader');
                  print('----$cprFront');
                  print('----$cprBack');
                  print('----$profilePic');

                  final String name1 = nameCon.text;
                  final String cpr1 = cprCon.text;
                  final String email1 = emailCon.text;

                  hitApi(context,cprFront,cprBack,cprReader,profilePic,nameCon.text,emailCon.text,phoneCon.text,cprCon.text,cprExpCon.text);
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
                  Color(0xffC1282D), Color(0xffF15B29)
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
          setState(() {
            cprBack = crop;
            print(imageFile);
            Get.back();
          });
        }
        break;

        case "cprReader": {
          //statements;
          setState(() {
            cprReader = crop;
            print(imageFile);
            Get.back();
          });
        }
        break;

        case "profilePic": {
          //statements;
          setState(() {
            profilePic = crop;
            print(imageFile);
            Get.back();
          });
        }
        break;
      }
    }
  }
int count = 0 ;
  hitViewAPI(userID){
    isLoading = true;
    employeeViewController.fetchServices(userID).then(
            (result){
              isLoading = false;
     if(result["status"] == true){
       employeeViewResultModel = EmployeeViewModel.fromJson(result).result;
       nameCon.text = employeeViewResultModel.name;
       cprCon.text = employeeViewResultModel.cpr;
       cprExpCon.text = employeeViewResultModel.cprExpiryDate.toString();
       emailCon.text = employeeViewResultModel.email.toString();
       phoneCon.text = employeeViewResultModel.phone.toString();
       // imageToFile(employeeViewResultModel.cprCardReader,cprReader,'cprReader');
       // imageToFile(employeeViewResultModel.cprFrontPage,cprFront,'cprFront');
       // imageToFile(employeeViewResultModel.cprBackPage,cprBack,'cprBack');
       // imageToFile(employeeViewResultModel.profilePhotoPath,cprBack,'profilePhotoPath');
       // _fileFromImageUrl(employeeViewResultModel.cprCardReader,'cprReader');
       // _fileFromImageUrl(employeeViewResultModel.cprFrontPage,'cprFront');
       // _fileFromImageUrl(employeeViewResultModel.cprBackPage,'cprBack');
       // _fileFromImageUrl(employeeViewResultModel.profilePhotoPath,'profilePhotoPath');
       setState(() {
       });

     }else{
       print('--------${result["message"]}');
     }

    }, onError: (error) {
      print('--------${error.toString()}');
      setState(() {});
    });
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

    showLoading('');

    print('cprFront : $cprFront ');
    print('cprBack : $cprBack ');
    print('cprReader : $cprReader ');
    print('profilePic : $profilePic ');
    print('name : $name ');
    print('email : $email ');
    print('phone : $phone ');
    print('cpr : $cpr ');
    print('cprExpiryDate : $cprExpiryDate ');

    final prefs = await SharedPreferences.getInstance();
    final DeviceID = prefs.getString("DeviceID");
    auth = prefs.getString("token");

    try {
      // String fileName = basename(pic.path);
      String cprFrontPath ;
      String cprBackPath;
      String cprReaderPath;
      String profilePicPath;

      if(cprFront != null){
        cprFrontPath = basename(cprFront.path);
      }
      if(cprBack != null){
        cprBackPath = basename(cprBack.path);
      }
      if(cprReader != null){
        cprReaderPath = basename(cprReader.path);
      }
      if(profilePic != null){
        profilePicPath = basename(profilePic.path);
      }

      // String fileName = pic.path.split("/").last;
      Dio.FormData formData = new Dio.FormData.fromMap({
        "name": name,
        "email": email,
        "phone": phone,
        "cpr": cpr,
        "cpr_expiry_date": cprExpiryDate,
        "user_id": widget.userId,
        "cpr_front_page": cprFront != null ? await Dio.MultipartFile.fromFile(cprFront.path, filename: cprFrontPath):null,
        "cpr_back_page": cprBack != null ? await Dio.MultipartFile.fromFile(cprBack.path, filename: cprBackPath):null,
        "cpr_card_reader": cprReader != null ? await Dio.MultipartFile.fromFile(cprReader.path, filename: cprReaderPath):null,
        "profile_photo": profilePic != null ? await Dio.MultipartFile.fromFile(profilePic.path, filename: profilePicPath): null,
      });
      // log.d("Path" + imageFile.path + "\nname:" + fileName);
      Dio.Response response =
      await dio.post(ApiStrings.BaseURL + ApiStrings.employeeEdit,
          data: formData,
          options: Dio.Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer " + auth,
          }));
      // log.d("res:   " + response.toString());
      // onBack();

      hideLoading();

      Navigator.pop(context,true);



      Get.snackbar(null,
          response.data['message'],
          snackPosition:SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.white);
      // Get.back();
    }
    catch (e) {
      hideLoading();
      print('----------\n$e\n-------------------');
      Get.snackbar(null,
          "$e",
          snackPosition:SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.white);
    }
  }



  // Future<void> _fileFromImageUrl(strURL,String fileName) async {
  //   final response = await http.get(strURL);
  //
  //   final documentDirectory = await getApplicationDocumentsDirectory();
  //
  //   final file = File(join(documentDirectory.path, '$fileName.png'));
  //
  //   file.writeAsBytesSync(response.bodyBytes);
  //
  //   count = count+1;
  //   if(fileName == 'cprReader' ){
  //     cprReader = file;
  //   }if(fileName == 'cprFront'){
  //     cprFront = file;
  //   }if(fileName == 'cprBack'){
  //     cprBack = file;
  //   }if(fileName == 'profilePhotoPath'){
  //     profilePic = file;
  //   }
  //   print('file = $file');
  //   setState(() {});
  //   print('$count file - $cprBack}');
  //   // if(count >= 4 ){
  //     isLoading = false;
  //   // }
  //   print(' file - $file}');
  //
  //   // return file;
  // }

  // Future<void> imageToFile(strURL,File _file,String fileName) async {
  //   final http.Response responseData = await http.get(strURL);
  //   final documentDirectory = await getApplicationDocumentsDirectory();
  //   print('${documentDirectory.path}');
  //   Uint8List uint8list = responseData.bodyBytes;
  //   var buffer = uint8list.buffer;
  //   ByteData byteData = ByteData.view(buffer);
  //   var tempDir = await getTemporaryDirectory();
  //   File file = await File('${tempDir.path}/$fileName.jpg').writeAsBytes(
  //       buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //   count = count+1;
  //   if(fileName == 'cprReader' ){
  //     cprReader = file;
  //   }if(fileName == 'cprFront'){
  //     cprFront = file;
  //   }if(fileName == 'cprBack'){
  //     cprBack = file;
  //   }if(fileName == 'profilePhotoPath'){
  //     profilePic = file;
  //   }
  //   print('file = $file');
  //   setState(() {});
  //   print('$count file - $cprBack}');
  //   if(count >= 4 ){
  //     isLoading = false;
  //   }
  //   print('$count file - $file}');
  //
  // }

  // onBack(){
  //   // cprReader.delete() ;
  //   // cprFront.delete() ;
  //   // cprBack.delete() ;
  //   // profilePic.delete() ;
  //
  //   deleteFile('cprReader');
  //   deleteFile('cprFront');
  //   deleteFile('cprBack');
  //   deleteFile('profilePhotoPath');
  //
  //   setState(() {
  //   });
  // }

  deleteFile(localFilename) async {
    final Directory output = await getTemporaryDirectory();
    final String tempLocalFilename = "${output.path}/$localFilename";
    File tempLocalFile = File(tempLocalFilename);
    if (tempLocalFile.existsSync()) {
      await tempLocalFile.delete(recursive: true,);
    }
    // tempLocalFile = await tempLocalFile.create();
  }


}
