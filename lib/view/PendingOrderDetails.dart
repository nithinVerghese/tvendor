import 'package:cached_network_image/cached_network_image.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
// import 'package:loading/indicator/ball_pulse_indicator.dart';
// import 'package:loading/loading.dart';
import 'package:readmore/readmore.dart';
// import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/Server/Database.dart';
import 'package:takhlees_v/Singleton/VendorDetailsSingleton.dart';
import 'package:takhlees_v/controller/Orders/OrderCompleteController.dart';
import 'package:takhlees_v/controller/Orders/OrderDetailController.dart';
import 'package:takhlees_v/model/OrderDetailModel.dart';
import 'package:takhlees_v/model/OrderDetailModel1.dart';
import 'package:takhlees_v/view/HomeScreen/OrderBottomBarIndex.dart';
import 'package:takhlees_v/view/OrderDetails.dart';
import 'package:takhlees_v/widget/LinedButton.dart';
import 'package:takhlees_v/widget/OrderStatusWidget.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:takhlees_v/widget/TimeCounter.dart';
import 'package:takhlees_v/widget/snackBar.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Chat/chat_conversation.dart';
import 'NewOrder/NewOrderService/NewOrderService.dart';

// import 'OrderDetails.dart';


class PendingOrderDetails extends StatefulWidget {
  final String status,orderID,needDelivery;


  const PendingOrderDetails(this.status,this.orderID,this.needDelivery);


  @override
  _PendingOrderDetailsState createState() => _PendingOrderDetailsState();
}

final readCon = new TextEditingController();
bool Other =false;
class _PendingOrderDetailsState extends State<PendingOrderDetails> {

  final orderDetailController = Get.put(OrderDetailController());
  final orderCompleteController = Get.put(OrderCompleteController());
  var orderDetailModel = OrderDetailResult1();
  String isServicePresent = '';
  String employeeName = "";
  String customerName = "";
  String eProfilePhotoPath = "";
  int seconds = 0;
  String cProfilePhotoPath = "";
  int servicesLength = 0;
  double vendorRating = 0.00;

  VendorDetailsSingleton sVendorDetail = new VendorDetailsSingleton();

  var isPickup = false;

  String driverName;

  String driverPhone;

  String driverProfilePhotoPath;

  bool isLoading = false;

  String stat = '';




  @override
  void initState() {
    print('------------------------------VehicleDetailsScreen------------------------');
    print('=====>   status ${widget.status}');
    print('    status : ${widget.status}');
    print('    orderID : ${widget.orderID}');
    print('    needDelivery : ${widget.needDelivery}');



    hitOrderListAPI(widget.orderID);
    print('\n\n\n\n===> status $stat');

    // TODO: implement initState
    super.initState();
  }

  _multi(context) {
    return MediaQuery
        .of(context)
        .size
        .height * 0.01;
  }

  FocusNode _focusNode1 = FocusNode();

  Widget orderItemsWithDetails(List<RequestedServiceService> orderDetailModel){
    return Column(
      children: List.generate(orderDetailModel.length, (serviceIndex) => Container(
          child: Container(
              padding:
              EdgeInsets.only(left: 24, right: 24),
              margin: EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: UIColor.baseColorWhite,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2), // changes position of shadow
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
                                            .symmetric(vertical: 8.0, horizontal: 2),
                                        child:orderDetailModel[serviceIndex].serviceNameEn != 'Pickup Extra Documents'? Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: orderDetailModel[serviceIndex]
                                              .serviceType ==
                                              'No delivery needed'
                                              ? UIColor
                                              .baseColorTeal
                                              : UIColor
                                              .baseGradientLight,
                                        ):Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: SvgPicture.asset(
                                            "assets/truck.svg",
                                            color: Color(
                                                0xffC1282D),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${orderDetailModel[serviceIndex].serviceNameEn}',
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

                              ],
                            ),
                          ),
                          orderDetailModel[serviceIndex].serviceNameEn != 'Pickup Extra Documents'?Container(
                            padding: EdgeInsets.only(
                                top: 0, bottom: 13),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Est.time: ',
                                    style: TextStyle(
                                        fontFamily:
                                        FontStrings
                                            .Roboto_Regular,
                                        color: Color(
                                            0xFF5D5F61)),
                                  ),
                                ),
                                Text(
                                  '${orderDetailModel[serviceIndex].serviceTime} days',
                                  style: TextStyle(
                                      fontFamily:
                                      FontStrings
                                          .Roboto_Regular,
                                      color: Color(
                                          0xFF5D5F61)),
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
                          ):Container(),
                        ],
                      )),
                  orderDetailModel[serviceIndex].documentNameEn != ''?Container(
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
                              '${orderDetailModel[serviceIndex].documentNameEn}',
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
                  orderDetailModel[serviceIndex].serviceNameEn != 'Pickup Extra Documents'? _item('Government fees', '${orderDetailModel[serviceIndex].governmentFee} BHD'):Container(),
                  orderDetailModel[serviceIndex].serviceNameEn != 'Pickup Extra Documents'?_item('Service fees',
                      '${orderDetailModel[serviceIndex].serviceFee} BHD'):Container(),
                  orderDetailModel[serviceIndex].serviceNameEn != 'Pickup Extra Documents'? Container(
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
                              '${orderDetailModel[serviceIndex].serviceFee} BHD',
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
                  ):Container(),
                  SizedBox(height: 15,)
                ],
              )),
      ),),
    );
  }
  Widget orderItems(List<RequestedServiceService> orderDetailModel){
    return Column(
      children: List.generate(orderDetailModel.length, (serviceIndex) => Container(
          child: Container(
              // padding: EdgeInsets.only(left: 10, right: 10),
              // margin: EdgeInsets.only(bottom: 14),
              // decoration: BoxDecoration(
              //   color: UIColor.baseColorWhite,
              //   borderRadius: BorderRadius.all(Radius.circular(10)),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.black12,
              //       spreadRadius: 1,
              //       blurRadius: 4,
              //       offset: Offset(0, 2), // changes position of shadow
              //     ),
              //   ],
              // ),
              child: Column(
                children: [
                  Container(
                      child: Column(
                        children: [
                          Container(
                            // padding: EdgeInsets.only(
                            //     top: 13, bottom: 7),
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
                                            .symmetric(vertical: 8.0, horizontal: 2),
                                        child:orderDetailModel[serviceIndex].serviceNameEn != 'Pickup Extra Documents'? Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: orderDetailModel[serviceIndex]
                                              .serviceType ==
                                              'No delivery needed'
                                              ? UIColor
                                              .baseColorTeal
                                              : UIColor
                                              .baseGradientLight,
                                        ):Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: SvgPicture.asset(
                                            "assets/truck.svg",
                                            color: Color(
                                                0xffC1282D),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${orderDetailModel[serviceIndex].serviceNameEn}',
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
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              )),
      ),),
    );
  }

  Widget mainStatus(String status){
    switch(status){
      case 'Order Issues':{
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 12),
          child: orderStatus(widget.status,context),
        );
      }
      case 'Document Delivery':{
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 12),
          child: orderStatus(widget.status,context),
        );
      }
      case 'Waiting Documents':{
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 12),
          child: orderStatus(widget.status,context),
        );
      }
      case 'Order Issues':{
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 12),
          child: orderStatus(widget.status,context),
        );
      }
      case 'Cancelled':{
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 12),
          child: orderStatus(widget.status,context),
        );
      }
      case 'Finished':{
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 12),
          child: orderStatus(widget.status,context),
        );
      }
      case 'Closed':{
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 12),
          child: orderStatus(widget.status,context),
        );
      }
      default:{
        return Container();
      }
    }
  }

  Widget _showRating(double _rating) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              ignoreGestures: true,
              direction: Axis.horizontal,
              unratedColor: Colors.black12,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
              onRatingUpdate: (rating) {
                print(rating);
                setState(() {

                });
              },
            )
          ],
        ),
        SizedBox(height: 10,),
      ],
    );
  }

  var serviceItemList = VendorDetailsSingleton();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        brightness: Brightness.light,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded,
                color: Color(0xff212156),),
              onPressed: () {

                if(
                stat == 'Cancelled'||
                stat == 'Order Issues'||
                stat == 'Waiting Documents'||
                stat == 'Document Delivery'
                ){
                  serviceItemList.setTabPosition(2);
                }else{
                  serviceItemList.setTabPosition(1);
                }

                print('===> status $stat');



                //
                // 1031765
                // 992385

                Get.offAll(OrderBottomBarIndex());
                // Navigator.pop(context,true);
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
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(
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
        title:
        Text("Order details",
          style: Theme
              .of(context)
              .textTheme
              .headline6
              .copyWith(
              fontFamily: FontStrings.Fieldwork10_Regular,
              color: Color(0xff212156)
          ),),
      ),


      body: SafeArea(
        child: isLoading ? Center(child: CircularProgressIndicator(
            color: UIColor.baseGradientLight,
        ),):Column(
          children: [
            SizedBox(height: 5,),
            Expanded(
              child: KeyboardActions(
                config: KeyboardActionsConfig(
                    actions: [
                      KeyboardActionsItem(focusNode: _focusNode1)
                    ]
                ),
                child: Column(
                  children: [
                    // statusIndicator(),
                    mainStatus(widget.status),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 12),
                    //   child: orderStatus(widget.status,context),
                    // ),


                    widget.status == 'Closed' ||  widget.status == 'Cancelled' ?Container():Container(
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
                            counterWid(context,
                                orderDetailModel.estimatedCompletedTime),
                          ],
                        )),


                    // widget.status != 'Closed'?Container(
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
                    //         counterWid(context,
                    //             orderDetailModel.estimatedCompletedTime),
                    //       ],
                    //     )):Container(),
                    Container(
                        padding: EdgeInsets.only(left: 24, right: 24),
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
                            _item4('$employeeName','Employee','$eProfilePhotoPath'),
                            widget.status == 'Closed'?_showRating(vendorRating):Container(),
                          ],
                        )
                    ),
                    SizedBox(height: 2,),
                    Container(
                        padding: EdgeInsets.only(left: 24, right: 24),
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
                        child: Row(
                          children: [
                            Expanded(child: _item4('$customerName','Customer','$cProfilePhotoPath')),

                            widget.status == 'Closed' ? Container():
                            widget.status == 'Cancelled' ? Container():
                            widget.status == 'Completed' ? Container():Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await launch('tel:${orderDetailModel.consumerDetails.phone}');
                                  },
                                  child: SvgPicture.asset(
                                    "assets/Phone.svg",
                                    color: UIColor.baseGradientLight,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(),
                                ),
                                GestureDetector(
                                  onTap:(){
                                    sendMessage('Awal Express WLL',"${orderDetailModel.consumerDetails.consumerName}");
                                    // print(' ------ ${DataBaseMethod().isChatCreated('13456')}');
                                  },
                                  child: SvgPicture.asset(
                                    "assets/message.svg",
                                    color: UIColor.baseGradientLight,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        )
                    ),
                    orderDetailModel.pickupNotes != null ? SizedBox(height: 1,) : Container(),
                    orderDetailModel.pickupNotes != null ? Container(
                        padding: EdgeInsets.only(left: 24, right: 24),
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
                              padding: EdgeInsets.only(top: 13.5,bottom: 12.5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Text('${orderDetailModel.pickupNotes}',
                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                    fontFamily: FontStrings.Roboto_Regular,
                                    color: Color(0xff212156)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ) ,
                          ],
                        )
                    ): Container(),
                    title(context,'SERVICE(S)','${orderDetailModel.totalServices}'),
                    Column(
                      children:
                      List.generate(servicesLength,
                              (serviceIndex) {
                            return Column(
                              children: [
                                // SizedBox(height: 1,),
                                // ClayContainer(
                                //   surfaceColor: Colors.white,
                                //   depth:10,
                                //   emboss:true,
                                //   spread: 5,
                                //   child: Container(
                                //       padding:
                                //       EdgeInsets.only(left: 24, right: 24),
                                //       decoration: BoxDecoration(
                                //         color: UIColor.baseColorWhite,
                                //         // color: Colors.amber,
                                //
                                //         boxShadow: [
                                //           BoxShadow(
                                //             color: Colors.black12,
                                //             spreadRadius: 1,
                                //             blurRadius: 4,
                                //             offset: Offset(0,
                                //                 2), // changes position of shadow
                                //           ),
                                //         ],
                                //       ),
                                //       child: Column(
                                //         children: [
                                //           Container(
                                //               child: Column(
                                //                 children: [
                                //                   Container(
                                //
                                //                     padding: EdgeInsets.only(
                                //                         top: 13, bottom: 7),
                                //                     child: Row(
                                //                       crossAxisAlignment:
                                //                       CrossAxisAlignment.start,
                                //                       children: [
                                //                         Expanded(
                                //                           child: Row(
                                //                             children: [
                                //                               Padding(
                                //                                 padding:
                                //                                 const EdgeInsets
                                //                                     .all(8.0),
                                //                                 child: Icon(
                                //                                   Icons.circle,
                                //                                   size: 8,
                                //                                   color: orderDetailModel
                                //                                       .services[
                                //                                   serviceIndex]
                                //                                       .serviceType ==
                                //                                       'No delivery needed'
                                //                                       ? UIColor
                                //                                       .baseColorTeal
                                //                                       : UIColor
                                //                                       .baseGradientLight,
                                //                                 ),
                                //                               ),
                                //                               Expanded(
                                //                                 child: Text(
                                //                                   '${orderDetailModel.services[serviceIndex].serviceNameEn}',
                                //                                   style: Theme.of(
                                //                                       context)
                                //                                       .textTheme
                                //                                       .bodyText1
                                //                                       .copyWith(
                                //                                       fontFamily:
                                //                                       FontStrings
                                //                                           .Roboto_Regular,
                                //                                       color: Color(
                                //                                           0xFf404243)),
                                //                                 ),
                                //                               ),
                                //                               orderStatus(
                                //                                   '${orderDetailModel.services[serviceIndex].itemStatus}',
                                //                                   context),
                                //                             ],
                                //                           ),
                                //                         ),
                                //
                                //                       ],
                                //                     ),
                                //
                                //                   ),
                                //
                                //                   Container(
                                //                     padding: EdgeInsets.only(
                                //                         top: 0, bottom: 13),
                                //                     child: Row(
                                //                       crossAxisAlignment:
                                //                       CrossAxisAlignment.start,
                                //                       children: [
                                //                         Expanded(
                                //                           child: Text(
                                //                             'Est.time: ',
                                //                             style: TextStyle(
                                //                                 fontFamily:
                                //                                 FontStrings
                                //                                     .Roboto_Regular,
                                //                                 color: Color(
                                //                                     0xFF5D5F61)),
                                //                           ),
                                //                         ),
                                //                         Text(
                                //                           '${orderDetailModel.services[serviceIndex].serviceTime} days',
                                //                           style: TextStyle(
                                //                               fontFamily:
                                //                               FontStrings
                                //                                   .Roboto_Regular,
                                //                               color: Color(
                                //                                   0xFF5D5F61)),
                                //                         ),
                                //                         // Container(
                                //                         //   child: Text(
                                //                         //     'Qty: ${orderDetailModel.services[serviceIndex].quantity}',
                                //                         //     style: TextStyle(
                                //                         //         fontFamily: FontStrings
                                //                         //             .Roboto_Regular,
                                //                         //         color: Color(
                                //                         //             0xFF5D5F61)),
                                //                         //   ),
                                //                         // ),
                                //                       ],
                                //                     ),
                                //                   ),
                                //
                                //                   widget.needDelivery == 'Yes'?
                                //                   // widget.status == 'With Service Provider'?
                                //                   orderDetailModel.services[serviceIndex].itemStatus == 'Processing' ?
                                //                   SizedBox(
                                //                     child: LinedButton(
                                //                       onPressed: () {
                                //                         processing = false;
                                //                         completed = false;
                                //                         solved = false;
                                //                         notSolved = false;
                                //                         readCon.text = '';
                                //                         setState((){});
                                //                         orderIssueDialog(
                                //                             context,"${orderDetailModel.services[serviceIndex].itemId}");
                                //                       },
                                //                       child: Row(
                                //                         mainAxisAlignment:
                                //                         MainAxisAlignment
                                //                             .center,
                                //                         children: [
                                //                           Text(
                                //                             'Service status',
                                //                             textAlign:
                                //                             TextAlign
                                //                                 .center,
                                //                             style: TextStyle(
                                //                                 color: Color(
                                //                                     0xff212156),
                                //                                 fontFamily:
                                //                                 FontStrings
                                //                                     .Fieldwork10_Regular,
                                //                                 fontSize: 16),
                                //                           ),
                                //                         ],
                                //                       ),
                                //                       color:
                                //                       Color(0xffC1282D),
                                //                     ),
                                //                     width: 300,
                                //                   ):
                                //                   // Container():
                                //                   Container():
                                //                   // widget.status == 'Order Accepted'?
                                //                   // orderDetailModel.services[serviceIndex].itemStatus == 'Processing' ?
                                //                   // SizedBox(
                                //                   //   child: LinedButton(
                                //                   //     onPressed: () {
                                //                   //       orderIssueDialog(
                                //                   //           context,"${orderDetailModel.services[serviceIndex].itemId}");
                                //                   //     },
                                //                   //     child: Row(
                                //                   //       mainAxisAlignment:
                                //                   //       MainAxisAlignment
                                //                   //           .center,
                                //                   //       children: [
                                //                   //         Text(
                                //                   //           'Service status',
                                //                   //           textAlign:
                                //                   //           TextAlign
                                //                   //               .center,
                                //                   //           style: TextStyle(
                                //                   //               color: Color(
                                //                   //                   0xff212156),
                                //                   //               fontFamily:
                                //                   //               FontStrings
                                //                   //                   .Fieldwork10_Regular,
                                //                   //               fontSize: 16),
                                //                   //         ),
                                //                   //       ],
                                //                   //     ),
                                //                   //     color:
                                //                   //     Color(0xffC1282D),
                                //                   //   ),
                                //                   //   width: 300,
                                //                   // ):
                                //                   // Container():
                                //                   Container(),
                                //
                                //                   widget.status == 'Something is Wrong'?
                                //                   orderDetailModel.services[serviceIndex].itemStatus == 'Processing' ?
                                //                   SizedBox(
                                //                     child: LinedButton(
                                //                       onPressed: () {
                                //                         orderIssueDialog(
                                //                             context,"${orderDetailModel.services[serviceIndex].itemId}");
                                //                       },
                                //                       child: Row(
                                //                         mainAxisAlignment:
                                //                         MainAxisAlignment
                                //                             .center,
                                //                         children: [
                                //                           Text(
                                //                             'Service status',
                                //                             textAlign:
                                //                             TextAlign
                                //                                 .center,
                                //                             style: TextStyle(
                                //                                 color: Color(
                                //                                     0xff212156),
                                //                                 fontFamily:
                                //                                 FontStrings
                                //                                     .Fieldwork10_Regular,
                                //                                 fontSize: 16),
                                //                           ),
                                //                         ],
                                //                       ),
                                //                       color:
                                //                       Color(0xffC1282D),
                                //                     ),
                                //                     width: 300,
                                //                   ):
                                //                   Container():
                                //                   Container(),
                                //                   //
                                //                   // SizedBox(height: 20),
                                //
                                //
                                //                   orderDetailModel.services[serviceIndex].needName == 'Yes' ? Padding(
                                //                     padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 24),
                                //                     child: ClayContainer(
                                //                       surfaceColor:Color(0xFFF8F8F8),
                                //                         borderRadius:10,
                                //                       child: Container(
                                //                         padding: EdgeInsets.symmetric(horizontal: 18,vertical: 1),
                                //                         child: Column(
                                //                           children: [
                                //                             Container(
                                //                               padding: EdgeInsets.symmetric(vertical: 10),
                                //                               child: Row(
                                //                                 crossAxisAlignment:
                                //                                 CrossAxisAlignment.start,
                                //                                 children: [
                                //                                   Expanded(
                                //                                     child: Text(
                                //                                       'Name: ',
                                //                                       style: TextStyle(
                                //                                           fontFamily:
                                //                                           FontStrings
                                //                                               .Roboto_Regular,
                                //                                           color: Color(
                                //                                               0xFF5D5F61)),
                                //                                     ),
                                //                                   ),
                                //                                   Text(
                                //                                     '${orderDetailModel.services[serviceIndex].name}',
                                //                                     style: TextStyle(
                                //                                         fontFamily:
                                //                                         FontStrings
                                //                                             .Roboto_Regular,
                                //                                         color: Color(
                                //                                             0xFF5D5F61)),
                                //                                   ),
                                //                                   // Container(
                                //                                   //   child: Text(
                                //                                   //     'Qty: ${orderDetailModel.services[serviceIndex].quantity}',
                                //                                   //     style: TextStyle(
                                //                                   //         fontFamily: FontStrings
                                //                                   //             .Roboto_Regular,
                                //                                   //         color: Color(
                                //                                   //             0xFF5D5F61)),
                                //                                   //   ),
                                //                                   // ),
                                //                                 ],
                                //                               ),
                                //                             ),
                                //                             Container(
                                //                               padding: EdgeInsets.symmetric(vertical: 10),
                                //                               child: Row(
                                //                                 crossAxisAlignment:
                                //                                 CrossAxisAlignment.start,
                                //                                 children: [
                                //                                   Expanded(
                                //                                     child: Text(
                                //                                       'ID Number: ',
                                //                                       style: TextStyle(
                                //                                           fontFamily:
                                //                                           FontStrings
                                //                                               .Roboto_Regular,
                                //                                           color: Color(
                                //                                               0xFF5D5F61)),
                                //                                     ),
                                //                                   ),
                                //                                   Text(
                                //                                     '${orderDetailModel.services[serviceIndex].documentId}',
                                //                                     style: TextStyle(
                                //                                         fontFamily:
                                //                                         FontStrings
                                //                                             .Roboto_Regular,
                                //                                         color: Color(
                                //                                             0xFF5D5F61)),
                                //                                   ),
                                //                                   // Container(
                                //                                   //   child: Text(
                                //                                   //     'Qty: ${orderDetailModel.services[serviceIndex].quantity}',
                                //                                   //     style: TextStyle(
                                //                                   //         fontFamily: FontStrings
                                //                                   //             .Roboto_Regular,
                                //                                   //         color: Color(
                                //                                   //             0xFF5D5F61)),
                                //                                   //   ),
                                //                                   // ),
                                //                                 ],
                                //                               ),
                                //                             ),
                                //                           ],
                                //                         ),
                                //                       ),
                                //                     ),
                                //                   ):Container(),
                                //                 ],
                                //               ),
                                //           ),
                                //           orderDetailModel.services[serviceIndex].documentNameEn != ''?Container(
                                //             padding: EdgeInsets.only(
                                //                 top: 13, bottom: 13),
                                //             child: Row(
                                //               crossAxisAlignment:
                                //               CrossAxisAlignment.start,
                                //               children: [
                                //                 Padding(
                                //                   padding:
                                //                   const EdgeInsets.only(
                                //                       right: 12),
                                //                   child: SvgPicture.asset(
                                //                     "assets/document.svg",
                                //                     color: Color(0xff404243),
                                //                   ),
                                //                 ),
                                //                 Expanded(
                                //                   child: Container(
                                //                     child: Text(
                                //                       '${orderDetailModel.services[serviceIndex].documentNameEn}',
                                //                       style: TextStyle(
                                //                           fontFamily: FontStrings
                                //                               .Roboto_Regular,
                                //                           color: Color(
                                //                               0xFF404243)),
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           ):Container(),
                                //           _item('Government fees', '${orderDetailModel.services[serviceIndex].governmentFee} BHD'),
                                //           _item('Services fees',
                                //               '${orderDetailModel.services[serviceIndex].serviceFee} BHD'),
                                //           Container(
                                //             padding: EdgeInsets.only(
                                //                 top: 13, bottom: 13),
                                //             child: Row(
                                //               // crossAxisAlignment: CrossAxisAlignment.start,
                                //
                                //               children: [
                                //                 Expanded(
                                //                   child: Container(
                                //                     child: Text(
                                //                       'Total service fees',
                                //                       style: Theme.of(context)
                                //                           .textTheme
                                //                           .bodyText2
                                //                           .copyWith(
                                //                           fontFamily:
                                //                           FontStrings
                                //                               .Roboto_Bold,
                                //                           fontWeight:
                                //                           FontWeight
                                //                               .w700,
                                //                           color: Color(
                                //                               0xFF4D4F51)),
                                //                     ),
                                //                   ),
                                //                 ),
                                //                 Expanded(
                                //                   child: Container(
                                //                     alignment:
                                //                     Alignment.centerRight,
                                //                     width: 200,
                                //                     child: Text(
                                //                       '${orderDetailModel.services[serviceIndex].serviceFee} BHD',
                                //                       overflow:
                                //                       TextOverflow.ellipsis,
                                //                       style: Theme.of(context)
                                //                           .textTheme
                                //                           .bodyText2
                                //                           .copyWith(
                                //                           fontFamily:
                                //                           FontStrings
                                //                               .Roboto_SemiBold,
                                //                           fontWeight:
                                //                           FontWeight
                                //                               .w700,
                                //                           color: Color(
                                //                               0xff212156)),
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           ),
                                //           // orderDetailModel.services[serviceIndex].requestedServices.length != 0 ?
                                //           //
                                //           //     Container(
                                //           //       child: Column(
                                //           //         children: List.generate(orderDetailModel.services[serviceIndex].requestedServices.length, (requestIndex) => Container(
                                //           //             child: Column(
                                //           //               children: List.generate(orderDetailModel.services[serviceIndex].requestedServices[requestIndex].services.length, (Index) => Container(
                                //           //                 child: Column(
                                //           //                   children: [
                                //           //                     Row(
                                //           //                       children: [
                                //           //                         SvgPicture.asset(
                                //           //                           "assets/truck.svg",
                                //           //                         ),
                                //           //                         Text(
                                //           //                             '${orderDetailModel.services[serviceIndex].requestedServices[requestIndex].services[Index].serviceNameEn}'
                                //           //                         )
                                //           //                       ],
                                //           //                     )
                                //           //                   ],
                                //           //                 ),
                                //           //               )),
                                //           //             )
                                //           //         )),
                                //           //       ),
                                //           //     )
                                //           //      :Container(),
                                //           orderDetailModel.services[serviceIndex].requestedServices.length != 0?Column(
                                //               children:[
                                //                 Container(
                                //                   child: Divider(
                                //                     color: Colors.black26,
                                //                   ),
                                //                 ),
                                //                 Container(
                                //                   child: Text(
                                //                     'NEW ORDER INFORMATION REQUESTED',
                                //                     style: TextStyle(
                                //                         fontFamily: FontStrings
                                //                             .Roboto_Regular,
                                //                         color: Color(
                                //                             0xFF404243)),
                                //                   ),
                                //                   alignment: Alignment.centerLeft,
                                //                 ),
                                //                 SizedBox(height: 15,),
                                //                 Container(
                                //                   padding: EdgeInsets.only(
                                //                       top: 0, bottom: 13),
                                //                   child: Row(
                                //                     crossAxisAlignment:
                                //                     CrossAxisAlignment.start,
                                //                     children: [
                                //                       Expanded(
                                //                         child: Text(
                                //                           'Order date & time : ',
                                //                           style: TextStyle(
                                //                               fontFamily:
                                //                               FontStrings
                                //                                   .Roboto_Regular,
                                //                               color: Color(
                                //                                   0xFF5D5F61)),
                                //                         ),
                                //                       ),
                                //                       Text(
                                //                         '${orderDetailModel.services[serviceIndex].requestedServices[0].orderDate}',
                                //                         style: TextStyle(
                                //                             fontFamily:
                                //                             FontStrings
                                //                                 .Roboto_Regular,
                                //                             color: Color(
                                //                                 0xFF5D5F61)),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ),
                                //                 Row(
                                //                   children: [
                                //                     Expanded(
                                //                       child: Column(
                                //                         children: [
                                //                           Text(
                                //                             'Reason for adding a service',textAlign: TextAlign.start,
                                //                             style: TextStyle(
                                //                                 fontFamily: FontStrings
                                //                                     .Roboto_Regular,
                                //                                 color: Color(
                                //                                     0xFF404243)),
                                //                           ),
                                //                           // SizedBox(height: 10,),
                                //                           Padding(
                                //                             padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 5),
                                //                             child: ReadMoreText("${orderDetailModel.services[serviceIndex].requestedServices[0].reason}",textAlign: TextAlign.start,
                                //                               style: TextStyle(
                                //                                   fontSize: Dimens.space14 *
                                //                                       _multi(context),
                                //                                   fontFamily: FontStrings
                                //                                       .Roboto_Regular,
                                //                                   color: Color(0xFF404243)),
                                //                               // trimLines: 2,
                                //                               lessStyle: TextStyle(
                                //                                 fontSize: Dimens.space12 *
                                //                                     _multi(context),
                                //                                 fontFamily:
                                //                                 FontStrings.Roboto_Medium,
                                //                               ),
                                //                               trimLength: 20,
                                //                               trimMode: TrimMode.Line,
                                //                               trimCollapsedText: 'Show more',
                                //                               trimExpandedText: 'Show less',
                                //                               moreStyle: TextStyle(
                                //                                 fontSize: Dimens.space12 *
                                //                                     _multi(context),
                                //                                 fontFamily:
                                //                                 FontStrings.Roboto_Medium,
                                //                               ),
                                //                             ),
                                //                           ),
                                //                           SizedBox(height: 10,),
                                //                           orderItems(orderDetailModel.services[serviceIndex].requestedServices[0].services),
                                //                           SizedBox(height: 10,),
                                //                         ],
                                //                         mainAxisAlignment: MainAxisAlignment.start,
                                //                         crossAxisAlignment:CrossAxisAlignment.start,
                                //                       ),
                                //                     ),
                                //                   ],
                                //                 ),
                                //                 SizedBox(height: 15,)
                                //               ]
                                //           ):Container(),
                                //         ],
                                //       )),
                                // ),
                                Container(
                                    padding:
                                    EdgeInsets.only(left: 24, right: 24),
                                    decoration: BoxDecoration(
                                      color: UIColor.baseColorWhite,
                                      // color: Colors.amber,

                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: Offset(0,
                                              2), // changes position of shadow
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
                                                                  ? UIColor.baseColorTeal
                                                                  : UIColor.baseGradientLight,
                                                            ),
                                                          ),
                                                          Expanded(
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
                                                          orderStatus(
                                                              '${orderDetailModel.services[serviceIndex].itemStatus}',
                                                              context),
                                                        ],
                                                      ),
                                                    ),
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
                                                      child: Text(
                                                        'Est.time: ',
                                                        style: TextStyle(
                                                            fontFamily:
                                                            FontStrings
                                                                .Roboto_Regular,
                                                            color: Color(
                                                                0xFF5D5F61)),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${orderDetailModel.services[serviceIndex].serviceTime} days',
                                                      style: TextStyle(
                                                          fontFamily:
                                                          FontStrings
                                                              .Roboto_Regular,
                                                          color: Color(
                                                              0xFF5D5F61)),
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
                                              // widget.needDelivery == 'Yes'?
                                              // widget.status == 'With Service Provider'?
                                              orderDetailModel.services[serviceIndex].itemStatus == 'Processing' ?
                                              SizedBox(
                                                child: LinedButton(
                                                  onPressed: () {
                                                    processing = false;
                                                    completed = false;
                                                    solved = false;
                                                    notSolved = false;
                                                    readCon.text = '';
                                                    setState((){});
                                                    orderIssueDialog(
                                                        context,"${orderDetailModel.services[serviceIndex].itemId}");
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Text(
                                                        'Service status',
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
                                              ):
                                              // Container():
                                              // Container():
                                              // widget.status == 'Order Accepted'?
                                              // orderDetailModel.services[serviceIndex].itemStatus == 'Processing' ?
                                              // SizedBox(
                                              //   child: LinedButton(
                                              //     onPressed: () {
                                              //       orderIssueDialog(
                                              //           context,"${orderDetailModel.services[serviceIndex].itemId}");
                                              //     },
                                              //     child: Row(
                                              //       mainAxisAlignment:
                                              //       MainAxisAlignment
                                              //           .center,
                                              //       children: [
                                              //         Text(
                                              //           'Service status',
                                              //           textAlign:
                                              //           TextAlign
                                              //               .center,
                                              //           style: TextStyle(
                                              //               color: Color(
                                              //                   0xff212156),
                                              //               fontFamily:
                                              //               FontStrings
                                              //                   .Fieldwork10_Regular,
                                              //               fontSize: 16),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //     color:
                                              //     Color(0xffC1282D),
                                              //   ),
                                              //   width: 300,
                                              // ):
                                              // Container():
                                              Container(),

                                              widget.status == 'Something is Wrong'?
                                              orderDetailModel.services[serviceIndex].itemStatus == 'Processing' ?
                                              SizedBox(
                                                child: LinedButton(
                                                  onPressed: () {
                                                    orderIssueDialog(
                                                        context,"${orderDetailModel.services[serviceIndex].itemId}");
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Text(
                                                        'Service status',
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
                                              ):
                                              Container():
                                              Container(),
                                              //
                                              // SizedBox(height: 20),


                                              orderDetailModel.services[serviceIndex].needName == 'Yes' ? Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 24),
                                                child: ClayContainer(
                                                  surfaceColor:Color(0xFFF8F8F8),
                                                  borderRadius:10,
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 18,vertical: 1),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(vertical: 10),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  'Name: ',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                      FontStrings
                                                                          .Roboto_Regular,
                                                                      color: Color(
                                                                          0xFF5D5F61)),
                                                                ),
                                                              ),
                                                              Text(
                                                                '${orderDetailModel.services[serviceIndex].name}',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                    FontStrings
                                                                        .Roboto_Regular,
                                                                    color: Color(
                                                                        0xFF5D5F61)),
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
                                                        Container(
                                                          padding: EdgeInsets.symmetric(vertical: 10),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  'ID Number: ',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                      FontStrings
                                                                          .Roboto_Regular,
                                                                      color: Color(
                                                                          0xFF5D5F61)),
                                                                ),
                                                              ),
                                                              Text(
                                                                '${orderDetailModel.services[serviceIndex].documentId}',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                    FontStrings
                                                                        .Roboto_Regular,
                                                                    color: Color(
                                                                        0xFF5D5F61)),
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
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ):Container(),
                                            ],
                                          ),
                                        ),
                                        orderDetailModel.services[serviceIndex].documentNameEn != ''?Container(
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
                                        _item('Service fees',
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
                                                    'Sub total service fees',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                        fontFamily:
                                                        FontStrings.Roboto_Bold,
                                                        fontWeight: FontWeight.w700,
                                                        color: Color(0xFF4D4F51)),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                  Alignment.centerRight,
                                                  width: 200,
                                                  child: Text(
                                                    '${(double.parse(orderDetailModel.services[serviceIndex].serviceFee)+double.parse(orderDetailModel.services[serviceIndex].governmentFee)).toStringAsFixed(3)} BHD',
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
                                        // orderDetailModel.services[serviceIndex].requestedServices.length != 0 ?
                                        //
                                        //     Container(
                                        //       child: Column(
                                        //         children: List.generate(orderDetailModel.services[serviceIndex].requestedServices.length, (requestIndex) => Container(
                                        //             child: Column(
                                        //               children: List.generate(orderDetailModel.services[serviceIndex].requestedServices[requestIndex].services.length, (Index) => Container(
                                        //                 child: Column(
                                        //                   children: [
                                        //                     Row(
                                        //                       children: [
                                        //                         SvgPicture.asset(
                                        //                           "assets/truck.svg",
                                        //                         ),
                                        //                         Text(
                                        //                             '${orderDetailModel.services[serviceIndex].requestedServices[requestIndex].services[Index].serviceNameEn}'
                                        //                         )
                                        //                       ],
                                        //                     )
                                        //                   ],
                                        //                 ),
                                        //               )),
                                        //             )
                                        //         )),
                                        //       ),
                                        //     )
                                        //      :Container(),
                                        orderDetailModel.services[serviceIndex].requestedServices.length != 0?Column(
                                            children:[
                                              Container(
                                                child: Divider(
                                                  color: Colors.black26,
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  'New order information requested',
                                                  style: TextStyle(
                                                      fontFamily: FontStrings
                                                          .Roboto_Bold,
                                                      color: UIColor.darkBlue),
                                                ),
                                                alignment: Alignment.centerLeft,
                                              ),
                                              SizedBox(height: 15,),

                                              Column(
                                                children: List.generate(orderDetailModel.services[serviceIndex].requestedServices.length, (requestedServiceIndex){
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                            top: 0,),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                'Order date & time : ',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                    FontStrings
                                                                        .Roboto_Regular,
                                                                    color: Color(
                                                                        0xFF5D5F61)),
                                                              ),
                                                            ),
                                                            Text(
                                                              '${orderDetailModel.services[serviceIndex].requestedServices[requestedServiceIndex].orderDate}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                  FontStrings
                                                                      .Roboto_Regular,
                                                                  color: Color(
                                                                      0xFF5D5F61)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                orderDetailModel.services[serviceIndex].requestedServices[requestedServiceIndex].status != 'Pending'?
                                                                Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                                                                  child: orderItems(orderDetailModel.services[serviceIndex].requestedServices[requestedServiceIndex].services),
                                                                ):Container(),

                                                                Text(
                                                                  'Reason for adding a service',textAlign: TextAlign.start,
                                                                  style: TextStyle(
                                                                      fontFamily: FontStrings
                                                                          .Roboto_Regular,
                                                                      color: Color(
                                                                          0xFF404243)),
                                                                ),
                                                                // SizedBox(height: 10,),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 5),
                                                                  child: ReadMoreText("${orderDetailModel.services[serviceIndex].requestedServices[requestedServiceIndex].reason}",textAlign: TextAlign.start,
                                                                    style: TextStyle(
                                                                        fontSize: Dimens.space14 *
                                                                            _multi(context),
                                                                        fontFamily: FontStrings
                                                                            .Roboto_Regular,
                                                                        color: Color(0xFF404243)),
                                                                    // trimLines: 2,
                                                                    lessStyle: TextStyle(
                                                                      fontSize: Dimens.space12 *
                                                                          _multi(context),
                                                                      fontFamily:
                                                                      FontStrings.Roboto_Medium,
                                                                    ),
                                                                    trimLength: 20,
                                                                    trimMode: TrimMode.Line,
                                                                    trimCollapsedText: 'Show more',
                                                                    trimExpandedText: 'Show less',
                                                                    moreStyle: TextStyle(
                                                                      fontSize: Dimens.space12 *
                                                                          _multi(context),
                                                                      fontFamily:
                                                                      FontStrings.Roboto_Medium,
                                                                    ),
                                                                  ),
                                                                ),
                                                                // SizedBox(height: 10,),
                                                                orderDetailModel.services[serviceIndex].requestedServices[requestedServiceIndex].status == 'Pending'?
                                                                Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                                                  child: orderItemsWithDetails(orderDetailModel.services[serviceIndex].requestedServices[requestedServiceIndex].services),
                                                                ):Container(),
                                                                // SizedBox(height: 10,),
                                                                SizedBox(height: 5,),
                                                                Divider(thickness:0.8),
                                                                SizedBox(height: 5,),
                                                              ],
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment:CrossAxisAlignment.start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                }),
                                              ),


                                              SizedBox(height: 15,)
                                            ]
                                        ):Container(),
                                      ],
                                    ))
                                // SizedBox(
                                //   height: 10,
                                // ),
                              ],
                            );
                          }),
                    ),

                    orderDetailModel.needDelivery == 'Yes'?Column(
                      children: [
                        title2(context,'PICKUP INFORMATION'),

                        orderDetailModel.orderDate.isNotEmpty ? Container(
                            padding: EdgeInsets.only(left: 24, right: 24),
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
                                _item('Order date & time','${orderDetailModel.orderDate}'),
                              ],
                            )
                        ):Container(),
                        orderDetailModel.pickupDate.isNotEmpty ? Container(
                            padding: EdgeInsets.only(left: 24, right: 24),
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
                                _item('Pickup date & time','${orderDetailModel.pickupDate}'),
                              ],
                            )
                        ): Container(),
                        // orderDetailModel.pickupAddress.isNotEmpty ?  Container(
                        //     padding: EdgeInsets.only(left: 24, right: 24),
                        //     decoration: BoxDecoration(
                        //       color: UIColor.baseColorWhite,
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.grey.withOpacity(0.2),
                        //           spreadRadius: 0.3,
                        //           blurRadius: 1,
                        //           offset:
                        //           Offset(0, 1), // changes position of shadow
                        //         ),
                        //       ],
                        //     ),
                        //     child: Column(
                        //       children: [
                        //         _item2('Pickup Address','${orderDetailModel.pickupAddress}'),
                        //       ],
                        //     )
                        // ):Container(),
                      ],
                    ):Container(),

                    orderDetailModel.needDelivery == 'Yes'? orderDetailModel.deliveryDate.isNotEmpty ? Column(
                      children: [
                        title2(context,'DELIVERY INFORMATION'),

                        Container(
                            padding: EdgeInsets.only(left: 24, right: 24),
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
                                _item('Delivery date & time','${orderDetailModel.deliveryDate}'),
                              ],
                            )
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
                                  offset:
                                  Offset(0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // _item2('Delivery Address','${orderDetailModel.pickupAddress}'),
                              ],
                            )
                        ),
                      ],
                    ):Container():Container(),

                    title2(context,'FEES & PAYMENT'),
                    Container(
                        padding: EdgeInsets.only(left: 24, right: 24),
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
                            _item('Total fees','BHD ${orderDetailModel.totalAmount}'),
                            _item('Payment Method','${orderDetailModel.paymentMethod}'),
                          ],
                        )
                    ),


                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),

                        (widget.status == 'Document Delivery' || widget.status == 'Waiting Documents')&&(driverName != null || driverName != '')?
                        Container(
                            padding: EdgeInsets.only(left: 24, right: 24),
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
                            child: Row(
                              children: [
                                Expanded(child: _item4('$driverName','Driver','$driverProfilePhotoPath')),
                                GestureDetector(
                                  onTap: () async {
                                    await launch('tel:$driverPhone');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      "assets/Phone.svg",
                                      color: UIColor.baseGradientLight,
                                    ),
                                  ),
                                ),

                              ],
                            )
                        ):
                        Container(),

                        // status == 'Document Delivery' || status == 'Waiting Documents'?
                        // driverName != null ?
                        // driverName != '' ?
                        // Container(
                        //     padding: EdgeInsets.only(left: 24, right: 24),
                        //     decoration: BoxDecoration(
                        //       color: UIColor.baseColorWhite,
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.grey.withOpacity(0.2),
                        //           spreadRadius: 0.3,
                        //           blurRadius: 1,
                        //           offset:
                        //           Offset(0, 1), // changes position of shadow
                        //         ),
                        //       ],
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         Expanded(child: _item4('$driverName','Driver','$driverProfilePhotoPath')),
                        //         GestureDetector(
                        //           onTap: () async {
                        //             await launch('tel:$driverPhone');
                        //           },
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: SvgPicture.asset(
                        //               "assets/Phone.svg",
                        //               color: UIColor.baseGradientLight,
                        //             ),
                        //           ),
                        //         ),
                        //
                        //       ],
                        //     )
                        // ):
                        // Container():
                        // Container():
                        // Container(),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                  ],
                ),
              ),
            ),

            _footer(),
            SizedBox(
              height: 18,
            ),
          ]
        ),
      ),
    );
  }



  sendMessage(from,to){
    print('chatttttt');
      List<String> users = ['$from',"$to"];

      String chatRoomId = widget.orderID;

      Map<String, dynamic> chatRoomMap = {
        "Users": users,
        "ChatRoomID" : chatRoomId,
        "CUSTOMER_IMAGE_URL" : "$cProfilePhotoPath",
        "VENDOR_IMAGE_URL":"$eProfilePhotoPath",
        "Vendor":"Awal Express WLL",
        "Time": DateTime.now().millisecondsSinceEpoch,
        "LastMessage":""
      };

      var result = DataBaseMethod().createChatRoom(chatRoomId, chatRoomMap);

      print('result ==> $result');

    Get.to(ChatConversation('$chatRoomId', '$cProfilePhotoPath','${orderDetailModel.consumerDetails.consumerName}'));


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
        //             'Service status',
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




        // widget.status == 'Order Accepted'
        //     ? Column(
        //       children: [
        //         Padding(
        //   padding: const EdgeInsets.only(left: 20, right: 20),
        //   child: RaisedGradientButton(
        //         onPressed: () {
        //           hitOrderCompleteAPI(widget.orderID);
        //         },
        //         child: Text(
        //           'Complete',
        //           style: TextStyle(
        //               color: Colors.white,
        //               fontFamily: FontStrings.Fieldwork10_Regular,
        //               fontSize: 16),
        //         ),
        //         gradient: LinearGradient(
        //           colors: <Color>[Color(0xffC1282D), Color(0xffF15B29)],
        //         ),
        //   ),
        // ),
        //         SizedBox(
        //           height: 10,
        //         )
        //       ],
        //     )
        //     : Container(),
        // widget.status == 'With Service Provider'
        //     ? Column(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.only(left: 20, right: 20),
        //       child: RaisedGradientButton(
        //         onPressed: () {
        //           hitOrderCompleteAPI(widget.orderID);
        //         },
        //         child: Text(
        //           'Complete',
        //           style: TextStyle(
        //               color: Colors.white,
        //               fontFamily: FontStrings.Fieldwork10_Regular,
        //               fontSize: 16),
        //         ),
        //         gradient: LinearGradient(
        //           colors: <Color>[Color(0xffC1282D), Color(0xffF15B29)],
        //         ),
        //       ),
        //     ),
        //     SizedBox(
        //       height: 10,
        //     )
        //   ],
        // )
        //     : Container(),






        widget.status == 'Processing'
            ? Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: RaisedGradientButton(
            onPressed: () {
              // hitOrderAcceptAPI(widget.orderID);
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
        )
            : Container(),
      ],
    );
  }

  Widget statusIndicator(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left:20 ,bottom:20, right: 20),
          child: RaisedGradientButton(
            child: Text(
              '${widget.status}',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(
                fontFamily: FontStrings.Roboto_Regular,
                color: Color(0xFFC1282D
                ),
                fontWeight:FontWeight.bold,
              ),
            ),
              gradient:
              LinearGradient(
                colors: <Color>[
                  Color(
                      0xFFFDD8DA),
                  Color(
                      0xFFFDD8DA)
                ],
              ),),
        ),
      ],
    );
  }
  Widget _profilePic(String URL,context){
    if(URL == null|| URL.isEmpty||URL.isBlank||URL== ''||URL == 'null'){
      URL = 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png';
    }else{
      print('@@@@@ - $URL');
    }
    return URL != null?
    CircleAvatar(
      radius: 20,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: new SizedBox(
            child: Stack(
              children: <Widget>[
                // Center(child: CircularProgressIndicator(
                //   // backgroundColor: UIColor.baseGradientLight,
                //   valueColor:AlwaysStoppedAnimation<Color>(UIColor.baseGradientLight),
                // )),
                Center(
                  child: CachedNetworkImage(
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
  Widget _item(String itemName,String item){
    return  Container(
      padding: EdgeInsets.only(top: 13,bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              child: Text(itemName,textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: FontStrings.Roboto_SemiBold,
                    color: Color(0xFF4D4F51)
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(item,textAlign: TextAlign.right,
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
  Widget _item2(String itemName,String item){
    return  Container(
      padding: EdgeInsets.only(top: 13,bottom: 13),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            child: Container(
              child: Text(itemName,
                style: TextStyle(
                    fontFamily: FontStrings.Roboto_SemiBold,
                    color: Color(0xFF4D4F51)
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              width: 200,
              child: Text(item,textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: FontStrings.Roboto_Bold,
                    color: Color(0xFF404243)
                ),
              ),
            ),
          ),
          Icon(Icons.chevron_right_outlined,
            color: Color(0xFF404243),
          ),
        ],
      ),
    );
  }
  Widget _item3(String item){
    return  Container(
      padding: EdgeInsets.only(top: 13,bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right:16 ),
            child: SvgPicture.asset(
              "assets/clock.svg",
              color: Color(
                  0xff404243),
            ),
          ),
          Expanded(
            child: Container(
              child: Text(item,
                style: TextStyle(
                    fontFamily: FontStrings.Roboto_SemiBold,
                    color: Color(0xFF212156)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _item4(String itemName,String item,String url){
    return  Container(
      child: Column(
        children: [
          Container(
            child: Container(
              padding: const EdgeInsets.only(top:14.5,bottom: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      _profilePic(
                          url,
                          context),
                      Container(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                fontFamily: FontStrings.Roboto_Bold,
                              ),
                            ),
                            SizedBox(height: 4,),
                            Text(item,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                fontFamily:
                                FontStrings.Roboto_Regular,
                              ),
                            )
                          ],
                        ),
                      )

                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top:25.5),
                  //   child: Row(
                  //     children: [
                  //       Text(item2,
                  //         style: Theme.of(context).textTheme.bodyText2.copyWith(
                  //             fontFamily: FontStrings.Roboto_Regular,
                  //             color: Color(0xff212156)
                  //         ),
                  //       ),
                  //
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _item5(String itemName2,String item2){
    return  Container(
      child: Column(
        children: [
          Container(
            child: Container(
              padding: const EdgeInsets.only(top:12,bottom: 12),
              child: Row(
                children: [
                  _profilePic(
                      "https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png",
                      context),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemName2,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                              fontFamily: FontStrings.Roboto_Bold,
                            ),
                          ),
                          SizedBox(height: 4,),
                          Text(item2,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                              fontFamily:
                              FontStrings.Roboto_Regular,
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
  Widget title(context,title,number){
    return Container(
      padding: EdgeInsets.only(left: 24,right: 24,top: 25.5,bottom: 16.5),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(title,
                style: Theme.of(context).textTheme.caption.copyWith(
                  fontFamily: FontStrings.Roboto_SemiBold,
                  fontWeight: FontWeight.bold,
                  color:Color(0xFF888B8D),),
                // TextStyle(
                //     fontFamily: FontStrings.Roboto_SemiBold,
                //     color: Color(0xFF888B8D)
                // ),
              ),
            ),
          ),
          Container(
            child: Text(number,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
          fontFamily: FontStrings.Fieldwork16_Bold,
          color: Color(0xff212156)
          ),
            ),
          ),
        ],
      ),
    );
  }
  Widget title2(context,title){
    return Container(
      padding: EdgeInsets.only(left: 24,right: 24,top: 25.5,bottom: 16.5),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(title,
                style: Theme.of(context).textTheme.caption.copyWith(
                  fontFamily: FontStrings.Roboto_SemiBold,
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
  void orderIssueDialog(BuildContext context,var itemID) {
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
                                          'Service Status',
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
                                          processing = false;
                                          completed = false;
                                          solved = false;
                                          notSolved = false;
                                          readCon.text = '';
                                          setState((){});
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
                                        'Something is wrong',
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
                                        Get.back();
                                        hitOrderStatusAPI(itemID);
                                      }

                                      if(status == "notSolved"){
                                        // Get.back();
                                        if(readCon.text.isNotEmpty || !readCon.text.isBlank){
                                          Get.back();
                                          hitCannotBeSolvedAPI(itemID,readCon.text);
                                          // getSnackBar(null,'${readCon.text}');
                                        }else{
                                          getSnackBar(null,'Enter the reason');
                                        }

                                      }

                                      if(status == "solved"){
                                        Get.back();
                                        // navigator.pop(true);
                                        // openServiceTypeDialog(context,itemID);xx
                                        Get.off(NewOrderService(widget.status,widget.needDelivery,itemID,isPickup?'Pickup documents':'Clearance documents',widget.orderID));
                                      }
                                      if(status == ""){
                                        getSnackBar(null,'Choose a service status');
                                      }

                                      print('processing : $processing');
                                      print('completed : $completed');
                                      print('solved : $solved');
                                      print('notSolved : $notSolved');
                                      print('status : $status');
                                      print('readCon : ${readCon.text}');

                                      processing = false;
                                      completed = false;
                                      solved = false;
                                      if(notSolved){
                                        if(readCon.text == null || readCon.text == ''){
                                          print('---->>>>----');
                                          notSolved = true;
                                        }else{
                                          notSolved = false;
                                        }
                                      }else{
                                        notSolved = false;
                                      }
                                      print('---------------------------------------');
                                      print('processing : $processing');
                                      print('completed : $completed');
                                      print('solved : $solved');
                                      print('notSolved : $notSolved');
                                      print('status : $status');

                                      status = '';
                                      setState((){});
                                      print('$processing\n$completed\n$solved\n$notSolved\n$status');
                                      // ProgressDialog pd = ProgressDialog(context: context);
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

  void hitOrderStatusAPI(String itemID) {
    // ProgressDialog pd = ProgressDialog(context: context);
    // pd.show(max: 0, msg: 'Loading',progressBgColor:Color(0xFFFFFFFF));
    orderStatusController.fetchServices(itemID).then((result) {
      if (result["status"] == true) {
        isServicePresent = "";
        // Get.back();
        // pd.close();
        // print('hhhhhhhh')
        hitOrderListAPI(widget.orderID);
        // Get.off(PendingOrderDetails(widget.status, widget.orderID, widget.needDelivery));
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
    // ProgressDialog pd = ProgressDialog(context: context);
    // pd.show(max: 0, msg: 'Loading',progressBgColor:Color(0xFFFFFFFF));
    orderCannotBeSolvedController.fetchServices(itemID,reason).then((result) {
      if (result["status"] == true) {
        isServicePresent = "";
        // Get.back();
        // pd.close();
        hitOrderListAPI(widget.orderID);
        // Get.off(PendingOrderDetails(widget.status, widget.orderID, widget.needDelivery));
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
                                        bottom: 16, top: 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '',
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
                                      Get.back();
                                      Get.to(NewOrderService(widget.status,widget.needDelivery,itemId,isPickup?'Pickup documents':'Clearance documents',widget.orderID));
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

  void loadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState){
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
                              child:Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(bottom:16,top:24),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text('Reject',
                                              style: Theme.of(context).textTheme.headline6.copyWith(
                                                fontFamily: FontStrings.Fieldwork16_Bold,
                                                color:Color(0xFF212156),),),
                                          ),
                                        ),
                                          GestureDetector(
                                          onTap:(){
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
                                    onTap:(){
                                      if (Other){
                                        Other=false;
                                        setState(() {
                                        });
                                      }
                                      else{
                                        Other=true;
                                        setState(() {
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Other==false? SvgPicture.asset(
                                          'assets/on.svg',
                                          allowDrawingOutsideViewBox: true,
                                        ):
                                        SvgPicture.asset(
                                          'assets/off.svg',
                                          allowDrawingOutsideViewBox: true,
                                        ),
                                        Text('Busy',style: Theme.of(context).textTheme.bodyText2.copyWith(
                                          fontFamily: FontStrings.Roboto_Regular,
                                          color:Color(0xFF212156),),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16,),
                                  GestureDetector(
                                    onTap:(){
                                      if (Other){
                                        Other=false;
                                        setState(() {
                                        });
                                      }
                                      else{
                                        Other=true;
                                        setState(() {
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: [
                                       Other==true? SvgPicture.asset(
                                          'assets/on.svg',
                                          allowDrawingOutsideViewBox: true,
                                        ):
                                       SvgPicture.asset(
                                         'assets/off.svg',
                                         allowDrawingOutsideViewBox: true,
                                       ),
                                        Text('Other',style: Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontFamily: FontStrings.Roboto_Regular,
                                      color:Color(0xFF212156),),
                                    ),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                      padding: EdgeInsets.only(top: 0, left: 0, right: 0,bottom: 24),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: TextField(
                                              keyboardType: TextInputType.streetAddress,
                                              controller: readCon,
                                              cursorColor: Color(0xff0A95A0),
                                              decoration: new InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  enabledBorder: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder.none,
                                                  hintText:'Type rejection reson...' ),
                                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                fontFamily: FontStrings.Roboto_Regular,
                                                color:Color(0xFF888B8D),),
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom:24),
                                    child: RaisedGradientButton(
                                      onPressed: (){
                                        Get.snackbar(null,
                                            'Order was rejected',
                                            snackPosition:SnackPosition.BOTTOM,
                                            backgroundColor: UIColor.baseGradientDar,
                                            colorText: Colors.white);
                                      },
                                      child: Text(
                                        'Confirm'+'نينثألا',
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
                                      ),),
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
          }
        );
      },
    );
  }

  Widget counterWid(BuildContext context, int second) {
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
  void hitOrderListAPI(String orderID) {
    isLoading = true;
    orderDetailController.fetchServices(orderID).then((result) {
      isLoading = false;
      if (result["status"] == true) {
        isServicePresent = "";
        print('---------------\n${result["status"]}');
        print('-----------${result["message"]}');
        orderDetailModel = OrderDetailModel1.fromJson(result).result;

        employeeName = orderDetailModel.employeeDetail.employeeName;
        if(orderDetailModel.rating != null){
          vendorRating = double.parse(orderDetailModel.rating.toString());
        }

        customerName = orderDetailModel.consumerDetails.consumerName;
        eProfilePhotoPath = orderDetailModel.employeeDetail.profilePhotoPath;
        seconds = orderDetailModel.estimatedCompletedTime;
        cProfilePhotoPath = orderDetailModel.consumerDetails.profilePhotoPath;
        servicesLength = orderDetailModel.services.length;
        stat = orderDetailModel.status;

        if(orderDetailModel.driverDetail.isNotEmpty){
          driverName = orderDetailModel.driverDetail[0].name;
          driverPhone = orderDetailModel.driverDetail[0].phone;
          driverProfilePhotoPath = orderDetailModel.driverDetail[0].profilePhotoPath;

          driverProfilePhotoPath = orderDetailModel.driverDetail[0].profilePhotoPath;
          driverProfilePhotoPath = orderDetailModel.driverDetail[0].profilePhotoPath;
          driverProfilePhotoPath = orderDetailModel.driverDetail[0].profilePhotoPath;
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


}