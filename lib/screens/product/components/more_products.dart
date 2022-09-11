import 'package:eShop/app_properties.dart';
import 'package:eShop/models/product.dart';
import 'package:eShop/screens/product/components/product_card.dart';
import 'package:eShop/screens/product/view_product_page.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

import '../product_page.dart';

class MoreProducts extends StatefulWidget {
  MoreProducts({required this.currentProduct});
  final Product currentProduct;

  @override
  _MoreProductsState createState() => _MoreProductsState();
}

class _MoreProductsState extends State<MoreProducts> {
  List<Product> products = [];
  // create late future product list
  late Future<List<Product>> getMoreProducts;
  @override
  void initState() {
    getMoreProducts = FireStorage.getMoreProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24.0, bottom: 8.0),
          child: Text(
            'More products',
            style: TextStyle(shadows: shadow, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          height: 250,
          child: FutureBuilder<List<Product>>(
              future: getMoreProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  //reload the page if error occurs
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${snapshot.error.toString().format()}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]),
                        ),
                        ElevatedButton(
                          child: Text('refresh',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            setState(() {
                              getMoreProducts = FireStorage.getMoreProducts();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }
                products = snapshot.data!;
                for (int i = 0; i < products.length; i++) {
                  if (products[i].id == widget.currentProduct.id) {
                    products.removeAt(i);
                  }
                }
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    return Padding(
                        padding: index == 0
                            ? EdgeInsets.only(left: 24.0, right: 8.0)
                            : index == 4
                                ? EdgeInsets.only(right: 24.0, left: 8.0)
                                : EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                            onLongPress: () {
                              NDialog(
                                dialogStyle: DialogStyle(
                                  backgroundColor: yellow,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                title: Text(
                                  products[index].name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                content: ProductPage(product: products[index]),
                              ).show(context);
                            },
                            onTap: () => Trans().nav(
                                ViewProductPage(product: products[index]),
                                context),
                            child: ProductCard(products[index])));
                  },
                  scrollDirection: Axis.horizontal,
                );
              }),
        )
      ],
    );
  }
}
