import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/controller/Orders/OrderAcceptController.dart';
import 'package:takhlees_v/controller/Orders/OrderCompleteController.dart';
import 'package:takhlees_v/controller/Orders/OrderDetailController.dart';
import 'package:takhlees_v/model/OrderDetailModel.dart';
import 'package:takhlees_v/widget/LinedButton.dart';
import 'package:takhlees_v/widget/OrderStatusWidget.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:takhlees_v/widget/snackBar.dart';
import 'package:transparent_image/transparent_image.dart';

class HistoryOrderDetails extends StatefulWidget {
  final String orderID;
  final String orderType;
  final String needDelivery;
  const HistoryOrderDetails(this.orderID, this.orderType, this.needDelivery);

  @override
  _HistoryOrderDetailsState createState() => _HistoryOrderDetailsState();
}

final readCon = new TextEditingController();
bool Other = false;
final orderDetailController = Get.put(OrderDetailController());
final orderAcceptController = Get.put(OrderAcceptController());
final orderCompleteController = Get.put(OrderCompleteController());
var orderDetailModel = OrderDetailResult();
String isServicePresent = 'de';
bool isOrderIssue = false ;

class _HistoryOrderDetailsState extends State<HistoryOrderDetails> {
  @override
  void initState() {
    print('------------------------------OrderDetailsScreen------------------------');
    hitOrderListAPI(widget.orderID);
    // TODO: implement initState
    super.initState();
  }

  _multi(context) {
    return MediaQuery.of(context).size.height * 0.01;
  }

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
                Navigator.pop(context);
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
      body: SafeArea(
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
                          // Container(
                          //     padding: EdgeInsets.only(left: 24, right: 24),
                          //     decoration: BoxDecoration(
                          //       color: UIColor.baseColorWhite,
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Colors.grey.withOpacity(0.2),
                          //           spreadRadius: 0.3,
                          //           blurRadius: 1,
                          //           offset: Offset(
                          //               0, 1), // changes position of shadow
                          //         ),
                          //       ],
                          //     ),
                          //     child: Column(
                          //       children: [
                          //         _item3('12h 45 min left'),
                          //       ],
                          //     )),
                          // Container(
                          //     padding: EdgeInsets.only(left: 24, right: 24),
                          //     decoration: BoxDecoration(
                          //       color: UIColor.baseColorWhite,
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Colors.grey.withOpacity(0.2),
                          //           spreadRadius: 0.3,
                          //           blurRadius: 1,
                          //           offset: Offset(
                          //               0, 1), // changes position of shadow
                          //         ),
                          //       ],
                          //     ),
                          //     child: Column(
                          //       children: [
                          //         _item4('Order date & time',
                          //             '${orderDetailModel.orderDate}'),
                          //         SizedBox(
                          //           height: 10,
                          //         ),
                          //       ],
                          //     )),
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            child: orderStatus('${orderDetailModel.status}',context),
                          ),
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
                          orderDetailModel.pickupNotes == null ?Container() : Container(
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
                                                      color: Color(0xff212156)),
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
                                                          Container(

                                                            child: Text(
                                                              '${orderDetailModel.services[serviceIndex].serviceNameEn}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .copyWith(
                                                                      fontFamily:
                                                                          FontStrings
                                                                              .Roboto_Regular,
                                                                      color: Color(
                                                                          0xFf404243)),
                                                            ),
                                                          ),
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
                                                          'Est.time: 7 days',
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
                                              isOrderIssue ?LinedButton(
                                                  onPressed: (){
                                                    loadingDialog(context);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Order issue',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Color(0xff212156),
                                                          fontFamily: FontStrings.Fieldwork10_Regular,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                                color: Color(0xffC1282D),
                                              ):Container(),
                                              isOrderIssue ? SizedBox(height: 10,):Container(),
                                            ],
                                          )),

                                          Container(
                                            child: Divider(
                                              color: Colors.black26,
                                            ),
                                          ),
                                          Container(
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
                                          ),
                                          _item('Customer fees', '12 BHD'),
                                          _item('Services fees',
                                              '${orderDetailModel.services[serviceIndex].serviceFee} BHD'),
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 13, bottom: 13),
                                            child: Row(
                                              // crossAxisAlignment: CrossAxisAlignment.start,

                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      'Total service fees',
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
                                                      '${orderDetailModel.services[serviceIndex].serviceFee} BHD',
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
                          widget.needDelivery == 'Yes'?title2(context, 'DELIVERY INFORMATION'):Container(),
                          widget.needDelivery == 'Yes'?Container(
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
                                  _item2('Pickup address',
                                      '${orderDetailModel.pickupAddress}'),
                                ],
                              )):Container(),
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
        isOrderIssue ? Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: RaisedGradientButton(
            onPressed: () {
              hitOrderCompleteAPI(widget.orderID);
            },
            child: Text(
              'Complete (waiting pickup)',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: FontStrings.Fieldwork10_Regular,
                  fontSize: 16),
            ),
            gradient: LinearGradient(
              colors: <Color>[Color(0xffC1282D), Color(0xffF15B29)],
            ),
          ),
        ): Container(),
        isOrderIssue ? SizedBox(height: 10,): Container(),
        !isOrderIssue ? Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: RaisedGradientButton(
            onPressed: () {
              hitOrderAcceptAPI(widget.orderID);
            },
            child: Text(
              'Got it',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: FontStrings.Fieldwork10_Regular,
                  fontSize: 16),
            ),
            gradient: LinearGradient(
              colors: <Color>[Color(0xffC1282D), Color(0xffF15B29)],
            ),
          ),
        ): Container(),
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
                  color: Color(0xFF404243)),
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
                    fontFamily: FontStrings.Roboto_Bold,
                    color: Color(0xFF404243)),
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

  Widget _item3(String item) {
    return Container(
      padding: EdgeInsets.only(top: 13, bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              child: Text(
                item,
                style: TextStyle(
                    fontFamily: FontStrings.Roboto_SemiBold,
                    color: Color(0xFF212156)),
              ),
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
                style: Theme.of(context).textTheme.caption.copyWith(
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

  void loadingDialog(BuildContext context) {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder:
            (BuildContext context, void Function(void Function()) setState) {
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
                                        child: Center(
                                          child: Text(
                                            'Order Issue',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                  fontFamily: FontStrings
                                                      .Fieldwork16_Bold,
                                                  color: Color(0xFF212156),
                                                ),
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
                                  onTap: () {
                                    if (Other) {
                                      Other = false;
                                      setState(() {});
                                    } else {
                                      Other = true;
                                      setState(() {});
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Other == false
                                          ? SvgPicture.asset(
                                              'assets/on.svg',
                                              allowDrawingOutsideViewBox: true,
                                            )
                                          : SvgPicture.asset(
                                              'assets/off.svg',
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                      Container(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Could be solved',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    fontFamily:
                                                        FontStrings.Roboto_Regular,
                                                    color: Color(0xFF212156),
                                                  ),
                                            ),
                                            SizedBox(height: 5,),
                                            Text(
                                              'You have to add new service',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                fontFamily:
                                                FontStrings.Roboto_Regular,
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
                                  height: 16,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (Other) {
                                      Other = false;
                                      setState(() {});
                                    } else {
                                      Other = true;
                                      setState(() {});
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Other == true
                                          ? SvgPicture.asset(
                                              'assets/on.svg',
                                              allowDrawingOutsideViewBox: true,
                                            )
                                          : SvgPicture.asset(
                                              'assets/off.svg',
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                      Container(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Could NOT be solved',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    fontFamily:
                                                        FontStrings.Roboto_Regular,
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
                                Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: TextField(
                                            keyboardType:
                                                TextInputType.streetAddress,
                                            controller: readCon,
                                            cursorColor: Color(0xff0A95A0),
                                            decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
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
                                                  color: Color(0xFF888B8D),
                                                ),
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: RaisedGradientButton(
                                    onPressed: () {
                                      // Get.to(OrderBottomBarIndex());
                                      Get.back();
                                      Get.snackbar(null, 'Order was rejected',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor:
                                              UIColor.baseGradientDar,
                                          colorText: Colors.white);
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
    orderDetailController.fetchServices(orderID).then((result) {
      if (result["status"] == true) {
        isServicePresent = "";
        print('---------------\n${result["status"]}');
        print('-----------${result["message"]}');
        orderDetailModel = OrderDetailModel.fromJson(result).result;

        if(orderDetailModel.status == 'Order Accepted'){
          isOrderIssue = true ;
          setState(() {});
        }else{
          isOrderIssue = false ;
          setState(() {});
        }

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
}
