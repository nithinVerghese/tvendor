import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/controller/Profile/AddVendorAvailabilityController.dart';
import 'package:takhlees_v/controller/Profile/DeleteVendorAvailabilityController.dart';
import 'package:takhlees_v/controller/Profile/VendorAvailabilityListController.dart';
import 'package:takhlees_v/model/VendorAvailabilityListModel.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:takhlees_v/widget/snackBar.dart';
import 'package:intl/intl.dart';

class ManageWorkTime extends StatefulWidget {
  @override
  _ManageWorkTimeState createState() => _ManageWorkTimeState();
}


class _ManageWorkTimeState extends State<ManageWorkTime> {
  var checkBoxExpressValue = false;
  var checkBoxSunday = false;
  var checkBoxMonday = false;
  var checkBoxTuesday = false;
  var checkBoxWednesday = false;
  var checkBoxThursday = false;
  var checkBoxFriday = false;
  var checkBoxSaturday = false;
  final vendorAvailabilityList = VendorAvailabilityListController();
  final addVendorAvailability = AddVendorAvailabilityController();
  final deleteVendorAvailability = DeleteVendorAvailabilityController();
  var vendorAvailableModel = VendorAvailableResult();
  var fromTime,toTime;
  bool isLoading = false;
  String isServicePresent;
  bool sunday = false,monday = false ,tuesday = false ,wednesday = false ,thursday = false, friday = false, saturday = false;

  Future<void> _loginCheck(String status ) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('status', status);
  }

  @override
  void initState() {
    // TODO: implement initState
    _loginCheck('vendorWorkTime');
    DateTime now = DateTime.now();
    fromTime = DateFormat('kk:mm').format(now);
    toTime = DateFormat('kk:mm').format(now);
    hitApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('----------------------------vendorWorkTime----------------------');
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
        title: Text("Work schedule",
          style: Theme.of(context).textTheme.headline6.copyWith(
              fontFamily: FontStrings.Fieldwork10_Regular,
              color: Color(0xff212156)
          ),),
      ),
      body: SafeArea(
        child: isLoading ? Center(
          child: CircularProgressIndicator(),
        ):SingleChildScrollView(
          child: Column(
            children: [
              // workStatus(),
              SizedBox(
                height: 24,
              ),
              Column(
                children: List.generate(7, (index) => day(index)),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24),
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
              SizedBox(
                height: 24,
              ),
            ],
          ),
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
                    'assets/status line.svg',
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'workingAvailability'.tr,
                    style: Theme.of(context).textTheme.caption.copyWith(
                          fontFamily: FontStrings.Roboto_Bold,
                          color: UIColor.baseColorTeal,
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Select the day and time you’re working. You can always change it in settings.',
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

  Widget day(var enable) {
    return Column(
      children: [
        SizedBox(
          height: 4,
        ),
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
                      onTap: () {
                        switch(enable) {
                          case 0: {
                            if(sunday){
                              sunday = false;
                              setState(() {});
                            }else{
                              sunday = true;
                              setState(() {});
                            }
                          }
                          break;

                          case 1: {
                            if(monday){
                              monday = false;
                              setState(() {});
                            }else{
                              monday = true;
                              setState(() {});
                            }
                          }
                          break;

                          case 2: {
                            if(tuesday){
                              tuesday = false;
                              setState(() {});
                            }else{
                              tuesday = true;
                              setState(() {});
                            }
                          }
                          break;

                          case 3: {
                            if(wednesday){
                              wednesday = false;
                              setState(() {});
                            }else{
                              wednesday = true;
                              setState(() {});
                            }
                          }
                          break;


                          case 4: {
                            if(thursday){
                              thursday = false;
                              setState(() {});
                            }else{
                              thursday = true;
                              setState(() {});
                            }
                          }
                          break;

                          case 5: {
                            if(friday){
                              friday = false;
                              setState(() {});
                            }else{
                              friday = true;
                              setState(() {});
                            }
                          }
                          break;

                          case 6: {
                            if(saturday){
                              saturday = false;
                              setState(() {});
                            }else{
                              saturday = true;
                              setState(() {});
                            }
                          }
                          break;

                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 13, bottom: 13),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                enable == 0
                                    ? 'Sunday'
                                    : enable == 1
                                    ? 'Monday'
                                    : enable == 2
                                    ? 'Tuesday'
                                    : enable == 3
                                    ? 'Wednesday'
                                    : enable == 4
                                    ? 'Thursday'
                                    : enable == 5
                                    ? 'Friday'
                                    : 'Saturday',
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
                            SvgPicture.asset(enable == 0
                                ? (checkBoxSunday == true
                                ? 'assets/check.svg'
                                : 'assets/uncheck.svg')
                                : enable == 1
                                ? (checkBoxMonday == true
                                ? 'assets/check.svg'
                                : 'assets/uncheck.svg')
                                : enable == 2
                                ? (checkBoxTuesday == true
                                ? 'assets/check.svg'
                                : 'assets/uncheck.svg')
                                : enable == 3
                                ? (checkBoxWednesday == true
                                ? 'assets/check.svg'
                                : 'assets/uncheck.svg')
                                : enable == 4
                                ? (checkBoxThursday == true
                                ? 'assets/check.svg'
                                : 'assets/uncheck.svg')
                                : enable == 5
                                ? (checkBoxFriday ==
                                true
                                ? 'assets/check.svg'
                                : 'assets/uncheck.svg')
                                : (checkBoxSaturday ==
                                true
                                ? 'assets/check.svg'
                                : 'assets/uncheck.svg')
                              // en == true
                              //     ? 'assets/check.svg'
                              //     : 'assets/uncheck.svg',
                              // allowDrawingOutsideViewBox: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // workTime()
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 1,
        ),
        enable == 0
            ? (sunday == true
            ? Column(
          children: [
            Column(
              children: List.generate(vendorAvailableModel.available.sunday.workingHours.length, (index) => Slidable(
                  secondaryActions: <Widget>[
                    GestureDetector(
                      onTap: (){
                        hitApiDelete('${vendorAvailableModel.available.sunday.workingHours[index].id}');
                      },
                      child: Container(
                        height: double.infinity,
                        color: Color(0xFFD43C43),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/delete.svg',
                            color: Colors.white,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                      ),
                    )
                  ],
                  closeOnScroll: true,
                  actionPane: SlidableDrawerActionPane(),
                  child: workTime('${vendorAvailableModel.available.sunday.workingHours[index].time}'))),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      print('---------------------------------------');
                      bottomSheet1('Sunday');
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 13, bottom: 13),
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
                      child: Text('Add Timing (+)',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(
                          fontFamily: FontStrings.Roboto_Medium,
                          color: UIColor.darkBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ) : Container())
            : enable == 1
            ? (monday == true
            ?  Column(
          children: [
            Column(
              children: List.generate(vendorAvailableModel.available.monday.workingHours.length, (index) => Slidable(
                  secondaryActions: <Widget>[
                    GestureDetector(
                      onTap: (){
                        hitApiDelete('${vendorAvailableModel.available.monday.workingHours[index].id}');
                      },
                      child: Container(
                        height: double.infinity,
                        color: Color(0xFFD43C43),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/delete.svg',
                            color: Colors.white,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                      ),
                    )
                  ],
                  closeOnScroll: true,
                  actionPane: SlidableDrawerActionPane(),
                  child: workTime('${vendorAvailableModel.available.monday.workingHours[index].time}'))),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      print('---------------------------------------');
                      bottomSheet1('Monday');
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 13, bottom: 13),
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
                      child: Text('Add Timing (+)',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(
                          fontFamily: FontStrings.Roboto_Medium,
                          color: UIColor.darkBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ) : Container())
            : enable == 2
            ? (tuesday == true
            ?  Column(
          children: [
            Column(
              children: List.generate(vendorAvailableModel.available.tuesday.workingHours.length, (index) => Slidable(
                  secondaryActions: <Widget>[
                    GestureDetector(
                      onTap: (){
                        hitApiDelete('${vendorAvailableModel.available.tuesday.workingHours[index].id}');
                      },
                      child: Container(
                        height: double.infinity,
                        color: Color(0xFFD43C43),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/delete.svg',
                            color: Colors.white,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                      ),
                    )
                  ],
                  closeOnScroll: true,
                  actionPane: SlidableDrawerActionPane(),
                  child: workTime('${vendorAvailableModel.available.tuesday.workingHours[index].time}'))),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      print('---------------------------------------');
                      bottomSheet1('Tuesday');
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 13, bottom: 13),
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
                      child: Text('Add Timing (+)',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(
                          fontFamily: FontStrings.Roboto_Medium,
                          color: UIColor.darkBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ) : Container())
            : enable == 3
            ? (wednesday == true
            ?  Column(
          children: [
            Column(
              children: List.generate(vendorAvailableModel.available.wednesday.workingHours.length, (index) => Slidable(
                  secondaryActions: <Widget>[
                    GestureDetector(
                      onTap: (){
                        hitApiDelete('${vendorAvailableModel.available.wednesday.workingHours[index].id}');
                      },
                      child: Container(
                        height: double.infinity,
                        color: Color(0xFFD43C43),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/delete.svg',
                            color: Colors.white,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                      ),
                    )
                  ],
                  closeOnScroll: true,
                  actionPane: SlidableDrawerActionPane(),
                  child: workTime('${vendorAvailableModel.available.wednesday.workingHours[index].time}'))),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      print('---------------------------------------');
                      bottomSheet1('Wednesday');
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 13, bottom: 13),
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
                      child: Text('Add Timing (+)',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(
                          fontFamily: FontStrings.Roboto_Medium,
                          color: UIColor.darkBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ) : Container())
            : enable == 4
            ? (thursday == true
            ?  Column(
          children: [
            Column(
              children: List.generate(vendorAvailableModel.available.thursday.workingHours.length, (index) => Slidable(
                  secondaryActions: <Widget>[
                    GestureDetector(
                      onTap: (){
                        hitApiDelete('${vendorAvailableModel.available.thursday.workingHours[index].id}');
                      },
                      child: Container(
                        height: double.infinity,
                        color: Color(0xFFD43C43),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/delete.svg',
                            color: Colors.white,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                      ),
                    )
                  ],
                  closeOnScroll: true,
                  actionPane: SlidableDrawerActionPane(),
                  child: workTime('${vendorAvailableModel.available.thursday.workingHours[index].time}'))),
            ),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      print('---------------------------------------');
                      bottomSheet1('Thursday');
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 13, bottom: 13),
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
                      child: Text('Add Timing (+)',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(
                          fontFamily: FontStrings.Roboto_Medium,
                          color: UIColor.darkBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ) : Container())
            : enable == 5
            ? (friday == true
            ?  Column(
          children: [
            Column(
              children: List.generate(vendorAvailableModel.available.friday.workingHours.length, (index) => Slidable(
                  secondaryActions: <Widget>[
                    GestureDetector(
                      onTap: (){
                        hitApiDelete('${vendorAvailableModel.available.friday.workingHours[index].id}');
                      },
                      child: Container(
                        height: double.infinity,
                        color: Color(0xFFD43C43),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/delete.svg',
                            color: Colors.white,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                      ),
                    )
                  ],
                  closeOnScroll: true,
                  actionPane: SlidableDrawerActionPane(),
                  child: workTime('${vendorAvailableModel.available.friday.workingHours[index].time}'))),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      print('---------------------------------------');
                      bottomSheet1('Friday');
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 13, bottom: 13),
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
                      child: Text('Add Timing (+)',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(
                          fontFamily: FontStrings.Roboto_Medium,
                          color: UIColor.darkBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ) : Container())
            : (saturday == true
            ?  Column(
          children: [
            Column(
              children: List.generate(vendorAvailableModel.available.saturday.workingHours.length, (index) => Slidable(
                  secondaryActions: <Widget>[
                    GestureDetector(
                      onTap: (){
                        hitApiDelete('${vendorAvailableModel.available.saturday.workingHours[index].id}');
                      },
                      child: Container(
                        height: double.infinity,
                        color: Color(0xFFD43C43),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/delete.svg',
                            color: Colors.white,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                      ),
                    )
                  ],
                  closeOnScroll: true,
                  actionPane: SlidableDrawerActionPane(),
                  child: workTime('${vendorAvailableModel.available.saturday.workingHours[index].time}'))),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      print('---------------------------------------');
                      bottomSheet1('Saturday');
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 13, bottom: 13),
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
                      child: Text('Add Timing (+)',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(
                          fontFamily: FontStrings.Roboto_Medium,
                          color: UIColor.darkBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ) : Container()),

        SizedBox(
          height: 1,
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

  // ignore: missing_return
  Widget bottomSheet1(String day) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Wrap(
                  children:[Container(
                    decoration: new BoxDecoration(
                      color: Color(0xffF4F6F9),
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0),
                      ),
                    ),
                    child:
                    Row(
                      children: [
                        Expanded(
                          child:
                          Column(
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: SvgPicture.asset(
                                        'assets/close.svg',
                                        allowDrawingOutsideViewBox: true,
                                      ),
                                    ),
                                    Text(
                                      'Add Timings',
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
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            color: Color(0xffC1282D),
                                            fontFamily:
                                                FontStrings.Roboto_Regular,
                                            fontSize: Dimens.space18 *
                                                _multi(context)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 18,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text('From:',textAlign: TextAlign.start,style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                    fontFamily:
                                    FontStrings.Fieldwork10_Regular,
                                    color: Color(0xff212156),
                                  ),),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Container(
                                  height: 100,
                                  child: CupertinoDatePicker(
                                    // minimumDate: DateTime. now(),
                                    minuteInterval: 1,
                                    mode: CupertinoDatePickerMode.time,
                                    onDateTimeChanged: (DateTime dateTime) {
                                      // print("dateTime: $dateTime");
                                      print("dateTime: ------ ${DateFormat('kk:mm').format(dateTime)}");
                                      fromTime = "${DateFormat('kk:mm').format(dateTime)}";
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text('To:',textAlign: TextAlign.start,style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                  //     .copyWith(
                                  //   fontFamily:
                                  //   FontStrings.Fieldwork10_Regular,
                                  //   color: Color(0xff212156),
                                  // ),
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Container(
                                  height: 100,
                                  child: CupertinoDatePicker(
                                    // minimumDate: DateTime. now(),
                                    minuteInterval: 1,
                                    mode: CupertinoDatePickerMode.time,
                                    onDateTimeChanged: (DateTime dateTime) {
                                      // String formattedDate = DateFormat('kk:mm').format(dateTime);
                                      print("dateTime: ------ ${DateFormat('kk:mm').format(dateTime)}");
                                      toTime = '${DateFormat('kk:mm').format(dateTime)}';
                                      // newDate = new DateTime(dateTime.hour, dateTime.minute);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                              ],
                            ),
                            //------------------------------------------------------------------Button--------------
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 24, left: 24, right: 24),
                              child: RaisedGradientButton(
                                  child: Text(
                                    'Add Time',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily:
                                            FontStrings.Fieldwork10_Regular,
                                        fontSize:
                                            Dimens.space16 * _multi(context)),
                                  ),
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xffC1282D),
                                      Color(0xffF15B29)
                                    ],
                                  ),
                                  onPressed: () {
                                    print('---------day: $day ,fromTime: $fromTime,toTime: $toTime');
                                    hitApiAdd(day, fromTime, toTime);
                                    DateTime now = DateTime.now();
                                    fromTime = DateFormat('kk:mm').format(now);
                                    toTime = DateFormat('kk:mm').format(now);
                                    print('---------day: $day ,fromTime: $fromTime,toTime: $toTime');
                                    // switch(day){
                                    //   case "Sunday":{
                                    //     print('Sunday closed');
                                    //       sunday = false;
                                    //     }
                                    //     break;
                                    //
                                    //   case "Monday":{
                                    //     print('monday closed');
                                    //     monday = false;
                                    //   }
                                    //   break;
                                    //
                                    //   case "Tuesday":{
                                    //     print('Tuesday closed');
                                    //     tuesday = false;
                                    //   }
                                    //   break;
                                    //
                                    //   case "Wednesday":{
                                    //     print('Wednesday closed');
                                    //     wednesday = false;
                                    //   }
                                    //   break;
                                    //
                                    //   case "Thursday":{
                                    //     print('Thursday closed');
                                    //     thursday = false;
                                    //   }
                                    //   break;
                                    //
                                    //   case "Friday":{
                                    //     print('Friday closed');
                                    //     friday = false;
                                    //   }
                                    //   break;
                                    //
                                    //   case "Saturday":{
                                    //     print('Saturday closed');
                                    //     saturday = false;
                                    //   }
                                    //   break;
                                    // }
                                    setState(() {});
                                    // Navigator.of(context).pop();
                                  }),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                      ],
                    ),
                    //
                  )],
                );
              });
        });
  }

  _multi(context) {
    return MediaQuery.of(context).size.height * 0.01;
  }
  hitApi(){
    isLoading = true;
    vendorAvailabilityList.fetchServices().then(
            (result) {
              isLoading = false;
          if (result["status"] == true) {
            isServicePresent = "";
            print('======${result["status"]}');
            print('======${result["message"]}');
            vendorAvailableModel = VendorAvailabilityListModel.fromJson(result).result;
            print("------${vendorAvailableModel.available}");

            if(vendorAvailableModel.availableDay.contains('Sunday')){
              checkBoxSunday = true;
            }else{
              checkBoxSunday = false;
            }
            if(vendorAvailableModel.availableDay.contains('Monday')){
              checkBoxMonday = true;
            }else{
              checkBoxMonday = false;
            }
            if(vendorAvailableModel.availableDay.contains('Tuesday')){
              checkBoxTuesday = true;
            }else{
              checkBoxTuesday = false;
            }
            if(vendorAvailableModel.availableDay.contains('Wednesday')){
              checkBoxWednesday = true;
            }else{
              checkBoxWednesday = false;
            }
            if(vendorAvailableModel.availableDay.contains('Thursday')){
              checkBoxThursday = true;
            }else{
              checkBoxThursday = false;
            }
            if(vendorAvailableModel.availableDay.contains('Friday')){
              checkBoxFriday = true;
            }else{
              checkBoxFriday = false;
            }
            if(vendorAvailableModel.availableDay.contains('Saturday')){
              checkBoxSaturday = true;
            }else{
              checkBoxSaturday = false;
            }
            
            
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
  lodingDialog(){
    Get.dialog(
      Center(
        child: ClayContainer(
          borderRadius:10,
          spread: 0,
          depth:0,
          color: Colors.white,
          child: Container(
              height:60,
              width: 60,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CircularProgressIndicator(),
              )),
        ),
      ),
      // useSafeArea:true,
      // barrierColor:Colors.white70,
    );
  }
  hitApiAdd(String day, String open, String close){
    Get.back();
    // lodingDialog();
    addVendorAvailability.fetchServices(day,open,close).then(
            (result) {
          if (result["status"] == true) {
            getSnackBar(null, "${result["message"]}");
            hitApi();
            setState(() {});
          } else {
            isServicePresent = result["message"];
            setState(() {});
            print('--------${result["message"]}');
            getSnackBar(null, '${result["message"]}');
          }
        }, onError: (error) {
      isServicePresent = error.toString();
      print('--------${isServicePresent}');
      setState(() {});
      getSnackBar(null, '$isServicePresent');

    });
  }
  hitApiDelete(String id) {
    deleteVendorAvailability.fetchServices(id).then((result) {
      if (result["status"] == true) {
        getSnackBar(null, "${result["message"]}");
        hitApi();
        setState(() {});
      } else {
        isServicePresent = result["message"];
        setState(() {});
        print('--------${result["message"]}');
        getSnackBar(null, '${result["message"]}');
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      print('--------${isServicePresent}');
      setState(() {});
      getSnackBar(null, '$isServicePresent');
    });
  }
}
