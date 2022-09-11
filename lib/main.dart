import 'package:eShop/app_properties.dart';
import 'package:eShop/firebase_options.dart';
import 'package:eShop/screens/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  //TODO: disable multidexing
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  // set user preferencesa
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //TODO: change title to app name
      title: 'Shoppe',
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CustomTransitionBuilder(),
            TargetPlatform.iOS: CustomTransitionBuilder(),
          },
        ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: kPrimaryColor),
          elevation: 0,
          color: Colors.white.withOpacity(0),
          toolbarHeight: 30,
        ),
        iconTheme: IconThemeData(color: kPrimaryColor),
        canvasColor: Colors.transparent,
        primarySwatch: kPrimaryMaterialColor,
        fontFamily: "Montserrat",
      ),
      home: SplashScreen(),
    );
  }
}

class CustomTransitionBuilder extends PageTransitionsBuilder {
  const CustomTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _CustomTransitionBuilder(routeAnimation: animation, child: child);
  }
}

class _CustomTransitionBuilder extends StatelessWidget {
  _CustomTransitionBuilder({
    Key? key,
    required Animation<double> routeAnimation,
    required this.child,
  })  : animation = routeAnimation,
        super(key: key);
  final begin = Offset(1, 0);
  final end = Offset.zero;
  final curve = Curves.ease;
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation.drive(Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      )),
      child: child,
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
