import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:intl/intl.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/controller/ReportController.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:takhlees_v/widget/snackBar.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:takhlees_v/model/ReportModel.dart';


class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

_multi(context){
  return MediaQuery.of(context).size.height * 0.01;
}
final dateCon = new TextEditingController();
final endCon = new TextEditingController();
final reportApi = ReportController();

var total = 0;

var reportModel = <ReportResult>[];

bool Other =false;
class _ReportState extends State<Report> {
  bool loading = false;
  String apiMessage ='';

  @override
  void initState() {
    print(
        '------------------------------VehicleDetailsScreen------------------------');

    // TODO: implement initState

    var prev = DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day) ;
    var currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) ;

    // print('-------------dateToday : $dateToday');
    // print('-------------currentDate : $currentDate');

    hitApi('$prev','$currentDate');
    super.initState();
  }


  multi(context){
    return MediaQuery.of(context).size.height * 0.01;
  }
  FocusNode _focusNode1 = FocusNode();
  bool isHistoryOpen = true;
  var date = '';
  var date1 ;

  var Enddate = '';
  var Enddate1 = '';
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
                Navigator.pop(context);
              },
            );
          },
        ),
        // Icon(Icons.arrow_back_ios_rounded,
        //     color: Color(0xff212156),),
        backgroundColor: Colors.white,
        title:
        Text("Report ",
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
            SizedBox(height: 18,),
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
                    GestureDetector(
                      onTap:(){
                        if(isHistoryOpen){
                          isHistoryOpen = false;
                        }else{
                          isHistoryOpen = true;
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 17.5,bottom: 16.5),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom:16.5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text('REVENUE HISTORY FILTER',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                          fontFamily: FontStrings.Roboto_SemiBold,
                                          color: Color(0xff888B8D)
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_down,
                                    color: Color(0xff212156),),
                                ],
                              ),
                            ),
                            isHistoryOpen?Container(
                              child:Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0,0,0,20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        new Flexible(
                                          child: Container(
                                              padding: EdgeInsets.only(right: 8),
                                              child:
                                              GestureDetector(
                                                onTap:(){
                                                  startBottomSheet1();
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Color(0xff888B8D),
                                                        width: 1,
                                                      ),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Center(
                                                        child:
                                                        TextFormField(
                                                          enabled: false,
                                                          cursorColor: UIColor.darkBlue,
                                                          controller: dateCon,
                                                          textAlign: TextAlign.center,
                                                          style:TextStyle(
                                                              fontFamily: FontStrings.Roboto_Regular,
                                                              fontSize: Dimens.space16 *_multi(context),
                                                              color: UIColor.darkBlue
                                                          ),
                                                          decoration: InputDecoration(
                                                            hintText: 'Start Date',
                                                            labelStyle: TextStyle(
                                                                fontFamily: FontStrings.Roboto_Regular,
                                                                fontSize: Dimens.space16 *_multi(context),
                                                                color: UIColor.darkBlue
                                                            ),
                                                            border: InputBorder.none,
                                                          ),
                                                        )
                                                    )
                                                ),
                                              ),
                                          ),
                                        ),
                                        Padding(
                                          padding:EdgeInsets.all(10)
                                        ),
                                        new Flexible(
                                          child: GestureDetector(
                                            onTap:(){
                                              endBottomSheet();
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color(0xff888B8D),
                                                    width: 1,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Center(
                                                    child:
                                                    TextFormField(
                                                      enabled: false,
                                                      cursorColor: UIColor.darkBlue,
                                                      controller: endCon,
                                                      textAlign: TextAlign.center,
                                                      style:TextStyle(
                                                          fontFamily: FontStrings.Roboto_Regular,
                                                          fontSize: Dimens.space16 *_multi(context),
                                                          color: UIColor.darkBlue
                                                      ),
                                                      decoration: InputDecoration(
                                                        hintText: 'End Date',
                                                        labelStyle: TextStyle(
                                                            fontFamily: FontStrings.Roboto_Regular,
                                                            fontSize: Dimens.space16 *_multi(context),
                                                            color: UIColor.darkBlue
                                                        ),
                                                        border: InputBorder.none,
                                                      ),
                                                    )
                                                    // Text(
                                                    //   Enddate == ""?'End Date':Enddate,
                                                    //   style:TextStyle(
                                                    //       fontFamily: FontStrings.Roboto_Regular,
                                                    //       fontSize: Dimens.space16 *_multi(context),
                                                    //       color: Color(0xff888B8D)
                                                    //   ),)
                                                )),
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 11.5),
                                    child: RaisedGradientButton(
                                      onPressed: (){
                                        hitApi(dateCon.text.toString(),endCon.text.toString());
                                      },
                                      height: Dimens.space60 * _multi(context),
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Color(0xffC1282D),
                                          Color(0xffF15B29)
                                        ],
                                      ),
                                      child: Text(
                                        "Show",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: FontStrings.Fieldwork10_Regular,
                                            fontSize: Dimens.space16 * _multi(context)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ):Container()
                          ],
                        ),
                      ),
                    ),
                  ],
                )
            ),
            SizedBox(height: 12,),
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
                    Container(
                      padding: EdgeInsets.only(top: 17.5,bottom: 16.5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text('Total fees: BHD $total',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                  fontFamily: FontStrings.Fieldwork16_Bold,
                                  color: Color(0xff212156)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            SizedBox(height: 12,),
            Expanded(
              child: loading ? Center(child: CircularProgressIndicator(),):
              apiMessage == ''?ListView.builder(
                  itemCount: reportModel.length,
                  itemBuilder: (context,index){
                return Column(
                  children: [
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
                            _item('Order ID','${reportModel[index].orderId}'),
                            _item('Employee','${reportModel[index].employeeName}'),
                            _item('Service date','${reportModel[index].serviceDate}'),
                            _item('Service fees','${reportModel[index].serviceCharge}'),
                          ],
                        )
                    ),
                    SizedBox(height: 10,)
                  ],
                );
              }):
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/emptyService.svg',
                    allowDrawingOutsideViewBox: true,
                  ),
                  SizedBox(height: 20,),
                  Text(apiMessage,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontFamily: FontStrings.Roboto_Regular,
                      color: Color(0xFF707375),
                    ),
                  ),
                ],
              ),

            ),



            // Column(
            //   children:
            //   List.generate(reportModel.length  , (index) => Padding(
            //     padding: const EdgeInsets.symmetric(vertical:3.0),
            //     child: Container(
            //         padding: EdgeInsets.only(left: 24, right: 24),
            //         decoration: BoxDecoration(
            //           color: UIColor.baseColorWhite,
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.grey.withOpacity(0.2),
            //               spreadRadius: 0.3,
            //               blurRadius: 1,
            //               offset:
            //               Offset(0, 1), // changes position of shadow
            //             ),
            //           ],
            //         ),
            //         child: Column(
            //           children: [
            //             _item('Order ID','${reportModel[index].orderId}'),
            //             _item('Services','${reportModel[index].serviceNameEn}'),
            //             _item('Employee','${reportModel[index].employeeName}'),
            //             _item('Service date','${reportModel[index].serviceDate}'),
            //             _item('Service Charge','${reportModel[index].serviceCharge}'),
            //           ],
            //         )
            //     ),
            //   )),
            // )
          ]
        ),
      ),
    );
  }

  // ignore: missing_return
  Widget startBottomSheet1() {
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
                      color: Colors.white,
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
                                        child:  Text(
                                          'Cancel',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                            fontFamily:
                                            FontStrings.Roboto_Regular,
                                            color: Color(0xff888B8D),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          dateCon.text = date;
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        },
                                        child:  Text(
                                          'Done',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                            fontFamily:
                                            FontStrings.Fieldwork10_Regular,
                                            color: Color(0xff2D9CDB),
                                          ),
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
                                  Container(
                                    height: 247,
                                    child: CupertinoDatePicker(
                                      minuteInterval: 1,
                                      mode: CupertinoDatePickerMode.date,
                                      onDateTimeChanged: (DateTime dateTime) {
                                        date1 = dateTime;
                                        date = '${DateFormat('dd MMM yyyy').format(dateTime)}';
                                        dateCon.text = date;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
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
  Widget endBottomSheet() {
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
                      color: Colors.white,
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
                                        child:  Text(
                                          'Cancel',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                            fontFamily:
                                            FontStrings.Roboto_Regular,
                                            color: Color(0xff888B8D),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // Enddate= Enddate1;
                                          endCon.text = Enddate;
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        },
                                        child:  Text(
                                          'Done',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                            fontFamily:
                                            FontStrings.Fieldwork10_Regular,
                                            color: Color(0xff2D9CDB),
                                          ),
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
                                  Container(
                                    height: 247,
                                    child: CupertinoDatePicker(
                                      minimumDate: date1,
                                      minuteInterval: 1,
                                      initialDateTime: date1,
                                      mode: CupertinoDatePickerMode.date,
                                      onDateTimeChanged: (DateTime dateTime) {
                                        Enddate = '${DateFormat('dd MMM yyyy').format(dateTime)}';
                                        endCon.text = Enddate;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
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
  Widget _item(String itemName,String item){
    return  Container(
      padding: EdgeInsets.only(top: 13,bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: Text(itemName,
                style: TextStyle(
                    fontFamily: FontStrings.Roboto_Regular,
                    color: Color(0xFF4D4F51)
                ),
              ),
            ),
          ),
          Container(
            child: Text(item,
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

  hitApi(String startDate, String endDate){
    loading = true;
    reportApi.fetchServices(startDate,endDate).then((result) {
      if (result["status"] == true) {
        loading = false;
        apiMessage = '';
        print('....................hitAcceptOrderAPI................${result["message"]}................');
        reportModel = ReportModel.fromJson(result).result;
        total = result["total"];
        setState(() {});
      } else {
        loading = false;
        apiMessage = result["message"];
        reportModel.clear();
        print('....................hitAcceptOrderAPI................${result["message"]}................');
        getSnackBar(null,result["message"] );
        setState(() {});
      }
    }, onError: (error) {
      loading = false;
      apiMessage = error.toString();
      print('---------hitAcceptOrderAPI--------------\n${error.toString()}');
      getSnackBar(null,error.toString());
      setState(() {});
    });
  }

}


