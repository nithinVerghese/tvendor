import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/view/Settings/ManageService/ManageBahrainTabBar.dart';
import 'package:takhlees_v/view/Settings/ManageService/ManageExpatTabBar.dart';
import 'package:takhlees_v/view/Settings/ManageService/ManageGccTabBar.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';

import '../HomeScreen/OrderBottomBarIndex.dart';
import 'VendorServiceBh.dart';
import 'VendorServiceEx.dart';
import 'VendorServiceGcc1.dart';

class VendorService extends StatefulWidget {
  @override
  _VendorServiceState createState() => _VendorServiceState();
}

class _VendorServiceState extends State<VendorService>
    with TickerProviderStateMixin {



  TabController tabController;
  List expandArray = [];

  // TabController _tabController;
  TabController _tabController;

  @override
  void initState() {
    print('------VendorService-------------');
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }
  //
  // @override
  // Widget build(BuildContext context) {
  //   print('----------------------------VendorService----------------------');
  //   return Scaffold(
  //     body:
  //     // SafeArea(
  //     //   child: SingleChildScrollView(
  //     //       child: Column(
  //     //     children: [
  //     //       space(24),
  //     //       workStatus(),
  //     //       space(24),
  //     //       nationalityTabs(),
  //     //       space(24),
  //     //       tabBarView(),
  //     //       space(24),
  //     //       tabView()
  //     //     ],
  //     //   )),
  //     // ),
  //   );
  // }
  //
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
  //                   fit: BoxFit.contain,
  //                 ),
  //                 SizedBox(
  //                   height: 16,
  //                 ),
  //                 Text(
  //                   'Services available',
  //                   style: Theme.of(context).textTheme.caption.copyWith(
  //                         fontFamily: FontStrings.Roboto_Bold,
  //                         color: UIColor.baseColorTeal,
  //                       ),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Text(
  //                   'Select the services you provide and it’s price. You can always change it in settings.',
  //                   textAlign: TextAlign.center,
  //                   style: Theme.of(context).textTheme.caption.copyWith(
  //                         fontFamily: FontStrings.Roboto_Regular,
  //                         color: Color(0xFF4D4F51),
  //                       ),
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
  //
  // Widget nationalityTabs() {
  //   return Container(
  //     // margin: EdgeInsets.symmetric(vertical: 20.0),
  //     height: 40,
  //     child: Row(
  //       // scrollDirection: Axis.horizontal,
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: <Widget>[
  //         Column(
  //           children: [
  //             Expanded(
  //               child: Center(
  //                 child: Container(
  //                   padding: EdgeInsets.all(10),
  //                   child: Text(
  //                     'Bahraini National',
  //                     textAlign: TextAlign.center,
  //                     style: Theme.of(context).textTheme.caption.copyWith(
  //                           fontFamily: FontStrings.Roboto_Bold,
  //                           color: UIColor.darkBlue,
  //                         ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               height: 2,
  //               color: UIColor.darkBlue,
  //             )
  //           ],
  //         ),
  //         Column(
  //           children: [
  //             Expanded(
  //               child: Center(
  //                 child: Container(
  //                   padding: EdgeInsets.all(10),
  //                   child: Text(
  //                     'Expatriate',
  //                     textAlign: TextAlign.center,
  //                     style: Theme.of(context).textTheme.caption.copyWith(
  //                           fontFamily: FontStrings.Roboto_Bold,
  //                           color: UIColor.darkBlue,
  //                         ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               height: 2,
  //               color: UIColor.darkBlue,
  //             )
  //           ],
  //         ),
  //         Column(
  //           children: [
  //             Expanded(
  //               child: Center(
  //                 child: Container(
  //                   padding: EdgeInsets.all(10),
  //                   child: Text(
  //                     'GCC National',
  //                     textAlign: TextAlign.center,
  //                     style: Theme.of(context).textTheme.caption.copyWith(
  //                           fontFamily: FontStrings.Roboto_Bold,
  //                           color: UIColor.darkBlue,
  //                         ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               height: 2,
  //               color: UIColor.darkBlue,
  //             )
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget tabBarView() {
  //   return TabBar(
  //     controller: tabController,
  //     isScrollable: true,
  //     indicatorColor: UIColor.darkBlue,
  //     unselectedLabelColor: Color(0xFF707375),
  //     labelStyle: Theme.of(context).textTheme.caption.copyWith(
  //           fontFamily: FontStrings.Roboto_Bold,
  //           color: UIColor.baseColorTeal,
  //         ),
  //     labelColor: UIColor.darkBlue,
  //     tabs: [
  //       Tab(
  //         text: 'CPR Cards',
  //       ),
  //       Tab(
  //         text: 'Passports',
  //       ),
  //       Tab(
  //         text: 'Vehicles',
  //       ),
  //       Tab(
  //         text: 'Utility (Electricity & Water)',
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget tabView() {
  //   return Container(
  //     child: TabBarView(
  //       children: <Widget>[
  //         Center(
  //           child: Text("Email"),
  //         ),
  //         Center(
  //           child: Text("Email"),
  //         ),
  //         Center(
  //           child: Text("Settings"),
  //         ),
  //         Center(
  //           child: Text("Settings"),
  //         ),
  //       ],
  //       controller: tabController,
  //     ),
  //   );
  // }
  //
  // Widget _tabView(context) {
  //   return Expanded(
  //       child: TabBarView(
  //     controller: tabController,
  //     children: List<Widget>.generate(4, (int index) {
  //       return ListView.builder(
  //           shrinkWrap: true,
  //           itemCount: 3,
  //           itemBuilder: (context, index) {
  //             return index == 1
  //                 ? Container(
  //                     decoration: BoxDecoration(
  //                       color: UIColor.baseColorWhite,
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey.withOpacity(0.2),
  //                           spreadRadius: 0.3,
  //                           blurRadius: 1,
  //                           offset: Offset(0, 1), // changes position of shadow
  //                         ),
  //                       ],
  //                     ),
  //                     padding: EdgeInsets.all(10),
  //                     margin: EdgeInsets.only(bottom: 10),
  //                     child: Container(
  //                       child: ListView.builder(
  //                           itemCount: 3,
  //                           physics: ClampingScrollPhysics(),
  //                           shrinkWrap: true,
  //                           itemBuilder: (context, i) {
  //                             return GestureDetector(
  //                               child: Padding(
  //                                 padding: const EdgeInsets.only(
  //                                     left: 24, right: 24, top: 12, bottom: 12),
  //                                 child: Row(
  //                                   children: [
  //                                     Padding(
  //                                         padding: const EdgeInsets.only(),
  //                                         child:
  //                                             // dataModel[index].services[i].quantity==0?
  //                                             Padding(
  //                                           padding: const EdgeInsets.only(
  //                                               left: 8.0, right: 5),
  //                                           child: Icon(
  //                                             Icons.circle,
  //                                             color:
  //                                                 // dataModel[index]
  //                                                 //     .services[i]
  //                                                 //     .serviceType ==
  //                                                 //     "No delivery needed"
  //                                                 index == 1
  //                                                     ? Colors.teal
  //                                                     : Color(0xffF15B29),
  //                                             size: 12,
  //                                           ),
  //                                         )
  //                                         // :Stack(
  //                                         //   alignment: Alignment.center,
  //                                         //   children: [
  //                                         //     Positioned(
  //                                         //       child: Icon(
  //                                         //         Icons.circle,
  //                                         //         color: dataModel[index]
  //                                         //             .services[i]
  //                                         //             .serviceType ==
  //                                         //             "No delivery needed"
  //                                         //             ? Colors.teal
  //                                         //             : Color(0xffF15B29),
  //                                         //         size: 26,
  //                                         //       ),
  //                                         //     ),
  //                                         //     Positioned(
  //                                         //       child: Text(dataModel[index].services[i].quantity.toString(),style: TextStyle(
  //                                         //         fontFamily: FontStrings.Roboto_Bold,
  //                                         //         color: UIColor.baseColorWhite,
  //                                         //       ),),
  //                                         //       bottom: 5,
  //                                         //     ),
  //                                         //   ],
  //                                         // )
  //                                         ),
  //                                     Expanded(
  //                                       child: Padding(
  //                                         padding:
  //                                             const EdgeInsets.only(left: 12.0),
  //                                         child: Text(
  //                                           'Testtttt $index ,$i',
  //                                           style: Theme.of(context)
  //                                               .textTheme
  //                                               .caption
  //                                               .copyWith(
  //                                                 fontFamily:
  //                                                     FontStrings.Roboto_Bold,
  //                                                 color: UIColor.baseColorTeal,
  //                                               ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(),
  //                                       child: Text(
  //                                         // "BHD ${dataModel[index].services[i].serviceFee}",
  //                                         'BHD 10',
  //                                         style: Theme.of(context)
  //                                             .textTheme
  //                                             .caption
  //                                             .copyWith(
  //                                               fontFamily:
  //                                                   FontStrings.Roboto_Bold,
  //                                               color: UIColor.baseColorTeal,
  //                                             ),
  //                                       ),
  //                                     )
  //                                   ],
  //                                 ),
  //                               ),
  //                             );
  //                           }),
  //                     ))
  //                 : Container(
  //                     decoration: BoxDecoration(
  //                       color: UIColor.baseColorWhite,
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey.withOpacity(0.2),
  //                           spreadRadius: 0.3,
  //                           blurRadius: 1,
  //                           offset: Offset(0, 1), // changes position of shadow
  //                         ),
  //                       ],
  //                     ),
  //                     padding: EdgeInsets.all(10),
  //                     margin: EdgeInsets.only(bottom: 10),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         GestureDetector(
  //                           onTap: () {
  //                             setState(() {
  //                               expandArray[index][index.toString()] == true
  //                                   ? expandArray[index][index.toString()] =
  //                                       false
  //                                   : expandArray[index][index.toString()] =
  //                                       true;
  //                             });
  //                           },
  //                           child: Container(
  //                             child: Padding(
  //                               padding: const EdgeInsets.only(
  //                                   left: 24, right: 24, top: 10, bottom: 10),
  //                               child: Row(
  //                                 children: [
  //                                   Expanded(
  //                                     child: Text(
  //                                       'wwww',
  //                                       // dataModel[index].categoryNameEn,
  //                                       style: Theme.of(context).textTheme.caption.copyWith(
  //                                         fontFamily: FontStrings.Roboto_Bold,
  //                                         color: UIColor.baseColorTeal,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   expandArray[index][index.toString()] == true
  //                                       ? Icon(
  //                                           Icons.chevron_right_outlined,
  //                                           size: 30,
  //                                         )
  //                                       : Icon(Icons.expand_more_rounded,
  //                                           size: 30)
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         expandArray[index][index.toString()] == true
  //                             ? Container(
  //                                 child: ListView.builder(
  //                                     itemCount:
  //                                         2,
  //                                     physics: ClampingScrollPhysics(),
  //                                     shrinkWrap: true,
  //                                     itemBuilder: (context, i) {
  //                                       return GestureDetector(
  //                                         // onTap: () async {
  //                                         //   print(
  //                                         //       'serviceNameEn ==> ${dataModel[index].services[i].serviceId.toString()}');
  //                                         //   var data = [];
  //                                         //   data.add(dataModel[index]
  //                                         //       .services[i]
  //                                         //       .serviceNameEn
  //                                         //       .toString()); //0
  //                                         //   data.add(dataModel[index]
  //                                         //       .services[i]
  //                                         //       .serviceId
  //                                         //       .toString()); //1
  //                                         //   data.add(dataModel[index]
  //                                         //       .services[i]
  //                                         //       .serviceNameAr
  //                                         //       .toString()); //2
  //                                         //   data.add(dataModel[index]
  //                                         //       .services[i]
  //                                         //       .serviceFee
  //                                         //       .toString()); //3
  //                                         //   data.add(dataModel[index]
  //                                         //       .services[i]
  //                                         //       .serviceType
  //                                         //       .toString()); //4
  //                                         //   data.add(dataModel[index]
  //                                         //       .services[i]
  //                                         //       .governmentFee
  //                                         //       .toString()); //5
  //                                         //   data.add(dataModel[index]
  //                                         //       .services[i]
  //                                         //       .serviceTime
  //                                         //       .toString()); //6
  //                                         //   // data.add(dataModel[index].services[i].documents);
  //                                         //
  //                                         //   List docu = dataModel[index]
  //                                         //       .services[i]
  //                                         //       .documents
  //                                         //       .toList();
  //                                         //   var arr = [];
  //                                         //   docu.forEach((element) {
  //                                         //     arr.add(element.documentNameEn);
  //                                         //   });
  //                                         //   data.add(arr); //7
  //                                         //   data.add(dataModel[index]
  //                                         //       .services[i]
  //                                         //       .quantity); //8
  //                                         //   data.add(dataModel[index]
  //                                         //       .services[i]
  //                                         //       .expressServiceFee
  //                                         //       .toString()); //9
  //                                         //   data.add(dataModel[index]
  //                                         //       .services[i]
  //                                         //       .expressService); //10
  //                                         //   data.add(dataModel[index]
  //                                         //       .services[i]
  //                                         //       .expressServiceTime); //11
  //                                         //   data.add(dataModel[index]
  //                                         //       .services[i]
  //                                         //       .expressSelected); //12
  //                                         //   final result = await Navigator.push(
  //                                         //       context, MaterialPageRoute(
  //                                         //           builder: (context) {
  //                                         //     return CartServiceScreen(data);
  //                                         //   }));
  //                                         //   log.d(
  //                                         //       ":::::::>>>>${dataModel[index].services[i].serviceNameEn}");
  //                                         //   log.d(
  //                                         //       ":::::::>>>>${dataModel[index].services[i].serviceType}");
  //                                         //   print(
  //                                         //       '----------------result = $result');
  //                                         //   if (result == 'true') {
  //                                         //     category
  //                                         //         .fetchCategory(serviceType)
  //                                         //         .then((result) {
  //                                         //       servicesModel = result;
  //                                         //     });
  //                                         //     _hitApiServices(0, vendorID,
  //                                         //         serviceType, _nationality);
  //                                         //   }
  //                                         //   log.d(
  //                                         //       ":::::::>>>> ${dataModel[index].services[i].serviceNameEn}");
  //                                         // },
  //                                         child: Padding(
  //                                           padding: const EdgeInsets.only(
  //                                               left: 24,
  //                                               right: 24,
  //                                               top: 12,
  //                                               bottom: 12),
  //                                           child: Row(
  //                                             children: [
  //                                               Padding(
  //                                                   padding:
  //                                                       const EdgeInsets.only(),
  //                                                   child:
  //                                             index == 1
  //                                                       // dataModel[index]
  //                                                       //             .services[i]
  //                                                       //             .quantity ==
  //                                                       //         0
  //                                                           ? Padding(
  //                                                               padding:
  //                                                                   const EdgeInsets
  //                                                                           .only(
  //                                                                       left:
  //                                                                           8.0),
  //                                                               child: Icon(
  //                                                                 Icons.circle,
  //                                                                 color:
  //                                                                   i == 1
  //                                                                 // dataModel[index]
  //                                                                 //             .services[
  //                                                                 //                 i]
  //                                                                 //             .serviceType ==
  //                                                                 //         "No delivery needed"
  //                                                                     ? Colors
  //                                                                         .teal
  //                                                                     : Color(
  //                                                                         0xffF15B29),
  //                                                                 size: 12,
  //                                                               ),
  //                                                             )
  //                                                           : Stack(
  //                                                               alignment:
  //                                                                   Alignment
  //                                                                       .center,
  //                                                               children: [
  //                                                                 Positioned(
  //                                                                   child: Icon(
  //                                                                     Icons
  //                                                                         .circle,
  //                                                                     color:
  //                                                 i == 1
  //                                                                     // dataModel[index].services[i].serviceType ==
  //                                                                     //         "No delivery needed"
  //                                                                         ? Colors
  //                                                                             .teal
  //                                                                         : Color(
  //                                                                             0xffF15B29),
  //                                                                     size: 26,
  //                                                                   ),
  //                                                                 ),
  //                                                                 Positioned(
  //                                                                   child: Text('',
  //                                                                     // dataModel[
  //                                                                     //         index]
  //                                                                     //     .services[
  //                                                                     //         i]
  //                                                                     //     .quantity
  //                                                                     //     .toString(),
  //                                                                     style:
  //                                                                         TextStyle(
  //                                                                       fontFamily:
  //                                                                           FontStrings.Roboto_Bold,
  //                                                                       color: UIColor
  //                                                                           .baseColorWhite,
  //                                                                     ),
  //                                                                   ),
  //                                                                   bottom: 5,
  //                                                                 ),
  //                                                               ],
  //                                                             )),
  //                                               Expanded(
  //                                                 child: Padding(
  //                                                   padding:
  //                                                       const EdgeInsets.only(
  //                                                           left: 12.0),
  //                                                   child: Text(
  //                                                     'ewef $index , $i',
  //                                                     // dataModel[index]
  //                                                     //     .services[i]
  //                                                     //     .serviceNameEn,
  //                                                     style: Theme.of(context).textTheme.caption.copyWith(
  //                                                       fontFamily: FontStrings.Roboto_Bold,
  //                                                       color: UIColor.baseColorTeal,
  //                                                     ),
  //                                                     // TextStyle(
  //                                                     //     fontSize: Dimens
  //                                                     //             .space18 *
  //                                                     //         _multi(context),
  //                                                     //     fontFamily: FontStrings
  //                                                     //         .Roboto_Regular,
  //                                                     //     color:
  //                                                     //         UIColor.darkGrey),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                               Padding(
  //                                                 padding:
  //                                                     const EdgeInsets.only(),
  //                                                 child: Text(
  //                                                   "BHD 10",
  //                                                   style: Theme.of(context).textTheme.caption.copyWith(
  //                                                     fontFamily: FontStrings.Roboto_Bold,
  //                                                     color: UIColor.baseColorTeal,
  //                                                   ),
  //                                                 ),
  //                                               )
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       );
  //                                     }),
  //                               )
  //                             : Container(
  //                                 height: 0.0,
  //                               ),
  //                       ],
  //                     ));
  //           });
  //     }),
  //   ));
  // }
  //
  // Widget space(double size) {
  //   return SizedBox(
  //     height: size,
  //   );
  // }
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
                Navigator.pop(context);
              },
            );
          },
        ),
        // Icon(Icons.arrow_back_ios_rounded,
        //     color: Color(0xff212156),),
        backgroundColor: Colors.white,
        title:
        Text("Services available ",
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
        child: Column(
          children: [
            SizedBox(height: 14,),
            workStatus(),
            SizedBox(height: 24,),
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
                  text: 'Bahraini National'.tr,
                ),
                Tab(
                  // icon: Icon(Icons.email),
                  text: 'Expatriate'.tr,
                ),
                Tab(
                  // icon: Icon(Icons.settings),
                  text: 'GCC National'.tr,
                ),
              ],
            ),
            SizedBox(height: 24,),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  BahrainTabBar(),
                  ExpatTabBar(),
                  GccTabBar(),
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget workStatus() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Container(
              padding: EdgeInsets.only(left: 50, right: 50),
              decoration: BoxDecoration(
                color: UIColor.baseColorWhite,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  SvgPicture.asset(
                    'assets/status line1.svg',
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Services available',
                    style: Theme.of(context).textTheme.caption.copyWith(
                      fontFamily: FontStrings.Roboto_Bold,
                      color: UIColor.baseColorTeal,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Select the services you provide and it’s price. You can always change it in settings.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption.copyWith(
                      fontFamily: FontStrings.Roboto_Regular,
                      color: Color(0xFF4D4F51),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget workTime(String time){
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                decoration: BoxDecoration(
                  color: UIColor.baseColorWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0, 0.1),
                      blurRadius: 0.2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.only(top: 13, bottom: 13),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Working Hours',
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                  fontFamily: FontStrings.Roboto_Regular,
                                  color: Color(0xFF4D4F51),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                time,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.caption.copyWith(
                                  fontFamily: FontStrings.Roboto_Bold,
                                  color: Color(0xFF4D4F51),
                                ),
                              ),
                            )
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
        SizedBox(
          height: 1,
        )
      ],
    );
  }
}
