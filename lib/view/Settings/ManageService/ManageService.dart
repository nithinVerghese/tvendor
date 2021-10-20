import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:takhlees_v/Constants/Dimens.dart';
import 'package:takhlees_v/Constants/FontStrings.dart';
import 'package:takhlees_v/Constants/UI_Color.dart';
import 'package:takhlees_v/widget/RaisedGradientButton.dart';
import 'ManageBahrainTabBar.dart';
import 'ManageExpatTabBar.dart';
import 'ManageGccTabBar.dart';

class ManageService extends StatefulWidget {
  @override
  _ManageServiceState createState() => _ManageServiceState();
}

class _ManageServiceState extends State<ManageService>
    with TickerProviderStateMixin {



  TabController tabController;
  List expandArray = [];
  // TabController _tabController;
  TabController _tabController;
  @override
  void initState() {
    print('------VendorService-------------');
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }
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
        title: Text("Manage services",
          style: Theme.of(context).textTheme.headline6.copyWith(
              fontFamily: FontStrings.Fieldwork10_Regular,
              color: Color(0xff212156)
          ),),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // workStatus(),
            SizedBox(height: 24,),
            TabBar(
              controller: _tabController,
              indicatorColor:UIColor.darkBlue,
              labelColor:  UIColor.darkBlue,
              unselectedLabelColor: Colors.black54,
              labelStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                fontFamily: FontStrings.Roboto_Bold,
              ),
              unselectedLabelStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                fontFamily: FontStrings.Roboto_Bold,
              ),
              tabs: <Widget>[
                Tab(
                  // icon: Icon(Icons.home),
                  text: 'Bahraini National',
                ),
                Tab(
                  // icon: Icon(Icons.email),
                  text: 'Expatriate',
                ),
                Tab(
                  // icon: Icon(Icons.settings),
                  text: 'GCC National',
                ),
              ],
            ),
            SizedBox(height: 24,),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  ManageBahrainTabBar(),
                  ManageExpatTabBar(),
                  ManageGccTabBar(),
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget workStatus() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Container(
              padding: EdgeInsets.only(left: 50, right: 50),
              decoration: BoxDecoration(
                color: UIColor.baseColorWhite,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  SvgPicture.asset(
                    'assets/status line1.svg',
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Services available',
                    style: Theme.of(context).textTheme.caption.copyWith(
                      fontFamily: FontStrings.Roboto_Bold,
                      color: UIColor.baseColorTeal,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Select the services you provide and it’s price. You can always change it in settings.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption.copyWith(
                      fontFamily: FontStrings.Roboto_Regular,
                      color: Color(0xFF4D4F51),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget workTime(String time){
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                decoration: BoxDecoration(
                  color: UIColor.baseColorWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0, 0.1),
                      blurRadius: 0.2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.only(top: 13, bottom: 13),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Working Hours',
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                  fontFamily: FontStrings.Roboto_Regular,
                                  color: Color(0xFF4D4F51),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                time,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.caption.copyWith(
                                  fontFamily: FontStrings.Roboto_Bold,
                                  color: Color(0xFF4D4F51),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 1,
        )
      ],
    );
  }
}
