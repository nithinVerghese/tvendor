import 'package:cached_network_image/cached_network_image.dart';
// import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
// import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DatasViewer extends StatefulWidget {
  final url;
  DatasViewer({Key key, this.url}) : super(key: key);

  @override
  _DatasViewerState createState() => _DatasViewerState();
}

class _DatasViewerState extends State<DatasViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        brightness: Brightness.light,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Color(0xff212156),
              ),
              onPressed: () {
                Navigator.pop(context, 'true');
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.cloud_download,color: Color(0xff212156),),
            onPressed: () async {
              await launch('${widget.url}');

            },
          ),
        ],
        // Icon(Icons.arrow_back_ios_rounded,
        //     color: Color(0xff212156),),
        backgroundColor: Colors.white,
        // title: Row(
        //   children: [
        //     GestureDetector(
        //       onTap: () async {
        //
        //       },
        //       child: Text(
        //         'Back',
        //         style: Theme.of(context).textTheme.headline6.copyWith(
        //           fontFamily: FontStrings.Fieldwork16_Bold,
        //           color: Color(0xff212156),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Container(
            // height: MediaQuery.of(context).size.height,
            child: InteractiveViewer(
              panEnabled: true, // Set it to false
              // boundaryMargin: EdgeInsets.all(100),
              minScale: 0.200,
              maxScale: 10,
              child: CachedNetworkImage(
                imageUrl: widget.url,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(
                      // backgroundColor: UIColor.baseGradientLight,
                      value: downloadProgress.progress,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          UIColor.baseGradientLight),
                    ),
                // CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
        ),
      )

      // _web()

    );
  }



  _web(){
    return Column(
      children: <Widget>[
        Expanded(
          child:
    // final imageProvider = Image.network("https://picsum.photos/id/1001/5616/3744").image;
    // showImageViewer(context, Image.network('${widget.url}'), onViewerDismissed: () {
    //   print("dismissed");
    // })
    //       PinchZoom(
    //         child: Image.network('${widget.url}'),
    //         resetDuration: const Duration(milliseconds: 100000000),
    //         // maxScale: 2.5,
    //         onZoomStart: (){print('Start zooming');},
    //         onZoomEnd: (){print('Stop zooming');},
    //       ),

          WebView(
            initialUrl: '${widget.url}',
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: <JavascriptChannel>{
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (JavascriptMessage msg) async {
                    print('222222v ${msg.message}');

                    // if(msg.message == 'success'){
                    //   // Navigator.pushReplacement(context,
                    //   //     MaterialPageRoute(
                    //   //         builder: (context) {
                    //   //           return OrderBottomBarIndex();
                    //   //         }));
                    //   Get.offAll(OrderBottomBarIndex());
                    // }else{
                    //   Get.back();
                    //   getSnackBar(null, 'Payment failed');
                    // }
                    // status = msg.message;
                    // await stripeNow(msg.message);
                    // PsProgressDialog.dismissDialog();
                  }),
            },
            onWebViewCreated: (WebViewController webcontroller){

            },
            onPageStarted: (url){
              setState(() {
                print('$url');
              });
            },
            onPageFinished: (url){
              setState(() {
                print('$url');
              });
            },
          ),
        ),
      ],
    );
  }
}