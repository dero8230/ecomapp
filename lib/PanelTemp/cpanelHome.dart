import 'package:eShop/PanelTemp/pages/adminsPage.dart';
import 'package:flutter/material.dart';

import 'bottom_navigation_view/bottom_bar_view.dart';
import 'cpanelTheme.dart';
import 'models/tabIcon_data.dart';
import 'pages/allProductsPage.dart';
import 'pages/home_screen.dart';
import 'pages/usersListPage.dart';

class FitnessAppHomeScreen extends StatefulWidget {
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );
  late List<Widget> pages;

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    pages = [
      MyHomePage(
        animationController: animationController,
      ),
      AllProductsPage(
        animationController: animationController,
      ),
      UsersListPage(
        animationController: animationController,
      ),
      AdminPage(
        animationController: animationController,
      ),
    ];
    tabBody = pages.first;
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            animationController?.reverse().then<dynamic>((data) {
              if (!mounted) return;
              setState(() {
                tabBody = pages[index];
              });
            });
          },
        ),
      ],
    );
  }
}
