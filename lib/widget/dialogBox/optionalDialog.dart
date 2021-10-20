import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';

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
                            CircularProgressIndicator(color: UIColor.baseGradientLight),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                "   Fetching Information..",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily:
                                        FontStrings.Fieldwork10_Regular),
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

void optionalDialog1(BuildContext context, var title, var body,
    Function onYesPressed, Function onNoPressed) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.all(50),
                child: Container(
                    padding:
                        EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 0),
                    decoration: BoxDecoration(
                      color: Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Text(
                            '$title',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Text(
                            '$body',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
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
                                          color: Colors.black12,
                                          style: BorderStyle.solid,
                                          width: 0.5),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10)),
                                    ),
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                          color: Color(0xFF007AFF),
                                          fontSize: 20),
                                    ),
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 20),
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
                                          color: Colors.black12,
                                          style: BorderStyle.solid,
                                          width: 0.5),
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(
                                        color: Color(0xFF007AFF),
                                        fontSize: 20,
                                        // fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 20),
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
      );
    },
  );
}

void optionalDialog(
    var title, var body, Function onYesPressed, Function onNoPressed) {
  Get.dialog(Dialog(
    elevation: 20,
    backgroundColor: Colors.transparent,
    child: Container(
        padding: EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 0),
        decoration: BoxDecoration(
          color: Color(0xFFEFEFEF),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: Text(
                '$title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: Text(
                '$body',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
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
                              color: Colors.black12,
                              style: BorderStyle.solid,
                              width: 0.5),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10)),
                        ),
                        child: Text(
                          "No",
                          style:
                              TextStyle(color: Color(0xFF007AFF), fontSize: 20),
                        ),
                        padding: EdgeInsets.only(top: 20, bottom: 20),
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
                              color: Colors.black12,
                              style: BorderStyle.solid,
                              width: 0.5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: Color(0xFF007AFF),
                            fontSize: 20,
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )),
  ));
}

void showLoading(String message) {
  Get.dialog(

    Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          message.isEmpty ? Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFEFEFEF),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: CircularProgressIndicator(color: UIColor.baseGradientLight)) : Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFEFEFEF),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
                child: Column(
            children: [
                CircularProgressIndicator(color: UIColor.baseGradientLight,),
                message.isNotEmpty ? SizedBox(height: 8):Container(),
                message.isNotEmpty ? Text(message ?? 'Loading...'):Container(),
            ],
          ),
              ),
        ],
      ),
    ),
    barrierDismissible:false,
  );
}
void hideLoading() {
  if (Get.isDialogOpen) Get.back();
}

void okDialog(BuildContext context, var title, var body, Function onNoPressed) {
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
                      padding: EdgeInsets.only(
                          left: 0, right: 0, top: 20, bottom: 0),
                      decoration: BoxDecoration(
                        color: Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: Text(
                              '$title',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: Text(
                              '$body',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
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
                                            color: Colors.black12,
                                            style: BorderStyle.solid,
                                            width: 0.5),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10)),
                                      ),
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Color(0xFF007AFF),
                                            fontSize: 20),
                                      ),
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 20),
                                    ),
                                  ),
                                ),
                                // Expanded(
                                //   child: GestureDetector(
                                //     onTap: onYesPressed,
                                //     child: Container(
                                //       alignment: Alignment.center,
                                //       decoration: BoxDecoration(
                                //         border: Border.all(
                                //             color: Colors.black12, style: BorderStyle.solid, width: 0.5),
                                //         borderRadius: BorderRadius.only(
                                //           bottomRight: Radius.circular(10),
                                //         ),
                                //       ),
                                //       child: Text(
                                //         "Yes",
                                //         style: TextStyle(
                                //             color: Color(0xFF007AFF),
                                //             fontSize:20,
                                //             fontWeight: FontWeight.bold
                                //         ),
                                //       ),
                                //       padding: EdgeInsets.only(top:20,bottom: 20),
                                //     ),
                                //   ),
                                // ),
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
