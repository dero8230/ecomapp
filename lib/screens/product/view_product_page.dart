import 'package:eShop/models/product.dart';
import 'package:flutter/material.dart';

import '../../app_properties.dart';
import '../../models/CustomAppBar.dart';
import 'components/color_list.dart';
import 'components/more_products.dart';
import 'components/product_options.dart';
import 'components/shop_bottomSheet.dart';

class ViewProductPage extends StatefulWidget {
  final Product product;

  ViewProductPage({required this.product});
  @override
  _ViewProductPageState createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // create persistent bottom sheet controller
  PersistentBottomSheetController? _bottomSheetController;

  bool expanded = false;
  int active = 0;
  void showCartSheet() {
    _bottomSheetController = _scaffoldKey.currentState!.showBottomSheet(
      (context) {
        return ShopBottomSheet();
      },
      elevation: 20,
      enableDrag: true,
    );
  }

  void hideCartSheet() {
    if (_bottomSheetController == null) {
      return;
    }
    _bottomSheetController!.close();
    _bottomSheetController = null;
  }

  ///list of product colors
  List<Widget> colors() {
    List<Widget> list = [];
    for (int i = 0; i < 5; i++) {
      list.add(
        InkWell(
          onTap: () {
            setState(() {
              active = i;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Transform.scale(
              scale: active == i ? 1.2 : 1,
              child: Card(
                elevation: 3,
                color: Colors.primaries[i],
                child: SizedBox(
                  height: 32,
                  width: 32,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    // description of product
    Widget description = Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.product.description,
            maxLines: expanded ? 100 : 6,
            semanticsLabel: '...',
            overflow: TextOverflow.ellipsis,
          ),
          // create row with text button to expand description
          widget.product.description.length > 100
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          expanded = !expanded;
                        });
                      },
                      child: Text(
                        expanded ? 'show less' : 'show more',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: showCartSheet,
          child: Icon(Icons.add_shopping_cart),
        ),
        key: _scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        backgroundColor: Colors.grey[100],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: CustomAppBar(rating: 4.2),
        ),
        body: GestureDetector(
          onTap: hideCartSheet,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 24),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  ProductOption(
                    _scaffoldKey,
                    product: widget.product,
                    onAddToCart: () {
                      setState(() {
                        Cart.add(widget.product, context);
                        if (_bottomSheetController != null) {
                          _bottomSheetController!.setState!(() {});
                        }
                      });
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Container(
                    // add top padding to container
                    padding: const EdgeInsets.only(top: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Text(
                            widget.product.name,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        description,
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: 24, left: 24, right: 10),
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Flexible(
                                  child: Container(
                                    // decorate container with shadow
                                    child: ColorList([
                                      Colors.red,
                                      Colors.blue,
                                      Colors.purple,
                                      Colors.green,
                                      Colors.yellow
                                    ]),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: RawMaterialButton(
                                    onPressed: () {},
                                    constraints: const BoxConstraints(
                                        minWidth: 45, minHeight: 45),
                                    child: Icon(Icons.favorite_border_outlined,
                                        color:
                                            Color.fromRGBO(255, 137, 147, 1)),
                                    elevation: 0.0,
                                    shape: CircleBorder(),
                                  ),
                                ),
                              ]),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: MoreProducts(
                              currentProduct: widget.product,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
