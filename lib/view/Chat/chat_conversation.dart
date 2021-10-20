import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takhlees_v/Constants/ApiStrings.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/Server/Database.dart';
import 'package:takhlees_v/view/Chat/datas_viewer.dart';
import 'package:takhlees_v/widget/snackBar.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:path/path.dart' as pathProvider;

class ChatConversation extends StatefulWidget {
  final String chatID,imageURL,name;
  const ChatConversation(this.chatID,this.imageURL, this.name);
  @override
  _ChatConversationState createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {

  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  String messageType = 'text';
  String profilePic ='https://miro.medium.com/max/882/1*9EBHIOzhE1XfMYoKz1JcsQ.gif';

  @override
  void initState() {
    DataBaseMethod().getChats(widget.chatID).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }
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
        // Icon(Icons.arrow_back_ios_rounded,
        //     color: Color(0xff212156),),
        backgroundColor: Colors.white,
        // actions: [
        //   Text(
        //     '#${widget.chatID}',
        //     style: Theme.of(context).textTheme.bodyText1.copyWith(
        //       fontFamily: FontStrings.Fieldwork16_Bold,
        //       color: Color(0xff212156),
        //     ),
        //   ),
        // ],
        title: Row(
          children: [
            _profilePic('${widget.imageURL}', context),
            SizedBox(width: 15,),
            Expanded(
              child: Text(
                '${widget.name}',
                style: Theme.of(context).textTheme.headline6.copyWith(
                  fontFamily: FontStrings.Fieldwork16_Bold,
                  color: Color(0xff212156),
                ),
              ),
            ),
            Text(
              '#${widget.chatID}',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontFamily: FontStrings.Fieldwork16_Bold,
                color: Color(0xff212156),
              ),
            )
          ],
        ),
      ),
        body: Container(
          color: Color(0xFFE5E5E5),
          child: Column(
            children: [
              Expanded(child: chatMessages()),
              _buildTextComposer(),
              SizedBox(height: 5,)
            ],
          ),
        ));
  }

  sendMessage(){
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": 'Nithin',
        "message": messageEditingController.text,
        "message_type": messageType,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      DataBaseMethod().addConversationMessage(widget.chatID, chatMessageMap);
      DataBaseMethod().updateLastMessageTime(widget.chatID,DateTime
          .now()
          .millisecondsSinceEpoch,messageEditingController.text);

      print(DateTime.now());

      setState(() {
        messageEditingController.text = "";
      });
    }

    // dataBaseMethod.getConversationMessage(widget.chatRoomID, chatMessageMap);
  }
  sendFile(URL,type){
    print('$URL');
    if (URL.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": 'Nithin',
        "message": URL,
        "message_type": type,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      DataBaseMethod().addConversationMessage(widget.chatID, chatMessageMap);
      DataBaseMethod().updateLastMessageTime(widget.chatID,DateTime
          .now()
          .millisecondsSinceEpoch,
          type);

      setState(() {
        messageEditingController.text = "";
      });
      if(Get.isBottomSheetOpen){
        Get.back();
      }
    }

    // dataBaseMethod.getConversationMessage(widget.chatRoomID, chatMessageMap);
  }

  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        // print(snapshot.data.documents.length);
        // List<DocumentSnapshot> items = snapshot.data.docs;
        return
          snapshot.hasData ?  ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            reverse: true,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data.documents[index].data()["message"],
                sendByMe: 'Nithin' == snapshot.data.documents[index].data()["sendBy"],
                time: snapshot.data.documents[index].data()["time"],
                messageType: snapshot.data.documents[index].data()["message_type"],
              );
            }) : Container();
      },
    );
  }

  _loadPicker(ImageSource source , String type)async{
    File pic = await ImagePicker.pickImage(
        source: source, maxHeight: 800, maxWidth: 600);
    if(pic != null){
      _cropper(pic,type);
    }
  }

  _cropper(File image , String type)async{
    File crop = await ImageCropper.cropImage(sourcePath: image.path);
    if(crop != null){
      print('${crop.path}');
      hitFileStoreAPI(crop);
    }
  }
  Dio.Dio dio = new Dio.Dio();

  hitFileStoreAPI(File cprFront) async {
    final prefs = await SharedPreferences.getInstance();
    final DeviceID = prefs.getString("DeviceID");
    var auth = prefs.getString("token");
    String cprFrontPath ;
    try{
      if(cprFront != null){
        cprFrontPath = pathProvider.basename(cprFront.path);
        Dio.FormData formData = new Dio.FormData.fromMap({
          "file":
          await Dio.MultipartFile.fromFile(cprFront.path, filename: cprFrontPath),
        });
        Dio.Response response =
        await dio.post(ApiStrings.BaseURL + ApiStrings.chatUpload,
            data: formData,
            options: Dio.Options(headers: {
              "Accept": "application/json",
              "Authorization": "Bearer " + auth,
            }));
        if(response.data['status'] == true){
          sendFile(response.data['url'],'IMAGE');
        }else if(response.data['status'] == 'true'){

        }else{
          getSnackBar(null,response.data['message']);
        }
      }
    }catch(e){

    }
  }

  Widget _buildTextComposer() {
    return Container(
      margin:EdgeInsets.all(7),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            offset: Offset(0.0, 1.5),
            blurRadius: 1.5,
          ),
        ],
      ),

      child: new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 2.0),
                child: new IconButton(
                    icon: new Icon(Icons.photo,color: Colors.cyan[900],),
                    onPressed: () {
                      Get.bottomSheet(Container(
                        child: Container(
                          child: Wrap(
                            children: [
                              GestureDetector(
                                onTap:(){
                                  // _openCamera1(context);
                                  _loadPicker(ImageSource.camera,'cprReader');
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left:8.0,right: 8,bottom: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius
                                              .circular(10),
                                          topRight: Radius
                                              .circular(10),
                                          bottomLeft: Radius
                                              .circular(10),
                                          bottomRight:
                                          Radius
                                              .circular(
                                              10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(
                                              0.2),
                                          spreadRadius: 0.3,
                                          blurRadius: 1,
                                          offset: Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        Icon(Icons.camera_alt,color:Colors.black54),
                                        Expanded(child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Camera',style: Theme.of(context).textTheme.bodyText2.copyWith(
                                              fontFamily: FontStrings.Fieldwork10_Regular,
                                              color:Colors.black54
                                          ),),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  // openGallary1(context);
                                  _loadPicker(ImageSource.gallery,'cprReader');
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left:8.0,right: 8,),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius
                                              .circular(10),
                                          topRight: Radius
                                              .circular(10),
                                          bottomLeft: Radius
                                              .circular(10),
                                          bottomRight:
                                          Radius
                                              .circular(
                                              10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(
                                              0.2),
                                          spreadRadius: 0.3,
                                          blurRadius: 1,
                                          offset: Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        Icon(Icons.collections,color:Colors.black54),
                                        Expanded(child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Gallery',style: Theme.of(context).textTheme.bodyText2.copyWith(
                                              fontFamily: FontStrings.Fieldwork10_Regular,
                                              color:Colors.black54
                                          ),),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              GestureDetector(
                                onTap: ()=>Get.back(),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius
                                              .circular(10),
                                          topRight: Radius
                                              .circular(10),
                                          bottomLeft: Radius
                                              .circular(10),
                                          bottomRight:
                                          Radius
                                              .circular(
                                              10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(
                                              0.2),
                                          spreadRadius: 0.3,
                                          blurRadius: 1,
                                          offset: Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          // padding: const EdgeInsets.all(0),
                                          child: Center(
                                            child: Text('Cancel',textAlign: TextAlign.center ,style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                fontFamily: FontStrings.Fieldwork10_Regular,
                                                color: Colors.red
                                            ),),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 25,
                              ),
                            ],
                          ),
                        ),
                      ));
                    }),
              ),
              new Flexible(
                child: new TextField(
                  controller: messageEditingController,
                  // onSubmitted: _handleSubmitted,
                  decoration: new InputDecoration.collapsed(
                      hintText: "Send a message"),
                ),
              ),

              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 2.0),
                child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: () {
                      setState(() { messageType = 'text'; });
                      sendMessage();
                      // _handleSubmitted(_msgTextController.text);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _multi(context) {
    return MediaQuery.of(context).size.height * 0.01;
  }

  // Widget _profilePic(String URL, context) {
  //   return URL != null
  //       ? CircleAvatar(
  //     radius: 20,
  //     backgroundColor: Colors.transparent,
  //     child: ClipOval(
  //       child: new SizedBox(
  //           child: Stack(
  //             children: <Widget>[
  //               // Center(
  //               //     child: CircularProgressIndicator(
  //               //   // backgroundColor: UIColor.baseGradientLight,
  //               //   valueColor: AlwaysStoppedAnimation<Color>(
  //               //       UIColor.baseGradientLight),
  //               // )),
  //               Center(
  //                 child:
  //                 CachedNetworkImage(
  //                   imageUrl: URL,
  //                   fit: BoxFit.cover,
  //                   height: Dimens.space120 * _multi(context),
  //                   width: Dimens.space120 * _multi(context),
  //                   progressIndicatorBuilder: (context, url, downloadProgress) =>
  //                       CircularProgressIndicator(
  //                         // backgroundColor: UIColor.baseGradientLight,
  //                         value: downloadProgress.progress,
  //                         valueColor: AlwaysStoppedAnimation<Color>(
  //                             UIColor.baseGradientLight),
  //                       ),
  //                   // CircularProgressIndicator(value: downloadProgress.progress),
  //                   errorWidget: (context, url, error) => Icon(Icons.error),
  //                 ),
  //                 // FadeInImage.memoryNetwork(
  //                 //   placeholder: kTransparentImage,
  //                 //   image: URL,
  //                 //   fit: BoxFit.cover,
  //                 //   height: Dimens.space120 * _multi(context),
  //                 //   width: Dimens.space120 * _multi(context),
  //                 // ),
  //               ),
  //             ],
  //           )
  //
  //         // Image.network(URL,
  //         //   fit: BoxFit.cover,
  //         //   height: Dimens.space140 * _multi(context),
  //         //   width: Dimens.space140 * _multi(context),
  //         // ),
  //       ),
  //     ),
  //   )
  //       : CircleAvatar(
  //     radius: 20,
  //     backgroundColor: Colors.transparent,
  //     child: ClipOval(
  //       child: new SizedBox(
  //         child: Image.asset("assets/takhlees_logo_transparent_icon.png"),
  //       ),
  //     ),
  //   );
  // }
  Widget _profilePic(String URL, context) {
    // print('---------> Image URL - ${URL.length}');
    // URL = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDeo2EJiwjckFFs9X4bnPnttb0dvmkuWvu4A&usqp=CAU';
    if(URL == null|| URL.isEmpty||URL.isBlank||URL== ''||URL == 'null'){
      URL = 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png';
    }else{
      // print('@@@@@ - $URL');
    }
    return URL != null
        ? CircleAvatar(
      radius: 20,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: new SizedBox(
            child: Stack(
              children: <Widget>[
                // Center(
                //     child: CircularProgressIndicator(
                //   // backgroundColor: UIColor.baseGradientLight,
                //   valueColor: AlwaysStoppedAnimation<Color>(
                //       UIColor.baseGradientLight),
                // )),
                Center(
                  child:
                  CachedNetworkImage(
                    imageUrl: URL,
                    fit: BoxFit.cover,
                    height: Dimens.space120 * _multi(context),
                    width: Dimens.space120 * _multi(context),
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
                  // FadeInImage.memoryNetwork(
                  //   placeholder: kTransparentImage,
                  //   image: URL,
                  //   fit: BoxFit.cover,
                  //   height: Dimens.space120 * _multi(context),
                  //   width: Dimens.space120 * _multi(context),
                  // ),
                ),
              ],
            )

          // Image.network(URL,
          //   fit: BoxFit.cover,
          //   height: Dimens.space140 * _multi(context),
          //   width: Dimens.space140 * _multi(context),
          // ),
        ),
      ),
    )
        : CircleAvatar(
      radius: 60,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: new SizedBox(
          child: Image.asset("assets/emptyPhoto.svg"),
        ),
      ),
    );
  }

}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final int time;
  final String messageType;
  String profilePic ='https://miro.medium.com/max/882/1*9EBHIOzhE1XfMYoKz1JcsQ.gif';

  MessageTile({@required this.message, @required this.sendByMe, this.time,this.messageType});



  @override
  Widget build(BuildContext context) {
    var dt = DateTime.fromMillisecondsSinceEpoch(time);
    var d12 = DateFormat('dd/MM, hh:mm a').format(dt);
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: sendByMe
              ? EdgeInsets.only(left: 30)
              : EdgeInsets.only(right: 30),
          padding: messageType == 'IMAGE'? EdgeInsets.only(
              top: 5, bottom: 10, left: 5, right: 5):EdgeInsets.only(
              top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 1),
                blurRadius: 1,
              ),
            ],
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
                colors: sendByMe ? [
                const Color(0xffD8EEF0),
                const Color(0xffD8EEF0)
                ]
                : [
                const Color(0xffFFFFFF),
            const Color(0xffFFFFFF)
            ],
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: sendByMe ?CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          messageType == 'IMAGE'?
          GestureDetector(
            onTap: (){
              print('-----> $message');
              Get.to(DatasViewer(url: message,));
            },
            child: Container(

              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.width / 2.5,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: CachedNetworkImage(
                    imageUrl: message,
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
                  // Image.network(message,
                  //   fit: BoxFit.cover,
                  // )
              ),
            ),
          ):
          Text(message,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Color(0xFF404243),
                  fontSize: 16,
                  fontFamily: FontStrings.Roboto_Regular,)),
          SizedBox(height: 10,),
          Text('$d12',
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: Color(0xFF5D5F61),
                  fontSize: 14,
                  fontFamily: FontStrings.Roboto_Regular,
                  fontWeight: FontWeight.w300)),
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

}