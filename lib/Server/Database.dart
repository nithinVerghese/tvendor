import 'package:cloud_firestore/cloud_firestore.dart';


class DataBaseMethod{


  getUserChats(String itIsMyName) async {

    return await FirebaseFirestore.instance
        .collection("ChatBox")
        // .orderBy('Time')
        .where('Users', arrayContains: itIsMyName)
        // .orderBy('Time')
        .orderBy('Time',descending: true)
        .snapshots();
  }

  getCustomerCareChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("CustomerCare")
        .where('Users', arrayContains: itIsMyName)
        .snapshots();
  }

  isChatCreated(chatRoomId)async{
    return FirebaseFirestore.instance
        .collection("ChatBox")
        .doc('chatRoomId')
        .get().then((value) =>
        print(value['ChatRoomID']))
        .catchError((e){
      print(e.toString());
    });
  }



  userChatsUpdate(String itIsMyName,chatRoomId)  {
    FirebaseFirestore.instance
        .collection("ChatBox")
        .doc(chatRoomId)
        .update({'Vendor':'test'})
        .catchError((e){
          print(e.toString());
        });
  }



  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("ChatBox")
        .doc(chatRoomId)
        .collection("Chat")
        .orderBy('time',descending: true)
        .snapshots();
  }

  addConversationMessage(String chatRoomId, chatMessageData) {
    FirebaseFirestore.instance
        .collection("ChatBox")
        .doc(chatRoomId)
        .collection("Chat")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  updateLastMessageTime(chatID,time,message){
    FirebaseFirestore.instance
        .collection("ChatBox")
        .doc(chatID)
    .update({
      'Time':time,
      'LastMessage':'$message',
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatBox')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print('createChatRoom --> $e');
    });
  }
}