import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/Singleton/VendorDetailsSingleton.dart';
import 'package:takhlees_v/controller/Orders/ActiveOrderController.dart';
import 'package:takhlees_v/controller/Orders/NewOrderController.dart';
import 'package:takhlees_v/controller/Orders/PendingOrderController.dart';
import 'package:takhlees_v/model/ActiveOrderModel.dart';
import 'package:takhlees_v/model/NewOrderModel.dart';
import 'package:takhlees_v/model/PendingOrderModel.dart';
import 'package:takhlees_v/widget/OrderStatusWidget.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/widget/dialogBox/optionalDialog.dart';
import 'package:takhlees_v/widget/snackBar.dart';
import 'package:transparent_image/transparent_image.dart';
import '../OrderDetails.dart';
import '../PendingOrderDetails.dart';
import '../notifications.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}
class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  int _tabIndicator = 0;
  TabController _tabController;
  bool searchStatus = false;
  String serviceType = "";
  String latitude = "";
  final activeOrderCon = new TextEditingController();
  final pendingOrderCon = new TextEditingController();
  final newOrderCon = new TextEditingController();
  final newOrder = Get.put(NewOrderController());
  final pendingOrder = Get.put(PendingOrderController());
  final activeOrder = Get.put(ActiveOrderController());
  var newOrderModel = List<NewOrderResult>();
  var newOrderModelOriginal = List<NewOrderResult>();
  var pendingOrderModel = List<PendingOrderResult>();
  var pendingOrderModelOriginal = List<PendingOrderResult>();
  var activeOrderModelOriginal = List<ActiveOrderResult>();
  var activeOrderModel = List<ActiveOrderResult>();
  String longitude = "";
  int homeTime;
  int totalOrders;
  String isNewServicePresent;
  String isPendingServicePresent;
  String isActiveServicePresent;
  bool isActiveLoding = false;
  var responseMessage = 'Loading';
  var pendingResponseMessage;
  var activeResponseMessage;

  GlobalKey<RefreshIndicatorState> refreshKey;



  bool isPendingLoding = false;

  bool isNewLoading = false;

  var serviceItemList = VendorDetailsSingleton();

  Future<void> _refresh() async {
    hitOrderActiveAPI();
  }
  String selectedLanguage;
  Future<void> _selectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    selectedLanguage = prefs.getString('language');
    setState(() {});
    print('-------------$selectedLanguage');
    // return selectedLanguage;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _selectedLanguage();
    hitOrderListAPI();
    hitOrderPendingAPI();
    hitOrderActiveAPI();

    _tabController = new TabController(vsync: this, length: 3);
    //
    if(!serviceItemList.tabIndex.isNullOrBlank){
      _tabController.animateTo(serviceItemList.tabIndex);
    }

    // _tabController.animateTo(1);
    serviceType = "clearance";
    _tabController.addListener(() {
      print('\n|\n|\n|------------------- moved = ${_tabController.hasListeners}--\n|\n|\n|\n|--');
      serviceItemList.setTabPosition(0);
      print(_tabController.index);
      hitOrderListAPI();
      hitOrderPendingAPI();
      hitOrderActiveAPI();
      if (_tabController.index.isEqual(0)) {
        // vendorModel.clear();
        setState(() {});
      } else {
        setState(() {});
      }
    });
  }
  _multi(context) {
    return MediaQuery.of(context).size.height * 0.01;
  }
  @override
  Widget build(BuildContext context) {
    // final index = DefaultTabController.of(this.context).index;
    return DefaultTabController(
      initialIndex: _tabIndicator,
      length: 3,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              (UIColor.baseGradientDar),
              (UIColor.baseGradientLight)
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
          ),
          child: Column(
            children: [
              Container(
                height: Dimens.space100 * _multi(context),
                color: Colors.transparent,
                padding: EdgeInsets.only(top: 30),
                child: searchStatus == false ? _appBar() : _searchBar(),
              ),
              Expanded(
                child: Container(
                  child: Column(children: [
                    Container(
                      decoration: BoxDecoration(
                        color: UIColor.baseColorWhite,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 0.3,
                            blurRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(top: 5),
                      child: TabBar(
                        controller: _tabController,
                        labelStyle:
                        Theme.of(context).textTheme.subtitle1.copyWith(
                          fontFamily: selectedLanguage == 'en'?FontStrings.Roboto_Bold:FontStrings.Tajawal_Bold,
                          fontWeight: FontWeight.w700
                        ),

                        // TextStyle(
                        //   fontFamily: selectedLanguage == 'en'?FontStrings.Roboto_Bold:FontStrings.Tajawal_Bold,
                        //   fontSize: Dimens.space16 * _multi(context),
                        // ),
                        tabs: [
                          Tab(
                            text: '${'New'.tr}${' ('}${newOrderModelOriginal.length})',
                          ),
                          Tab(
                            // text: 'Active (${activeOrderModel.length})',
                            text: '${'Active'.tr}${' ('}${activeOrderModelOriginal.length})',

                          ),
                          Tab(
                            text: '${'Pending'.tr}${' ('}${pendingOrderModelOriginal.length})',
                          ),
                        ],
                        indicatorColor: UIColor.darkBlue,
                        unselectedLabelColor: UIColor.unselectedGrey,
                        labelColor: UIColor.darkBlue,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 2.0,
                        indicatorPadding: EdgeInsets.all(2),
                        isScrollable: false,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(controller: _tabController, children: [
                        !isNewLoading?newOrderModelOriginal.length != 0 ? Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
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
                                              controller: newOrderCon,
                                              keyboardType: TextInputType.text,
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
                                                print("search");
                                                if (text.length != 0) {
                                                  newOrderModel = newOrderModelOriginal
                                                      .where((x) => x.orderId
                                                      .toLowerCase()
                                                      .contains(text.toLowerCase()))
                                                      .toList();
                                                  setState(() {});
                                                } else {
                                                  newOrderModel = newOrderModelOriginal;
                                                  setState(() {});
                                                }
                                              },
                                              onChanged: (text) {
                                                if (text.length != 0) {
                                                  newOrderModel = newOrderModelOriginal
                                                      .where((x) => x.orderId
                                                      .toLowerCase()
                                                      .contains(text.toLowerCase()))
                                                      .toList();
                                                  setState(() {});
                                                } else {
                                                  newOrderModel = newOrderModelOriginal;
                                                  setState(() {});
                                                }
                                              }),
                                        ),
                                        newOrderCon.text.length > 0? GestureDetector(
                                          onTap: () {
                                            print('hhhh');
                                            FocusScope.of(context).requestFocus(FocusNode());
                                            setState(() {
                                              newOrderCon.text = '';
                                              newOrderModel = newOrderModelOriginal;
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
                                        ):Container(),
                                      ],
                                    ),
                                  ),
                                ),
                                //
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Container(
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: newOrderModel.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          final result = await Navigator.push(context,
                                              MaterialPageRoute(builder: (context) {
                                                return OrderDetails(
                                                    '${newOrderModel[index].orderId}','${newOrderModel[index].status}','${newOrderModel[index].needDelivery}');
                                              }));



                                          print('------- result = $result');
                                          if(result == 'true'||result == true){
                                            hitOrderListAPI();
                                            hitOrderActiveAPI();
                                            hitOrderPendingAPI();
                                          }

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
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        '${'#'}${newOrderModel[index].orderId}',
                                                                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                                            fontFamily:
                                                                                selectedLanguage == 'en'?FontStrings.Fieldwork10_Regular:FontStrings.Tajawal_Regular,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: UIColor.darkBlue),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SvgPicture.asset(
                                                                    "assets/clock.svg",
                                                                    color: Color(
                                                                        0xff404243),
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      '${newOrderModel[index].daysLeft} ${'d'.tr} ${'left'.tr}',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyText1
                                                                          .copyWith(
                                                                              fontFamily: selectedLanguage == 'en'?FontStrings.Roboto_Regular:FontStrings.Tajawal_Regular,
                                                                              color: UIColor.darkBlue),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: Dimens
                                                                        .space12 *
                                                                    _multi(
                                                                        context),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Expanded(
                                                                    child: Column(
                                                                        children: List
                                                                            .generate(
                                                                      newOrderModel[
                                                                              index]
                                                                          .services
                                                                          .length,
                                                                      (serviceIndex) =>
                                                                          Container(
                                                                        padding: EdgeInsets
                                                                            .only(
                                                                                left:
                                                                                    8.0,
                                                                                bottom:
                                                                                    8),
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
                                                                                color: newOrderModel[index].services[serviceIndex].serviceType == 'No delivery needed'
                                                                                    ? UIColor.baseColorTeal
                                                                                    : UIColor.baseGradientLight,
                                                                                size:
                                                                                    8,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              selectedLanguage == 'en'?
                                                                              '${newOrderModel[index].services[serviceIndex].serviceNameEn}':
                                                                              '${newOrderModel[index].services[serviceIndex].serviceNameAr}',
                                                                              style: Theme.of(context)
                                                                                  .textTheme
                                                                                  .subtitle1
                                                                                  .copyWith(
                                                                                      fontFamily:selectedLanguage == 'en'? FontStrings.Fieldwork10_Regular:FontStrings.Tajawal_Regular,
                                                                                      color: UIColor.darkBlue),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )),
                                                                  ),
                                                                  newOrderModel[index].isExpressService == 'Yes' ?  SvgPicture
                                                                      .asset(
                                                                    "assets/truck.svg",
                                                                    color: Color(
                                                                        0xff404243),
                                                                  ):Container(),
                                                                  Padding(padding: EdgeInsets.all(8))
                                                                ],
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0,
                                                                        right:
                                                                            8,
                                                                        top: 4,
                                                                        bottom:
                                                                            4),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                8.0,
                                                                            right:
                                                                                8,
                                                                            top:
                                                                                8),
                                                                        child:
                                                                            Text(
                                                                          '${newOrderModel[index].orderDate}',
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
                                                                        'Qty: ${newOrderModel[index].quantity}',
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
                                                              )
                                                              // Padding(padding: EdgeInsets.only(top: 0, bottom: 5)),
                                                            ],
                                                          )),
                                                    ],
                                                  ))),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ):Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/emptyService.svg',
                                allowDrawingOutsideViewBox: true,
                              ),
                              SizedBox(height: 10,),
                              Text("$isNewServicePresent",style:  Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontFamily: FontStrings.Roboto_Regular
                              ),),
                            ],
                          ),
                        ):Center(child: CircularProgressIndicator(color: UIColor.baseGradientLight,),),
                       !isActiveLoding ? activeOrderModelOriginal.length != 0 ? Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
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
                                            controller: activeOrderCon,
                                              keyboardType: TextInputType.text,
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
                                                print("search");
                                                if (text.length != 0) {
                                                  activeOrderModel = activeOrderModelOriginal
                                                      .where((x) => x.orderId
                                                      .toLowerCase()
                                                      .contains(text.toLowerCase()))
                                                      .toList();
                                                  setState(() {});
                                                } else {
                                                  activeOrderModel = activeOrderModelOriginal;
                                                  setState(() {});
                                                }
                                              },
                                              onChanged: (text) {
                                                if (text.length != 0) {
                                                  activeOrderModel = activeOrderModelOriginal
                                                      .where((x) => x.orderId
                                                      .toLowerCase()
                                                      .contains(text.toLowerCase()))
                                                      .toList();
                                                  setState(() {});
                                                } else {
                                                  activeOrderModel = activeOrderModelOriginal;
                                                  setState(() {});
                                                }
                                              }),
                                        ),
                                        activeOrderCon.text.length > 0 ?GestureDetector(
                                          onTap: () {
                                            print('hhhh');
                                            FocusScope.of(context).requestFocus(FocusNode());
                                            setState(() {
                                              activeOrderCon.text = '';
                                              activeOrderModel = activeOrderModelOriginal;
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
                                        ):Container(),
                                      ],
                                    ),
                                  ),
                                ),
                                //
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Container(
                                child:
                                RefreshIndicator(
                                  key: refreshKey,
                                  onRefresh: () {
                                   return _refresh();
                                  },
                                  child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: activeOrderModel.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            final result = await Navigator.push(context,
                                                MaterialPageRoute(builder: (context) {
                                                  return PendingOrderDetails(activeOrderModel[index].status,activeOrderModel[index].orderId,activeOrderModel[index].needDelivery);
                                                }));

                                            if(result == 'true'||result == true){
                                              print('');
                                              print('');
                                              print('');
                                              print('');
                                              print('');
                                              hitOrderListAPI();
                                              hitOrderActiveAPI();
                                              hitOrderPendingAPI();
                                            }

                                            // Get.to(OrderDetails( '${activeOrderModel[index].orderId}','${activeOrderModel[index].status}','${activeOrderModel[index].needDelivery}'));
                                          },
                                          child: activeOrderModel.length != 0? Container(
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
                                                                          '#${activeOrderModel[index].orderId}',
                                                                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                                              fontFamily:
                                                                                  FontStrings.Fieldwork10_Regular,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: UIColor.darkBlue),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    int.parse(activeOrderModel[index].daysLeft) > 1 ? Row(
                                                                      children: [
                                                                        SvgPicture
                                                                            .asset(
                                                                          "assets/clock.svg",
                                                                          color: Color(
                                                                              0xff404243),
                                                                        ),

                                                                        Container(
                                                                          padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                          child: Text(
                                                                            '${activeOrderModel[index].daysLeft}h left',
                                                                            style: Theme.of(
                                                                                context)
                                                                                .textTheme
                                                                                .bodyText1
                                                                                .copyWith(
                                                                                fontFamily: FontStrings.Roboto_Regular,
                                                                                color: UIColor.darkBlue),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ): Container(
                                                                      padding:
                                                                      const EdgeInsets.all(
                                                                          8.0),
                                                                      child: Text(
                                                                        'Over due',
                                                                        style: Theme.of(
                                                                            context)
                                                                            .textTheme
                                                                            .bodyText1
                                                                            .copyWith(
                                                                            fontFamily: FontStrings.Roboto_Regular,
                                                                            color: UIColor.baseGradientDar),
                                                                      ),
                                                                    ),
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
                                                                            activeOrderModel[index].services.length,
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
                                                                                  color: activeOrderModel[index].services[serviceIndex].serviceType == 'No delivery needed'
                                                                                      ? UIColor
                                                                                      .baseColorTeal
                                                                                      : UIColor
                                                                                      .baseGradientLight,
                                                                                  size:
                                                                                      8,
                                                                                ),
                                                                              ),
                                                                                  Text(
                                                                                '${activeOrderModel[index].services[serviceIndex].serviceNameEn}',
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
                                                                    activeOrderModel[index].isExpressService != 'No' ?  SvgPicture
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
                                                                              left:
                                                                                  8.0,
                                                                              right:
                                                                                  8,
                                                                              top:
                                                                                  8),
                                                                          child:
                                                                              Text(
                                                                            '${activeOrderModel[index].orderDate}',
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
                                                                          'Qty: ${activeOrderModel[index].quantity}',
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
                                                                        "${activeOrderModel[index].profilePhotoPath}",
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
                                                                              "${activeOrderModel[index].employeeName}",
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
                                          ): Container(),
                                        );
                                      }),
                                )
                              ),
                            ),
                          ],
                        ) : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/emptyService.svg',
                                allowDrawingOutsideViewBox: true,
                              ),
                              SizedBox(height: 10,),
                              Text("$isActiveServicePresent",style:  Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontFamily: FontStrings.Roboto_Regular
                              ),),
                            ],
                          ),
                        ):Center(child: CircularProgressIndicator(color: UIColor.baseGradientLight,),),
                        pendingOrderModelOriginal.length != 0 ? Column(
                          children: [
                          SizedBox(
                          height: 10,
                        ),
                        Row(
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
                                          controller: pendingOrderCon,
                                          keyboardType: TextInputType.text,
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
                                            print("search");
                                            if (text.length != 0) {
                                              pendingOrderModel = pendingOrderModelOriginal
                                                  .where((x) => x.orderId
                                                  .toLowerCase()
                                                  .contains(text.toLowerCase()))
                                                  .toList();
                                              setState(() {});
                                            } else {
                                              pendingOrderModel = pendingOrderModelOriginal;
                                              setState(() {});
                                            }
                                          },
                                          onChanged: (text) {
                                            if (text.length != 0) {
                                              pendingOrderModel = pendingOrderModelOriginal
                                                  .where((x) => x.orderId
                                                  .toLowerCase()
                                                  .contains(text.toLowerCase()))
                                                  .toList();
                                              setState(() {});
                                            } else {
                                              pendingOrderModel = pendingOrderModelOriginal;
                                              setState(() {});
                                            }
                                          }),
                                    ),
                                    pendingOrderCon.text.length > 0 ? GestureDetector(
                                      onTap: () {
                                        print('hhhh');
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        setState(() {
                                          pendingOrderCon.text = '';
                                          pendingOrderModel = pendingOrderModelOriginal;
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
                                    ): Container(),
                                  ],
                                ),
                              ),
                            ),
                            //
                          ],
                        ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Container(
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: pendingOrderModel.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          // Get.to(OrderDetails(
                                          //     '${pendingOrderModel[index].orderId}',
                                          //     '${pendingOrderModel[index].status}',
                                          //     '${pendingOrderModel[index].needDelivery}'
                                          // ));

                                          final result = await Navigator.push(context,
                                              MaterialPageRoute(builder: (context) {
                                                return PendingOrderDetails(pendingOrderModel[index].status,pendingOrderModel[index].orderId,pendingOrderModel[index].needDelivery);
                                              }));



                                          print('------- result = $result');
                                          if(result == 'true'||result == true){
                                            print('------- result = $result');
                                            hitOrderListAPI();
                                            hitOrderActiveAPI();
                                            hitOrderPendingAPI();
                                          }

                                          // Get.to(PendingOrderDetails(pendingOrderModel[index].status,pendingOrderModel[index].orderId));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(left: 20,right: 20,top: 4,bottom: 8),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight:Radius.circular(10),
                                                    bottomLeft: Radius.circular(10),
                                                    bottomRight: Radius.circular(10)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.2),
                                                    spreadRadius: 0.3,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1), // changes position of shadow
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
                                                                        '#${pendingOrderModel[index].orderId}',
                                                                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                                            fontFamily:FontStrings.Fieldwork10_Regular,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: UIColor.darkBlue),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  // Container(
                                                                  //   padding:
                                                                  //       const EdgeInsets.all(
                                                                  //           8.0),
                                                                  //   decoration: BoxDecoration(
                                                                  //       borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                  //       color: pendingOrderModel[index].status == 'Processing'
                                                                  //           ? Color(0xffD8EEF0)
                                                                  //           : pendingOrderModel[index].status == 'Order Accepted'
                                                                  //               ? Color(0xffD8EEF0)
                                                                  //               : pendingOrderModel[index].status == 'Document Collection'
                                                                  //                   ? Color(0xffD8EEF0)
                                                                  //                   : pendingOrderModel[index].status == 'With Driver'
                                                                  //                       ? Color(0x12F15B29)
                                                                  //                       : pendingOrderModel[index].status == 'With Service Provider'
                                                                  //                           ? Color(0x12F15B29)
                                                                  //                           : pendingOrderModel[index].status == 'Something is Wrong'
                                                                  //                               ? Color(0xffFDD8DA)
                                                                  //                               : pendingOrderModel[index].status == 'Completed - Book Delivery'
                                                                  //                                   ? Color(0xffD8EEF0)
                                                                  //                                   : pendingOrderModel[index].status == 'Delivery'
                                                                  //                                       ? Color(0xffD8EEF0)
                                                                  //                                       : pendingOrderModel[index].status == 'Closed'
                                                                  //                                           ? Color(0xffD8EEF0)
                                                                  //                                           : pendingOrderModel[index].status == 'Cancelled'
                                                                  //                                               ? Color(0xffFDD8DA)
                                                                  //                                               : Colors.transparent
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
                                                                  //       ),
                                                                  //   child: Text(
                                                                  //     '${pendingOrderModel[index].status}',
                                                                  //     style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                                  //         fontFamily: FontStrings.Roboto_Regular,
                                                                  //         color: pendingOrderModel[index].status == 'Processing'
                                                                  //             ? Color(0xff0A95A0)
                                                                  //             : pendingOrderModel[index].status == 'Order Accepted'
                                                                  //                 ? Color(0xff0A95A0)
                                                                  //                 : pendingOrderModel[index].status == 'Document Collection'
                                                                  //                     ? Color(0xff0A95A0)
                                                                  //                     : pendingOrderModel[index].status == 'With Driver'
                                                                  //                         ? Color(0xFFF15B29)
                                                                  //                         : pendingOrderModel[index].status == 'With Service Provider'
                                                                  //                             ? Color(0xFFF15B29)
                                                                  //                             : pendingOrderModel[index].status == 'Something is Wrong'
                                                                  //                                 ? Color(0xffC1282D)
                                                                  //                                 : pendingOrderModel[index].status == 'Completed - Book Delivery'
                                                                  //                                     ? Color(0xff0A95A0)
                                                                  //                                     : pendingOrderModel[index].status == 'Delivery'
                                                                  //                                         ? Color(0xff0A95A0)
                                                                  //                                         : pendingOrderModel[index].status == 'Closed'
                                                                  //                                             ? Color(0xff0A95A0)
                                                                  //                                             : pendingOrderModel[index].status == 'Cancelled'
                                                                  //                                                 ? Color(0xffC1282D)
                                                                  //                                                 : Colors.transparent),
                                                                  //   ),
                                                                  // ),
                                                                  orderStatus(pendingOrderModel[index].status,context)
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
                                                                  Column(
                                                                      crossAxisAlignment:CrossAxisAlignment.start,
                                                                      children: List.generate(pendingOrderModel[index].services.length,
                                                                    (serviceIndex) => Container(
                                                                      // color: Colors.red,
                                                                      padding: EdgeInsets.only(left:8, bottom: 8),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        // crossAxisAlignment:CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            padding: const EdgeInsets.only(left:8,right:8),
                                                                            child:
                                                                                Icon(Icons.circle,
                                                                              color: pendingOrderModel[index].services[serviceIndex].serviceType == 'Needs delivery'
                                                                                  ? Color(0xffF15B29)
                                                                                  : UIColor.baseColorTeal,
                                                                              size:
                                                                                  8,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            '${pendingOrderModel[index].services[serviceIndex].serviceNameEn}',
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
                                                                  )),
                                                                  Spacer(),
                                                                  pendingOrderModel[index].isExpressService == 'Yes' ?  SvgPicture
                                                                      .asset(
                                                                    "assets/truck.svg",
                                                                    color: UIColor.darkBlue,
                                                                  ):Container(),
                                                                  SizedBox(width: 10,)
                                                                ],
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0,
                                                                        right:
                                                                            8,
                                                                        top: 4,
                                                                        bottom:
                                                                            4),
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
                                                                            left:
                                                                                8.0,
                                                                            right:
                                                                                8,
                                                                            top:
                                                                                8),
                                                                        child:
                                                                            Text(
                                                                          '${pendingOrderModel[index].orderDate}',
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
                                                                        'Qty: ${pendingOrderModel[index].quantity}',
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
                                                                      "${pendingOrderModel[index].profilePhotoPath}",
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
                                                                            "${pendingOrderModel[index].employeeName}",
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
                                                                            style: Theme.of(context).textTheme.caption.copyWith(fontFamily: FontStrings.Roboto_Regular, fontSize: 10),
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
                            ),
                          ],
                        ):Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/emptyService.svg',
                                allowDrawingOutsideViewBox: true,
                              ),
                              SizedBox(height: 10,),
                              Text("$pendingResponseMessage",style:  Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontFamily: FontStrings.Roboto_Regular
                              ),),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ]),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      color: Color(0xffF4F6F9)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                  child: Text(
                    'Service Providers'.tr,
                    style: TextStyle(
                        fontFamily: FontStrings.Fieldwork16_Bold,
                        fontSize: Dimens.space24 *
                            MediaQuery.of(context).size.height *
                            0.01,
                        color: Colors.white),
                  )),
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              //notification
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Notifications();
                    }));
                  },
                  child: SvgPicture.asset(
                    'assets/With Notification.svg',
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
              ),

              //search
              // Padding(
              //   padding: EdgeInsets.only(
              //       top: Dimens.space10 * _multi(context),
              //       bottom: Dimens.space10 * _multi(context),
              //       right: Dimens.space10 * _multi(context),
              //       left: Dimens.space16 * _multi(context)),
              //   child: GestureDetector(
              //     onTap: () {
              //       setState(() {
              //         searchStatus = true;
              //       });
              //     },
              //     child: SvgPicture.asset(
              //       'assets/Search.svg',
              //       allowDrawingOutsideViewBox: true,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
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
                      keyboardType: TextInputType.text,
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
                        print("search");
                        // if (text.length != 0) {
                        //   vendorModel = originalVendorModel
                        //       .where((x) => x.companyNameEn
                        //           .toLowerCase()
                        //           .contains(text.toLowerCase()))
                        //       .toList();
                        //   setState(() {});
                        // } else {
                        //   vendorModel = originalVendorModel;
                        //   setState(() {});
                        // }
                      },
                      onChanged: (text) {
                        // log.d("First text field: $text");
                        // if (text.length != 0) {
                        //   vendorModel = originalVendorModel
                        //       .where((x) => x.companyNameEn
                        //           .toLowerCase()
                        //           .contains(text.toLowerCase()))
                        //       .toList();
                        //   setState(() {});
                        // } else {
                        //   vendorModel = originalVendorModel;
                        //   setState(() {});
                        // }
                      }),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // vendorModel = originalVendorModel;
                      // searchStatus = false;
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
      ],
    );
  }
  Future<bool> loginAction() async {
    await new Future.delayed(const Duration(seconds: 1));
    serviceTypesDialog();
    return true;
  }
  void serviceTypesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
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
                        height: MediaQuery.of(context).size.height / 3,
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
                                child: Column(
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
                                                fontSize: Dimens.space12 *
                                                    _multi(context),
                                                fontFamily:
                                                    FontStrings.Roboto_Bold,
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
                                          fontFamily:
                                              FontStrings.Roboto_Regular,
                                          fontSize:
                                              Dimens.space14 * _multi(context),
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
                                                fontFamily:
                                                    FontStrings.Roboto_Bold,
                                                fontSize: Dimens.space12 *
                                                    _multi(context),
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
                                          fontFamily:
                                              FontStrings.Roboto_Regular,
                                          fontSize:
                                              Dimens.space14 * _multi(context),
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
                                  colors: <Color>[
                                    Color(0xffC1282D),
                                    Color(0xffF15B29)
                                  ],
                                ),
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily:
                                          FontStrings.Fieldwork10_Regular,
                                      fontSize:
                                          Dimens.space16 * _multi(context)),
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
  void hitOrderListAPI() {
    isNewLoading = true;
    newOrder.fetchServices().then((result) {
      isNewLoading = false;
      if (result["status"] == true) {
        isNewServicePresent = "";
        responseMessage = result["message"];
        print('---------------\n${result["status"]}');
        print('-----------${result["message"]}');
        totalOrders = result['total'];
        newOrderModelOriginal = NewOrderModel.fromJson(result).result;
        newOrderModel.clear();
        newOrderModel = newOrderModelOriginal;
        print('--------- orderId -- ${newOrderModel[0].orderId}');
        print('--------- orderId -- ${newOrderModel[0].status}');
        setState(() {});
      } else {
        isNewServicePresent = result["message"];
        responseMessage = result["message"];
        if(result["message"] == "Order not found"){
          totalOrders = 0;
          newOrderModel.clear();
        }
        print('-----else------${result["message"]}');
        if('${result["message"]}'.contains('Unauthenticated')){
          getSnackBar(null, 'Account Inactive');
        }
        setState(() {});
      }
    }, onError: (error) {
      isNewServicePresent = error.toString();
      newOrderModel.clear();

      

      print('-----error-bbb------$isServicePresent');
      setState(() {});
    });
  }
  void hitOrderPendingAPI() {
    isPendingLoding = true;
    pendingOrder.fetchServices().then((result) {
      isPendingLoding = false;
      if('${result["message"]}'.contains('Unauthenticated')){
        getSnackBar(null, 'Account Inactive');
      }
      if (result["status"] == true) {
        pendingResponseMessage = result["message"];
        isPendingServicePresent = "";
        print('---------------\n${result["status"]}');
        print('-----------${result["message"]}');
        totalOrders = result['total'];
        pendingOrderModelOriginal = PendingOrderModel.fromJson(result).result;
        pendingOrderModel.clear();
        pendingOrderModel = pendingOrderModelOriginal;
        print('--------- orderId -- ${pendingOrderModel[0].orderId}');
        setState(() {});
      } else {
        pendingResponseMessage = result["message"];
        isPendingServicePresent = result["message"];
        pendingOrderModel.clear();
        if('${result["message"]}'.contains('Unauthenticated')){
          getSnackBar(null, 'Account Inactive');
        }
        if(result["message"] == "Order not found"){
          totalOrders = 0;
          pendingOrderModel.clear();
        }
        print('-----------${result["message"]}');
        setState(() {});
      }
    }, onError: (error) {
      isPendingServicePresent = error.toString();
      pendingOrderModel.clear();
      print('------------$isPendingServicePresent');
      setState(() {});
    });
  }
  void hitOrderActiveAPI() {
    isActiveLoding = true;
    // showLoading('message');
    // activeOrderModel.clear();
    activeOrder.fetchServices().then((result) {
      isActiveLoding = false;
      // hideLoading();
      if (result["status"] == true) {
        isActiveServicePresent = "";
        activeResponseMessage = result["message"];
        print('===> status ==>${result["status"]}');
        print('===> message ==> ${result["message"]}');
        print('  ');
        print('   ');
        print('====> result ==> ${result["result"]}');

        // print('${ActiveOrderModel
        //     .fromJson(result)
        //     .result}');
        totalOrders = result['total'];
        activeOrderModelOriginal = ActiveOrderModel.fromJson(result).result;
        activeOrderModel.clear();
        activeOrderModel= activeOrderModelOriginal;
        setState(() {});
      } else {
        print('====> error result ==> ${result["result"]}');
        if('${result["message"]}'.contains('Unauthenticated')){
          getSnackBar(null, 'Account Inactive');
        }
        activeResponseMessage = result["message"];
        isActiveServicePresent = result["message"];
        activeOrderModel.clear();
        // if(result["message"] == "Order not found"){
        //   totalOrders = 0;
        //   activeResponseMessage = '';
        // }
        print('------Aresult["message"] -----${result["message"]}');
        setState(() {});
      }
    }, onError: (error) {
      activeOrderModel.clear();
      isActiveServicePresent = error.toString();
      print('===> error ==> $isActiveServicePresent');
      setState(() {});
    });
  }
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
  Widget _profilePic(String URL, context) {
    // print('---------> Image URL - ${URL.length}');
    // URL = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDeo2EJiwjckFFs9X4bnPnttb0dvmkuWvu4A&usqp=CAU';
    if(URL == null|| URL.isEmpty||URL.isBlank||URL== ''||URL == 'null'){
      URL = 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png';
    }else{
      // print('@@@@@ - $URL');
    }
    return URL != null
        ? CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: new SizedBox(
                  child: Stack(
                children: <Widget>[
                  // Center(
                  //     child: CircularProgressIndicator(
                  //   // backgroundColor: UIColor.baseGradientLight,
                  //   valueColor: AlwaysStoppedAnimation<Color>(
                  //       UIColor.baseGradientLight),
                  // )),
                  Center(
                    child:
                    CachedNetworkImage(
                      imageUrl: URL,
                      fit: BoxFit.cover,
                        height: Dimens.space120 * _multi(context),
                        width: Dimens.space120 * _multi(context),
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircularProgressIndicator(
                            // backgroundColor: UIColor.baseGradientLight,
                              value: downloadProgress.progress,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                UIColor.baseGradientLight),
                          ),
                          // CircularProgressIndicator(value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    // FadeInImage.memoryNetwork(
                    //   placeholder: kTransparentImage,
                    //   image: URL,
                    //   fit: BoxFit.cover,
                    //   height: Dimens.space120 * _multi(context),
                    //   width: Dimens.space120 * _multi(context),
                    // ),
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
}
