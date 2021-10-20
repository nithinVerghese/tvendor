import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/Singleton/VendorDetailsSingleton.dart';
import 'package:takhlees_v/controller/Orders/OrderAcceptController.dart';
import 'package:takhlees_v/controller/Orders/OrderCannotBeSolvedController.dart';
import 'package:takhlees_v/controller/Orders/OrderCompleteController.dart';
import 'package:takhlees_v/controller/Orders/OrderDetailController.dart';
import 'package:takhlees_v/controller/Orders/OrderStatusController.dart';
import 'package:takhlees_v/model/OrderDetailModel.dart';
import 'package:takhlees_v/view/NewOrder/NewOrderService/NewOrderService.dart';
import 'package:takhlees_v/widget/LinedButton.dart';
import 'package:takhlees_v/widget/OrderStatusWidget.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:takhlees_v/widget/TimeCounter.dart';
import 'package:takhlees_v/widget/snackBar.dart';
import 'package:transparent_image/transparent_image.dart';

import 'Settings/ManageService/ManageService.dart';


class OrderDetails extends StatefulWidget {
  final String orderID;
  final String orderType;
  final String needDelivery;

  const OrderDetails(this.orderID, this.orderType, this.needDelivery);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

final readCon = new TextEditingController();
bool processing = false;
bool completed = false;
bool solved = false;
bool notSolved = false;
final orderDetailController = Get.put(OrderDetailController());
final orderAcceptController = Get.put(OrderAcceptController());
final orderCompleteController = Get.put(OrderCompleteController());
final orderStatusController = Get.put(OrderStatusController());
final orderCannotBeSolvedController = Get.put(OrderCannotBeSolvedController());
var orderDetailModel = OrderDetailResult();
String isServicePresent = 'de';
bool isOrderIssue = false;
String status = '';
String _orderMainStatus;

class _OrderDetailsState extends State<OrderDetails> {
  // String Status;

  VendorDetailsSingleton sVendorDetail = new VendorDetailsSingleton();
  bool isLoading = false;


  @override
  void initState() {
    print(
        '------------------------------OrderDetailsScreen------------------------');
    hitOrderListAPI(widget.orderID);
    print('''------
processing: $processing,
completed: $completed,
solved: $solved,
notSolved: $notSolved
------''');
    // TODO: implement initState
    super.initState();
  }

  _multi(context) {
    return MediaQuery.of(context).size.height * 0.01;
  }

  var isPickup = false;
  var serviceType = "";

  FocusNode _focusNode1 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        brightness: Brightness.light,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Color(0xff212156),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            );
          },
        ),
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.only(right: 24),
              child: GestureDetector(
                child: Text(
                  '#${widget.orderID}',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontFamily: FontStrings.Fieldwork16_Bold,
                        color: Color(0xff212156),
                      ),
                ),
              ),
            ),
          ),
        ],
        // Icon(Icons.arrow_back_ios_rounded,
        //     color: Color(0xff212156),),
        backgroundColor: Colors.white,
        title: Text(
          "Order details",
          style: Theme.of(context).textTheme.headline6.copyWith(
              fontFamily: FontStrings.Fieldwork10_Regular,
              color: Color(0xff212156)),
        ),
      ),
      body: isLoading?Center(
        child: CircularProgressIndicator(),
      ):SafeArea(
        child: isServicePresent == ''
            ? Column(children: [
                SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: KeyboardActions(
                    config: KeyboardActionsConfig(
                        actions: [KeyboardActionsItem(focusNode: _focusNode1)]),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // time left
                          Container(
                              padding: EdgeInsets.only(left: 24, right: 24),
                              decoration: BoxDecoration(
                                color: UIColor.baseColorWhite,
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
                              child: Column(
                                children: [
                                  _item3(context,
                                      orderDetailModel.estimatedCompletedTime),
                                ],
                              )),
                          Container(
                              padding: EdgeInsets.only(left: 24, right: 24),
                              decoration: BoxDecoration(
                                color: UIColor.baseColorWhite,
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
                              child: Column(
                                children: [
                                  _item4('Order date & time',
                                      '${orderDetailModel.orderDate}'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 24, right: 24),
                              decoration: BoxDecoration(
                                color: UIColor.baseColorWhite,
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
                              child: Column(
                                children: [
                                  _item5(
                                      '${orderDetailModel.consumerDetails.consumerName}',
                                      'Customer',
                                      '${orderDetailModel.consumerDetails.profilePhotoPath}'),
                                ],
                              )),
                          SizedBox(
                            height: 1,
                          ),
                          orderDetailModel.pickupNotes == null
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.only(left: 24, right: 24),
                                  decoration: BoxDecoration(
                                    color: UIColor.baseColorWhite,
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
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 13.5, bottom: 12.5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Text(
                                                  "${orderDetailModel.pickupNotes}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                          fontFamily: FontStrings
                                                              .Roboto_Regular,
                                                          color: Color(
                                                              0xff212156)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                          title(context, 'SERVICE(S)',
                              '${orderDetailModel.totalServices}'),
                          Column(
                            children:
                                List.generate(orderDetailModel.services.length,
                                    (serviceIndex) {
                              return Column(
                                children: [
                                  // SizedBox(height: 1,),
                                  Container(
                                      padding:
                                          EdgeInsets.only(left: 24, right: 24),
                                      decoration: BoxDecoration(
                                        color: UIColor.baseColorWhite,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(0,
                                                1), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                              child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 13, bottom: 7),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Icon(
                                                              Icons.circle,
                                                              size: 8,
                                                              color: orderDetailModel
                                                                          .services[
                                                                              serviceIndex]
                                                                          .serviceType ==
                                                                      'No delivery needed'
                                                                  ? UIColor
                                                                      .baseColorTeal
                                                                  : UIColor
                                                                      .baseGradientLight,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              '${orderDetailModel.services[serviceIndex].serviceNameEn}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .subtitle1
                                                                  .copyWith(
                                                                      fontFamily:
                                                                          FontStrings
                                                                              .Roboto_Regular,
                                                                      color: Color(
                                                                          0xFf404243)),
                                                            ),
                                                          ),
                                                          orderStatus(
                                                              '${orderDetailModel.services[serviceIndex].itemStatus}',
                                                              context),
                                                        ],
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   child: Text(
                                                    //     '40 BHD',
                                                    //     style: TextStyle(
                                                    //         fontFamily:
                                                    //             FontStrings
                                                    //                 .Roboto_Bold,
                                                    //         color: Color(
                                                    //             0xFF212156)),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0, bottom: 13),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        child: Text(
                                                          'Est.time: ${orderDetailModel.services[serviceIndex].serviceTime} days',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  FontStrings
                                                                      .Roboto_Regular,
                                                              color: Color(
                                                                  0xFF5D5F61)),
                                                        ),
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   child: Text(
                                                    //     'Qty: ${orderDetailModel.services[serviceIndex].quantity}',
                                                    //     style: TextStyle(
                                                    //         fontFamily: FontStrings
                                                    //             .Roboto_Regular,
                                                    //         color: Color(
                                                    //             0xFF5D5F61)),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              orderDetailModel.services[serviceIndex].needName == "Yes" ? Container(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text("Name: ",
                                                                style: TextStyle(
                                                                  fontFamily: FontStrings
                                                                      .Roboto_Regular,
                                                                  color: Color(
                                                                      0xFF404243),
                                                                ))),
                                                        Text("${orderDetailModel.services[serviceIndex].name}",
                                                            style: TextStyle(
                                                              fontFamily: FontStrings
                                                                  .Roboto_Regular,
                                                              color:
                                                              Color(0xFF404243),
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text("ID Number: ",
                                                                style: TextStyle(
                                                                  fontFamily: FontStrings
                                                                      .Roboto_Regular,
                                                                  color: Color(
                                                                      0xFF404243),
                                                                ))),
                                                        Text("${orderDetailModel.services[serviceIndex].documentID}",
                                                            style: TextStyle(
                                                              fontFamily: FontStrings
                                                                  .Roboto_Regular,
                                                              color:
                                                              Color(0xFF404243),
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ):Container(),
                                      isOrderIssue ? orderDetailModel.services[serviceIndex].itemStatus == "Processing"
                                                  ? SizedBox(
                                                      child: LinedButton(
                                                        onPressed: () {
                                                          loadingDialog(
                                                              context,"${orderDetailModel.services[serviceIndex].itemId}");
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Order issue',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xff212156),
                                                                  fontFamily:
                                                                      FontStrings
                                                                          .Fieldwork10_Regular,
                                                                  fontSize: 16),
                                                            ),
                                                          ],
                                                        ),
                                                        color:
                                                            Color(0xffC1282D),
                                                      ),
                                                      width: 300,
                                                    )
                                                  : Container(): Container(),
                                              isOrderIssue
                                                  ? SizedBox(
                                                      height: 10,
                                                    )
                                                  : Container(),
                                            ],
                                          )),
                                          Container(
                                            child: Divider(
                                              color: Colors.black26,
                                            ),
                                          ),
                                          orderDetailModel.services[serviceIndex].documentNameEn.isNotEmpty ? Container(
                                            padding: EdgeInsets.only(
                                                top: 13, bottom: 13),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 12),
                                                  child: SvgPicture.asset(
                                                    "assets/document.svg",
                                                    color: Color(0xff404243),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      '${orderDetailModel.services[serviceIndex].documentNameEn}',
                                                      style: TextStyle(
                                                          fontFamily: FontStrings
                                                              .Roboto_Regular,
                                                          color: Color(
                                                              0xFF404243)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ):Container(),
                                          _item('Government fees', '${orderDetailModel.services[serviceIndex].governmentFee} BHD'),
                                          _item('Service fees', '${orderDetailModel.services[serviceIndex].serviceFee} BHD'),
                                          Container(
                                            padding: EdgeInsets.only(top: 13, bottom: 13),
                                            child: Row(
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      'Sub total service fees',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2
                                                          .copyWith(
                                                              fontFamily:
                                                                  FontStrings
                                                                      .Roboto_Bold,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Color(
                                                                  0xFF4D4F51)),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    width: 200,
                                                    child: Text(
                                                      '${orderDetailModel.services[serviceIndex].subTotal} BHD',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2
                                                          .copyWith(
                                                              fontFamily:
                                                                  FontStrings
                                                                      .Roboto_SemiBold,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Color(
                                                                  0xff212156)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            }),
                          ),
                          widget.needDelivery == 'Yes'
                              ? title2(context, 'PICKUP INFORMATION')
                              : Container(),
                          widget.needDelivery == 'Yes'
                              ? Container(
                                  padding: EdgeInsets.only(left: 24, right: 24),
                                  decoration: BoxDecoration(
                                    color: UIColor.baseColorWhite,
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
                                  child: Column(
                                    children: [
                                      // _item2('Pickup address',
                                      //     '${orderDetailModel.pickupAddress}'),
                                      _item('Pickup date & time','${orderDetailModel.pickupDate}')
                                    ],
                                  ))
                              : Container(),
                          title2(context, 'FEES & PAYMENT'),
                          Container(
                              padding: EdgeInsets.only(left: 24, right: 24),
                              decoration: BoxDecoration(
                                color: UIColor.baseColorWhite,
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
                              child: Column(
                                children: [
                                  _item('Total fees',
                                      'BHD ${orderDetailModel.totalAmount}'),
                                  _item('Payment Method',
                                      '${orderDetailModel.paymentMethod}'),
                                ],
                              )),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                _footer(),
                SizedBox(
                  height: 18,
                ),
              ])
            : Container(),
      ),
    );
  }

  Widget _footer() {
    return Column(
      children: [
        // isOrderIssue ? Padding(
        //   padding: const EdgeInsets.only(left:20, right: 20),
        //   child: LinedButton(
        //   //   onPressed: (){
        //   //     loadingDialog(context);
        //   // },
        //       child: Row(
        //         mainAxisAlignment:
        //         MainAxisAlignment.center,
        //         children: [
        //           Text(
        //             'Order issue',
        //             textAlign: TextAlign.center,
        //             style: TextStyle(
        //                 color: Color(0xff212156),
        //                 fontFamily: FontStrings.Fieldwork10_Regular,
        //                 fontSize: 16),
        //           ),
        //         ],
        //       ),
        //       color: Color(0xffC1282D),
        //   )
        // ) : Container(),
        // isOrderIssue ? SizedBox(height: 10,): Container(),
        _orderMainStatus == 'Order Accepted'
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: RaisedGradientButton(
                  onPressed: () {
                    hitOrderCompleteAPI(widget.orderID);
                  },
                  child: Text(
                    'Complete',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: FontStrings.Fieldwork10_Regular,
                        fontSize: 16),
                  ),
                  gradient: LinearGradient(
                    colors: <Color>[Color(0xffC1282D), Color(0xffF15B29)],
                  ),
                ),
              )
            : Container(),
        _orderMainStatus == 'Order Accepted'
            ? SizedBox(
                height: 10,
              )
            : Container(),
        _orderMainStatus == 'Processing'
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: RaisedGradientButton(
                  onPressed: () {
                    hitOrderAcceptAPI(widget.orderID);
                  },
                  child: Text(
                    'Claim',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: FontStrings.Fieldwork10_Regular,
                        fontSize: 16),
                  ),
                  gradient: LinearGradient(
                    colors: <Color>[Color(0xffC1282D), Color(0xffF15B29)],
                  ),
                ),
              )
            : Container(),
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
              )),
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

  Widget _item(String itemName, String item) {
    return Container(
      padding: EdgeInsets.only(top: 13, bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: Text(
                itemName,
                style: TextStyle(
                    fontFamily: FontStrings.Roboto_SemiBold,
                    color: Color(0xFF4D4F51)),
              ),
            ),
          ),
          Container(
            child: Text(
              item,
              style: TextStyle(
                  fontFamily: FontStrings.Roboto_Bold,
                  color: UIColor.darkBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item2(String itemName, String item) {
    var text = Text(
      item,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontFamily: FontStrings.Roboto_Bold, color: Color(0xFF404243)),
    );
    return Container(
      padding: EdgeInsets.only(top: 13, bottom: 13),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            child: Container(
              child: Text(
                itemName,
                style: TextStyle(
                    fontFamily: FontStrings.Roboto_SemiBold,
                    color: Color(0xFF4D4F51)),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              width: 200,
              child: text,
            ),
          ),
          Icon(
            Icons.chevron_right_outlined,
            color: Color(0xFF404243),
          ),
        ],
      ),
    );
  }

  Widget _item3(BuildContext context, int second) {
    print('-----------Second = $second');
    return Container(
      padding: EdgeInsets.only(top: 13, bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SvgPicture.asset(
              "assets/clock.svg",
              color: Color(0xff404243),
            ),
          ),
          Expanded(
            child: Container(
              child: counter(context, second),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item4(String itemName, String item) {
    return Container(
      padding: EdgeInsets.only(top: 13),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: Text(
                    itemName,
                    style: TextStyle(
                        fontFamily: FontStrings.Roboto_SemiBold,
                        color: Color(0xFF4D4F51)),
                  ),
                ),
              ),
              Container(
                child: Text(
                  item,
                  style: TextStyle(
                      fontFamily: FontStrings.Roboto_Bold,
                      color: Color(0xFF404243)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item5(String itemName2, String item2, String url) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Container(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Row(
                children: [
                  _profilePic("$url", context),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemName2,
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontFamily: FontStrings.Roboto_Bold,
                                    ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            item2,
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontFamily: FontStrings.Roboto_Regular,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget title(context, title, number) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 25.5, bottom: 16.5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontFamily: FontStrings.Roboto_SemiBold,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF888B8D),
                    ),
              ),
            ),
          ),
          Container(
            child: Text(
              number,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  fontFamily: FontStrings.Fieldwork16_Bold,
                  color: Color(0xff212156)),
            ),
          ),
        ],
      ),
    );
  }

  Widget title2(context, title) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 15, bottom: 16.5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: Theme.of(context).textTheme.caption.copyWith(
                      fontFamily: FontStrings.Roboto_SemiBold,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF888B8D),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void loadingDialog(BuildContext context,var itemID) {
    showDialog(
      context: context,
      // barrierDismissible: false,
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
                        margin: EdgeInsets.all(18),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFFEFEFEF),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 16, top: 16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Order Status',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                fontFamily: FontStrings
                                                    .Fieldwork10_Regular,
                                                color: Color(0xFF212156),
                                              ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: SvgPicture.asset(
                                          'assets/close.svg',
                                          allowDrawingOutsideViewBox: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     // if (processing) {
//                                     //   processing = false;
//                                     //   completed = false;
//                                     //   solved = false;
//                                     //   notSolved = false;
//                                     //   setState(() {});
//                                     // } else {
//                                     //   processing = true;
//                                     //   completed = false;
//                                     //   solved = false;
//                                     //   notSolved = false;
//                                     //   setState(() {});
//                                     // }
//
//                                     // _orderStatus("processing");
//                                     processing = true;
//                                     completed = false;
//                                     solved = false;
//                                     notSolved = false;
//                                     setState(() {});
//                                     print('''------
// processing: $processing,
// completed: $completed,
// solved: $solved,
// notSolved: $notSolved
// ------''');
//                                   },
//                                   child: Row(
//                                     children: [
//                                       processing == true
//                                           ? SvgPicture.asset(
//                                               'assets/on.svg',
//                                               allowDrawingOutsideViewBox: true,
//                                             )
//                                           : SvgPicture.asset(
//                                               'assets/off.svg',
//                                               allowDrawingOutsideViewBox: true,
//                                             ),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 12.0,vertical: 10),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Processing',
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .bodyText2
//                                                   .copyWith(
//                                                     fontFamily: FontStrings
//                                                         .Roboto_Regular,
//                                                     color: Color(0xFF212156),
//                                                   ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
                                GestureDetector(
                                  onTap: () {

                                    processing = false;
                                    completed = true;
                                    solved = false;
                                    notSolved = false;
                                    status = "completed";
                                    setState(() {});
                                    print('''------
processing: $processing,
completed: $completed,
solved: $solved,
notSolved: $notSolved
------''');

                                  },
                                  child: Row(
                                    children: [
                                      completed == true
                                          ? SvgPicture.asset(
                                              'assets/on.svg',
                                              allowDrawingOutsideViewBox: true,
                                            )
                                          : SvgPicture.asset(
                                              'assets/off.svg',
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                      Container(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 12.0,vertical: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Completed',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    fontFamily: FontStrings
                                                        .Roboto_Regular,
                                                    color: Color(0xFF212156),
                                                  ),
                                            ),
                                            // TextField(
                                            //   keyboardType:
                                            //   TextInputType.streetAddress,
                                            //   controller: readCon,
                                            //   cursorColor: Color(0xff0A95A0),
                                            //   decoration: new InputDecoration(
                                            //       border: InputBorder.none,
                                            //       focusedBorder: InputBorder.none,
                                            //       enabledBorder: InputBorder.none,
                                            //       errorBorder: InputBorder.none,
                                            //       disabledBorder:
                                            //       InputBorder.none,
                                            //       hintText:
                                            //       'Describe the reason'),
                                            //   style: Theme.of(context)
                                            //       .textTheme
                                            //       .bodyText2
                                            //       .copyWith(
                                            //     fontFamily: FontStrings
                                            //         .Roboto_Regular,
                                            //     color: Color(0xFF888B8D),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Order Issue',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                              fontFamily: FontStrings
                                                  .Fieldwork10_Regular,
                                              color: Color(0xFF212156),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                GestureDetector(
                                  onTap: () {

                                    processing = false;
                                    completed = false;
                                    solved = true;
                                    notSolved = false;
                                    status = "solved";
                                    setState(() {});
                                    print('''------
processing: $processing,
completed: $completed,
solved: $solved,
notSolved: $notSolved
------''');

                                  },
                                  child: Row(
                                    children: [
                                      solved == true
                                          ? SvgPicture.asset(
                                              'assets/on.svg',
                                              allowDrawingOutsideViewBox: true,
                                            )
                                          : SvgPicture.asset(
                                              'assets/off.svg',
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Could be solved',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    fontFamily: FontStrings
                                                        .Roboto_Regular,
                                                    color: Color(0xFF212156),
                                                  ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'You have to add new service',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    fontFamily: FontStrings
                                                        .Roboto_Regular,
                                                    color: Color(0xFF5D5F61),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {

                                    processing = false;
                                    completed = false;
                                    solved = false;
                                    notSolved = true;
                                    status = "notSolved";
                                    setState(() {});
                                    print('''------
processing: $processing,
completed: $completed,
solved: $solved,
notSolved: $notSolved
------''');
                                  },
                                  child: Row(
                                    children: [
                                      notSolved == true
                                          ? SvgPicture.asset(
                                              'assets/on.svg',
                                              allowDrawingOutsideViewBox: true,
                                            )
                                          : SvgPicture.asset(
                                              'assets/off.svg',
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Could NOT be solved',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    fontFamily: FontStrings
                                                        .Roboto_Regular,
                                                    color: Color(0xFF212156),
                                                  ),
                                            ),
                                            Container(
                                                width: 200,
                                                height: 30,
                                                child: TextField(
                                                  keyboardType: TextInputType
                                                      .streetAddress,
                                                  controller: readCon,
                                                  cursorColor:
                                                      Color(0xff0A95A0),
                                                  decoration: new InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                      hintText:
                                                          'Describe the reason'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                        fontFamily: FontStrings
                                                            .Roboto_Regular,
                                                        color:
                                                            Color(0xFF888B8D),
                                                      ),
                                                )),

                                            // TextField(
                                            //   keyboardType:
                                            //   TextInputType.streetAddress,
                                            //   controller: readCon,
                                            //   cursorColor: Color(0xff0A95A0),
                                            //   decoration: new InputDecoration(
                                            //       border: InputBorder.none,
                                            //       focusedBorder: InputBorder.none,
                                            //       enabledBorder: InputBorder.none,
                                            //       errorBorder: InputBorder.none,
                                            //       disabledBorder:
                                            //       InputBorder.none,
                                            //       hintText:
                                            //       'Describe the reason'),
                                            //   style: Theme.of(context)
                                            //       .textTheme
                                            //       .bodyText2
                                            //       .copyWith(
                                            //     fontFamily: FontStrings
                                            //         .Roboto_Regular,
                                            //     color: Color(0xFF888B8D),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: RaisedGradientButton(
                                    onPressed: () {
                                      // Get.to(OrderBottomBarIndex());

                                      // Get.back();
                                      // Get.snackbar(null, 'Order was rejected',
                                      //     snackPosition: SnackPosition.BOTTOM,
                                      //     backgroundColor: UIColor.baseGradientDar,
                                      //     colorText: Colors.white);

                                      if(status == "completed"){
                                        hitOrderStatusAPI(itemID);
                                      }

                                      if(status == "notSolved"){
                                        if(readCon.text.isNotEmpty || !readCon.text.isBlank)
                                        hitCannotBeSolvedAPI(itemID,readCon.text);
                                      }

                                      if(status == "solved"){
                                        Get.back();
                                        openServiceTypeDialog(context,itemID);
                                      }

                                    },
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily:
                                              FontStrings.Fieldwork10_Regular,
                                          fontSize: 16),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xffC1282D),
                                        Color(0xffF15B29)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          );
        });
      },
    );
  }

  void hitOrderListAPI(String orderID) {
    isLoading = true;
    orderDetailController.fetchServices(orderID).then((result) {
      isLoading = false;
      if (result["status"] == true) {
        isServicePresent = "";
        print('---------------\n${result["status"]}');
        print('-----------${result["message"]}');
        orderDetailModel = OrderDetailModel.fromJson(result).result;

        _orderMainStatus  = orderDetailModel.status;


        if (orderDetailModel.status == 'Order Accepted') {
          isOrderIssue = true;
          setState(() {});
        } else {
          isOrderIssue = false;
          setState(() {});
        }
        print('--------- orderMainStatus -- $_orderMainStatus');
        print('--------- isOrderIssue -- $isOrderIssue');
        print('-----------${orderDetailModel.orderDate}');
        print('-----------${orderDetailModel.status}');
        setState(() {});
      } else {
        isServicePresent = result["message"];
        print('-----------${result["message"]}');
        setState(() {});
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      print('------------$isServicePresent');
      setState(() {});
    });
  }

  void hitOrderAcceptAPI(String orderID) {
    orderAcceptController.fetchServices(orderID).then((result) {
      if (result["status"] == true) {
        isServicePresent = "";
        Navigator.pop(context, 'true');
        getSnackBar(null, result["message"]);
        setState(() {});
      } else {
        Get.back();
        isServicePresent = result["message"];
        getSnackBar(null, result["message"]);
        print('-----------${result["message"]}');
        setState(() {});

        // 107948
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      Get.back();
      getSnackBar(null, error.toString());
      print('------------$isServicePresent');
      setState(() {});
    });
  }

  void hitOrderCompleteAPI(String orderID) {
    orderCompleteController.fetchServices(orderID).then((result) {
      if (result["status"] == true) {
        isServicePresent = "";
        Get.back();
        getSnackBar(null, result["message"]);
        setState(() {});
      } else {
        Get.back();
        isServicePresent = result["message"];
        getSnackBar(null, result["message"]);
        print('-----------${result["message"]}');
        setState(() {});
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      Get.back();
      getSnackBar(null, error.toString());
      print('------------$isServicePresent');
      setState(() {});
    });
  }

  void hitOrderStatusAPI(String itemID) {
    orderStatusController.fetchServices(itemID).then((result) {
      if (result["status"] == true) {
        isServicePresent = "";
        Get.back();
        getSnackBar(null, result["message"]);
        setState(() {});
      } else {
        Get.back();
        isServicePresent = result["message"];
        getSnackBar(null, result["message"]);
        print('-----------${result["message"]}');
        setState(() {});
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      Get.back();
      getSnackBar(null, error.toString());
      print('------------$isServicePresent');
      setState(() {});
    });
  }

  void hitCannotBeSolvedAPI(String itemID,reason) {
    orderCannotBeSolvedController.fetchServices(itemID,reason).then((result) {
      if (result["status"] == true) {
        isServicePresent = "";
        Get.back();
        getSnackBar(null, result["message"]);
        setState(() {});
      } else {
        Get.back();
        isServicePresent = result["message"];
        getSnackBar(null, result["message"]);
        print('-----------${result["message"]}');
        setState(() {});
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      Get.back();
      getSnackBar(null, error.toString());
      print('------------$isServicePresent');
      setState(() {});
    });
  }



  _orderStatus(String status) {
    switch (status) {
      case "processing":
        {
          setState(() {
            processing = true;
            completed = false;
            solved = false;
            notSolved = false;
          });
        }
        break;

      case "completed":
        {
          setState(() {
            processing = false;
            completed = true;
            solved = false;
            notSolved = false;
          });
        }
        break;

      case "solved":
        {
          setState(() {
            processing = false;
            completed = false;
            solved = true;
            notSolved = false;
          });
        }
        break;

      case "notSolved":
        {
          setState(() {
            processing = false;
            completed = false;
            solved = false;
            notSolved = true;
          });
        }
        break;
    }
  }
  void openServiceTypeDialog(BuildContext context, var itemId) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                        margin: EdgeInsets.all(56),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFFEFEFEF),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 16, top: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Need to',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                              fontFamily: FontStrings
                                                  .Fieldwork10_Regular,
                                              color: Color(0xFF212156),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: SvgPicture.asset(
                                            'assets/close.svg',
                                            allowDrawingOutsideViewBox: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: (){
                                      isPickup = true;
                                      sVendorDetail.setServiceType("Pickup documents");
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: !isPickup ? Color(0xFFDDDEDE):Colors.transparent,
                                              style: BorderStyle.solid,
                                              width: 1.0),
                                          color: !isPickup ? UIColor.baseColorWhite:Colors.teal,
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          child: Text("Pickup document Services",style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                            fontFamily: FontStrings
                                                .Roboto_Regular,
                                            color: !isPickup ? Color(0xFF4D4F51):Colors.white,
                                          ),),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10,),

                                  GestureDetector(
                                    onTap: (){
                                      isPickup = false;
                                      sVendorDetail.setServiceType("Clearance documents");
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: isPickup ? Color(0xFFDDDEDE):Colors.transparent,
                                              style: BorderStyle.solid,
                                              width: 1.0),
                                          color: isPickup ? UIColor.baseColorWhite:Colors.teal,
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          child: Text("Add new services",style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                            fontFamily: FontStrings
                                                .Roboto_Regular,
                                            color: isPickup ? Color(0xFF4D4F51):Colors.white,
                                          ),),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10,),
                                  RaisedGradientButton(
                                    onPressed: () {
                                      Get.to(NewOrderService(widget.orderType,widget.needDelivery,itemId,isPickup?'Pickup documents':'Clearance documents',widget.orderID));
                                    },
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily:
                                          FontStrings.Fieldwork10_Regular,
                                          fontSize: 16),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xffC1282D),
                                        Color(0xffF15B29)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          );
        });
      },
    );
  }
}


