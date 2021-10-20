import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/controller/Orders/NewOrderController.dart';
import 'package:takhlees_v/controller/Orders/OrderHistoryController.dart';
import 'package:takhlees_v/model/NewOrderModel.dart';
import 'package:takhlees_v/model/OrderHistoryModel.dart';
import 'package:takhlees_v/widget/OrderStatusWidget.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:http/http.dart' as http;
import 'package:takhlees_v/widget/snackBar.dart';
import 'package:transparent_image/transparent_image.dart';

import '../HistoryOrderDetails.dart';
import '../PendingOrderDetails.dart';


class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin{
  var vendorCountClear = 0;
  var vendorCountPick = 0;
  int _tabIndicator = 0;
  final mobileNumberCon = new TextEditingController();
  TabController _tabController;
  int _selectedItemIndex = 0;//bottom bar
  var rangeValue = RangeValues(1, 99.0);
  bool searchStatus = false;
  bool checkBoxExpressValue = false;
  bool checkBoxSpecialValue = false;
  bool checkBoxCashValue = false;
  bool checkBoxDebitValue = false;
  bool checkBoxCreditValue = false;
  bool checkBoxWalletValue = false;
  double minAmount = 0;
  double maxAmount = 0;
  String serviceType = "";
  String services;
  String rating;
  String searchValue;
  String isServicePresent = "";
  var totalOrders = 0;

  final orderHistory = Get.put(OrderHistoryController());
  var orderHistoryModel = <OrderHistoryResult>[];
  var dupOrderHistoryModel = <OrderHistoryResult>[];



      _multi(context){
    return MediaQuery.of(context).size.height * 0.01;
  }

  @override
  void initState() {
    // hitOrderListAPI();
    // TODO: implement initState
    hitOrderHistoryListAPI();
    super.initState();
  }

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
              child: searchStatus == false?_appBar():_searchBar(),
            ),
            //-------------------------------- body ----------------------------------------------------------
            Expanded(
              child: isServicePresent == ''?
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                    ),
                    color: Color(0xffF4F6F9)),
                  child: totalOrders > 0 ? Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(
                            left: 24, right: 20, top: 22, bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${dupOrderHistoryModel.length} ORDERS",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Color(0xff707375),
                              fontFamily: FontStrings.Roboto_Bold),
                        )
                    ),
                    Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                        itemCount: dupOrderHistoryModel.length,
                          itemBuilder: (context,orderIndex){
                        return GestureDetector(
                          onTap: () async {
                            print('${dupOrderHistoryModel[orderIndex].orderId}');
                            final result = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return
                                    PendingOrderDetails(dupOrderHistoryModel[orderIndex].status,dupOrderHistoryModel[orderIndex].orderId,dupOrderHistoryModel[orderIndex].needDelivery);
                                    // HistoryOrderDetails(
                                    //   '${dupOrderHistoryModel[orderIndex].orderId}','${dupOrderHistoryModel[orderIndex].status}','${dupOrderHistoryModel[orderIndex].needDelivery}');
                                }));


                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 4,
                                bottom: 8),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft:
                                      Radius.circular(10),
                                      topRight:
                                      Radius.circular(10),
                                      bottomLeft:
                                      Radius.circular(10),
                                      bottomRight:
                                      Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.2),
                                      spreadRadius: 0.3,
                                      blurRadius: 1,
                                      offset: Offset(0,
                                          1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Container(
                                  // padding: EdgeInsets.all(15),
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 0,
                                        right: 0),
                                    child: Column(
                                      children: [
                                        Padding(
                                            padding:
                                            EdgeInsets.only(
                                                left: 15,
                                                top: 5,
                                                right: 15),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child:
                                                      Container(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                        child:
                                                        Text(
                                                          '#${dupOrderHistoryModel[orderIndex].orderId}',
                                                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                              fontFamily:
                                                              FontStrings.Fieldwork10_Regular,
                                                              fontWeight: FontWeight.bold,
                                                              color: UIColor.darkBlue),
                                                        ),
                                                      ),
                                                    ),
                                                    orderStatus(dupOrderHistoryModel[orderIndex].status,context)
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: Dimens
                                                      .space12 *
                                                      _multi(
                                                          context),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                          children: List.generate(
                                                            dupOrderHistoryModel[orderIndex].services.length,
                                                                (serviceIndex) =>
                                                                Container(
                                                                  padding: EdgeInsets.only(left: 8.0, bottom: 8),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                            8.0,
                                                                            right:
                                                                            8),
                                                                        child:
                                                                        Icon(
                                                                          Icons
                                                                              .circle,
                                                                          color: dupOrderHistoryModel[orderIndex].services[serviceIndex].serviceType == 'No delivery needed'
                                                                              ? UIColor.baseColorTeal
                                                                              : Color(0xffF15B29),
                                                                          size:
                                                                          8,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${dupOrderHistoryModel[orderIndex].services[serviceIndex].serviceNameEn}',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .subtitle2
                                                                            .copyWith(
                                                                            fontFamily: FontStrings.Fieldwork10_Regular,
                                                                            color: UIColor.darkBlue),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                          )
                                                      ),
                                                    ),
                                                    dupOrderHistoryModel[orderIndex].isExpressService != 'No' ?  SvgPicture
                                                        .asset(
                                                      "assets/truck.svg",
                                                      color: UIColor.darkBlue,
                                                    ):Container(),
                                                    Padding(padding: EdgeInsets.all(8),)
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                  const EdgeInsets.only(left: 8.0, right: 8, top: 4, bottom: 4),
                                                  child: Row(
                                                    children: [
                                                      // Expanded(
                                                      //     child:
                                                      //         Text(
                                                      //   '${newOrderModel[index].orderId}',
                                                      //   style: Theme.of(
                                                      //           context)
                                                      //       .textTheme
                                                      //       .bodyText2
                                                      //       .copyWith(
                                                      //         fontFamily:
                                                      //             FontStrings.Roboto_Regular,
                                                      //       ),
                                                      // )),
                                                      Expanded(
                                                        child:
                                                        Container(
                                                          padding: const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8,
                                                              top: 8),
                                                          child:
                                                          Text(
                                                            '${dupOrderHistoryModel[orderIndex].orderDate}',
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyText2
                                                                .copyWith(
                                                              fontFamily: FontStrings.Roboto_Regular,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            left:
                                                            8.0,
                                                            top:
                                                            8),
                                                        child:
                                                        Text(
                                                          'Qty: ${dupOrderHistoryModel[orderIndex].quantity}',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyText2
                                                              .copyWith(
                                                            fontFamily: FontStrings.Roboto_Regular,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  color: Colors
                                                      .black26,
                                                ),
                                                Row(
                                                  children: [
                                                    _profilePic(
                                                        "${dupOrderHistoryModel[orderIndex].profilePhotoPath}",
                                                        context),
                                                    Expanded(
                                                      child:
                                                      Container(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            left:
                                                            16),
                                                        child:
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "${dupOrderHistoryModel[orderIndex].employeeName}",
                                                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                                fontFamily: FontStrings.Roboto_Bold,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height:
                                                              4,
                                                            ),
                                                            Text(
                                                              "Employee",
                                                              style:
                                                              Theme.of(context).textTheme.caption.copyWith(fontFamily: FontStrings.Roboto_Regular, fontSize: 10),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // Padding(padding: EdgeInsets.only(top: 0, bottom: 5)),
                                              ],
                                            )),
                                      ],
                                    ))),
                          ),
                        );
                      }),
                    ),
                  ],
                ):
                  Row(
                    children: [
                      Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/emptyOrder.svg',
                            allowDrawingOutsideViewBox: true,
                          ),
                          SizedBox(height: 20,),
                          Container(
                            child: Text('Your past and active orders will be shown here',textAlign: TextAlign.center ,style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontFamily: FontStrings.Roboto_Regular,
                              color: Color(0xFF707375),
                            ),),
                          ),
                        ],
                      ),
                ),
                    ],
                  ),
              ):
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    color: Color(0xffF4F6F9)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/emptyOrder.svg',
                            allowDrawingOutsideViewBox: true,
                          ),
                          SizedBox(height: 20,),
                          Container(
                            child: Text('$isServicePresent',textAlign: TextAlign.center ,style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontFamily: FontStrings.Roboto_Regular,
                              color: Color(0xFF707375),
                            ),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _appBar(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: Text(
                'History',
                style: TextStyle(
                    fontFamily: FontStrings.Fieldwork16_Bold,
                    fontSize: Dimens.space24 * MediaQuery.of(context).size.height * 0.01,
                    color: Colors.white),
              )),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              searchStatus = true;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SvgPicture.asset(
              'assets/Search.svg',
              allowDrawingOutsideViewBox: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchBar1(){
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: 50,
            margin: EdgeInsets.only(left: 10,right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: SvgPicture.asset(
                    'assets/Search.svg',
                    color: Color(0xff888B8D),
                    allowDrawingOutsideViewBox: true,
                  ),),

                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    cursorColor: Color(0xff0A95A0),
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: 'Search by order ID'),
                    style: TextStyle(
                      color: Color(0xff212156),
                      fontFamily: FontStrings.Roboto_Regular,
                    ),
                  ),),

                GestureDetector(
                  onTap: (){
                    setState(() {
                      searchStatus = false;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10,right: 10),
                    child: SvgPicture.asset(
                      'assets/close.svg',
                      color: Color(0xff888B8D),
                      allowDrawingOutsideViewBox: true,
                    ),),
                ),
              ],
            ),
          ),
        ),
        //
      ],
    );
  }

  Widget _searchBar() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: Dimens.space50 * _multi(context),
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: SvgPicture.asset(
                    'assets/Search.svg',
                    color: Color(0xff888B8D),
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
                Expanded(
                  child: TextField(
                      keyboardType: TextInputType.numberWithOptions(signed: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textInputAction: TextInputAction.search,
                      cursorColor: Color(0xff0A95A0),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Search'),
                      style: TextStyle(
                        color: Color(0xff212156),
                        fontFamily: FontStrings.Roboto_Regular,
                      ),
                      onSubmitted: (text) {
                        print("text : $text");

                        if (text.length != 0) {
                          dupOrderHistoryModel = orderHistoryModel
                              .where((x) => x.orderId
                              .toLowerCase()
                              .contains(text.toLowerCase()))
                              .toList();
                          print('dupOrderHistoryModel : ${dupOrderHistoryModel.length}');
                          print('orderHistoryModel : ${orderHistoryModel.length}');
                          setState(() {});
                        } else {
                          dupOrderHistoryModel = orderHistoryModel;
                          print('dupOrderHistoryModel : ${dupOrderHistoryModel.length}');
                          print('orderHistoryModel : ${orderHistoryModel.length}');
                          setState(() {});
                        }
                      },
                      onChanged: (text) {
                        print("text : $text");
                        if (text.length != 0) {
                          dupOrderHistoryModel = orderHistoryModel
                              .where((x) => x.orderId
                              .toLowerCase()
                              .contains(text.toLowerCase()))
                              .toList();
                          print('dupOrderHistoryModel : ${dupOrderHistoryModel.length}');
                          print('orderHistoryModel : ${orderHistoryModel.length}');
                          setState(() {});
                        } else {
                          dupOrderHistoryModel = orderHistoryModel;
                          print('dupOrderHistoryModel : ${dupOrderHistoryModel.length}');
                          print('orderHistoryModel : ${orderHistoryModel.length}');
                          setState(() {});
                        }
                      }),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      dupOrderHistoryModel = orderHistoryModel;
                      print('dupOrderHistoryModel : ${dupOrderHistoryModel.length}');
                      print('orderHistoryModel : ${orderHistoryModel.length}');
                      searchStatus = false;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: SvgPicture.asset(
                      'assets/close.svg',
                      color: Color(0xff888B8D),
                      allowDrawingOutsideViewBox: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        //
      ],
    );
  }

  Widget _profilePic(String URL, context) {
    return URL != null
        ? CircleAvatar(
      radius: 20,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: new SizedBox(
            child: Stack(
              children: <Widget>[
                Center(
                    child: CircularProgressIndicator(
                      // backgroundColor: UIColor.baseGradientLight,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          UIColor.baseGradientLight),
                    )),
                Center(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: URL,
                    fit: BoxFit.cover,
                    height: Dimens.space120 * _multi(context),
                    width: Dimens.space120 * _multi(context),
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
    )
        : CircleAvatar(
      radius: 60,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: new SizedBox(
          child: Image.asset("assets/emptyPhoto.svg"),
        ),
      ),
    );
  }

  // Widget orderStatus(String status){
  //   return Container(
  //     padding:
  //     const EdgeInsets.all(
  //         8.0),
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(10)),
  //         color: status == 'Processing'
  //             ? Color(0xffD8EEF0)
  //             : status == 'Order Accepted'
  //             ? Color(0xffD8EEF0)
  //             : status == 'Document Collection'
  //             ? Color(0xffD8EEF0)
  //             : status == 'With Driver'
  //             ? Color(0x12F15B29)
  //             : status == 'With Service Provider'
  //             ? Color(0x12F15B29)
  //             : status == 'Something is Wrong'
  //             ? Color(0xffFDD8DA)
  //             : status == 'Completed - Book Delivery'
  //             ? Color(0xffD8EEF0)
  //             : status == 'Delivery'
  //             ? Color(0xffD8EEF0)
  //             : status == 'Closed'
  //             ? Color(0xffD8EEF0)
  //             : status == 'Cancelled'
  //             ? Color(0xffFDD8DA)
  //             : Colors.transparent
  //
  //       // 'Processing',
  //       // 'Order Accepted',
  //       // 'Document Collection',
  //       // 'With Driver',
  //       // 'With Service Provider',
  //       // 'Something is Wrong',
  //       // 'Completed - Book Delivery',
  //       // 'Delivery',
  //       // 'Closed',
  //       // 'Cancelled'
  //
  //     ),
  //     child: Text(
  //       '$status',
  //       style: Theme.of(context).textTheme.bodyText1.copyWith(
  //           fontFamily: FontStrings.Roboto_Regular,
  //           color: status == 'Processing'
  //               ? Color(0xff0A95A0)
  //               : status == 'Order Accepted'
  //               ? Color(0xff0A95A0)
  //               : status == 'Document Collection'
  //               ? Color(0xff0A95A0)
  //               : status == 'With Driver'
  //               ? Color(0xFFF15B29)
  //               : status == 'With Service Provider'
  //               ? Color(0xFFF15B29)
  //               : status == 'Something is Wrong'
  //               ? Color(0xffC1282D)
  //               : status == 'Completed - Book Delivery'
  //               ? Color(0xff0A95A0)
  //               : status == 'Delivery'
  //               ? Color(0xff0A95A0)
  //               : status == 'Closed'
  //               ? Color(0xff0A95A0)
  //               : status == 'Cancelled'
  //               ? Color(0xffC1282D)
  //               : Colors.transparent),
  //     ),
  //   );
  // }

  void hitOrderHistoryListAPI(){
    orderHistory.fetchServices().then((result) {
      if (result["status"] == true) {
        isServicePresent = "";
        print('---------------${result["status"]}');
        print('-----------${result["message"]}');

        // dataModel = OrderListModel.fromJson(result).result;
        // print('-----------${dataModel[1].orderId}');
        orderHistoryModel = OrderHistoryModel.fromJson(result).result;
        dupOrderHistoryModel = orderHistoryModel;
        totalOrders = result["total"];

        setState(() {});
        // var obj = expandArray[0] as Map;
        // obj[0.toString()] = true;
        // print(obj);

      } else {
        isServicePresent = result["message"];
        print('-----------${result["message"]}');
        setState(() {
        });
        getSnackBar(null, result["message"]);
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      print('------------$isServicePresent');
      setState(() {
      });
      getSnackBar(null, isServicePresent);
    });
  }

}

