import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/controller/NewOrderController/CartServiceScreen.dart';
import 'package:takhlees_v/controller/NewOrderController/NewOrderRrequestController.dart';
import 'package:takhlees_v/controller/NewOrderController/NewVendorServiceCategoryController.dart';
import 'package:takhlees_v/controller/NewOrderController/NewViewCartController.dart';
import 'package:takhlees_v/controller/NewOrderController/ViewCartModel.dart';
import 'package:takhlees_v/controller/ServiceAddControlleer.dart';
import 'package:takhlees_v/controller/ServiceControlleer.dart';
import 'package:takhlees_v/controller/ServiceDeleteControlleer.dart';
import 'package:takhlees_v/controller/VendorServiceControlleer.dart';
import 'package:takhlees_v/controller/VendorServiceCategoryController.dart';
import 'package:takhlees_v/model/CategoryModel.dart';
import 'package:takhlees_v/model/ServiceModel.dart';
import 'package:takhlees_v/model/VendorCategoryModel.dart';
import 'package:takhlees_v/model/VendorServiceModel.dart';
import 'package:takhlees_v/view/HomeScreen/OrderBottomBarIndex.dart';
import 'package:takhlees_v/view/Settings/ManageService/itemCount.dart';
import 'package:takhlees_v/view/VendorService/VendorService.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:takhlees_v/widget/dialogBox/optionalDialog.dart';
import 'package:takhlees_v/widget/snackBar.dart';

import '../../PendingOrderDetails.dart';

class ExpatTabBar extends StatefulWidget {
  final String itemID;
  final String orderType;
  final String orderID;
  final String status;
  final String needDelivery;
  const ExpatTabBar(
      this.itemID,
      this.orderType,
      this.status,
      this.needDelivery,
      this.orderID);

  @override
  _ExpatTabBarState createState() => _ExpatTabBarState();
}

class _ExpatTabBarState extends State<ExpatTabBar>
    with TickerProviderStateMixin {

  Map<String, String> docMap = {};
  var docList =[];
  var serviceItemList = [];

  final vendorServiceCategory = VendorServiceCategoryController();
  var vendorCategoryModel = <CategoryResult>[];
  final services = Get.put(NewVendorServiceCategoryController());
  final viewCartController = Get.put(NewViewCartController());
  final orderRequestController = Get.put(NewOrderRrequestController());
  final deleteServices = Get.put(ServiceDeleteController());
  final addServices = Get.put(ServiceAddController());

  var dataModel = <NewServiceResult>[];
  var originalDataModel = <NewServiceResult>[];
  var viewCartModel = ViewCartResult();

  String isServicePresent;
  String total = "0";
  String needsDelivery = "Yes";
  String isServicePresent1;
  int tabLength;
  bool isAttached = false;

  Map<String, bool> expandMap = new HashMap();
  List expandArray = [];

  Map<String, bool> expandMapOriginel = new HashMap();
  List expandArrayOriginel = [];
  TabController _nestedTabController;
  bool express = false;
  String expressTime = "1 day";
  final amountCon = new TextEditingController();
  final requestReasonCon = new TextEditingController();
  bool isLoading = false;
  bool isCategoryItemLoading = false;

  @override
  void initState() {
    super.initState();
    print('             Expat');
    print('    itemID  : ${widget.itemID}');
    print('    orderType  : ${widget.orderType}');
    print('    orderID  : ${widget.orderID}');
    print('    status  : ${widget.status}');
    print('    needDelivery  : ${widget.needDelivery}');

    isLoading = true;
    _nestedTabController =  TabController(length: 4, vsync: this);
    vendorServiceCategory.fetchServices(widget.orderType).then(
            (result) {
          if (result["status"] == true) {
            isServicePresent = "";
            print('======${result["status"]}');
            print('======${result["message"]}');
            vendorCategoryModel = CategoryModel.fromJson(result).results;
            print('vendorCategoryModel : ${vendorCategoryModel.length}');
            tabLength = vendorCategoryModel.length;
            _nestedTabController =  TabController(length: vendorCategoryModel.length, vsync: this);
            isLoading = false;
            setState(() {});
            _hitApiServices(0,widget.orderType);
            _nestedTabController.addListener(() {
              _hitApiServices(_nestedTabController.index,widget.orderType);
            });
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return SettingsScreen();
            // }));
            // Navigator.pop(context,true);
          } else {
            isServicePresent = result["message"];
            isLoading = false;
            setState(() {});
            print('--------${result["message"]}');
          }
        }, onError: (error) {
      isLoading = false;
      isServicePresent = error.toString();
      print('--------$isServicePresent');
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  _multi(context) {
    return MediaQuery.of(context).size.height * 0.01;
  }

  Widget bottomSheet1(List<ViewCartService> viewCartService,var itemID, var orderType, var orderID) {
    isBottomOpen = true;
    setState(() {
    });
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: MediaQuery.of(context).size.height - 6.95 * _multi(context),
                  decoration: new BoxDecoration(
                    color: Color(0xffF4F6F9),
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
                              offset: Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(25.0),
                            topRight: const Radius.circular(25.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: new BorderRadius.all(const Radius.circular(25.0),
                                    ),
                                  ),
                                  width: 40,
                                  height: 3,
                                ),
                              ),
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      isBottomOpen = false;
                                      setState((){});
                                      Navigator.of(context).pop();
                                    },
                                    child: SvgPicture.asset(
                                      'assets/close.svg',
                                      color: UIColor.baseGradientLight,
                                      allowDrawingOutsideViewBox: true,
                                    ),
                                  ),
                                  Text(
                                    'Add new service',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                      fontFamily:
                                      FontStrings.Fieldwork10_Regular,
                                      color: Color(0xff212156),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                      'assets/close.svg',
                                      color: Colors.white,
                                      allowDrawingOutsideViewBox: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal:24.0),
                            child: Text(
                              'EXTRA SERVICE(S) REQUESTED',
                              textAlign: TextAlign.start,
                              style:
                              Theme.of(context).textTheme.subtitle1.copyWith(
                                  fontFamily: FontStrings.Roboto_Bold,
                                  color: Color(0xFF888B8D)
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Container(
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 0.3,
                                blurRadius: 1,
                                offset: Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal:24.0),
                          child: TextFormField(
                            controller: requestReasonCon,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding:
                                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Reason for adding a service *"),
                          )
                      ),
                      SizedBox(
                        height: 18,
                      ),

                      // Container(
                      //   margin: EdgeInsets.symmetric(vertical: 3),
                      //   decoration: new BoxDecoration(
                      //     color: Colors.white,
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.grey.withOpacity(0.2),
                      //         spreadRadius: 0.3,
                      //         blurRadius: 1,
                      //         offset: Offset(
                      //             0, 1), // changes position of shadow
                      //       ),
                      //     ],
                      //   ),
                      //   padding: const EdgeInsets.symmetric(vertical:12.0,horizontal: 18),
                      //   child: GestureDetector(
                      //     onTap: (){
                      //       setState(() {
                      //         isAttached = !isAttached;
                      //       });
                      //     },
                      //     child: Row(
                      //       children: [
                      //         isAttached?SvgPicture.asset('assets/check.svg'):SvgPicture.asset('assets/uncheck.svg'),
                      //         SizedBox(width: 10,),
                      //         Expanded(
                      //           child: Text('No delivery required'.tr,style:Get.textTheme.bodyText1.copyWith(
                      //             fontFamily: FontStrings.Roboto_Bold,
                      //           )),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      SizedBox(
                        height: 18,
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: viewCartService.length,
                            itemBuilder: (context,index){
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 3),
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 0.3,
                                      blurRadius: 1,
                                      offset: Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(vertical:12.0,horizontal: 24),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: viewCartService[index]
                                              .serviceType ==
                                              "No delivery needed"
                                              ? Colors.teal
                                              : Color(0xffF15B29),
                                          size: 12,
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal:18.0),
                                            child: Text("${viewCartService[index].serviceNameEn}",style:Theme.of(context).textTheme.bodyText2.copyWith(
                                              fontFamily: FontStrings.Roboto_Bold,
                                            ),),
                                          ),
                                        ),
                                        Text('${viewCartService[index].serviceFee} BHD',style:Theme.of(context).textTheme.bodyText2.copyWith(
                                          fontFamily: FontStrings.Roboto_Bold,
                                        ),),

                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: Text("Estimated time ${viewCartService[index].serviceTime} days",style:Theme.of(context).textTheme.bodyText2.copyWith(
                                              fontFamily: FontStrings.Roboto_Regular,
                                            ),),
                                          ),
                                        ),
                                        Text('Qty: ${viewCartService[index].quantity}',style:Theme.of(context).textTheme.bodyText2.copyWith(
                                          fontFamily: FontStrings.Roboto_Regular,
                                        ),),

                                      ],
                                    ),
                                    SizedBox(height: 10,),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: List.generate(viewCartService[index].documents.length, (docIndex){
                                        return GestureDetector(
                                          onTap: (){
                                            if(!serviceItemList.contains('${viewCartService[index].serviceId} ${viewCartService[index].documents[docIndex].documentId}')||serviceItemList.length==0){
                                              // serviceItemList.setItemList(services[index].itemId);
                                              serviceItemList.add('${viewCartService[index].serviceId} ${viewCartService[index].documents[docIndex].documentId}');
                                              // serviceItemList.setItemList('${services[index].itemId} ${services[index].documents[docIndex].documentNameAr}');

                                              docMap = {'service_id': '${viewCartService[index].serviceId}', 'document_id': '${viewCartService[index].documents[docIndex].documentId}'};

                                              docList.add(docMap);

                                              setState(() {});
                                              print('=====> $serviceItemList');
                                              print('=====> $docList');
                                            }else{
                                              var pos = serviceItemList.indexOf('${viewCartService[index].serviceId} ${viewCartService[index].documents[docIndex].documentId}');
                                              serviceItemList.removeAt(pos);

                                              var dummy = [];

                                              for(var item in docList){
                                                dummy.add('${item['service_id']} ${item['document_id']}');
                                              }


                                              var itemPos = dummy.indexOf('${viewCartService[index].serviceId} ${viewCartService[index].documents[docIndex].documentId}');

                                              print(itemPos);
                                              docList.removeAt(itemPos);
                                              dummy.removeAt(itemPos);
                                              print('=====>dummy      $dummy');
                                              print('=====>docList    $docList');

                                              // print(jsonEncode(docList));


                                              setState(() {});
                                              // print(serviceItemList);
                                            }
                                            print(jsonEncode(docList));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Container(
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
                                                  Expanded(
                                                    child: Text(
                                                      "${viewCartService[index].documents[docIndex].documentNameEn}",
                                                      style: TextStyle(
                                                          fontSize: Dimens.space16 *
                                                              _multi(context),
                                                          fontFamily: FontStrings
                                                              .Roboto_Regular,
                                                          color: Color(0xFF404243)),
                                                    ),
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    // child: serviceItemList.itemList.contains(services[index].itemId)||serviceItemList.itemList == null?SvgPicture.asset(
                                                    child: serviceItemList.contains('${viewCartService[index].serviceId} ${viewCartService[index].documents[docIndex].documentId}')||serviceItemList == null?SvgPicture.asset(
                                                      "assets/check.svg",
                                                    ):SvgPicture.asset(
                                                      "assets/uncheck.svg",
                                                    ),
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
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 18,
                      ),

                      //------------------------------------------------------------------Button--------------
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 24, left: 24, right: 24),
                        child: RaisedGradientButton(
                            child: Text(
                              'Send Request',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily:
                                  FontStrings.Fieldwork10_Regular,
                                  fontSize:16),
                            ),
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xffC1282D),
                                Color(0xffF15B29)
                              ],
                            ),
                            onPressed: () {
                              var reason = requestReasonCon.text;

                              reason = reason.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
                              reason = reason.replaceAll(' ', "");
                              reason = reason.replaceAll('  ', "");
                              reason = reason.replaceAll('   ', "");
                              reason = reason.replaceAll('    ', "");
                              reason = reason.replaceAll('     ', "");
                              reason = reason.replaceAll('      ', "");
                              reason = reason.replaceAll('       ', "");

                              if(reason.isNotEmpty){
                                Get.back();
                                // Get.back();
                                print('---------prv ${Get.previousRoute}');


                                hitRequestAPI(
                                    orderID,
                                    itemID,
                                    requestReasonCon.text,
                                    docList.length > 0 ? "Yes":'No',
                                    orderType,
                                    '${jsonEncode(docList)}'
                                );
                              }else{
                                okDialog(context,"Add reason before ","Please add a reason for adding a service",(){Get.back();});
                              }

                            }),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                  //
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return !isLoading ? Column(
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
                'Add ($total Services)',
                style: TextStyle(color: Colors.white,fontFamily: FontStrings.Fieldwork10_Regular, fontSize: 16),
              ),
              gradient: LinearGradient(
                colors: <Color>[Color(0xffC1282D), Color(0xffF15B29)],
              ),
              onPressed: (){
                // Get.back();
                // Get.bottomSheet(Container(
                //   child: Container(
                //     child: Wrap(
                //       children: [
                //         GestureDetector(
                //           onTap:(){
                //             // _openCamera1(context);
                //             // _loadPicker(ImageSource.camera,'profilePic');
                //
                //           },
                //           child: Container(
                //             padding: const EdgeInsets.only(left:8.0,right: 8,bottom: 8),
                //             child: Container(
                //               decoration: BoxDecoration(
                //                 color: Colors.white,
                //                 borderRadius: BorderRadius.only(
                //                     topLeft: Radius
                //                         .circular(10),
                //                     topRight: Radius
                //                         .circular(10),
                //                     bottomLeft: Radius
                //                         .circular(10),
                //                     bottomRight:
                //                     Radius
                //                         .circular(
                //                         10)),
                //                 boxShadow: [
                //                   BoxShadow(
                //                     color: Colors.grey
                //                         .withOpacity(
                //                         0.2),
                //                     spreadRadius: 0.3,
                //                     blurRadius: 1,
                //                     offset: Offset(0,
                //                         1), // changes position of shadow
                //                   ),
                //                 ],
                //               ),
                //               padding: EdgeInsets.all(15),
                //               child: Row(
                //                 children: [
                //                   Icon(Icons.camera_alt,color:Colors.black54),
                //                   Expanded(child: Container(
                //                     padding: const EdgeInsets.all(8.0),
                //                     child: Text('Camera',style: Theme.of(context).textTheme.bodyText2.copyWith(
                //                         fontFamily: FontStrings.Fieldwork10_Regular,
                //                         color:Colors.black54
                //                     ),),
                //                   ))
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //         GestureDetector(
                //           onTap: (){
                //             // openGallery(context);
                //             // _loadPicker(ImageSource.gallery,'profilePic');
                //           },
                //           child: Container(
                //             padding: const EdgeInsets.only(left:8.0,right: 8,),
                //             child: Container(
                //               decoration: BoxDecoration(
                //                 color: Colors.white,
                //                 borderRadius: BorderRadius.only(
                //                     topLeft: Radius
                //                         .circular(10),
                //                     topRight: Radius
                //                         .circular(10),
                //                     bottomLeft: Radius
                //                         .circular(10),
                //                     bottomRight:
                //                     Radius
                //                         .circular(
                //                         10)),
                //                 boxShadow: [
                //                   BoxShadow(
                //                     color: Colors.grey
                //                         .withOpacity(
                //                         0.2),
                //                     spreadRadius: 0.3,
                //                     blurRadius: 1,
                //                     offset: Offset(0,
                //                         1), // changes position of shadow
                //                   ),
                //                 ],
                //               ),
                //               padding: EdgeInsets.all(15),
                //               child: Row(
                //                 children: [
                //                   Icon(Icons.collections,color:Colors.black54),
                //                   Expanded(child: Container(
                //                     padding: const EdgeInsets.all(8.0),
                //                     child: Text('Gallery',style: Theme.of(context).textTheme.bodyText2.copyWith(
                //                         fontFamily: FontStrings.Fieldwork10_Regular,
                //                         color:Colors.black54
                //                     ),),
                //                   ))
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //         GestureDetector(
                //           onTap: ()=>Get.back(),
                //           child: Container(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Container(
                //               decoration: BoxDecoration(
                //                 color: Colors.white,
                //                 borderRadius: BorderRadius.only(
                //                     topLeft: Radius
                //                         .circular(10),
                //                     topRight: Radius
                //                         .circular(10),
                //                     bottomLeft: Radius
                //                         .circular(10),
                //                     bottomRight:
                //                     Radius
                //                         .circular(
                //                         10)),
                //                 boxShadow: [
                //                   BoxShadow(
                //                     color: Colors.grey
                //                         .withOpacity(
                //                         0.2),
                //                     spreadRadius: 0.3,
                //                     blurRadius: 1,
                //                     offset: Offset(0,
                //                         1), // changes position of shadow
                //                   ),
                //                 ],
                //               ),
                //               padding: EdgeInsets.all(15),
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Container(
                //                     // padding: const EdgeInsets.all(0),
                //                     child: Center(
                //                       child: Text('Cancel',textAlign: TextAlign.center ,style: Theme.of(context).textTheme.bodyText1.copyWith(
                //                           fontFamily: FontStrings.Fieldwork10_Regular,
                //                           color: Colors.red
                //                       ),),
                //                     ),
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //         Container(
                //           height: 25,
                //         ),
                //       ],
                //     ),
                //   ),
                // ));

                if(total != '0'){
                  hitViewCartAPI();
                }else{
                  getSnackBar(null, 'Select a service');
                }



              }
          ),
        ),
      ],
    ):Center(
      child: CircularProgressIndicator(),
    );
  }



  // hitCategoryApi(){
  //   vendorServiceCategory.fetchServices('Clearance documents').then(
  //           (result) {
  //         if (result["status"] == true) {
  //           isServicePresent = "";
  //           print('======${result["status"]}');
  //           print('======${result["message"]}');
  //           vendorCategoryModel = CategoryModel.fromJson(result).results;
  //           print('vendorCategoryModel : ${vendorCategoryModel.length}');
  //           tabLength = vendorCategoryModel.length;
  //           _nestedTabController =  TabController(length: vendorCategoryModel.length, vsync: this);
  //           setState(() {});
  //           // Navigator.push(context, MaterialPageRoute(builder: (context) {
  //           //   return SettingsScreen();
  //           // }));
  //           // Navigator.pop(context,true);
  //         } else {
  //           isServicePresent = result["message"];
  //           setState(() {});
  //           print('--------${result["message"]}');
  //         }
  //       }, onError: (error) {
  //     isServicePresent = error.toString();
  //     print('--------$isServicePresent');
  //     setState(() {});
  //   });
  // }
  Widget _tabView(BuildContext context) {
    return TabBarView(
      controller: _nestedTabController,
      children: List<Widget>.generate(vendorCategoryModel.length, (int index) {
        return !isCategoryItemLoading ? isServicePresent.length != 0 ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/emptyService.svg',
                allowDrawingOutsideViewBox: true,
                // color: UIColor.baseGradientDar ,
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
              return dataModel.isNotEmpty  ?  dataModel[index].type == 1
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
                              var data = [];
                              data.add(dataModel[index].services[i].serviceNameEn.toString()); //0
                              data.add(dataModel[index].services[i].serviceId.toString()); //1
                              data.add(dataModel[index].services[i].serviceNameAr.toString()); //2
                              data.add(dataModel[index].services[i].serviceFee.toString()); //3
                              data.add(dataModel[index].services[i].serviceType.toString()); //4
                              data.add(dataModel[index].services[i].governmentFee.toString()); //5
                              data.add(dataModel[index].services[i].serviceTime.toString()); //6
                              List docu = dataModel[index].services[i].documents.toList();
                              var arr = [];
                              docu.forEach((element) {
                                arr.add(element.documentNameEn);
                              });
                              data.add(arr); //7
                              data.add(dataModel[index].services[i].quantity); //8
                              data.add(dataModel[index].services[i].expressServiceFee.toString()); //9
                              data.add(dataModel[index].services[i].expressService); //10
                              data.add(dataModel[index].services[i].expressServiceTime); //11
                              data.add(dataModel[index].services[i].expressSelected); //12
                              data.add(dataModel[index].services[i].showExpressService);//13
                              data.add(dataModel[index].services[i].needName);//14
                              data.add(dataModel[index].services[i].maxQuantity);//15
                              var nameArr = [];
                              // ignore: deprecated_member_use
                              if(!dataModel[index].services[i].nameList.isNullOrBlank){
                                List name = dataModel[index].services[i].nameList.toList();
                                var nameArr = [];
                                name.forEach((nameElement) {
                                  Map<String, String> map = {'name': '${nameElement.name}', 'doc_number': '${nameElement.docNumber}'};
                                  nameArr.add(map);
                                  print(nameArr);
                                  data.add(nameArr);//16
                                });
                                print(nameArr);
                              }else{
                                data.add(nameArr);
                              }
                              print(jsonEncode(data));

                              final result = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return CartServiceScreen(data);
                                  }));

                              if(result == 'true'){
                                _hitApiServices(_nestedTabController.index,widget.orderType);
                              }

                              // if(dataModel[index].services[i].serviceFee == null){
                              //   print('serviceNameEn => ${dataModel[index].services[i].serviceId.toString()}');
                              //   addServiceDialog(context,dataModel[index].services[i].serviceId.toString(),'Enter the service price',' Update passport number',(){
                              //   },(){},dataModel[index].services[i].showExpressService == 'Yes'?true:false);
                              // }else{
                              //   print('serviceNameEn +=> ${dataModel[index].services[i].serviceId.toString()}');
                              //   optionalDialog(context,'Delete','Do you want to delete the service.?',(){
                              //     print('yes');
                              //     _hitApiServicesDelete(dataModel[index].services[i].serviceId.toString());
                              //     // Get.back();
                              //   },(){
                              //     Get.back();
                              //     print('no');
                              //   });
                              // }
                              // getSnackBar(null,"ffff");
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
                                        padding: const EdgeInsets.only(left:8.0,right: 8),
                                        child: dataModel[index]
                                            .services[i]
                                            .quantity == 0 ? Padding(
                                          padding: const EdgeInsets.only(left:6.0,right: 7),
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
                                        ):Container(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Positioned(
                                                  child: Icon(
                                                    Icons.circle,
                                                    color: dataModel[index]
                                                        .services[i]
                                                        .serviceType ==
                                                        "No delivery needed"
                                                        ? Colors.teal
                                                        : Color(0xffF15B29),
                                                    size: 26,
                                                  ),
                                                ),
                                                Positioned(
                                                  child: Text(dataModel[index].services[i].quantity.toString(),style: TextStyle(
                                                    fontFamily: FontStrings.Roboto_Bold,
                                                    color: UIColor.baseColorWhite,
                                                  ),),
                                                  // bottom: 5,
                                                ),
                                              ],
                                            )
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
                                        // dataModel[index].services[i].showExpressService == 'Yes'? dataModel[index].services[i].expressService == 'Yes'? SvgPicture.asset(
                                        //   'assets/truck.svg',
                                        //   allowDrawingOutsideViewBox: true,
                                        // ):Container():Container(),
                                        Text(
                                          "  "+"BHD "+"${double.parse(dataModel[index].services[i].serviceFee)+double.parse(dataModel[index].services[i].governmentFee)}  ",
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
                                        // SvgPicture.asset(
                                        //   'assets/delete.svg',color: Color(0xFFA0A2A4),
                                        //   allowDrawingOutsideViewBox: true,
                                        // ),
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
                                dataModel[index].openContainer == 'No'? expandArray[index][index.toString()] == true ? Icon(Icons.chevron_right_outlined,size: 30,):
                                Icon(Icons.expand_more_rounded,size: 30):Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      dataModel[index].openContainer == 'No'?expandArray[index][index.toString()] == true ?Container(
                        child: ListView.builder(
                            itemCount: dataModel[index].services.length,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () async {

                                  var data = [];
                                  data.add(dataModel[index].services[i].serviceNameEn.toString()); //0
                                  data.add(dataModel[index].services[i].serviceId.toString()); //1
                                  data.add(dataModel[index].services[i].serviceNameAr.toString()); //2
                                  data.add(dataModel[index].services[i].serviceFee.toString()); //3
                                  data.add(dataModel[index].services[i].serviceType.toString()); //4
                                  data.add(dataModel[index].services[i].governmentFee.toString()); //5
                                  data.add(dataModel[index].services[i].serviceTime.toString()); //6
                                  List docu = dataModel[index].services[i].documents.toList();
                                  var arr = [];
                                  docu.forEach((element) {
                                    arr.add(element.documentNameEn);
                                  });
                                  data.add(arr); //7
                                  data.add(dataModel[index].services[i].quantity); //8
                                  data.add(dataModel[index].services[i].expressServiceFee.toString()); //9
                                  data.add(dataModel[index].services[i].expressService); //10
                                  data.add(dataModel[index].services[i].expressServiceTime); //11
                                  data.add(dataModel[index].services[i].expressSelected); //12
                                  data.add(dataModel[index].services[i].showExpressService);//13
                                  data.add(dataModel[index].services[i].needName);//14
                                  data.add(dataModel[index].services[i].maxQuantity);//15
                                  var nameArr = [];
                                  // ignore: deprecated_member_use
                                  if(!dataModel[index].services[i].nameList.isNullOrBlank){
                                    List name = dataModel[index].services[i].nameList.toList();
                                    var nameArr = [];
                                    name.forEach((nameElement) {
                                      Map<String, String> map = {'name': '${nameElement.name}', 'doc_number': '${nameElement.docNumber}'};
                                      nameArr.add(map);
                                      print(nameArr);
                                      data.add(nameArr);//16
                                    });
                                    print(nameArr);
                                  }else{
                                    data.add(nameArr);
                                  }
                                  print(jsonEncode(data));

                                  final result = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return CartServiceScreen(data);
                                      }));

                                  if(result == 'true'){
                                    _hitApiServices(_nestedTabController.index,widget.orderType);
                                  }
                                  // if(dataModel[index].services[i].serviceFee == null){
                                  //   print('serviceNameEn => ${dataModel[index].services[i].serviceId.toString()}');
                                  //   addServiceDialog(context,dataModel[index].services[i].serviceId.toString(),'Enter the service price',' Update passport number',(){
                                  //     print('yes');
                                  //     Get.back();
                                  //   },(){Get.back();print('no');
                                  //   },dataModel[index].services[i].showExpressService == 'Yes'?true:false);
                                  // }else{
                                  //   print('serviceNameEn +=> ${dataModel[index].services[i].serviceId.toString()}');
                                  //   optionalDialog(context,'Delete','Do you want to delete the service.?',(){
                                  //     print('yes');
                                  //     _hitApiServicesDelete(dataModel[index].services[i].serviceId.toString());
                                  //   },(){
                                  //     Get.back();
                                  //     print('no');
                                  //   });
                                  // }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 12),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left:8.0,right: 8),
                                        child: dataModel[index]
                                            .services[i]
                                            .quantity == 0 ? Padding(
                                          padding: const EdgeInsets.only(left:6.0,right: 7),
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
                                        ):Container(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Positioned(
                                                  child: Icon(
                                                    Icons.circle,
                                                    color: dataModel[index]
                                                        .services[i]
                                                        .serviceType ==
                                                        "No delivery needed"
                                                        ? Colors.teal
                                                        : Color(0xffF15B29),
                                                    size: 26,
                                                  ),
                                                ),
                                                Positioned(
                                                  child: Text(dataModel[index].services[i].quantity.toString(),style: TextStyle(
                                                    fontFamily: FontStrings.Roboto_Bold,
                                                    color: UIColor.baseColorWhite,
                                                  ),),
                                                  // bottom: 5,
                                                ),
                                              ],
                                            )
                                        ),
                                      ),
                                      // Padding(
                                      //     padding: const EdgeInsets.only(),
                                      //     child:
                                      //     Padding(
                                      //       padding: const EdgeInsets.only(left:8.0),
                                      //       child: Icon(
                                      //         Icons.circle,
                                      //         color: dataModel[index]
                                      //             .services[i]
                                      //             .serviceType ==
                                      //             "No delivery needed"
                                      //             ? Colors.teal
                                      //             : Color(0xffF15B29),
                                      //         size: 12,
                                      //       ),
                                      //     ),
                                      // ),
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
                                            // dataModel[index].services[i].expressService == 'Yes'? SvgPicture.asset(
                                            //   'assets/truck.svg',
                                            //   allowDrawingOutsideViewBox: true,
                                            // ):Container(),
                                            Text(
                                              "  "+"BHD "+"${double.parse(dataModel[index].services[i].serviceFee)+double.parse(dataModel[index].services[i].governmentFee)}  ",

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
                                            // SvgPicture.asset(
                                            //   'assets/delete.svg',color: Color(0xFFA0A2A4),
                                            //   allowDrawingOutsideViewBox: true,
                                            // ),
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
                      ):Container(height: 0.0,):Container(
                        child: ListView.builder(
                            itemCount: dataModel[index].services.length,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () async {

                                  var data = [];
                                  data.add(dataModel[index].services[i].serviceNameEn.toString()); //0
                                  data.add(dataModel[index].services[i].serviceId.toString()); //1
                                  data.add(dataModel[index].services[i].serviceNameAr.toString()); //2
                                  data.add(dataModel[index].services[i].serviceFee.toString()); //3
                                  data.add(dataModel[index].services[i].serviceType.toString()); //4
                                  data.add(dataModel[index].services[i].governmentFee.toString()); //5
                                  data.add(dataModel[index].services[i].serviceTime.toString()); //6
                                  List docu = dataModel[index].services[i].documents.toList();
                                  var arr = [];
                                  docu.forEach((element) {
                                    arr.add(element.documentNameEn);
                                  });
                                  data.add(arr); //7
                                  data.add(dataModel[index].services[i].quantity); //8
                                  data.add(dataModel[index].services[i].expressServiceFee.toString()); //9
                                  data.add(dataModel[index].services[i].expressService); //10
                                  data.add(dataModel[index].services[i].expressServiceTime); //11
                                  data.add(dataModel[index].services[i].expressSelected); //12
                                  data.add(dataModel[index].services[i].showExpressService);//13
                                  data.add(dataModel[index].services[i].needName);//14
                                  data.add(dataModel[index].services[i].maxQuantity);//15
                                  var nameArr = [];
                                  // ignore: deprecated_member_use
                                  if(!dataModel[index].services[i].nameList.isNullOrBlank){
                                    List name = dataModel[index].services[i].nameList.toList();
                                    var nameArr = [];
                                    name.forEach((nameElement) {
                                      Map<String, String> map = {'name': '${nameElement.name}', 'doc_number': '${nameElement.docNumber}'};
                                      nameArr.add(map);
                                      print(nameArr);
                                      data.add(nameArr);//16
                                    });
                                    print(nameArr);
                                  }else{
                                    data.add(nameArr);
                                  }
                                  print(jsonEncode(data));

                                  final result = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return CartServiceScreen(data);
                                      }));

                                  if(result == 'true'){
                                    _hitApiServices(_nestedTabController.index,widget.orderType);
                                  }
                                  // if(dataModel[index].services[i].serviceFee == null){
                                  //   print('serviceNameEn => ${dataModel[index].services[i].serviceId.toString()}');
                                  //   addServiceDialog(context,dataModel[index].services[i].serviceId.toString(),'Enter the service price',' Update passport number',(){
                                  //     print('yes');
                                  //     Get.back();
                                  //   },(){Get.back();print('no');
                                  //   },dataModel[index].services[i].showExpressService == 'Yes'?true:false);
                                  // }else{
                                  //   print('serviceNameEn +=> ${dataModel[index].services[i].serviceId.toString()}');
                                  //   optionalDialog(context,'Delete','Do you want to delete the service.?',(){
                                  //     print('yes');
                                  //     _hitApiServicesDelete(dataModel[index].services[i].serviceId.toString());
                                  //   },(){
                                  //     Get.back();
                                  //     print('no');
                                  //   });
                                  // }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 12),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left:8.0,right: 8),
                                        child: dataModel[index]
                                            .services[i]
                                            .quantity == 0 ? Padding(
                                          padding: const EdgeInsets.only(left:6.0,right: 7),
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
                                        ):Container(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Positioned(
                                                  child: Icon(
                                                    Icons.circle,
                                                    color: dataModel[index]
                                                        .services[i]
                                                        .serviceType ==
                                                        "No delivery needed"
                                                        ? Colors.teal
                                                        : Color(0xffF15B29),
                                                    size: 26,
                                                  ),
                                                ),
                                                Positioned(
                                                  child: Text(dataModel[index].services[i].quantity.toString(),style: TextStyle(
                                                    fontFamily: FontStrings.Roboto_Bold,
                                                    color: UIColor.baseColorWhite,
                                                  ),),
                                                  // bottom: 5,
                                                ),
                                              ],
                                            )
                                        ),
                                      ),
                                      // Padding(
                                      //     padding: const EdgeInsets.only(),
                                      //     child:
                                      //     Padding(
                                      //       padding: const EdgeInsets.only(left:8.0),
                                      //       child: Icon(
                                      //         Icons.circle,
                                      //         color: dataModel[index]
                                      //             .services[i]
                                      //             .serviceType ==
                                      //             "No delivery needed"
                                      //             ? Colors.teal
                                      //             : Color(0xffF15B29),
                                      //         size: 12,
                                      //       ),
                                      //     ),
                                      // ),
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
                                            // dataModel[index].services[i].expressService == 'Yes'? SvgPicture.asset(
                                            //   'assets/truck.svg',
                                            //   allowDrawingOutsideViewBox: true,
                                            // ):Container(),
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
                                            // SvgPicture.asset(
                                            //   'assets/delete.svg',color: Color(0xFFA0A2A4),
                                            //   allowDrawingOutsideViewBox: true,
                                            // ),
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
                      ),
                    ],
                  )): Container();
            }):Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
  void _hitApiServices(int index,String orderType) {
    // isLoading = true;
    isCategoryItemLoading = true;
    print('******** ${vendorCategoryModel[index].id.toString()},${vendorCategoryModel[index].nameEn.toString()}, ');
    dataModel.clear();
    setState(() {});
    services.fetchServices("${vendorCategoryModel[index].id}", 'Expatriate', orderType)
        .then((result) {
      if (result["status"] == true) {
        isCategoryItemLoading  = false;
        isServicePresent = "";
        total = "${result['totalInCart']}";
        ItemCount().setItem(total);
        dataModel = VendorCategoryModel.fromJson(result).results;
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
        isCategoryItemLoading  = false;
        setState(() {});
        print('ffff');
        getSnackBar(null, isServicePresent);
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      isCategoryItemLoading  = false;
      setState(() {});
    });
  }

  bool isBottomOpen = false;

  void hitViewCartAPI() {
    showLoading('');
    // print('******** ${vendorCategoryModel[index].id.toString()},${vendorCategoryModel[index].nameEn.toString()}, ');
    // dataModel.clear();
    // setState(() {});
    viewCartController.fetchServices()
        .then((result) {
      hideLoading();
      if (result["status"] == true) {
        isServicePresent = "";
        // needsDelivery = "${result['needs_delivery']}";

        viewCartModel = ViewCartModel.fromJson(result).result;
        if(!isBottomOpen) {
          bottomSheet1(viewCartModel.services,widget.itemID,widget.orderType,widget.orderID);
        }

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
  void hitRequestAPI(String order_id,String item_id,String reason,String need_delivery,String clearance_or_pickup,String requestDoc) {
    // print('******** ${vendorCategoryModel[index].id.toString()},${vendorCategoryModel[index].nameEn.toString()}, ');
    // dataModel.clear();
    // setState(() {});
    orderRequestController.fetchServices(order_id,item_id,reason,need_delivery,clearance_or_pickup,requestDoc)
        .then((result) {
      if (result["status"] == true) {
        isServicePresent = "";
        // needsDelivery = "${result['needs_delivery']}";

        // Get.offAll(OrderBottomBarIndex());

        Get.off(PendingOrderDetails(widget.status, widget.orderID, widget.needDelivery));
        // Get.offAll(page)
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



}

// ignore: camel_case_types
class expandModel {
  String type;
  bool expandFlag;
  expandModel(this.type, this.expandFlag);
  @override
  String toString() {
    return '{ ${this.type}, ${this.expandFlag} }';
  }
}
