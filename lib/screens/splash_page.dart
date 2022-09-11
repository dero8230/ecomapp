import 'package:eShop/app_properties.dart';
import 'package:eShop/screens/intro_page.dart';
import 'package:eShop/screens/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> opacity;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
    /*opacity = Tween<double>(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });*/
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool get isDarkMode =>
      (MediaQuery.of(context).platformBrightness == Brightness.dark);

  void navigationPage(bool isFirstTime) {
    var page = PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            isFirstTime ? IntroPage() : MainPage(),
        transitionDuration: Duration(milliseconds: 2500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, -1);
          const end = Offset.zero;
          const curve = Curves.bounceOut;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        });
    Navigator.pushReplacement(context, page);
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(
          color: isDarkMode ? Color(0xFF2D2B2B) : Color(0xFFFFF8F8)),
      child: SafeArea(
        child: new Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                child: Lottie.asset(
                    isDarkMode
                        ? "assets/splashDark.json"
                        : "assets/splash.json",
                    controller: controller, onLoaded: (composition) {
                  controller.forward().then((_) async {
                    final prefs = await SharedPreferences.getInstance();
                    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
                        overlays: [SystemUiOverlay.top]);
                    navigationPage(isFirstTime);
                  });
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: 'Powered by ',
                            style: TextStyle(color: kPrimaryColor)),
                        TextSpan(
                            text: 'AGB',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor))
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
