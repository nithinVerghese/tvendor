import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:takhlees_v/Constants/FontStrings.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xff212156),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
              color: Color(0xff212156),
              fontSize: 22,
              fontFamily: FontStrings.Fieldwork10_Regular),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          color: Color(0xffE5E5E5),
          child: EmptyNotification(),
        ),
      ),
    );
  }
}

class EmptyNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFDDDEDE),
                child: ClipOval(
                  child: new SizedBox(
                    child: SvgPicture.asset(
                      'assets/notification.svg',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text("You have no notifications",
            style: TextStyle(
              fontFamily: FontStrings.Roboto_Regular,
              fontSize: 18,
              color: Color(0xFF707375),
            ),)
          ],
        ),
      ),
    );
  }
}
