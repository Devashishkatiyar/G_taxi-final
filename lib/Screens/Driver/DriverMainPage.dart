import "package:flutter/material.dart";
import 'package:trackingapp/Screens/Driver/TabBar/EarningsTab.dart';
import 'package:trackingapp/Screens/Driver/TabBar/HomeTab.dart';
import 'package:trackingapp/Screens/Driver/TabBar/ProfileTab.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';
import 'package:trackingapp/brand_colors.dart';

class DriverMainPage extends StatefulWidget {
  static const String id = "DriverMainPage";
  const DriverMainPage({Key key}) : super(key: key);

  @override
  _DriverMainPageState createState() => _DriverMainPageState();
}

class _DriverMainPageState extends State<DriverMainPage> with SingleTickerProviderStateMixin {
  
  TabController tabController;
  int selectedIndex = 0;

  void onItemClicked(int index){
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // final Position coordinate = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: "Earnings",
          ),BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        unselectedItemColor: BrandColors.colorIcon,
        selectedItemColor: BrandColors.colorOrange,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 12
        ),
        type: BottomNavigationBarType.fixed,
        onTap: onItemClicked,
        currentIndex: selectedIndex,
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTab(coordinate: currentDriverInfo.currentPosition,),
          EarningsTab(),
          ProfileTab()
        ],
      ),
    );
  }
}
