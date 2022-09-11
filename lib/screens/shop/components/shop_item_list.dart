import 'package:eShop/app_properties.dart';
import 'package:eShop/models/product.dart';
import 'package:eShop/screens/product/components/color_list.dart';
import 'package:eShop/screens/product/components/shop_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:numberpicker/numberpicker.dart';

class ShopItemList extends StatefulWidget {
  final Product product;
  final VoidCallback onRemove;
  final VoidCallback onchange;
  ShopItemList(this.product, {required this.onRemove, required this.onchange});

  @override
  _ShopItemListState createState() => _ShopItemListState();
}

class _ShopItemListState extends State<ShopItemList> {
  late int quantity;
  late double initialPrice;

  @override
  void initState() {
    initialPrice = widget.product.price;
    quantity = widget.product.quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Color(0xFFFFE6E6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Spacer(),
            SvgPicture.asset("assets/icons/Trash.svg"),
          ],
        ),
      ),
      key: Key(widget.product.id +
          widget.product.name +
          widget.product.price.toString()),
      onDismissed: (direction) {
        widget.onRemove();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.only(
          top: 10,
        ),
        height: 130,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(0, 0.8),
              child: Container(
                  height: 100,
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: shadow,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 12.0, right: 12.0),
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.product.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: darkGrey,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 160,
                                  padding: const EdgeInsets.only(
                                      left: 0.0, top: 8.0, bottom: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 20,
                                      ),
                                      ColorOption(Colors.red),
                                      // sizedbox width: 15
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        '\$${Cart.getProductPrice(widget.product)}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: darkGrey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Theme(
                            data: ThemeData(
                                textTheme: TextTheme(
                                  headline6: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  bodyText1: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                colorScheme: ColorScheme.fromSwatch()
                                    .copyWith(secondary: Colors.black)),
                            child: NumberPicker(
                              itemWidth: 50,
                              minValue: 1,
                              maxValue: 10,
                              onChanged: (value) {
                                setState(() {
                                  quantity = value;
                                  widget.product.quantity = value;
                                });
                                widget.onchange();
                              },
                              value: quantity,
                            ))
                      ])),
            ),
            Positioned(
                top: 5,
                child: ShopProductDisplay(
                  widget.product,
                  onPressed: widget.onRemove,
                )),
          ],
        ),
      ),
    );
  }
}
