import 'package:flutter/material.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';

void loadingDialog(BuildContext context) {
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
                    margin: EdgeInsets.all(56),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Text('',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: FontStrings.Fieldwork10_Regular),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      );
    },
  );
}

