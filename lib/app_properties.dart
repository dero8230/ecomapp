import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eShop/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);
const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const Color yellow = Color(0xffFDC054);
const Color mediumYellow = Color(0xffFDB846);
const Color darkYellow = Color(0xffE99E22);
const Color transparentYellow = Color.fromRGBO(253, 184, 70, 0.7);
const Color darkGrey = Color(0xff202020);

const LinearGradient mainButton = LinearGradient(colors: [
  kPrimaryColor,
  kPrimaryColor,
  kPrimaryColor,
], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter);

const List<BoxShadow> shadow = [
  BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 6)
];

screenAwareSize(int size, BuildContext context) {
  double baseHeight = 640.0;
  return size * MediaQuery.of(context).size.height / baseHeight;
}

const Map<int, Color> materialColor = {
  50: kPrimaryColor,
  100: kPrimaryColor,
  200: kPrimaryColor,
  300: kPrimaryColor,
  400: kPrimaryColor,
  500: kPrimaryColor,
  600: kPrimaryColor,
  700: kPrimaryColor,
  800: kPrimaryColor,
  900: kPrimaryColor,
};
MaterialColor kPrimaryMaterialColor = MaterialColor(
  kPrimaryColor.value,
  materialColor,
);

class Cart {
  static List<Product> cart = [];
  static int cartCount = 0;
  static double cartTotal = 0;

  static Future add(Product product, BuildContext context) async {
    // check if product already exists in cart
    if (cart.any((p) => p.id == product.id)) {
      //return if quantity => 10
      if (cart.firstWhere((p) => p.id == product.id).quantity >= 10) {
        errorp.showErr("you can't add anymore items", context);
        return;
      }
      // if it does, increment the quantity
      cart.firstWhere((p) => p.id == product.id).quantity++;
      errorp.success("Item added to cart", context);
    } else {
      // if it doesn't, add it to the cart
      cart.add(new Product(
          product.image,
          product.name,
          product.description,
          product.price,
          product.category,
          product.tags,
          product.id,
          product.quantity));
      cartCount = cart.length;
      errorp.success("Item added to cart", context);
    }
  }

  // check if cart is empty
  static bool isEmpty() {
    return cart.length == 0;
  }

  static Future remove(Product product) async {
    cart.remove(product);
    cartCount = cart.length;
  }

  // get cartTotal
  static String getCartTotal() {
    cartTotal = 0;
    for (var product in cart) {
      var price = product.price * product.quantity;
      cartTotal += price;
    }
    return cartTotal.toStringAsFixed(2);
  }

  // get product price * quantity
  static String getProductPrice(Product product) {
    if (product.quantity > 1) {
      return (product.price * product.quantity).toStringAsFixed(2);
    } else {
      return product.price.toStringAsFixed(2);
    }
  }

  ///empty cart
  static void clear() {
    cart.clear();
    cartCount = 0;
    cartTotal = 0;
  }
}

//create class Storage
class FireStorage {
  static Future<Product> getProduct(String id) async {
    var doc =
        await FirebaseFirestore.instance.collection("products").doc(id).get();
    var dat = doc;
    var pro = Product.fromJson(dat);
    return pro;
  }

  static Future<List<Product>> getRecommendedProduct() async {
    try {
      var hasInternet = await Internet.checkInternet();
      if (!hasInternet) {
        throw Exception("No internet connection");
      }
      var doc = await FirebaseFirestore.instance.collection("rproducts").get();
      var dat = doc;
      var pro = <Product>[];
      for (var i = 0; i < dat.docs.length; i++) {
        var prod = Product.fromJson(dat.docs[i]);
        pro.add(prod);
      }
      return pro;
    } on Exception catch (e) {
      throw e;
    }
  }

  static void testStore() async {
    var products = await getRecommendedProduct();
    for (var product in products) {
      rStore(product);
    }
    print("done");
  }

  static Future storeProducts(List<Product> products) async {
    var path = FirebaseFirestore.instance.collection("products");
    products.forEach((product) async {
      await path.add(product.toJson());
    });
  }

  static void addToCart(Product product, BuildContext context) async {
    var cart = await FirebaseFirestore.instance.collection("cart").get();
    var dat = cart;
    var pro = <Product>[];
    for (var i = 0; i < dat.docs.length; i++) {
      var prod = Product.fromJson(dat.docs[i]);
      pro.add(prod);
    }
    if (pro.contains(product)) {
      errorp.showErr("Product already in cart", context);
    } else {
      pro.add(product);
      await FirebaseFirestore.instance.collection("cart").add(product.toJson());
      errorp.success("Product added to cart", context);
    }
  }

  static Future<List<Product>> getCart() async {
    try {
      var doc = await FirebaseFirestore.instance.collection("cart").get();
      var dat = doc;
      var pro = <Product>[];
      for (var i = 0; i < dat.docs.length; i++) {
        var prod = Product.fromJson(dat.docs[i]);
        pro.add(prod);
      }
      return pro;
    } on Exception catch (e) {
      throw e;
      return [];
    }
  }

  static Future<void> rStore(Product product) async {
    var path = FirebaseFirestore.instance.collection("rproducts");
    await path.doc(product.id).set(product.toJson());
  }

  // update product in firebase
  static Future<void> updateProduct(Product product) async {
    // split product name to array
    final List<String> categories = [
      'Gadgets',
      'Clothes',
      'Fashion',
      'Home',
      'Beauty',
      'Appliances',
      'Other',
    ];
    categories.shuffle();
    // create map of name for firebase
    var map = <String, dynamic>{
      "category": categories[3].toLowerCase(),
    };
    await FirebaseFirestore.instance
        .collection("products")
        .doc(product.id)
        .update(map);
  }

  // search products
  static Future<List<Product>> searchProducts(String query) async {
    // return all products if query is empty
    if (query.isEmpty) {
      return await getRecommendedProduct();
    }
    try {
      var hasInternet = await Internet.checkInternet();
      if (!hasInternet) {
        throw Exception("No internet connection");
      }
      var doc = await FirebaseFirestore.instance
          .collection("products")
          .where("firstLetter",
              isEqualTo: query.characters.first.toString().toLowerCase())
          .get();
      var dat = doc.docs
          .where((element) => element
              .data()["name"]
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
      var pro = <Product>[];
      for (var i = 0; i < dat.length; i++) {
        var prod = Product.fromJson(dat[i]);
        pro.add(prod);
      }
      return pro;
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  // get more products
  static Future<List<Product>> getMoreProducts() async {
    // return all products if query is empty
    try {
      var hasInternet = await Internet.checkInternet();
      if (!hasInternet) {
        throw Exception("No internet connection");
      }
      var doc = await FirebaseFirestore.instance
          .collection("products")
          .limit(5)
          .get();
      var dat = doc.docs;
      var pro = <Product>[];
      for (var i = 0; i < dat.length; i++) {
        var prod = Product.fromJson(dat[i]);
        pro.add(prod);
      }
      return pro;
    } on Exception catch (e) {
      throw e;
    }
  }

// search products by category
  static Future<List<Product>> getCategory(String query) async {
    // return all products if query is empty
    try {
      var hasInternet = await Internet.checkInternet();
      if (!hasInternet) {
        throw Exception("No internet connection");
      }
      var doc = await FirebaseFirestore.instance
          .collection("products")
          .where("category", isEqualTo: query.toLowerCase())
          .get();
      var dat = doc.docs;
      var pro = <Product>[];
      for (var i = 0; i < dat.length; i++) {
        var prod = Product.fromJson(dat[i]);
        pro.add(prod);
      }
      return pro;
    } on Exception catch (e) {
      throw e;
    }
  }

  // check if user is admin
  static Future<bool> isAdmin(User? user) async {
    try {
      var hasInternet = await Internet.checkInternet();
      if (!hasInternet) {
        throw Exception("No internet connection");
      }
      if (user == null) {
        return false;
      }
      var doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      // return false if document is not found
      if (doc.data() == null) {
        return false;
      }
      var dat = doc;
      var pro = dat.data()!["admin"];
      return pro;
    } on Exception catch (e) {
      throw e;
    }
  }
  /*static final firebaseStorage = FirebaseStorage.instance;
  // load image from firebase cloud storage
  static Future<String> loadImage(String url) async {
    try {
      var ref = firebaseStorage.ref("products").child(url);
      String urlx = await ref.getDownloadURL();
      return urlx;
    } catch (e) {
      print(e);
      return "";
    }
  }*/
}

class Trans {
  void nav(Widget route, BuildContext context) {
    var page = PageRouteBuilder(
        reverseTransitionDuration: Duration(milliseconds: 500),
        transitionDuration: Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => route,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0);
          const end = Offset.zero;
          const curve = Curves.easeInOutBack;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        });
    Navigator.push(context, page);
  }

  void searchNav(Widget route, BuildContext context) {
    var page = PageRouteBuilder(
        reverseTransitionDuration: Duration(milliseconds: 200),
        transitionDuration: Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) => route,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, 0.97);
          const end = Offset.zero;
          const curve = Curves.ease;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        });
    Navigator.push(context, page);
  }

  void dialogNav(Widget route, BuildContext context) {
    var page = PageRouteBuilder(
        barrierColor: kPrimaryColor,
        reverseTransitionDuration: Duration(milliseconds: 500),
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => route,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, 0.97);
          const end = Offset.zero;
          const curve = Curves.ease;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        });
    Navigator.push(context, page);
  }
}

final List<Product> mainPro = [];

class errorp {
  static void showErr(String con, BuildContext context) async {
    var errx = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(con),
      duration: const Duration(seconds: 4),
      backgroundColor: const Color.fromARGB(255, 175, 58, 54),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(errx);
  }

  static void success(String con, BuildContext context) async {
    var errx = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(con),
      duration: const Duration(seconds: 1),
      backgroundColor: kPrimaryColor,
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(errx);
    await Future.delayed(const Duration(seconds: 2));
    await Future.delayed(const Duration(milliseconds: 700));
  }
}

class Internet {
  // check internet connection
  static Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}

//extension on String
extension E on String {
  String format() {
    return replaceAll("Exception:", "");
  }

  String shrink() {
    return this.length > 15
        ? this.substring(0, 15) + "..."
        : this.substring(0, this.length);
  }
}
