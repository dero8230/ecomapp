import 'package:eShop/models/product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: null,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
              height: 250,
              width: MediaQuery.of(context).size.width / 2 - 29,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 3))
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey[50]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      width: MediaQuery.of(context).size.width / 2 - 64,
                      height: MediaQuery.of(context).size.width / 2 - 64,
                      child: Hero(
                        tag: product.image,
                        child: Image.network(
                          product.image,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/error.png');
                          },
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : Center(
                                    child: CircularProgressIndicator(
                                        value: (progress.cumulativeBytesLoaded /
                                                progress.expectedTotalBytes!
                                                    .toInt())
                                            .toDouble()),
                                  );
                          },
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: Alignment(1, 0.5),
                      child: Container(
                          margin: const EdgeInsets.only(left: 16.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              // create box shadows to give card effect
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 5,
                                    offset: Offset(0, 3))
                              ],
                              color: Color(0xffe0450a).withOpacity(0.51),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Text(
                            product.name,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  )
                ],
              )),
        ));
  }
}
