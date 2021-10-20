import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/controller/ServiceAddControlleer.dart';
import 'package:takhlees_v/controller/ServiceControlleer.dart';
import 'package:takhlees_v/controller/ServiceDeleteControlleer.dart';
import 'package:takhlees_v/controller/VendorServiceControlleer.dart';
import 'package:takhlees_v/controller/VendorServiceCategoryController.dart';
import 'package:takhlees_v/model/CategoryModel.dart';
import 'package:takhlees_v/model/ServiceModel.dart';
import 'package:takhlees_v/model/VendorServiceModel.dart';
import 'package:takhlees_v/view/HomeScreen/OrderBottomBarIndex.dart';
import 'package:takhlees_v/view/VendorService/VendorService.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:takhlees_v/widget/snackBar.dart';

class ManageExpatTabBar extends StatefulWidget {

  @override
  _ManageExpatTabBarState createState() => _ManageExpatTabBarState();
}

class _ManageExpatTabBarState extends State<ManageExpatTabBar>
    with TickerProviderStateMixin {

  final vendorServiceCategory = VendorServiceCategoryController();
  var vendorCategoryModel = List<CategoryResult>();
  final services = Get.put(ServiceController());
  final deleteServices = Get.put(ServiceDeleteController());
  final addServices = Get.put(ServiceAddController());

  var dataModel = List<ServiceResult>();
  var originalDataModel = List<ServiceResult>();

  String isServicePresent;
  String isServicePresent1;
  int tabLength;

  Map<String, bool> expandMap = new HashMap();
  List expandArray = [];

  Map<String, bool> expandMapOriginel = new HashMap();
  List expandArrayOriginel = [];
  TabController _nestedTabController;
  bool express = false;
  String expressTime = "1 day";
  final amountCon = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _nestedTabController =  TabController(length: 4, vsync: this);
    vendorServiceCategory.fetchServices('Clearance documents').then(
            (result) {
          if (result["status"] == true) {
            isServicePresent = "";
            print('======${result["status"]}');
            print('======${result["message"]}');
            vendorCategoryModel = CategoryModel.fromJson(result).results;
            print('vendorCategoryModel : ${vendorCategoryModel.length}');
            tabLength = vendorCategoryModel.length;
            _nestedTabController =  TabController(length: vendorCategoryModel.length, vsync: this);
            setState(() {});
            _hitApiServices(0);
            _nestedTabController.addListener(() {
              _hitApiServices(_nestedTabController.index);
            });
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

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: vendorCategoryModel.length != 0
                  ? TabBar(
                      controller: _nestedTabController,
                      isScrollable: true,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.black,
                      labelStyle:
                          Theme.of(context).textTheme.bodyText2.copyWith(
                                fontFamily: FontStrings.Roboto_Bold,
                              ),
                      labelColor: UIColor.darkBlue,
                      tabs: List<Widget>.generate(vendorCategoryModel.length,
                          (int index) {
                        return new Tab(
                          // text: servicesModel[index].nameEn,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(vendorCategoryModel[index].nameEn),
                            ],
                          ),
                        );
                      }))
                  : Container(
                      height: 0,
                      child: TabBar(
                        controller: _nestedTabController,
                        isScrollable: true,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.transparent,
                        labelStyle:
                            Theme.of(context).textTheme.bodyText2.copyWith(
                                  fontFamily: FontStrings.Roboto_Bold,
                                ),
                        // labelColor: UIColor.darkBlue,
                        tabs: <Widget>[
                          Tab(
                            text: "",
                          ),
                          Tab(
                            text: "",
                          ),
                          Tab(
                            text: "",
                          ),
                          Tab(
                            text: "",
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Container(
            // height: screenHeight * 0.70,
            margin: EdgeInsets.only(left: 1.0, right: 1.0),
            child: vendorCategoryModel.length != 0 ?
            _tabView(context):
            TabBarView(
              controller: _nestedTabController,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.transparent,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.transparent,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.transparent,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left:18,right: 18,bottom: 18),
          child: RaisedGradientButton(
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white,fontFamily: FontStrings.Fieldwork10_Regular, fontSize: 16),
              ),
              gradient: LinearGradient(
                colors: <Color>[Color(0xffC1282D), Color(0xffF15B29)],
              ),
              onPressed: (){
                Get.back();
              }
          ),
        ),
      ],
    );
  }

  hitCategoryApi(){
    vendorServiceCategory.fetchServices('Clearance documents').then(
            (result) {
          if (result["status"] == true) {
            isServicePresent = "";
            print('======${result["status"]}');
            print('======${result["message"]}');
            vendorCategoryModel = CategoryModel.fromJson(result).results;
            print('vendorCategoryModel : ${vendorCategoryModel.length}');
            tabLength = vendorCategoryModel.length;
            _nestedTabController =  TabController(length: vendorCategoryModel.length, vsync: this);
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
  Widget _tabView(BuildContext context) {
    return TabBarView(
      controller: _nestedTabController,
      children: List<Widget>.generate(vendorCategoryModel.length, (int index) {
        return isServicePresent.length != 0 ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/emptyService.svg',
                allowDrawingOutsideViewBox: true,
              ),
              SizedBox(height: 20,),
              Text(isServicePresent,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontFamily: FontStrings.Roboto_Regular,
                  color: Color(0xFF707375),
                ),
              ),
            ],
          ),
        ):
        ListView.builder(
            shrinkWrap: true,
            itemCount: dataModel.length,
            itemBuilder: (context, index) {
              return dataModel[index].type == 1
                  ? Container(
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
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Container(
                    child: ListView.builder(
                        itemCount: dataModel[index].services.length,
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () async {
                              if(dataModel[index].services[i].serviceFee == null){
                                print('serviceNameEn => ${dataModel[index].services[i].serviceId.toString()}');
                                addServiceDialog(context,dataModel[index].services[i].serviceId.toString(),'Enter the service price',' Update passport number',(){
                                },(){
                                });
                              }else{
                                print('serviceNameEn +=> ${dataModel[index].services[i].serviceId.toString()}');
                                optionalDialog(context,'Delete','Do you want to delete the service.?',(){
                                  print('yes');
                                  _hitApiServicesDelete(dataModel[index].services[i].serviceId.toString());
                                  // Get.back();
                                },(){
                                  Get.back();
                                  print('no');
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  // left: 24,
                                  // right: 24,
                                  top: 12,
                                  bottom: 12),
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(),
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.only(left:8.0,right: 5),
                                        child: Icon(
                                          Icons.circle,
                                          color: dataModel[index]
                                              .services[i]
                                              .serviceType ==
                                              "No delivery needed"
                                              ? Colors.teal
                                              : Color(0xffF15B29),
                                          size: 12,
                                        ),
                                      )
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0,right: 12),
                                      child: Text(
                                        dataModel[index]
                                            .services[i]
                                            .serviceNameEn,
                                        style:
                                        Theme.of(context).textTheme.bodyText2.copyWith(
                                          fontFamily: FontStrings
                                              .Roboto_Regular,
                                            fontWeight: FontWeight.normal,
                                            color: UIColor.darkGrey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  dataModel[index].services[i].serviceFee != null?Padding(
                                    padding: const EdgeInsets.only(),
                                    child: Row(
                                      children: [
                                        dataModel[index].services[i].expressService == 'Yes'? SvgPicture.asset(
                                          'assets/truck.svg',
                                          allowDrawingOutsideViewBox: true,
                                        ):Container(),
                                        Text(
                                          "  "+"BHD ${dataModel[index].services[i].serviceFee}"+"  ",
                                          style:
                                          // TextStyle(
                                          //     fontSize: Dimens.space18 *
                                          //         _multi(context),
                                          //     fontFamily:
                                          //     FontStrings.Roboto_Bold,
                                          //     color: UIColor.darkBlue),

                                          Theme.of(context).textTheme.bodyText2.copyWith(
                                            fontFamily: FontStrings
                                                .Roboto_Bold,
                                            color: UIColor.darkBlue,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          'assets/delete.svg',color: Color(0xFFA0A2A4),
                                          allowDrawingOutsideViewBox: true,
                                        ),
                                      ],
                                    ),
                                  ):Icon(
                                    Icons.add_circle_outline,
                                    color: UIColor.darkBlue,
                                    size: 22,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ))
                  : Container(
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
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            expandArray[index][index.toString()] == true?
                            expandArray[index][index.toString()] = false:expandArray[index][index.toString()] = true;
                          });
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10,bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    dataModel[index].categoryNameEn,
                                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontFamily: FontStrings
                                          .Roboto_Bold,
                                      fontWeight: FontWeight.bold,
                                      color:  Color(0xFF404243),
                                    ),

                                  ),
                                ),
                                expandArray[index][index.toString()] == true ? Icon(Icons.chevron_right_outlined,size: 30,):
                                Icon(Icons.expand_more_rounded,size: 30)
                              ],
                            ),
                          ),
                        ),
                      ),
                      expandArray[index][index.toString()] == true ?Container(
                        child: ListView.builder(
                            itemCount: dataModel[index].services.length,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () async {
                                  if(dataModel[index].services[i].serviceFee == null){
                                    print('serviceNameEn => ${dataModel[index].services[i].serviceId.toString()}');
                                    addServiceDialog(context,dataModel[index].services[i].serviceId.toString(),'Enter the service price',' Update passport number',(){
                                      print('yes');
                                      Get.back();
                                    },(){
                                      Get.back();
                                      print('no');
                                    });
                                  }else{
                                    print('serviceNameEn +=> ${dataModel[index].services[i].serviceId.toString()}');
                                    optionalDialog(context,'Delete','Do you want to delete the service.?',(){
                                      print('yes');
                                      _hitApiServicesDelete(dataModel[index].services[i].serviceId.toString());
                                    },(){
                                      Get.back();
                                      print('no');
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 12),
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(),
                                          child:
                                          Padding(
                                            padding: const EdgeInsets.only(left:8.0),
                                            child: Icon(
                                              Icons.circle,
                                              color: dataModel[index]
                                                  .services[i]
                                                  .serviceType ==
                                                  "No delivery needed"
                                                  ? Colors.teal
                                                  : Color(0xffF15B29),
                                              size: 12,
                                            ),
                                          ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0,right: 12.0),
                                          child: Text(
                                            dataModel[index]
                                                .services[i]
                                                .serviceNameEn,
                                            style:
                                            // TextStyle(
                                            //     fontSize: Dimens.space18 *
                                            //         _multi(context),
                                            //     fontFamily: FontStrings
                                            //         .Roboto_Regular,
                                            //     color: UIColor.darkGrey),

                                            Theme.of(context).textTheme.bodyText2.copyWith(
                                              fontFamily: FontStrings
                                                  .Roboto_Regular,
                                              fontWeight: FontWeight.normal,
                                              color: UIColor.darkGrey,
                                            ),

                                          ),
                                        ),
                                      ),
                                      dataModel[index].services[i].serviceFee != null?Padding(
                                        padding: const EdgeInsets.only(),
                                        child: Row(
                                          children: [
                                            dataModel[index].services[i].expressService == 'Yes'? SvgPicture.asset(
                                              'assets/truck.svg',
                                              allowDrawingOutsideViewBox: true,
                                            ):Container(),
                                            Text(
                                              "  "+"BHD ${dataModel[index].services[i].serviceFee}"+"  ",
                                              style:
                                              // TextStyle(
                                              //     fontSize: Dimens.space18 *
                                              //         _multi(context),
                                              //     fontFamily:
                                              //     FontStrings.Roboto_Bold,
                                              //     color: UIColor.darkBlue),

                                              Theme.of(context).textTheme.bodyText2.copyWith(
                                                fontFamily: FontStrings
                                                    .Roboto_Bold,
                                                color: UIColor.darkBlue,
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              'assets/delete.svg',color: Color(0xFFA0A2A4),
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                          ],
                                        ),
                                      ):Icon(
                                        Icons.add_circle_outline,
                                        color: UIColor.darkBlue,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ):Container(height: 0.0,),
                    ],
                  ));
            });
      }),
    );
  }
  void _hitApiServices(int index) {
    print('******** ${vendorCategoryModel[index].id.toString()},${vendorCategoryModel[index].nameEn.toString()}, ');
    dataModel.clear();
    setState(() {});
    services.fetchServices(vendorCategoryModel[index].id.toString(), 'Expatriate', 'Clearance documents')
        .then((result) {
      if (result["status"] == true) {
        isServicePresent = "";
        dataModel = ServiceModel.fromJson(result).results;
        originalDataModel = dataModel;
        expandArrayOriginel.clear();
        expandMapOriginel.clear();
        expandMap.clear();
        expandArray.clear();
        for (int x = 0; x < dataModel.length; x++) {
          expandMap = {x.toString(): false};
          expandArray.add(expandMap);
        }
        expandMapOriginel = expandMap;
        expandArrayOriginel = expandArray;
        print(expandMap);
        print(expandArray);
        setState(() {});
      } else {
        isServicePresent = result["message"];
        setState(() {});
        getSnackBar(null, isServicePresent);
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      setState(() {});
    });
  }
  void _hitApiServicesDelete(String serviceId) {
    deleteServices.fetchServices(serviceId)
        .then((result) {
      if (result["status"] == true) {
        isServicePresent1 = result["message"];
        _hitApiServices(_nestedTabController.index);
        setState(() {});
        Get.back();
        getSnackBar(null, isServicePresent1);
      } else {
        isServicePresent1 = result["message"];
        setState(() {});
        Get.back();
        getSnackBar(null, isServicePresent1);
      }
    }, onError: (error) {
      isServicePresent1 = error.toString();
      setState(() {});
      Get.back();
      getSnackBar(null, isServicePresent1);

    });
  }
  void _hitApiServicesAdd(String serviceId, String serviceFee, String expressDelivery, String expressServiceTime,) {
    addServices.fetchServices(serviceId,serviceFee, expressDelivery, expressServiceTime)
        .then((result) {
      if (result["status"] == true) {
        isServicePresent1 = result["message"];
        _hitApiServices(_nestedTabController.index);
        amountCon.text = "";
        setState(() {});
        Get.back();
        getSnackBar(null, isServicePresent1);
      } else {
        isServicePresent1 = result["message"];
        setState(() {});
        Get.back();
        getSnackBar(null, isServicePresent1);
      }
    }, onError: (error) {
      isServicePresent1 = error.toString();
      setState(() {});
      Get.back();
      getSnackBar(null, isServicePresent1);

    });
  }
  void optionalDialog(BuildContext context, var title, var body,Function onYesPressed, Function onNoPressed){
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
                            SizedBox(height: 8,),
                            Padding(
                              padding: const EdgeInsets.only(left:16.0,right: 16),
                              child: Text('$body',textAlign:TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
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
                                      onTap: onYesPressed,
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
  void addServiceDialog(BuildContext context, var serviceID, var title, var body,Function onYesPressed, Function onNoPressed){
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
          return Container(
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
                              SizedBox(height: 8,),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                                child: Column(
                                  children: [
                                    Text(
                                      '$body',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black12, style: BorderStyle.solid, width: 0.5),
                                          borderRadius: BorderRadius.all(Radius.circular(10),),
                                          color: Colors.white
                                      ),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: amountCon,
                                        cursorColor: Color(0xff0A95A0),
                                        decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            hintText: 'Price in BHD'),
                                        style: TextStyle(
                                          color: Color(0xff212156),
                                          fontFamily: FontStrings.Roboto_Regular,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: (){
                                  if(express){
                                    express = false;
                                    setState(() {});
                                  }else{
                                    express = true;
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left:15,right: 15),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/truck.svg',
                                        allowDrawingOutsideViewBox: true,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Express Service',
                                            style:
                                            Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                              fontFamily: FontStrings.Roboto_Regular,
                                              color: UIColor.darkBlue,
                                            ),
                                          ),
                                        ),
                                      ),
                                      express?SvgPicture.asset(
                                        'assets/check.svg',
                                        allowDrawingOutsideViewBox: true,
                                      ):SvgPicture.asset(
                                        'assets/uncheck.svg',
                                        allowDrawingOutsideViewBox: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              express ?Container(
                                padding: const EdgeInsets.only(left:18.0,right: 18),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black12, style: BorderStyle.solid, width: 0.5),
                                    color: Colors.white),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text('Up to ',
                                        style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontFamily: FontStrings.Roboto_Regular,
                                        color: UIColor.darkGrey,
                                      ),),
                                    ),
                                    DropdownButton(
                                        underline: Container(),
                                      elevation: 0,
                                        iconEnabledColor: UIColor.darkBlue,
                                        icon: Transform.rotate(
                                          angle: 42.4 ,
                                          child: Icon(
                                            Icons.arrow_back_ios_rounded
                                          ),
                                        ),
                                        items: [
                                      DropdownMenuItem(
                                        child: Text('1 day',style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontFamily: FontStrings.Roboto_Regular,
                                        color: UIColor.darkGrey,
                                      ),),
                                        value: '1 day',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('2 day',style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontFamily: FontStrings.Roboto_Regular,
                                        color: UIColor.darkGrey,
                                      ),),
                                        value: '2 day',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('3 day',style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontFamily: FontStrings.Roboto_Regular,
                                        color: UIColor.darkGrey,
                                      ),),
                                        value: '3 day',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('4 day',style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontFamily: FontStrings.Roboto_Regular,
                                        color: UIColor.darkGrey,
                                      ),),
                                        value: '4 day',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('5 day',style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontFamily: FontStrings.Roboto_Regular,
                                        color: UIColor.darkGrey,
                                      ),),
                                        value: '5 day',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('6 day',style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontFamily: FontStrings.Roboto_Regular,
                                        color: UIColor.darkGrey,
                                      ),),
                                        value: '6 day',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('7 day',style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontFamily: FontStrings.Roboto_Regular,
                                        color: UIColor.darkGrey,
                                      ),),
                                        value: '7 day',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('8 day',style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontFamily: FontStrings.Roboto_Regular,
                                        color: UIColor.darkGrey,
                                      ),),
                                        value: '8 day',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('9 day',style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontFamily: FontStrings.Roboto_Regular,
                                        color: UIColor.darkGrey,
                                      ),),
                                        value: '9 day',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('10 day',style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontFamily: FontStrings.Roboto_Regular,
                                        color: UIColor.darkGrey,
                                      ),),
                                        value: '10 day',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('11 day',style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontFamily: FontStrings.Roboto_Regular,
                                        color: UIColor.darkGrey,
                                      ),),
                                        value: '11 day',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('12 day',style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        fontFamily: FontStrings.Roboto_Regular,
                                        color: UIColor.darkGrey,
                                      ),),
                                        value: '12 day',
                                      ),
                                    ], value: expressTime, onChanged: (value) {
                                      setState(() {
                                        expressTime = value;
                                      });
                                    }),
                                  ],
                                ),
                              ):Container(),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: (){
                                          if(amountCon.text.isEmpty){getSnackBar(null, 'Enter Amount');
                                          }else{
                                            _hitApiServicesAdd(serviceID,amountCon.text,express.toString(),expressTime);
                                          }
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
                                            "Save",
                                            style: TextStyle(
                                                color: Color(0xFF007AFF),
                                                fontSize:20,
                                                fontWeight: FontWeight.normal
                                            ),
                                          ),
                                          padding: EdgeInsets.only(top:10,bottom: 10),
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
        },);
      },
    );
  }

}

class expandModel {
  String type;
  bool expandFlag;
  expandModel(this.type, this.expandFlag);
  @override
  String toString() {
    return '{ ${this.type}, ${this.expandFlag} }';
  }
}
