import 'package:flutter/material.dart';
import 'package:get/get.dart';

void snackBar(_scaffoldKey,SnackBarBehavior behavior,String message,bool actions,String btnName, Function onPressed) {
  var snackBar;
  if(actions){
    snackBar = SnackBar(
      content: Text(message),
      behavior: behavior,
      action: SnackBarAction(
        label: btnName,
        onPressed: onPressed
      ),
    );
  }else{
    snackBar = SnackBar(
      content: Text(message),
      behavior: behavior,
    );
  }
  _scaffoldKey.currentState.showSnackBar(snackBar);
}

void getSnackBar(String title,String message){
  Get.snackbar(title,
      '$message',
      snackPosition:SnackPosition.BOTTOM,
      backgroundColor: Colors.black54,
      colorText: Colors.white);
}