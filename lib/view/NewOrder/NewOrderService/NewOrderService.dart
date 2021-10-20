import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/controller/NewOrderController/ClearCartServiceControlleer.dart';
import 'package:takhlees_v/view/Settings/ManageService/itemCount.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:takhlees_v/widget/dialogBox/optionalDialog.dart';
import '../../PendingOrderDetails.dart';
import 'BahrainTabBar.dart';
import 'ExpatTabBar.dart';
import 'GccTabBar.dart';

class NewOrderService extends StatefulWidget {
  final String itemID;
  final String orderType;
  final String orderID;
  final String status,needDelivery;
  const NewOrderService(this.status,this.needDelivery,this.itemID,this.orderType,this.orderID);
  @override
  _NewOrderServiceState createState() => _NewOrderServiceState();
}

class _NewOrderServiceState extends State<NewOrderService>
    with TickerProviderStateMixin {
  
  TabController tabController;
  List expandArray = [];
  // TabController _tabController;
  TabController _tabController;
  String isServicePresent = "";

  var dataModel;
  final clearCart = Get.put(ClearCartServiceController());
  @override
  void initState() {
    print('------New Order Service-------------');

    print('itemID : ${widget.itemID}');
    print('orderType : ${widget.orderType}');
    print('orderID : ${widget.orderID}');
    print('status : ${widget.status}');
    print('needDelivery : ${widget.needDelivery}');

    _hitClearCartServicesAPI(true);
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        brightness: Brightness.light,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.clear,
                color: Color(0xffF15B29),),
              onPressed: () {
                print('-------${ItemCount().getItem}');
                if(ItemCount().getItem == '0'|| ItemCount().getItem == null){
                  // Get.back();
                  Get.off(PendingOrderDetails(widget.status, widget.orderID, widget.needDelivery));
                }else{
                  optionalDialog("Leave the page","Are you sure you would like to go back and remove your selected services?",(){
                    _hitClearCartServicesAPI(false);
                  },(){Get.back();});
                }

                // Navigator.pop(context);
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: Text("#${widget.orderID}",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(
                    fontFamily: FontStrings.Fieldwork16_Bold,
                    color: Color(0xff212156),
                  ),),
            ),
          ),
        ],

        // Icon(Icons.arrow_back_ios_rounded,
        //     color: Color(0xff212156),),
        backgroundColor: Colors.white,
        title: Text("Add new service",
          style: Theme.of(context).textTheme.headline6.copyWith(
              fontFamily: FontStrings.Fieldwork10_Regular,
              color: Color(0xff212156)
          ),),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // workStatus(),
            SizedBox(height: 5,),
            TabBar(
              controller: _tabController,
              indicatorColor:UIColor.darkBlue,
              labelColor:  UIColor.darkBlue,
              unselectedLabelColor: Colors.black54,
              labelStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                fontFamily: FontStrings.Roboto_Bold,
              ),
              unselectedLabelStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                fontFamily: FontStrings.Roboto_Bold,
              ),
              tabs: <Widget>[
                Tab(
                  // icon: Icon(Icons.home),
                  text: 'Bahraini National',
                ),
                Tab(
                  // icon: Icon(Icons.email),
                  text: 'Expatriate',
                ),
                Tab(
                  // icon: Icon(Icons.settings),
                  text: 'GCC National',
                ),
              ],
            ),
            SizedBox(height: 5,),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  BahrainTabBar(
                      widget.itemID,
                      widget.orderType,
                      widget.status,
                      widget.needDelivery,
                      widget.orderID),
                  ExpatTabBar(widget.itemID,
                      widget.orderType,
                      widget.status,
                      widget.needDelivery,
                      widget.orderID),
                  GccTabBar(widget.itemID,
                      widget.orderType,
                      widget.status,
                      widget.needDelivery,
                      widget.orderID),
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Widget workStatus() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Container(
  //           padding: EdgeInsets.only(left: 24, right: 24),
  //           child: Container(
  //             padding: EdgeInsets.only(left: 50, right: 50),
  //             decoration: BoxDecoration(
  //               color: UIColor.baseColorWhite,
  //               borderRadius: BorderRadius.circular(10.0),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.black12,
  //                   offset: Offset(0.0, 1.0),
  //                   blurRadius: 3,
  //                 ),
  //               ],
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 SizedBox(
  //                   height: 16,
  //                 ),
  //                 SvgPicture.asset(
  //                   'assets/status line1.svg',
  //                   allowDrawingOutsideViewBox: true,
  //                   fit: BoxFit.cover,
  //                 ),
  //                 SizedBox(
  //                   height: 16,
  //                 ),
  //                 Text(
  //                   'Services available',
  //                   style: Theme.of(context).textTheme.caption.copyWith(
  //                     fontFamily: FontStrings.Roboto_Bold,
  //                     color: UIColor.baseColorTeal,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Text(
  //                   'Select the services you provide and it’s price. You can always change it in settings.',
  //                   textAlign: TextAlign.center,
  //                   style: Theme.of(context).textTheme.caption.copyWith(
  //                     fontFamily: FontStrings.Roboto_Regular,
  //                     color: Color(0xFF4D4F51),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 16,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  void _hitClearCartServicesAPI(bool isStart) {
    // dataModel.clear();
    if(!isStart){
      showLoading('');
    }

    setState(() {});
    clearCart
        .fetchServices()
        .then((result) {
          // hideLoading();
      if(!isStart){
        hideLoading();
      }
      if (result["status"] == true) {
        isServicePresent = "";
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(
        //         builder: (context) {
        //           return HomeBottomBarIndex();
        //         }));
        if(!isStart){
          if(Get.isDialogOpen){
            Get.back();
            Get.back();
          }else{
            Get.back();
          }
        }

        // Scaffold.of(context).showSnackBar(SnackBar(
        //   behavior: SnackBarBehavior.floating,
        //   content: Text(result["status"]),
        // ));
        print('******** ${result["status"]}');

      } else {
        isServicePresent = result["message"];
        setState(() {});
        print("--------------$isServicePresent");
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      setState(() {});
      print("--------------$isServicePresent");

    });
  }

}
