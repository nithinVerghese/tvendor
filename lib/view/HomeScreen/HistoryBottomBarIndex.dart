import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';

import 'ChatScreen.dart';
import 'HistoryScreen.dart';
import 'SettingsScreen.dart';
import 'OrderScreen.dart';

class HistoryBottomBarIndex extends StatefulWidget {
  @override
  _HistoryBottomBarIndexState createState() => _HistoryBottomBarIndexState();
}

class _HistoryBottomBarIndexState extends State<HistoryBottomBarIndex> {

  int _selectedItemIndex = 1;//bottom bar
  final tab = [
    OrderScreen(),
    HistoryScreen(),
    ChatScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tab[_selectedItemIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0.3,
              blurRadius: 1,
              offset: Offset(0, -1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            buildNavBarItem("assets/home.svg", "Home",0),
            buildNavBarItem("assets/orders.svg", "Orders",1),
            buildNavBarItem("assets/message.svg", "Chat",2),
            buildNavBarItem("assets/settings.svg", "Settings", 3),
          ],
        ),
      ),
    );
  }
  Widget buildNavBarItem(
      String icon,
      String title,
      int index,
      ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
        });
      },
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width / 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SvgPicture.asset(
                icon,
                color: index == _selectedItemIndex ? Color(0xffF15B29) : Color(0xff5D5F61),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                title,
                style: TextStyle(
                  fontFamily: FontStrings.Roboto_Regular,
                  color:  index == _selectedItemIndex ? Color(0xffF15B29) : Color(0xff5D5F61),
                ),
              ),
              SizedBox(
                height: 2,
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
  }

}
