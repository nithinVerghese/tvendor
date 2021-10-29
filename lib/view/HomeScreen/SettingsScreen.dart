import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/Constants/ApiStrings.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/Constants/stringConst.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:takhlees_v/controller/Profile/VendorInfoController.dart';
import 'package:takhlees_v/model/VendorProfileModel.dart';
import 'package:takhlees_v/view/Auth/sign_in.dart';
import 'package:takhlees_v/view/Settings/EditSettingsScreen.dart';
import 'package:takhlees_v/view/Settings/LanguageScreen.dart';
import 'package:takhlees_v/widget/dialogBox/optionalDialog.dart';
import 'package:transparent_image/transparent_image.dart';

import '../Settings/PrivateInformationScreen.dart';
import '../Auth/sign_up.dart';


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin{

  //Variabless
  Dio.Dio dio = new Dio.Dio();
  File imageFile;
  String auth;
  final nameCon = new TextEditingController();
  String profilePic ='https://miro.medium.com/max/882/1*9EBHIOzhE1XfMYoKz1JcsQ.gif';
  var _lights = false;
  var isServicePresent;

  var name = '';
  var email = '';
  var phone = '';
  var notification = false;
  var companyNameEn = '';
  var availableNow = false;
  var selectedLanguage ;
  String role = '';
  // var profile_photo_path;
  // var profile_photo_url;

  final infoAPI = VendorInfoController();
  var profileModel = ProfileResult();

  _multi(BuildContext context){
    return MediaQuery.of(context).size.height * 0.01;
  }

  Future<void> _selectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    selectedLanguage = prefs.getString('language');
    setState(() {});
    print('-------------$selectedLanguage');
  }

  @override
  void initState() {
    print('-------------------------------------SettingsScreen--------------------------');
    hitAddToCart(context);
    _selectedLanguage();
    _getRole();
    // TODO: implement initState
    super.initState();
  }


//Main Builder
  @override
  Widget build(BuildContext context) {
    // final index = DefaultTabController.of(this.context).index;
    return Scaffold(
      body: Container(
        //------------------------------ Background--------------------------------------------------------
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [(Color(0xffC1282D)), (Color(0xffF15B29))],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
        ),
        child: Column(
          children: [
            //-------------------------------- App Bar ----------------------------------------------------------
            Container(
              height: Dimens.space100 * _multi(context),
              color: Colors.transparent,
              padding: EdgeInsets.only(top: 30),
              child: _appBar(context),
            ),

            Expanded(
              child: Container(
                // height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    color: Color(0xffF4F6F9)
                ),
                child: SingleChildScrollView(
                  child: Container(
                    child:
                    // isServicePresent == ""?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 18,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all( Radius.circular(5),),
                                            color: Color(0xffF2C94C)
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                        children: [
                                        Icon(Icons.star_sharp,color: Colors.white,),
                                        Padding(padding: EdgeInsets.all(4)),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text('4.5',style: Theme.of(context).textTheme.bodyText2.copyWith(
                                            fontFamily: FontStrings.Fieldwork10_Regular,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                          ),),
                                        ),
                                      ],
                                    )),
                                  ),
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
                                    child: Container(child:_isImageNull(('$profilePic'),context)
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: (){
                                  //     print('----------- profile pic ---------');
                                  //     Get.bottomSheet(Container(
                                  //       child: Container(
                                  //         // color: Colors.white,
                                  //         // height: 100,
                                  //         child: Wrap(
                                  //           children: [
                                  //             // SizedBox(height: 20,),
                                  //             // ListTile(
                                  //             //   leading: Icon(Icons.camera_alt),
                                  //             //   title: Text('Camera'),
                                  //             // ),
                                  //             // SizedBox(height: 20,),
                                  //             // ListTile(
                                  //             //   leading: Icon(Icons.camera_alt),
                                  //             //   title: Text('Camera'),
                                  //             // ),
                                  //             GestureDetector(
                                  //
                                  //               child: Container(
                                  //                 padding: const EdgeInsets.only(left:8.0,right: 8,bottom: 8),
                                  //                 child: Container(
                                  //                   decoration: BoxDecoration(
                                  //                     color: Colors.white,
                                  //                     borderRadius: BorderRadius.only(
                                  //                         topLeft: Radius
                                  //                             .circular(10),
                                  //                         topRight: Radius
                                  //                             .circular(10),
                                  //                         bottomLeft: Radius
                                  //                             .circular(10),
                                  //                         bottomRight:
                                  //                         Radius
                                  //                             .circular(
                                  //                             10)),
                                  //                     boxShadow: [
                                  //                       BoxShadow(
                                  //                         color: Colors.grey
                                  //                             .withOpacity(
                                  //                             0.2),
                                  //                         spreadRadius: 0.3,
                                  //                         blurRadius: 1,
                                  //                         offset: Offset(0,
                                  //                             1), // changes position of shadow
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                   padding: EdgeInsets.all(15),
                                  //                   child: Row(
                                  //                     children: [
                                  //                       Icon(Icons.camera_alt,color:Colors.black54),
                                  //                       Expanded(child: Container(
                                  //                         padding: const EdgeInsets.all(8.0),
                                  //                         child: Text('Camera',style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  //                           fontFamily: FontStrings.Fieldwork10_Regular,
                                  //                             color:Colors.black54
                                  //                         ),),
                                  //                       ))
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //             GestureDetector(
                                  //               onTap: (){
                                  //                 openGallary(context);
                                  //               },
                                  //               child: Container(
                                  //                 padding: const EdgeInsets.only(left:8.0,right: 8,),
                                  //                 child: Container(
                                  //                   decoration: BoxDecoration(
                                  //                     color: Colors.white,
                                  //                     borderRadius: BorderRadius.only(
                                  //                         topLeft: Radius
                                  //                             .circular(10),
                                  //                         topRight: Radius
                                  //                             .circular(10),
                                  //                         bottomLeft: Radius
                                  //                             .circular(10),
                                  //                         bottomRight:
                                  //                         Radius
                                  //                             .circular(
                                  //                             10)),
                                  //                     boxShadow: [
                                  //                       BoxShadow(
                                  //                         color: Colors.grey
                                  //                             .withOpacity(
                                  //                             0.2),
                                  //                         spreadRadius: 0.3,
                                  //                         blurRadius: 1,
                                  //                         offset: Offset(0,
                                  //                             1), // changes position of shadow
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                   padding: EdgeInsets.all(15),
                                  //                   child: Row(
                                  //                     children: [
                                  //                       Icon(Icons.collections,color:Colors.black54),
                                  //                       Expanded(child: Container(
                                  //                         padding: const EdgeInsets.all(8.0),
                                  //                         child: Text('Gallery',style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  //                           fontFamily: FontStrings.Fieldwork10_Regular,
                                  //                             color:Colors.black54
                                  //                         ),),
                                  //                       ))
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //             GestureDetector(
                                  //               onTap: ()=>Get.back(),
                                  //               child: Container(
                                  //                 padding: const EdgeInsets.all(8.0),
                                  //                 child: Container(
                                  //                   decoration: BoxDecoration(
                                  //                     color: Colors.white,
                                  //                     borderRadius: BorderRadius.only(
                                  //                         topLeft: Radius
                                  //                             .circular(10),
                                  //                         topRight: Radius
                                  //                             .circular(10),
                                  //                         bottomLeft: Radius
                                  //                             .circular(10),
                                  //                         bottomRight:
                                  //                         Radius
                                  //                             .circular(
                                  //                             10)),
                                  //                     boxShadow: [
                                  //                       BoxShadow(
                                  //                         color: Colors.grey
                                  //                             .withOpacity(
                                  //                             0.2),
                                  //                         spreadRadius: 0.3,
                                  //                         blurRadius: 1,
                                  //                         offset: Offset(0,
                                  //                             1), // changes position of shadow
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                   padding: EdgeInsets.all(15),
                                  //                   child: Row(
                                  //                     mainAxisAlignment: MainAxisAlignment.center,
                                  //                     children: [
                                  //                       Container(
                                  //                         // padding: const EdgeInsets.all(0),
                                  //                         child: Center(
                                  //                           child: Text('Cancel',textAlign: TextAlign.center ,style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  //                             fontFamily: FontStrings.Fieldwork10_Regular,
                                  //                             color: Colors.red
                                  //                           ),),
                                  //                         ),
                                  //                       )
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //             Container(
                                  //               height: 25,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ));
                                  //   },
                                  //     child: _profilePic('https://cdn.logo.com/hotlink-ok/logo-social.png',context)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all( Radius.circular(10),),
                                            color: Colors.transparent
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Icon(Icons.star_sharp,color: Colors.transparent,),

                                            Padding(padding: EdgeInsets.all(4)),
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Text('4',style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                fontFamily: FontStrings.Fieldwork10_Regular,
                                                color:  Colors.transparent,
                                              ),),
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                              // _profilePic(profileModel.profilePhotoPath.length == 0 ?
                              // profileModel.profilePhotoUrl:
                              // profileModel.profilePhotoPath),
                              SizedBox(height: 25,),
                              title(context),
                              SizedBox(height: 25,),
                              _companyInfo(context),
                              SizedBox(height: 10,),
                              _personalInfoTitle(context),
                              SizedBox(height: 10,),
                              privateInfo(context),
                              // _name('nithin',context),
                              // _email('email@email.com',context),
                              // _phone('phone',context),
                              SizedBox(height: 16,),
                              _settings(context),
                              SizedBox(height: 1,),
                              _companyDetail(context),
                              SizedBox(height: 9,),
                            ],
                          ),
                      ],
                    )
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   crossAxisAlignment: CrossAxisAlignment.stretch,
                    //   children: [
                    //     SizedBox(height: (MediaQuery.of(context).size.height-(30+Dimens.space100 * _multi(context)))/2,),
                    //     Container(child: Center(
                    //         child: Text(
                    //             isServicePresent==null?"...":isServicePresent,
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //             fontFamily: FontStrings.Roboto_Regular,
                    //             fontSize: Dimens.space18 * _multi(context),
                    //             color: UIColor.darkGrey
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
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
      await dio.post(ApiStrings.BaseURL + ApiStrings.vendorProfileImageUpload,
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
  Widget _isImageNull(String URL,context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        imageFile == null
            ? CircleAvatar(
          radius: 60,
          backgroundColor: Colors.transparent,
          child:
          ClipOval(
            child: new SizedBox(
              child: Stack(
                children: <Widget>[
                  Center(child: CircularProgressIndicator(
                    valueColor:AlwaysStoppedAnimation<Color>(UIColor.baseGradientLight),
                  )),
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: URL,
                      fit: BoxFit.cover,
                      height: Dimens.space160 * _multi(context),
                      width: Dimens.space160 * _multi(context),
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircularProgressIndicator(
                            // backgroundColor: UIColor.baseGradientLight,
                            value: downloadProgress.progress,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                UIColor.baseGradientLight),
                          ),
                      // CircularProgressIndicator(value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                    // FadeInImage.memoryNetwork(
                    //   placeholder: kTransparentImage,
                    //   image: URL,
                    //   fit: BoxFit.cover,
                    //   height: Dimens.space140 * _multi(context),
                    //   width: Dimens.space140 * _multi(context),
                    // ),
                  ),
                ],
              ),
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
  Widget _appBar(context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  child: Text('   '+'Settings'.tr,
                    style: TextStyle(
                        fontFamily: FontStrings.Fieldwork16_Bold,
                        fontSize: Dimens.space24 * MediaQuery.of(context).size.height * 0.01,
                        color: Colors.white),
                  )),
            ],
          ),
        ),
        role == 'Admin'?Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Logout
              Padding(
                padding:
                EdgeInsets.only(top: Dimens.space10*_multi(context),
                    bottom: Dimens.space10*_multi(context),
                    left: Dimens.space10*_multi(context),
                    right: Dimens.space20*_multi(context)
                ),
                child: GestureDetector(
                  onTap: () async {
                    // logOutDialog(context);
                    // final prefs = await SharedPreferences.getInstance();
                    // await prefs.setString("token", "");
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) {
                    //       return SignUp();
                    //     }));
                    final result = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return EditSettingsScreen();
                        }));
                  },
                  child: SvgPicture.asset(
                    'assets/settings.svg',
                    color: Colors.white,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
                // Icon(Icons.notifications, size: 24,color: Colors.white,),
              ),
            ],
          ),
        ):Container(),
      ],
    );
  }
  Widget _personalInfoTitle(context){
    return Container(
      padding: EdgeInsets.only(left: 24,right: 24,top: 8,bottom: 8),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment:selectedLanguage == 'en' ? Alignment.centerLeft:Alignment.centerRight,
              child: Text("PRIVATE INFORMATION".tr,
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
          GestureDetector(
            onTap: () async {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return EditProfileScreen(
              //       profileModel.name.toString(),
              //       profileModel.email.toString(),
              //       profileModel.phone.toString(),
              //       profileModel.cpr
              //   );
              // }));
              final result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return PrivateInformationScreen(name,email,phone);
                  }));
              if(result == true){
                hitAddToCart(context);
              }
            },
            child: Container(
              child: SvgPicture.asset(
                'assets/edit.svg',
                color: Color(0xFF404243),
                allowDrawingOutsideViewBox: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget title(context){
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
  Widget _name(String name,context){
    return Padding(
      padding: EdgeInsets.only(left: 24,right: 24,top: 12,bottom: 12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xff212156),
              style: BorderStyle.solid,
              width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 16,bottom: 4),
              child: Text(
                'Full Name',
                style:
                Theme.of(context).textTheme.overline.copyWith(
                  fontFamily: FontStrings.Roboto_Bold,
                  color:Color(0xff404243),),
                // TextStyle(
                //     fontSize: Dimens.space10 * _multi(context),
                //     fontFamily: FontStrings.Roboto_Regular,
                //     color: Color(0xff404243)),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 0, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child:
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                        name,
                        style:
                        Theme.of(context).textTheme.bodyText1.copyWith(
                          fontFamily: FontStrings.Roboto_Regular,
                          color:Color(0xff212156),),
                        // TextStyle(
                        //   color: Color(0xff212156),
                        //   fontSize: Dimens.space16 * _multi(context),
                        //   fontFamily: FontStrings.Roboto_Regular,
                        // ),
                    ),
                      )
                      // TextField(
                      //   keyboardType: TextInputType.name,
                      //   controller: nameCon,
                      //   cursorColor: Color(0xff0A95A0),
                      //   decoration: new InputDecoration(
                      //       border: InputBorder.none,
                      //       focusedBorder: InputBorder.none,
                      //       enabledBorder: InputBorder.none,
                      //       errorBorder: InputBorder.none,
                      //       disabledBorder: InputBorder.none,
                      //       hintText: 'Enter your name'),
                      //   style: TextStyle(
                      //     color: Color(0xff212156),
                      //     fontFamily: FontStrings.Roboto_Regular,
                      //   ),
                      // ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 0, left: 16, right: 0),
                    //   child: SvgPicture.asset(
                    //     "assets/user.svg",
                    //     width: 25,
                    //     height: 25,
                    //   ),
                    // ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
  Widget _email(String email,context){
    return Padding(
      padding: EdgeInsets.only(left: 24,right: 24,top: 0,bottom: 12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xff212156),
              style: BorderStyle.solid,
              width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 16,bottom: 4),
              child: Text(
                'Email'.tr,
                style: Theme.of(context).textTheme.overline.copyWith(
                  // fontFamily: FontStrings.Roboto_Bold,
                  fontFamily:selectedLanguage == 'en'?FontStrings.Roboto_Bold:FontStrings.Tajawal_Bold,

                  color:Color(0xff404243),),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 0, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child:
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                        email,
                        style:
                        Theme.of(context).textTheme.bodyText1.copyWith(
                          fontFamily: FontStrings.Roboto_Regular,
                          color:Color(0xff212156),),
                        // TextStyle(
                        //   color: Color(0xff212156),
                        //   fontSize: Dimens.space16 * _multi(context),
                        //   fontFamily: FontStrings.Roboto_Regular,
                        // ),
                    ),
                      )
                      // TextField(
                      //   keyboardType: TextInputType.name,
                      //   controller: nameCon,
                      //   cursorColor: Color(0xff0A95A0),
                      //   decoration: new InputDecoration(
                      //       border: InputBorder.none,
                      //       focusedBorder: InputBorder.none,
                      //       enabledBorder: InputBorder.none,
                      //       errorBorder: InputBorder.none,
                      //       disabledBorder: InputBorder.none,
                      //       hintText: 'Enter your name'),
                      //   style: TextStyle(
                      //     color: Color(0xff212156),
                      //     fontFamily: FontStrings.Roboto_Regular,
                      //   ),
                      // ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 0, left: 16, right: 0),
                    //   child: SvgPicture.asset(
                    //     "assets/user.svg",
                    //     width: 25,
                    //     height: 25,
                    //   ),
                    // ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
  Widget _phone(String phone,context){
    return Padding(
      padding: EdgeInsets.only(left: 24,right: 24,top: 0,bottom: 0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xff212156),
              style: BorderStyle.solid,
              width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 16,bottom: 4),
              child: Text(
                'Mobile Phone'.tr,
                style: Theme.of(context).textTheme.overline.copyWith(
                  fontFamily: FontStrings.Roboto_Bold,
                  color:Color(0xff404243),),
                // TextStyle(
                //     fontSize: Dimens.space10 * _multi(context),
                //     fontFamily: FontStrings.Roboto_Regular,
                //     color: Color(0xff404243)),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 0, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child:
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                        phone,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontFamily: FontStrings.Roboto_Regular,
                          color:Color(0xff212156),),
                        // TextStyle(
                        //   color: Color(0xff212156),
                        //   fontSize: Dimens.space16 * _multi(context),
                        //   fontFamily: FontStrings.Roboto_Regular,
                        // ),
                    ),
                      )
                      // TextField(
                      //   keyboardType: TextInputType.name,
                      //   controller: nameCon,
                      //   cursorColor: Color(0xff0A95A0),
                      //   decoration: new InputDecoration(
                      //       border: InputBorder.none,
                      //       focusedBorder: InputBorder.none,
                      //       enabledBorder: InputBorder.none,
                      //       errorBorder: InputBorder.none,
                      //       disabledBorder: InputBorder.none,
                      //       hintText: 'Enter your name'),
                      //   style: TextStyle(
                      //     color: Color(0xff212156),
                      //     fontFamily: FontStrings.Roboto_Regular,
                      //   ),
                      // ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 0, left: 16, right: 0),
                    //   child: SvgPicture.asset(
                    //     "assets/user.svg",
                    //     width: 25,
                    //     height: 25,
                    //   ),
                    // ),
                  ],
                )),
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
  Widget _profilePicFile(String URL,context){
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
  Widget _settings(BuildContext context){
    return Container(
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
          Container(
            padding: EdgeInsets.only(top: 10,bottom: 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    child: Text("Notifications".tr,
                      style: TextStyle(
                          // fontFamily: FontStrings.Roboto_SemiBold,
                          fontFamily:selectedLanguage == 'en'?FontStrings.Roboto_SemiBold:FontStrings.Tajawal_Medium,
                          color: Color(0xFF404243)
                      ),
                    ),
                  ),
                ),
                Container(
                  child:  CupertinoSwitch(
                    activeColor: UIColor.baseGradientLight,
                    value: notification,
                    onChanged: (bool value) {
                      setState(() {
                        notification = value;
                      });
                      hitNotificationSettings(value.toString(),context);
                    },
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap:(){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return LanguageScreen();
                  }));
            },
              child: _item("Change Language".tr)),
          // GestureDetector(
          //   onTap: (){
          //     // Navigator.push(context,
          //     //     MaterialPageRoute(builder: (context) {
          //     //       return LocationScreen();
          //     //     }));
          //   },
          //     child: _item("Saved Addresses")),
        ],
      ),
    );
  }
  Widget _companyDetail(BuildContext context){
    return Container(
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
          _item2("Customer Care".tr),
          //-----about
          GestureDetector(
            onTap: (){
              bottomSheet(context,"About", "Upon downloading this app, users will notice that the Terms and Conditions aren’t available on the app itself. That’s because Apalon provides an End-User License Agreement that applies to all their apps, products, and services on their website’s Terms and Privacy Policy pag Ac diam nunc in porta nunc, ultricies proin nulla. Aliquam, id vitae donec ultrices augue dolor. Eu, tincidunt blandit scelerisque nascetur enim. Vitae nulla pulvinar massa molestie lobortis orci et risus nascetur. At laoreet ultrices diam eu. Sed ornare ac pellentesque turpis consequat elit. Upon downloading this app, users will notice that the Terms and Conditions aren’t available on the app itself. That’s because Apalon provides an End-User License Agreement that applies to all their apps, products, and services on their website’s Terms and Privacy Policy pag Upon downloading this app, users will notice that the Terms and Conditions aren’t available on the app itself. That’s because Apalon provides an End-User License Agreement that applies to all their apps, products, and services on their website’s Terms and Privacy Policy pag Upon downloading this app, users will notice that the Terms and Conditions aren’t available on the app itself. That’s because Apalon provides an End-User License Agreement that applies to all their apps, products, and services on their website’s Terms and Privacy Policy pag");
            },
              child: _item2("About".tr)),
          //-----Terms and Conditions
          GestureDetector(
              onTap: (){
                bottomSheet(context,"Terms and Conditions", "Upon downloading this app, users will notice that the Terms and Conditions aren’t available on the app itself. That’s because Apalon provides an End-User License Agreement that applies to all their apps, products, and services on their website’s Terms and Privacy Policy pag Ac diam nunc in porta nunc, ultricies proin nulla. Aliquam, id vitae donec ultrices augue dolor. Eu, tincidunt blandit scelerisque nascetur enim. Vitae nulla pulvinar massa molestie lobortis orci et risus nascetur. At laoreet ultrices diam eu. Sed ornare ac pellentesque turpis consequat elit. Upon downloading this app, users will notice that the Terms and Conditions aren’t available on the app itself. That’s because Apalon provides an End-User License Agreement that applies to all their apps, products, and services on their website’s Terms and Privacy Policy pag Upon downloading this app, users will notice that the Terms and Conditions aren’t available on the app itself. That’s because Apalon provides an End-User License Agreement that applies to all their apps, products, and services on their website’s Terms and Privacy Policy pag Upon downloading this app, users will notice that the Terms and Conditions aren’t available on the app itself. That’s because Apalon provides an End-User License Agreement that applies to all their apps, products, and services on their website’s Terms and Privacy Policy page");
              },
              child: _item2("Terms and Conditions".tr)),
          //-----Privacy Policy
          GestureDetector(
              onTap: (){
                bottomSheet(context,"Privacy Policy", "Upon downloading this app, users will notice that the Terms and Conditions aren’t available on the app itself. That’s because Apalon provides an End-User License Agreement that applies to all their apps, products, and services on their website’s Terms and Privacy Policy pag Ac diam nunc in porta nunc, ultricies proin nulla. Aliquam, id vitae donec ultrices augue dolor. Eu, tincidunt blandit scelerisque nascetur enim. Vitae nulla pulvinar massa molestie lobortis orci et risus nascetur. At laoreet ultrices diam eu. Sed ornare ac pellentesque turpis consequat elit. Upon downloading this app, users will notice that the Terms and Conditions aren’t available on the app itself. That’s because Apalon provides an End-User License Agreement that applies to all their apps, products, and services on their website’s Terms and Privacy Policy pag Upon downloading this app, users will notice that the Terms and Conditions aren’t available on the app itself. That’s because Apalon provides an End-User License Agreement that applies to all their apps, products, and services on their website’s Terms and Privacy Policy pag Upon downloading this app, users will notice that the Terms and Conditions aren’t available on the app itself. That’s because Apalon provides an End-User License Agreement that applies to all their apps, products, and services on their website’s Terms and Privacy Policy page");
              },
              child: _item2("Privacy Policy".tr)),
          GestureDetector(
              onTap: (){
                optionalDialog('Log Out','Are you sure want to logout.?',(){
                  _loginRemove();
                },(){
                  Get.back();
                });
              },
              child: _item2("Log out".tr))
        ],
      ),
    );
  }
  Widget _companyInfo(BuildContext context){
    return Container(
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
          _item3('Company Name'.tr,'${selectedLanguage == 'en'? companyNameEn:companyNameEn}'),
          _item3('Name'.tr,'$name'),
          Container(
            padding: EdgeInsets.only(top: 10,bottom: 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    child: Text("Work Availability".tr,
                      style: TextStyle(
                          // fontFamily: FontStrings.Roboto_SemiBold,
                          fontFamily:selectedLanguage == 'en'?FontStrings.Roboto_SemiBold:FontStrings.Tajawal_Medium,
                          color: Color(0xFF404243)
                      ),
                    ),
                  ),
                ),
                Container(
                  child:  CupertinoSwitch(
                    activeColor: UIColor.baseGradientLight,
                    value: availableNow,
                    onChanged: (bool value) {
                      setState(() {
                        availableNow = value;
                      });
                      hitNotificationSettings(value.toString(),context);
                    },
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
  Widget privateInfo(BuildContext context){
    return Container(
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
          _item3('Email'.tr,'$email'),
          _item3('Mobile Phone'.tr,'$phone'),
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
              child: Text(itemName,
                style: TextStyle(
                    // fontFamily: FontStrings.Roboto_SemiBold,
                    fontFamily:selectedLanguage == 'en'?FontStrings.Roboto_SemiBold:FontStrings.Tajawal_Medium,
                    color: Color(0xFF404243)
                ),
              ),
            ),
          ),
          selectedLanguage == 'en'?Icon(Icons.chevron_right_outlined,
            color: Color(0xFF404243),
          ):Icon(Icons.chevron_left_outlined,
            color: Color(0xFF404243),
          ),
        ],
      ),
    );
  }
  Widget _item2(String itemName){
    return  Container(
      padding: EdgeInsets.only(top: 13,bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: Text(itemName,
                style: TextStyle(
                    // fontFamily: FontStrings.Roboto_SemiBold,
                    fontFamily:selectedLanguage == 'en'?FontStrings.Roboto_SemiBold:FontStrings.Tajawal_Medium,
                    color: Color(0xFF404243)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _item3(String itemName,String item){
    return  Container(
      padding: EdgeInsets.only(top: 13,bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: Text(itemName,
                style: TextStyle(
                    // fontFamily: FontStrings.Roboto_SemiBold,
                    fontFamily:selectedLanguage == 'en'?FontStrings.Roboto_SemiBold:FontStrings.Tajawal_Medium,
                    color: Color(0xFF404243)
                ),
              ),
            ),
          ),
          Container(
            child: Text(item,
              style: TextStyle(
                  fontFamily: FontStrings.Roboto_Bold,
                  color: Color(0xFF404243)
              ),
            ),
          ),
        ],
      ),
    );
  }
  // ignore: missing_return
  Widget bottomSheet(BuildContext context,String title, String content) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height - 6.95 * _multi(context),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child: Column(
              children: [
                Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 0.3,
                        blurRadius: 1,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.clear,
                            color: Color(0xffF15B29),
                          ),
                        ),
                        Center(
                          child: Text(
                            "     $title",
                            style: TextStyle(
                                color: Color(0xff212156),
                                fontFamily: FontStrings.Fieldwork10_Regular,
                                fontSize: Dimens.space24 * _multi(context)),
                          ),
                        ),
                        Center(
                          child: Text(
                            "           ",
                            style: TextStyle(
                                color: Color(0xff212156),
                                fontFamily: FontStrings.Fieldwork10_Regular,
                                fontSize: Dimens.space24 * _multi(context)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                    child: Text(
                      content,
                      style: TextStyle(
                          fontSize: Dimens.space16 * _multi(context),
                          fontFamily: FontStrings.Roboto_Regular,
                          color: Color(0xFF404243)),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void hitAddToCart(context){

    infoAPI.fetchServices().
    then((result) {
      if (result["status"] == true) {
        isServicePresent = "";

        profileModel = VendorProfileModel.fromJson(result).result;

        availableNow = profileModel.availableNow == "Yes" ? true : false;

        name = profileModel.name;

        email = profileModel.email;

        phone = profileModel.phone;

        companyNameEn = profileModel.companyNameEn;

        if(profileModel.profilePhotoPath == null){
          profilePic = profileModel.profilePhotoUrl;
        }else{
          profilePic = profileModel.profilePhotoPath;
        }

        

        if(profileModel.notification == "Yes"){
          notification = true;
        }else{
          notification = false;
        }

        setState(() {});
      } else {
        isServicePresent = result["message"];
        setState(() {
        });
        // Scaffold.of(context).showSnackBar(
        //     SnackBar(
        //       behavior: SnackBarBehavior.floating,
        //       content: Text(isServicePresent),
        //     )
        // );
        Get.snackbar(null,
            isServicePresent,
            snackPosition:SnackPosition.BOTTOM,
            backgroundColor: Colors.black54,
            colorText: Colors.white);

        // Fluttertoast.showToast(
        //     msg: result["message"],
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIos: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.yellow);
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      setState(() {
      });
    });
  }
  void hitNotificationSettings(String status,BuildContext context){
    // notificationSettings.fetchServices(status).
    // then((result) {
    //   if (result["status"] == true) {
    //     isServicePresent = "";
    //     setState(() {
    //     });
    //     hitAddToCart(context);
    //   } else {
    //     isServicePresent = result["message"];
    //     setState(() {
    //     });
    //     // Scaffold.of(context).showSnackBar(
    //     //     SnackBar(
    //     //       behavior: SnackBarBehavior.floating,
    //     //       content: Text(isServicePresent),
    //     //     )
    //     // );
    //     Get.snackbar(null,
    //         isServicePresent,
    //         snackPosition:SnackPosition.BOTTOM,
    //         backgroundColor: Colors.black54,
    //         colorText: Colors.white);
    //
    //     // Fluttertoast.showToast(
    //     //     msg: result["message"],
    //     //     toastLength: Toast.LENGTH_SHORT,
    //     //     gravity: ToastGravity.BOTTOM,
    //     //     timeInSecForIos: 1,
    //     //     backgroundColor: Colors.red,
    //     //     textColor: Colors.yellow);
    //   }
    // }, onError: (error) {
    //   isServicePresent = error.toString();
    //   setState(() {
    //   });
    //   Get.snackbar(null,
    //       isServicePresent,
    //       snackPosition:SnackPosition.BOTTOM,
    //       backgroundColor: Colors.black54,
    //       colorText: Colors.white);
    // });
  }
  // void lodingDialog(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return CustomAlertDialog(
  //           content: Container(
  //             // width: MediaQuery.of(context).size.width / 1.2,
  //             height:50,
  //             color: UIColor.baseColorWhite,
  //             child: Center(
  //               child: Row(
  //                 children: [
  //                   CircularProgressIndicator(),
  //                   Text("   Fetching Information..",
  //                     style: TextStyle(
  //                         fontSize: 18,
  //                         fontFamily: FontStrings.Fieldwork10_Regular
  //                     ),)
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       }
  //   );
  //
  // }

  Future<void> lodingDialog() async {
    Get.dialog(
        AlertDialog(
          content:CircularProgressIndicator(),
        )
    );
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return CustomAlertDialog(
    //         content: Container(
    //           // width: MediaQuery.of(context).size.width / 1.2,
    //           height: 50,
    //           color: UIColor.baseColorWhite,
    //           child: Center(
    //             child: Row(
    //               children: [
    //                 CircularProgressIndicator(),
    //                 Text(
    //                   "   Fetching Information..",
    //                   style: TextStyle(
    //                       fontSize: 18,
    //                       fontFamily: FontStrings.Fieldwork10_Regular),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     });
  }

  Future<void> _loginRemove() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('signIn', 'false');
    prefs.setString('service_added', 'No');
    Get.offAll(SignIn());
  }
  Future<void> _getRole() async{
    final prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role');
  }
}

