import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/controller/Profile/EmployeeDeleteController.dart';
import 'package:takhlees_v/controller/Profile/EmployeeListController.dart';
import 'package:takhlees_v/model/EmployeeListModel.dart';
import 'package:takhlees_v/view/Settings/Employees/EditEmployeeProfile.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'package:takhlees_v/widget/snackBar.dart';
import 'package:transparent_image/transparent_image.dart';

import 'AddEmployeeProfile.dart';

// ignore: must_be_immutable
class EmployeesScreen extends StatefulWidget {

  // final String name;
  // final String emailID;
  // final String phone;
  // final int cpr;

  // PrivateInformationScreen(this.name,this.emailID,this.phone,this.cpr);

  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {

  @override
  void initState() {
    print('------------------------------EmployeesScreen------------------------');
    hitProfileUpdate();
    // TODO: implement initState
    super.initState();
  }


  String isServicePresent = "";
  String otpStatus  = "";

  final nameCon = new TextEditingController();
  final buildingCon = new TextEditingController();
  final flatCon = new TextEditingController();
  final blockCon = new TextEditingController();
  final roadCon = new TextEditingController();
  final codeCon = new TextEditingController();

  final employeeListController = EmployeeListController();
  final employeeDeleteController = EmployeeDeleteController();
  var employeeListModel = EmployeeListModel();
  var employeeListReModel = List<EmployeeListResult>();
  bool isLoading = false;
  SlidableController slidableController = SlidableController();

  _multi(context){
    return MediaQuery.of(context).size.height * 0.01;
  }

  BitmapDescriptor myIcon;

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
        title: Text("Employees",
        style: Theme.of(context).textTheme.headline6.copyWith(
            fontFamily: FontStrings.Fieldwork10_Regular,
            fontWeight: FontWeight.normal,
            color: Color(0xff212156)
        ),),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return AddEmployeeProfile();
              }));
              if(result){
                hitProfileUpdate();
              }
            },
            child: Container(
              padding: const EdgeInsets.only(left:8.0,right: 24),
              child: Center(
                child: Text('Add new',style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontFamily: FontStrings.Roboto_Bold,
                    color: Color(0xffF15B29)
                ),),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading?Center(
          child: CircularProgressIndicator(),
        ):Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              child: Text('${employeeListReModel.length} EMPLOYEES',style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontFamily: FontStrings.Roboto_Bold,
                  color: Color(0xff888B8D)
              ),),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: employeeListReModel.length,
                  itemBuilder: (context,index){
                    return Slidable(
                      controller: slidableController,
                      actionPane: SlidableDrawerActionPane(),
                      closeOnScroll: true,
                      secondaryActions: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            slidableController.activeState.dismiss();
                            // hitDeleteCart(serviceModel[index].serviceId.toString());
                            final result = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return EditEmployeeProfile(userId: '${employeeListReModel[index].userId}',);
                                }));
                            if(result){
                              hitProfileUpdate();
                            }
                          },
                          child: Container(
                            height: double.infinity,
                            color: Colors.teal,
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/edit.svg',
                                color: Colors.white,
                                allowDrawingOutsideViewBox: true,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            slidableController.activeState.dispose();
                            print('${employeeListReModel[index].userId}');
                            hitDelete('${employeeListReModel[index].userId}');
                            // hitDelete(serviceModel[index].serviceId.toString());
                          },
                          child: Container(
                            height: double.infinity,
                            color: Color(0xFFD43C43),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/delete.svg',
                                color: Colors.white,
                                allowDrawingOutsideViewBox: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.only(top: 1,bottom: 1),
                        child:
                        Container(
                          decoration: BoxDecoration(
                            color: UIColor.baseColorWhite,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 0.3,
                                blurRadius: 1,
                                offset: Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(left: 24,top: 12,bottom: 12),
                            child: Row(
                              children: [
                                _profilePic(
                                    "${employeeListReModel[index].profilePhotoPath == null? employeeListReModel[index].profilePhotoUrl:employeeListReModel[index].profilePhotoPath}",
                                    context),
                                Container(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${employeeListReModel[index].name}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                              fontFamily: FontStrings.Roboto_Bold,
                                            ),
                                      ),
                                      SizedBox(height: 4,),
                                      Text(
                                        '${employeeListReModel[index].cpr}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                              fontFamily:
                                                  FontStrings.Roboto_Regular,
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        // Card(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: ListTile(
                        //       leading: _profilePic('https://cdn.logo.com/hotlink-ok/logo-social.png',context),
                        //       title: Text('David Yang',style: Theme.of(context).textTheme.bodyText2.copyWith(
                        //         fontFamily: FontStrings.Roboto_Bold,
                        //       ),),
                        //       subtitle: Text(
                        //           'CPR 834504025',style: Theme.of(context).textTheme.bodyText2.copyWith(
                        //         fontFamily: FontStrings.Roboto_Regular,
                        //       ),
                        //       ),
                        //       // trailing: Icon(Icons.more_vert),
                        //       // isThreeLine: true,
                        //     ),
                        //   ),
                        // ),
                      ),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profilePic(String URL,context){
    return URL != null?
    CircleAvatar(
      radius: 30,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: new SizedBox(
          child: Stack(
            children: <Widget>[
              Center(child: CircularProgressIndicator(
                // backgroundColor: UIColor.baseGradientLight,
                valueColor:AlwaysStoppedAnimation<Color>(UIColor.baseGradientLight),
              )),
              Center(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: URL,
                  fit: BoxFit.cover,
                  height: Dimens.space140 * _multi(context),
                  width: Dimens.space140 * _multi(context),
                ),
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
    ):CircleAvatar(
      radius: 60,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: new SizedBox(
          child: Image.asset("assets/emptyPhoto.svg"),
        ),
      ),
    );
  }

  void hitProfileUpdate(){
    isLoading = true;
    employeeListController.fetchServices().then(
        (result) {
          isLoading = false;
      if (result["status"] == true) {
        isServicePresent = "";
        print('======${result["status"]}');
        print('======${result["message"]}');
        employeeListReModel = EmployeeListModel.fromJson(result).result;
        print('--------${employeeListReModel.length}');
        setState(() {});
      } else {
        isServicePresent = result["message"];
        setState(() {});
        print('--------${result["message"]}');
        getSnackBar(null, '$isServicePresent');
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      print('--------${isServicePresent}');
      setState(() {});
      getSnackBar(null, '$isServicePresent');
    }
    );
  }
  void hitDelete(String userID){
    isLoading = true;
    employeeDeleteController.fetchServices(userID).then(
        (result) {
          isLoading = false;
      if (result["status"] == true) {
        isServicePresent = "";
        print('======${result["status"]}');
        print('======${result["message"]}');
        hitProfileUpdate();
        Get.off(EmployeesScreen());
        setState(() {});
      } else {
        isServicePresent = result["message"];
        setState(() {});
        print('--------${result["message"]}');
      }
    }, onError: (error) {
      isServicePresent = error.toString();
      print('--------${isServicePresent}');
      setState(() {});
    }
    );
  }

}



