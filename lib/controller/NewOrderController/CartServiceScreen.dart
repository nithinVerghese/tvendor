import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/model/AddToCart.dart';
import 'package:takhlees_v/model/NameListModel.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:takhlees_v/widget/dialogBox/optionalDialog.dart';
import 'package:takhlees_v/widget/snackBar.dart';

import 'AddToCartController.dart';
import 'DeleteCartController.dart';


// ignore: must_be_immutable
class CartServiceScreen extends StatefulWidget {
  final List servicesModel;
  const CartServiceScreen(this.servicesModel);

  @override
  _CartServiceScreenState createState() => _CartServiceScreenState();
}

class _CartServiceScreenState extends State<CartServiceScreen> {

  bool checkBoxExpressValue = false;

  var serviceNameEn;
  var serviceId;
  var serviceNameAr;
  var serviceFee;
  var serviceType;
  var governmentFee;
  var serviceTime;
  var quantity;
  var expressServiceFee;
  var expressService;
  var expressServiceTime;
  var expressSelected;
  var documents;
  var showExpressService;
  var needName;
  var maxQuantity;
  var selectedLanguage;

  var nameList = [];

  var nameListModel = NameListModel();

  // VendorDetailsSingleton sVendorDetail = new VendorDetailsSingleton();

  bool numberExist = false;
  bool numberNotAdded = false;

  var isNameExist = false;


  Future<void> _selectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    selectedLanguage = prefs.getString('language');
    setState(() {});
    print('-------------$selectedLanguage');
  }

  @override
  void initState() {
    print('Express Service ----> ${widget.servicesModel[12]}');
    _selectedLanguage();
    serviceNameEn  = widget.servicesModel[0];
    serviceId = widget.servicesModel[1];
    serviceNameAr = widget.servicesModel[2];
    serviceFee = widget.servicesModel[3];
    serviceType = widget.servicesModel[4];
    governmentFee = widget.servicesModel[5];
    serviceTime = widget.servicesModel[6];
    documents = widget.servicesModel[7];
    quantity = widget.servicesModel[8];
    expressServiceFee = widget.servicesModel[9];
    expressService = widget.servicesModel[10];
    expressServiceTime = widget.servicesModel[11];
    expressSelected = widget.servicesModel[12];
    showExpressService = widget.servicesModel[13];
    needName = widget.servicesModel[14];
    maxQuantity = '${widget.servicesModel[15]}';
    print('maxQuantity : $maxQuantity');
    nameList = widget.servicesModel[16];

    //
    // print(''' ----------------------==
    // ------------------serviceNameEn = $serviceNameEn,
    // ------------------serviceId = $serviceId,
    // ------------------serviceNameAr = $serviceNameAr,
    // ------------------serviceFee = $serviceFee,
    // ------------------serviceType = $serviceType,
    // ------------------governmentFee = $governmentFee,
    // ------------------serviceTime = $serviceTime,
    // ------------------documents = documents,
    // ------------------quantity = $quantity,
    // ------------------expressServiceFee = $expressServiceFee,
    // ------------------expressService = $expressService,
    // ------------------expressServiceTime = $expressServiceTime,
    // ''');

    // print('-----------${sVendorDetail.nationalType}');

    setState(() {
      checkBoxExpressValue = widget.servicesModel[12] == 'Yes'? true:false;
      _counter = widget.servicesModel[8];
    });
    super.initState();
  }

  void displayDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Alert"),
        content: new Text("My alert message"),
        actions: [
          CupertinoDialogAction(
              isDefaultAction: false, child: new Text("Close"))
        ],
      ),
    );
  }

  final addToCart = AddToCartController();
  final deleteCart = DeleteCartController();

  int _counter = 0;
  String isServicePresent = "";
  var dataModel = <AddToCart>[];

  _multi(context){
    return MediaQuery.of(context).size.height * 0.01;
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {

    bool _delivery;
    //serviceType

    if(widget.servicesModel[4] == 'Needs delivery'){
      _delivery = true;
    }else{
      _delivery = false;
    }
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        brightness: Brightness.light,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded,
                color: Color(0xff212156),),
              onPressed: () {
                print('---------> qty : ${widget.servicesModel[8]}');
                print('---------> count : $_counter');

                if(widget.servicesModel[8] <= 0 || widget.servicesModel[8] == _counter){
                  Navigator.pop(context,true);
                  // if(_counter > 0){
                  //   hitDeleteCart(serviceId);
                  // }else{
                  //   Navigator.pop(context,true);
                  // }
                }else{
                  print('---------> back : ${widget.servicesModel[8]}');
                  if(widget.servicesModel[8] < _counter){
                    Navigator.pop(context,true);
                  }else{
                    if(_counter != 0){
                      needName == 'Yes'? hitAddToCart(serviceId,_counter,"No",nameList):hitAddToCart(serviceId,_counter,"No","");
                    }else{
                      hitDeleteCart(serviceId);
                    }

                  }
                }

                // if(_counter >= widget.servicesModel[8]){
                //   print('---------> back');
                // }else if(_counter == widget.servicesModel[8]){
                //   print('---------> back');
                // }else if(widget.servicesModel[8]){
                //
                // }

                // if(_counter == 0){
                //   hitDeleteCart(serviceId);
                // }else{
                //   Navigator.pop(context,true);
                // }
              },
            );
          },
        ),

        // Icon(Icons.arrow_back_ios_rounded,
        //     color: Color(0xff212156),),
        backgroundColor: Colors.white,
        title: Text(widget.servicesModel[0],
          style: TextStyle(
            color: Color(0xff212156),
          ),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        print('############# ${widget.servicesModel[11]} 00000000000  ${widget.servicesModel[12]} ');
                      },
                      child: _servicePrice(_delivery)),
                  // widget.servicesModel[10] == 'Yes'
                  //     ? _expressService(widget.servicesModel[11])
                  //     : Container(),
                  _title(),

                  _documentRequired(),

                  // if (_delivery) _notes() else Container(),
                  needName == 'Yes'?
                  addItem(true):addItem(false),
                ],
              ),
              SizedBox(height: 20,),
              _footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _servicePrice(bool delivery){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10)),
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            widget.servicesModel[0] != 'Pickup Extra Documents'?Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0),
                        child: Text(
                          "Service fees".tr,
                          style: TextStyle(
                              fontSize: Dimens.space16 *
                                  _multi(context),
                              fontFamily: FontStrings
                                  .Roboto_Regular,
                              color: Color(0xFF404243)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Text(
                        "BHD ${widget.servicesModel[3]}",
                        style: TextStyle(
                            fontSize: Dimens.space16 *
                                _multi(context),
                            fontFamily:
                            FontStrings.Roboto_Bold,
                            color: Color(0xFF212156)),
                      ),
                    )
                  ],
                ),
              ),
            ):Container(),
            widget.servicesModel[0] != 'Pickup Extra Documents'?Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0),
                        child: Text(
                          "Government fees",
                          style: TextStyle(
                              fontSize: Dimens.space16 *
                                  _multi(context),
                              fontFamily: FontStrings
                                  .Roboto_Regular,
                              color: Color(0xFF404243)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Text(
                        "BHD ${widget.servicesModel[5]}",
                        style: TextStyle(
                            fontSize: Dimens.space16 *
                                _multi(context),
                            fontFamily:
                            FontStrings.Roboto_Bold,
                            color: Color(0xFF212156)),
                      ),
                    )
                  ],
                ),
              ),
            ):Container(),
            widget.servicesModel[0] != 'Pickup Extra Documents'?Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0),
                        child: Text(
                          "Estimated service time",
                          style: TextStyle(
                              fontSize: Dimens.space16 *
                                  _multi(context),
                              fontFamily: FontStrings
                                  .Roboto_Regular,
                              color: Color(0xFF404243)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Text(
                        "${widget.servicesModel[6]} Days",
                        style: TextStyle(
                            fontSize: Dimens.space16 *
                                _multi(context),
                            fontFamily:
                            FontStrings.Roboto_Bold,
                            color: Color(0xFF212156)),
                      ),
                    )
                  ],
                ),
              ),
            ):Container(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0),
                            child: Text(
                              "Service type",
                              style: TextStyle(
                                  fontSize: Dimens.space16 *
                                      _multi(context),
                                  fontFamily: FontStrings
                                      .Roboto_Regular,
                                  color: Color(0xFF404243)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8,top: 5),
                            child: GestureDetector(
                              onTap: (){
                                serviceTypesDialog();
                              },
                              child: Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFF5D5F61),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if(widget.servicesModel[4] != "No delivery needed")Text(
                      "${widget.servicesModel[4]}",
                      style: TextStyle(
                          fontSize: Dimens.space16*
                              _multi(context),
                          fontFamily:
                          FontStrings.Roboto_Bold,
                          color: Color(0xFFF15B29)),
                    )else Text(
                      "${widget.servicesModel[4]}",
                      style: TextStyle(
                          fontSize: Dimens.space16*
                              _multi(context),
                          fontFamily:
                          FontStrings.Roboto_Bold,
                          color: Colors.teal),
                    ),
                    if(widget.servicesModel[4] != "No delivery needed")Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.circle,
                        color: Color(0xFFF15B29),
                        size: 12,
                      ),
                    )else Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.circle,
                        color: Colors.teal,
                        size: 12,
                      ),
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

  Widget _title(){
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 12.0),
                child: Text(
                  "REQUIRED DOCUMENTS",
                  style: TextStyle(
                      fontSize: Dimens.space16 *
                          _multi(context),
                      fontFamily: FontStrings
                          .Roboto_SemiBold,
                      color: Color(0xFF888B8D)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(),
            )
          ],
        ),
      ),
    );
  }
  Widget _titleWithButton(String title){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 12.0),
                child: Text(
                  "$title",
                  style: TextStyle(
                      fontSize: Dimens.space16 *
                          _multi(context),
                      fontFamily: FontStrings
                          .Roboto_SemiBold,
                      color: Color(0xFF888B8D)),
                ),
              ),
            ),
            _counter == 0?Container():SvgPicture.asset(
              'assets/add.svg',
              color: UIColor.darkBlue,
              allowDrawingOutsideViewBox: true,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.0),
            )
          ],
        ),
      ),
    );
  }
  Widget _documentRequired(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10)),
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(widget.servicesModel[7].length, (index){
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/document.svg',
                        color: UIColor.darkBlue,
                        allowDrawingOutsideViewBox: true,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16),
                      ),
                      Text(
                        "${widget.servicesModel[7][index]}",
                        style: TextStyle(
                            fontSize: Dimens.space16 *
                                _multi(context),
                            fontFamily: FontStrings
                                .Roboto_Regular,
                            color: Color(0xFF404243)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          // [
          //   Padding(
          //     padding: const EdgeInsets.all(10.0),
          //     child: Container(
          //       child: Padding(
          //         padding: const EdgeInsets.only(
          //             left: 12.0),
          //         child: Text(
          //           "Original passport",
          //           style: TextStyle(
          //               fontSize: Dimens.space16 *
          //                   _multi(context),
          //               fontFamily: FontStrings
          //                   .Roboto_Regular,
          //               color: Color(0xFF404243)),
          //         ),
          //       ),
          //     ),
          //   ),
          //   Padding(
          //     padding: const EdgeInsets.all(10.0),
          //     child: Container(
          //       child: Padding(
          //         padding: const EdgeInsets.only(
          //             left: 12.0),
          //         child: Text(
          //           "Original CPR",
          //           style: TextStyle(
          //               fontSize: Dimens.space16 *
          //                   _multi(context),
          //               fontFamily: FontStrings
          //                   .Roboto_Regular,
          //               color: Color(0xFF404243)),
          //         ),
          //       ),
          //     ),
          //   ),
          // ],
        ),
      ),
    );
  }


  Widget qty(){
    return Column(
      children: [
        SizedBox(height: 50,),
        Container(
          child: Text('Service qty.',style: Theme.of(context).textTheme.bodyText2.copyWith(color: Color(0xff707375),fontFamily: FontStrings.Roboto_Regular)),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  _decrementCounter();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.remove_circle_outline_outlined,
                    color: Color(0xFF707375),
                    size: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text("$_counter",style: TextStyle(
                  fontFamily: FontStrings.Fieldwork16_Bold,
                  color: Color(0xFF212156),
                  fontSize:  Dimens.space24 * _multi(context),
                ),),
              ),
              GestureDetector(
                onTap: (){
                  print('maxQuantity : $maxQuantity\ncount : $_counter');
                  if(maxQuantity == 0){
                    _incrementCounter();
                  }else{
                    if(_counter < int.parse(maxQuantity)){
                      _incrementCounter();
                    }else{
                      getSnackBar(null, "Maximum quantity is $maxQuantity");
                    }
                  }


                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Color(0xFF707375),
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



  Widget _nameList(bool hasItem){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            print('---- maxQuantity: $maxQuantity');
            if(maxQuantity == 0 || maxQuantity == '0'){
              optionalDialog("Add applicant".tr,(){
              },(){ print('''
                       isNameExist = $isNameExist
                         numberExist = $numberExist
                         numberNotAdded = $numberNotAdded
                       ''');
              setState(() {
                isNameExist = false;
                numberExist = false;
                numberNotAdded = false;
              });

              print('''
                       isNameExist = $isNameExist
                         numberExist = $numberExist
                         numberNotAdded = $numberNotAdded
                       ''');
              Get.back();});
            }else{
              if(_counter <= int.parse(maxQuantity)){
                optionalDialog("Add applicant".tr,(){
                },(){Get.back();});
              }else{
                getSnackBar(null, "Maximum quantity is $maxQuantity");
              }
            }
          },
            child: _titleWithButton("Add applicant for this service")
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
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
                child:
                nameList.length > 0 ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: List.generate(nameList.length, (index) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text("${index + 1}.",
                                style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontFamily: FontStrings.Roboto_Regular,
                                  color: Color(0xff404243)
                              ),),
                            ),
                            Expanded(child: Text("${nameList[index]['name']}",
                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontFamily: FontStrings.Roboto_Regular,
                                  color: Color(0xff404243)
                              ),
                            )
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                            Text("${nameList[index]['doc_number']}",style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontFamily: FontStrings.Roboto_Regular,
                                color: Color(0xff404243)
                            ),
                            ),
                            // Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                            // GestureDetector(
                            //   onTap: (){
                            //
                            //   },
                            //   child: Container(
                            //     height: 20,
                            //     width: 20,
                            //     child: SvgPicture.asset(
                            //       'assets/edit.svg',
                            //       color: UIColor.baseColorTeal,
                            //       allowDrawingOutsideViewBox: true,
                            //     ),
                            //   ),
                            // ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  nameList.removeAt(index);
                                  _counter = nameList.length;
                                });
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Icon(
                                              Icons.remove_circle,
                                              color: Colors.red,
                                              size: 20,
                                            ),

                                            // SvgPicture.asset(
                                            //   'assets/delete.svg',kjljkl
                                            //   color: UIColor.baseGradientDar,
                                            //   allowDrawingOutsideViewBox: true,
                                            // ),
                                          ),
                                        ),
                          ],
                        ),
                      )),
                    ),
                  ):
                 GestureDetector(
                   onTap: (){
                     optionalDialog("Add applicant".tr,(){},(){

                       print('''
                       isNameExist = $isNameExist
                         numberExist = $numberExist
                         numberNotAdded = $numberNotAdded
                       ''');
                       setState(() {
                         isNameExist = false;
                         numberExist = false;
                         numberNotAdded = false;
                       });

                       print('''
                       isNameExist = $isNameExist
                         numberExist = $numberExist
                         numberNotAdded = $numberNotAdded
                       ''');
                       Get.back();

                     });
                   },
                   child: Column(
                    children: [
                      SizedBox(height: 13,),
                      SvgPicture.asset(
                        'assets/add.svg',
                        allowDrawingOutsideViewBox: true,
                          color: Color(0xff2F80ED)
                      ),
                      SizedBox(height: 10,),
                      Text(
                        'Add the applicant for this service'.tr,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontFamily: selectedLanguage == 'en'? FontStrings.Roboto_Regular:FontStrings.Tajawal_Regular,
                            color: Color(0xff2F80ED)
                        ),
                      ),
                      SizedBox(height: 13,),
                    ],
                ),
                 ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget addItem(bool name){
    return Column(
      children: [
        name?_nameList(true):
        qty(),
      ],
    );
  }

  void optionalDialog(var title,Function onYesPressed, Function onNoPressed){
    final nameCon = new TextEditingController();
    final docNumber = new TextEditingController();
    FocusNode _focusNode1  = FocusNode();
    FocusNode _focusNode2  = FocusNode();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
          return KeyboardActions(
            config: KeyboardActionsConfig(
                actions: [
                  KeyboardActionsItem(focusNode: _focusNode1),
                  KeyboardActionsItem(focusNode: _focusNode2),
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
                        margin: EdgeInsets.all(50),
                        child: Container(
                            padding: EdgeInsets.only(left: 0,right: 0,top: 20,bottom: 0),
                            decoration: BoxDecoration(
                              color: Color(0xFFEFEFEF),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 8,),
                                Padding(
                                  padding: const EdgeInsets.only(left:16.0,right: 16),
                                  child: Text('$title',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16,),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black12, style: BorderStyle.solid, width: 0.5),
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  padding: const EdgeInsets.only(left:16.0,right: 16),
                                  child: TextField(
                                    controller: nameCon,
                                    focusNode:_focusNode1,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    cursorColor: Color(0xff0A95A0),
                                    decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'Name'),
                                    style: TextStyle(
                                      color: Color(0xff212156),
                                      fontFamily: FontStrings.Roboto_Regular,
                                    ),
                                  ),
                                ),
                                isNameExist?Container(
                                  margin: EdgeInsets.symmetric(horizontal: 22,vertical: 5),
                                  child: Row(
                                    children: [
                                      Text('* Enter Name',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.red[900],
                                            fontFamily: FontStrings.Roboto_Regular,
                                          )),
                                    ],
                                  ),
                                ):Container(),
                                SizedBox(height: 16,),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black12, style: BorderStyle.solid, width: 0.5),
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  padding: const EdgeInsets.only(left:16.0,right: 16),
                                  child:TextField(
                                    controller: docNumber,
                                    focusNode:_focusNode2,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    cursorColor: Color(0xff0A95A0),
                                    decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: 'ID Number'),
                                    style: TextStyle(
                                      color: Color(0xff212156),
                                      fontFamily: FontStrings.Roboto_Regular,
                                    ),
                                  ),
                                ),
                                numberExist ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 22,vertical: 5),
                                  child: Row(
                                    children: [
                                      Text('* ID Number already exist',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.red[900],
                                            fontFamily: FontStrings.Roboto_Regular,
                                          )),
                                    ],
                                  ),
                                ):Container(),
                                numberNotAdded ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 22,vertical: 5),
                                  child: Row(
                                    children: [
                                      Text('* Add number',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.red[900],
                                            fontFamily: FontStrings.Roboto_Regular,
                                          )),
                                    ],
                                  ),
                                ):Container(),
                                SizedBox(height: 20,),
                                Container(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: onNoPressed,
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
                                              "No",
                                              style: TextStyle(
                                                  color: Color(0xFF007AFF),
                                                  fontSize:20),
                                            ),
                                            padding: EdgeInsets.only(top:20,bottom: 20),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: (){
                                            // if(nameList.length > 0){
                                            //   // print('--------> ${nameList[1]['doc_number']}');
                                            //   for(int i = 0; i < nameList.length ; i++){
                                            //     print('-----------${nameList[i]['doc_number']}');
                                            //     if(nameList[i]['doc_number'].e)
                                            //   }
                                            // }
                                            Map<String, String> map = {'name': '${nameCon.text}', 'doc_number': '${docNumber.text}'};

                                            var docNumberList =[];
                                            nameList.forEach((element) {
                                              docNumberList.add(element['doc_number']);
                                            });

                                            var dummy_name = nameCon.text;
                                            dummy_name = dummy_name.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
                                            dummy_name = dummy_name.replaceAll(' ', "");
                                            dummy_name = dummy_name.replaceAll('  ', "");
                                            dummy_name = dummy_name.replaceAll('   ', "");
                                            dummy_name = dummy_name.replaceAll('    ', "");
                                            dummy_name = dummy_name.replaceAll('     ', "");
                                            dummy_name = dummy_name.replaceAll('      ', "");
                                            dummy_name = dummy_name.replaceAll('       ', "");

                                            // dummy_name.trim();

                                            print('====> dummy_name $dummy_name ${dummy_name.length}');

                                            if(docNumber.text.isNotEmpty){
                                              numberNotAdded = false;
                                              if(maxQuantity == 0 || maxQuantity == '0'){
                                                if(dummy_name.isNotEmpty && docNumber.text.isNotEmpty){
                                                  isNameExist = false;
                                                  if(docNumberList.contains(docNumber.text)){
                                                    print("duplicate ");
                                                    setState(() {
                                                      numberExist = true;
                                                    });
                                                  }else{
                                                    setState(() {
                                                      numberExist = false;
                                                    });
                                                    nameList.add(map);
                                                    _counter++;
                                                    print(jsonEncode(nameList));
                                                    Get.back();
                                                  }
                                                }else{
                                                  setState(() {
                                                    isNameExist = true;
                                                    // numberNotAdded = true;
                                                  });
                                                }
                                              }else{
                                                if(dummy_name.isNotEmpty && docNumber.text.isNotEmpty){
                                                  isNameExist = false;
                                                  if(docNumberList.contains(docNumber.text)){
                                                    print("duplicate ");
                                                    setState(() {
                                                      numberExist = true;
                                                    });
                                                  }else{
                                                    setState(() {
                                                      numberExist = false;
                                                    });
                                                    if(_counter > int.parse(maxQuantity)){
                                                      // getSnackBar(null, "Maximum quantity is $maxQuantity");
                                                      Get.back();
                                                      Get.snackbar(null,
                                                          "Maximum quantity is $maxQuantity",
                                                          backgroundColor: Color(
                                                              0xBAC60000),
                                                          colorText: Colors.white);
                                                    }else{
                                                      nameList.add(map);
                                                      _counter++;
                                                      print(jsonEncode(nameList));
                                                      Get.back();
                                                    }

                                                  }
                                                }else{
                                                  setState(() {
                                                    isNameExist = true;
                                                  });
                                                }
                                              }
                                            }else{
                                              setState(() {
                                                numberNotAdded = true;
                                              });
                                            }
                                            






                                            // nameList.forEach((u){
                                            //   if (names.contains(u['doc_number'])) print("duplicate ${u["name"]}");
                                            //   else {
                                            //     names.add(u['doc_number']);
                                            //     Map<String, String> map = {'name': '${nameCon.text}', 'doc_number': '${docNumber.text}'};
                                            //     nameList.add(map);
                                            //     _counter++;
                                            //     print(jsonEncode(nameList));
                                            //     Get.back();
                                            //   }
                                            // });
                                            // print("-------------------------${jsonEncode(names)}");

                                            // Map<String, String> map = {'name': '${nameCon.text}', 'doc_number': '${docNumber.text}'};
                                            //
                                            // nameList.add(map);
                                            // _counter++;
                                            // print(jsonEncode(nameList));
                                            // Get.back();
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
                                              "Yes",
                                              style: TextStyle(
                                                  color: Color(0xFF007AFF),
                                                  fontSize:20,
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
        });

      },
    );
  }

  Widget _footer(){
    return Column(
      children: [
        SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RaisedGradientButton(
              child: Text(
                'Add to Order',
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
                print('-------serviceId = $serviceId,\n_counter = $_counter,\ncheckBoxExpressValue = $checkBoxExpressValue');
                if(widget.servicesModel[8] == 0 && _counter == 0){
                  Get.snackbar(null,
                      'Add item to continue',
                      snackPosition:SnackPosition.BOTTOM,
                      backgroundColor: Colors.black54,
                      colorText: Colors.white);
                } else
                if(_counter == 0 && widget.servicesModel[8] > 0){
                  hitDeleteCart(serviceId);
                }else{
                  needName == 'Yes'? hitAddToCart(serviceId,_counter,"No",nameList):hitAddToCart(serviceId,_counter,"No","");
                }

                // displayDialog();
              }),
        ),
      ],
    );
  }

  Widget _notes(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFD8EEF0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Wrap(
              children: [
                Text("You must ensure that the required documents are ready for pickup before the driver arrives. Our drivers will provide sealed envelopes for your documents.",
                  style: TextStyle(
                      fontSize: Dimens.space14 * _multi(context),
                      fontFamily: FontStrings.Roboto_Regular,
                      color: Colors.teal
                  ),),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    if (_counter != 0) {
      setState(() {
        _counter--;
      });
    }
  }

  // void serviceTypesDialog(context){
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return CustomAlertDialog(
  //           content: Container(
  //             // width: MediaQuery.of(context).size.width / 1.2,
  //             height: MediaQuery
  //                 .of(context)
  //                 .size
  //                 .height / 2.5,
  //             color: UIColor.baseColorWhite,
  //             child: Center(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     "Service Types",
  //                     style: TextStyle(
  //                         fontFamily: FontStrings.Fieldwork10_Regular,
  //                         fontSize: Dimens.space28 * _multi(context),
  //                         color: UIColor.darkBlue),
  //                   ),
  //                   SizedBox(
  //                     height: Dimens.space24 * _multi(context),
  //                   ),
  //                   Row(
  //                     children: [
  //                       Container(
  //                         padding: EdgeInsets.all(5),
  //                         decoration: new BoxDecoration(
  //                           shape: BoxShape.circle,// You can use like this way or like the below line
  //                           //borderRadius: new BorderRadius.circular(30.0),
  //                           color:Color(0xffF15B29),
  //                         ),
  //                       ),
  //                       Container(
  //                           padding: EdgeInsets.only(left: 10),
  //                           child: Text("Needs delivery",style: TextStyle(
  //                             fontFamily: FontStrings.Roboto_Regular,
  //                             color: Color(0xffF15B29),
  //                           ),)),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: Dimens.space10 * _multi(context),
  //                   ),
  //                   Text("A driver will pick up all required physical documents from you. Please ensure you have those documents ready.",style: TextStyle(
  //                     fontFamily: FontStrings.Roboto_Regular,
  //                   ),),
  //                   SizedBox(
  //                     height: Dimens.space10 * _multi(context),
  //                   ),
  //                   Row(
  //                     children: [
  //                       Container(
  //                         padding: EdgeInsets.all(5),
  //                         decoration: new BoxDecoration(
  //                           shape: BoxShape.circle,// You can use like this way or like the below line
  //                           //borderRadius: new BorderRadius.circular(30.0),
  //                           color:UIColor.baseColorTeal,
  //                         ),
  //                       ),
  //                       Container(
  //                           padding: EdgeInsets.only(left: 10),
  //                           child: Text("No delivery needed",style: TextStyle(
  //                             fontFamily: FontStrings.Roboto_Regular,
  //                             color: UIColor.baseColorTeal,
  //                           ),)),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: Dimens.space10 * _multi(context),
  //                   ),
  //                   Text("You will NOT need to arrange a pickup for any physical documents. You may share them in Chat with the service provider.",style: TextStyle(
  //                     fontFamily: FontStrings.Roboto_Regular,
  //                   ),),
  //                   SizedBox(
  //                     height: Dimens.space14 * _multi(context),
  //                   ),
  //                   RaisedGradientButton(
  //                     height: Dimens.space50 * _multi(context),
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     gradient: LinearGradient(
  //                       colors: <Color>[
  //                         Color(0xffC1282D),
  //                         Color(0xffF15B29)
  //                       ],
  //                     ),
  //                     child: Text(
  //                       "Continue",
  //                       style: TextStyle(
  //                           color: Colors.white,
  //                           fontFamily: FontStrings.Fieldwork10_Regular,
  //                           fontSize: Dimens.space16 * _multi(context)),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }
  void serviceTypesDialog() {
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
                      margin: EdgeInsets.all(56),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          color: UIColor.baseColorWhite,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: Container(
                            // width: MediaQuery.of(context).size.width / 1.2,
                            height: MediaQuery.of(context).size.height / 2.8,
                            color: UIColor.baseColorWhite,
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Service Types",
                                    style: TextStyle(
                                        fontFamily: FontStrings.Fieldwork10_Regular,
                                        fontSize: Dimens.space28 * _multi(context),
                                        color: UIColor.darkBlue),
                                  ),
                                  Expanded(
                                    child:  Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                // You can use like this way or like the below line
                                                //borderRadius: new BorderRadius.circular(30.0),
                                                color: Color(0xffF15B29),
                                              ),
                                            ),
                                            Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text(
                                                  "Needs delivery",
                                                  style: TextStyle(
                                                    fontSize: Dimens.space12 * _multi(context),
                                                    fontFamily: FontStrings.Roboto_Bold,
                                                    color: Color(0xffF15B29),
                                                  ),
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: Dimens.space10 * _multi(context),
                                        ),
                                        Text(
                                          "A driver will pick up all required physical documents from you. Please ensure you have those documents ready.",
                                          style: TextStyle(
                                              fontFamily: FontStrings.Roboto_Regular,
                                              fontSize: Dimens.space14 * _multi(context),
                                              color: Color(0xFF404243)),
                                        ),
                                        SizedBox(
                                          height: Dimens.space16 * _multi(context),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                // You can use like this way or like the below line
                                                //borderRadius: new BorderRadius.circular(30.0),
                                                color: UIColor.baseColorTeal,
                                              ),
                                            ),
                                            Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text(
                                                  "No delivery needed",
                                                  style: TextStyle(
                                                    fontFamily: FontStrings.Roboto_Bold,
                                                    fontSize: Dimens.space12 * _multi(context),
                                                    color: UIColor.baseColorTeal,
                                                  ),
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: Dimens.space10 * _multi(context),
                                        ),
                                        Text(
                                          "You will NOT need to arrange a pickup for any physical documents. You may share them in Chat with the service provider.",
                                          style: TextStyle(
                                              fontFamily: FontStrings.Roboto_Regular,
                                              fontSize: Dimens.space14 * _multi(context),
                                              color: Color(0xFF404243)),
                                        ),
                                        SizedBox(
                                          height: Dimens.space14 * _multi(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RaisedGradientButton(
                                    height: Dimens.space50 * _multi(context),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // dialogStatus.setStatus(true);
                                    },
                                    gradient: LinearGradient(
                                      colors: <Color>[Color(0xffC1282D), Color(0xffF15B29)],
                                    ),
                                    child: Text(
                                      "Continue",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: FontStrings.Fieldwork10_Regular,
                                          fontSize: Dimens.space16 * _multi(context)),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        );
      },
    );
  }

  Widget _expressService(var date){
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0.3,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left:24.0,right: 24.0),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/truck.svg',
                color: UIColor.darkBlue,
                allowDrawingOutsideViewBox: true,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Express Service",
                        style: TextStyle(
                          fontFamily: FontStrings.Roboto_Regular,
                          fontSize: Dimens.space16 * _multi(context),
                          color: Color(0xFF212156),
                        ),),
                      SizedBox(height: 5,),
                      Text("Est. time:  $date days delivery",
                        style: TextStyle(
                          fontFamily: FontStrings.Roboto_Regular,
                          fontSize: Dimens.space12 * _multi(context),
                          color: Color(0xFF4D4F51),
                        ),),
                    ],
                  ),
                ),
              ),

              GestureDetector(
                onTap: (){
                  if(checkBoxExpressValue){
                    checkBoxExpressValue=false;
                    setState(() {});
                  }else{
                    checkBoxExpressValue = true;
                    setState(() {});
                  }

                },
                child: SvgPicture.asset(
                  checkBoxExpressValue == true ?'assets/check.svg':'assets/uncheck.svg',
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ],
          ),
        )
    );
  }

  void hitAddToCart(String vendorServiceID, var quantity, var expressDelivery,var nameList){
    showLoading('');
    // addToCart.fetchServices(widget.servicesModel[1].toString(), _counter.toString()).
   String jsonNameList = jsonEncode(nameList);
    var exp = expressDelivery.toString() == 'false'?'No':'Yes';
    print('----------- vendorServiceID = $vendorServiceID,\nquantity = $quantity,\nexpressDelivery = $expressDelivery');

    print('----------------------- expressDelivery =    $exp');
    addToCart.fetchServices(vendorServiceID.toString(), quantity.toString(),exp,jsonNameList).
    then((result) {
      hideLoading();
      if (result["status"] == true) {
        Navigator.pop(context, 'true');
        isServicePresent = result["message"];
        setState(() {
        });
        // snackBar(_scaffoldKey,SnackBarBehavior.floating, isServicePresent, false, 'Retry', (){});
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
      }else{
        isServicePresent = result["message"];
        setState(() {
        });
        Get.snackbar(null,
            isServicePresent,
            snackPosition:SnackPosition.BOTTOM,
            backgroundColor: Colors.black54,
            colorText: Colors.white);
        // snackBar(_scaffoldKey,SnackBarBehavior.floating, isServicePresent, false, 'Retry', (){});
        // Fluttertoast.showToast(
        //     msg: isServicePresent,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIos: 1,
        //     backgroundColor: Colors.black45,
        //     textColor: Colors.white);
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      setState(() {
      });
      snackBar(_scaffoldKey,SnackBarBehavior.floating, isServicePresent, true, 'Retry', (){
        // hitAddToCart(serviceId,_counter,checkBoxExpressValue);
      });
    });
  }

  void hitDeleteCart(String vendorServiceID){
    showLoading('');
    // addToCart.fetchServices(widget.servicesModel[1].toString(), _counter.toString()).

    print('----------------------- vendorServiceID = $vendorServiceID  ');
    deleteCart.fetchServices(vendorServiceID).
    // addToCart.fetchServices(vendorServiceID.toString(), quantity.toString(),exp).
    then((result) {
      hideLoading();
      if (result["status"] == true) {
        Navigator.pop(context, 'true');
        isServicePresent = result["message"];
        setState(() {
        });
        // snackBar(_scaffoldKey,SnackBarBehavior.floating, isServicePresent, false, 'Retry', (){});
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
      }else{
        isServicePresent = result["message"];
        setState(() {
        });
        Get.snackbar(null,
            isServicePresent,
            snackPosition:SnackPosition.BOTTOM,
            backgroundColor: Colors.black54,
            colorText: Colors.white);
        // snackBar(_scaffoldKey,SnackBarBehavior.floating, isServicePresent, false, 'Retry', (){});
        // Fluttertoast.showToast(
        //     msg: isServicePresent,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIos: 1,
        //     backgroundColor: Colors.black45,
        //     textColor: Colors.white);
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      setState(() {
      });
      snackBar(_scaffoldKey,SnackBarBehavior.floating, isServicePresent, true, 'Retry', (){
        // hitAddToCart(serviceId,_counter,checkBoxExpressValue);
      });
    });
  }

}