import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../app_properties.dart';

class menuState {
  static int _currentIndex = 0;
}

class CurvedNavBar extends StatefulWidget {
  const CurvedNavBar({Key? key, required this.onTap}) : super(key: key);
  final Function(int) onTap;
  @override
  State<CurvedNavBar> createState() => _CurvedNavBarState();
}

class _CurvedNavBarState extends State<CurvedNavBar> {
  void _onTap(int index) {
    widget.onTap(index);
    setState(() {
      menuState._currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
        color: Colors.white,
        index: 0,
        animationDuration: Duration(milliseconds: 300),
        height: 50,
        backgroundColor: Colors.transparent,
        items: <Widget>[
          SvgPicture.asset(
            "assets/icons/Shop Icon.svg",
            color: menuState._currentIndex == 0
                ? kPrimaryColor
                : inActiveIconColor,
          ),
          SvgPicture.asset(
            "assets/icons/Parcel.svg",
            color: menuState._currentIndex == 1
                ? kPrimaryColor
                : inActiveIconColor,
          ),
          SvgPicture.asset('assets/icons/Cart Icon.svg',
              color: menuState._currentIndex == 2
                  ? kPrimaryColor
                  : inActiveIconColor),
          SvgPicture.asset(
            "assets/icons/User Icon.svg",
            color: menuState._currentIndex == 3
                ? kPrimaryColor
                : inActiveIconColor,
          )
        ],
        onTap: _onTap);
  }
}
