import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/Server/Database.dart';
import 'package:takhlees_v/view/Chat/chat_conversation.dart';
import 'package:transparent_image/transparent_image.dart';

import 'SettingsScreen.dart';
import 'OrderScreen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  var vendorCountClear = 0;
  var vendorCountPick = 0;
  int _tabIndicator = 0;
  final mobileNumberCon = new TextEditingController();
  TabController _tabController;
  int _selectedItemIndex = 0; //bottom bar
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

  Stream chatRooms;


  getUserInfogetChats() async {
    // Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DataBaseMethod().getUserChats('Awal Express WLL').then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  'Nithin'");
      });
    });
  }


  _multi(context) {
    return MediaQuery.of(context).size.height * 0.01;
  }

  @override
  void initState() {
    getUserInfogetChats();
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
              child: _appBar(),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    color: Color(0xffF4F6F9)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          customerCare(),
                          customer()

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
      radius: 20,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: new SizedBox(
          child: Image.asset("assets/takhlees_logo_transparent_icon.png"),
        ),
      ),
    );
  }


  Widget chatContainer(URL,time,name,subTitle) {
    return Card(
      child: ListTile(
        leading: _profilePic(URL,context),
        title: Text(URL != null ?'$name':'$name',style: Get.textTheme.bodyText1
                        .copyWith(fontFamily: FontStrings.Fieldwork16_Bold,color: Color(0xFF212156))),
         subtitle: URL != null ? Text('$subTitle',style: Get.textTheme.bodyText1
            .copyWith(fontFamily: FontStrings.Fieldwork10_Regular),):null,
        trailing: Text('$time',style: Get.textTheme.bodyText1
            .copyWith(fontFamily: FontStrings.Roboto_Regular))
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
                  padding: EdgeInsets.all(5),
                  child: Text(
                    '   Chat',
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
                padding: EdgeInsets.only(
                    top: Dimens.space10 * _multi(context),
                    bottom: Dimens.space10 * _multi(context),
                    left: Dimens.space10 * _multi(context),
                    right: Dimens.space20 * _multi(context)),
                child: GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/CustomerSupport.svg',
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
                // Icon(Icons.notifications, size: 24,color: Colors.white,),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget emptyChat() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/emptyChat.svg',
            allowDrawingOutsideViewBox: true,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'No chats available',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontFamily: FontStrings.Roboto_Regular,
                  color: Color(0xFF707375),
                ),
          ),
        ],
      ),
    );
  }

  Widget customer() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 14),
          child:
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      'CUSTOMERS',
                      style: Get.textTheme.bodyText1
                          .copyWith(fontFamily: FontStrings.Roboto_Medium,
                      color: Color(0xff888B8D)),
                    ),
                  ),
                  StreamBuilder(
                    stream: chatRooms,
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            print('----- ${snapshot.data.documents[index].data()['ChatRoomID']}');
                            return GestureDetector(
                              onTap: (){
                                print('====> ${snapshot.data.documents[index].data()['CUSTOMER_IMAGE_URL']}');
                                Get.to(ChatConversation('${snapshot.data.documents[index].data()['ChatRoomID']}', '${snapshot.data.documents[index].data()['CUSTOMER_IMAGE_URL']}','${snapshot.data.documents[index].data()['Users'][1].toString()}'));
                              },
                              child: chatContainer('${snapshot.data.documents[index].data()['CUSTOMER_IMAGE_URL']}',

                                  timeStampToDate('${snapshot.data.documents[index].data()['Time']}'),
                                  '${snapshot.data.documents[index].data()['ChatRoomID']
                                      .toString()
                                      .replaceAll("_", "")
                                      .replaceAll('Nithin', "")}',
                                  '${snapshot.data.documents[index].data()['Users'][1].toString()}'
                              ),
                            );
                          })
                          : Container();
                    },
                  )
                ],
              ),
          ),
    );
  }

  timeStampToDate(millis){
    var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(millis));
    var d12 = DateFormat('dd/MM/yyyy, hh:mm a').format(dt); // 12/31/2000, 10:00 PM
    return d12;
  }
  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print('----- ${snapshot.data.documents[index].data()['ChatRoomID']}');
              return chatContainer('${snapshot.data.documents[index].data()['IMAGE_URL']}',timeStampToDate('${snapshot.data.documents[index].data()['Time']}'),
              '${snapshot.data.documents[index].data()['ChatRoomID']
                  .toString()
                  .replaceAll("_", "")
                  .replaceAll('Nithin', "")}','${snapshot.data.documents[index].data()['Vendor']
                      .toString()}'
              );
            })
            : Container();
      },
    );
  }


  Widget customerCare() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 14),
          child:
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      'CUSTOMER CARE',
                      style: Get.textTheme.bodyText1
                          .copyWith(fontFamily: FontStrings.Roboto_Medium,
                      color: Color(0xff888B8D)),
                    ),
                  ),
                  chatContainer(null,'','Customer Care',''),
                ],
              ),
          ),
    );
  }
}
