import 'package:card_swiper/card_swiper.dart';
import 'package:eShop/app_properties.dart';
import 'package:eShop/screens/address/add_address_page.dart';
import 'package:eShop/screens/payment/unpaid_page.dart';
import 'package:flutter/material.dart';

import 'components/credit_card.dart';
import 'components/shop_item_list.dart';

class CheckOutPage extends StatefulWidget {
  CheckOutPage(this.isFromCart);
  final bool isFromCart;
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final paymentMethods = [
    'CreditCard',
    'Paypal',
  ];
  int activePaymentMethod = 0;
  final methods = [
    CreditCard(),
    PaypalCard(),
  ];
  SwiperController swiperController = SwiperController();
  //create new scroll controller
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget checkOutButton = InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Cart.isEmpty()
          ? null
          : Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AddAddressPage(() {
                    setState(() {
                      Cart.clear();
                    });
                  }))),
      child: AnimatedContainer(
        height: 70,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
            gradient: getButtonColor(activePaymentMethod),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(20)),
        duration: Duration(milliseconds: 300),
        child: Center(
          child: Text(
              Cart.isEmpty()
                  ? 'Cart is empty'
                  : activePaymentMethod == 0
                      ? "Check Out"
                      : "Continue with ${paymentMethods[activePaymentMethod]}",
              style: TextStyle(
                  color: Cart.isEmpty()
                      ? Color(0xfffefefe)
                      : activePaymentMethod == 0
                          ? Color(0xfffefefe)
                          : Color(0xff0a3172),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: Cart.isEmpty()
                      ? 20.0
                      : activePaymentMethod == 0
                          ? 20.0
                          : 16.0)),
        ),
      ),
    );

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    '\$${Cart.getCartTotal()}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              Container(child: checkOutButton),
            ],
          ),
        ),
      ),
      backgroundColor:
          widget.isFromCart ? Colors.grey[50] : Colors.white.withOpacity(0.5),
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: darkGrey),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/icons/denied_wallet.png'),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => UnpaidPage())),
          )
        ],
        title: Text(
          'Checkout',
          style: TextStyle(
              color: darkGrey, fontWeight: FontWeight.w500, fontSize: 18.0),
        ),
      ),
      body: LayoutBuilder(
        builder: (_, constraints) => SingleChildScrollView(
          controller: scrollController,
          physics: ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    Cart.cartCount.toString() + ' item(s)',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: Builder(builder: (context) {
                    if (Cart.isEmpty()) {
                      return Center(
                        child: Text("nothing here",
                            style: TextStyle(
                              color: Colors.grey[400],
                            )),
                      );
                    }
                    return Scrollbar(
                      child: ListView.builder(
                        controller: scrollController,
                        itemBuilder: (_, index) {
                          return ShopItemList(
                            Cart.cart[index],
                            onRemove: () {
                              setState(() {
                                Cart.remove(Cart.cart[index]);
                              });
                            },
                            onchange: () {
                              setState(() {});
                            },
                          );
                        },
                        itemCount: Cart.cart.length,
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Payment Method',
                    style: TextStyle(
                        fontSize: 20,
                        color: darkGrey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: Swiper(
                    physics: BouncingScrollPhysics(),
                    onIndexChanged: (index) {
                      setState(() {
                        activePaymentMethod = index;
                      });
                    },
                    itemCount: methods.length,
                    itemBuilder: (_, index) {
                      return methods[index];
                    },
                    scale: 0.8,
                    controller: swiperController,
                    viewportFraction: 0.6,
                    loop: false,
                    fade: 0.7,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Gradient getButtonColor(int index) {
    // return dark grey if Cart is empty
    if (Cart.isEmpty()) {
      return LinearGradient(
        colors: [Colors.grey, Colors.grey, Colors.grey],
      );
    }
    if (index == 0) {
      return mainButton;
    } else {
      // return LinearGradient
      return LinearGradient(colors: [
        Colors.white,
        Colors.white,
        Colors.white54,
      ], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter);
    }
  }
}

class Scroll extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    LinearGradient grT = LinearGradient(
        colors: [Colors.transparent, Colors.black26],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);
    LinearGradient grB = LinearGradient(
        colors: [Colors.transparent, Colors.black26],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter);

    canvas.drawRect(
        Rect.fromLTRB(0, 0, size.width, 30),
        Paint()
          ..shader = grT.createShader(Rect.fromLTRB(0, 0, size.width, 30)));

    canvas.drawRect(Rect.fromLTRB(0, 30, size.width, size.height - 40),
        Paint()..color = Color.fromRGBO(50, 50, 50, 0.4));

    canvas.drawRect(
        Rect.fromLTRB(0, size.height - 40, size.width, size.height),
        Paint()
          ..shader = grB.createShader(
              Rect.fromLTRB(0, size.height - 40, size.width, size.height)));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
