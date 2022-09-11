import 'package:eShop/app_properties.dart';
import 'package:eShop/models/product.dart';
import 'package:flutter/material.dart';

class ShopProduct extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;

  const ShopProduct(
    this.product, {
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          children: <Widget>[
            ShopProductDisplay(
              product,
              onPressed: onRemove,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkGrey,
                ),
              ),
            ),
            Text(
              '\$${product.price * product.quantity}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: darkGrey, fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            product.quantity > 1
                ? Text(
                    'x${product.quantity}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: darkGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  )
                : Container(),
          ],
        ));
  }
}

class ShopProductDisplay extends StatelessWidget {
  final Product product;
  final VoidCallback onPressed;

  const ShopProductDisplay(this.product, {required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 200,
      child: Stack(children: <Widget>[
        /* Positioned(
          left: 25,
          child: SizedBox(
            height: 150,
            width: 150,
            child: Transform.scale(
              scale: 1.2,
              child: Image.asset('assets/bottom_yellow.png'),
            ),
          ),
        ),*/
        Positioned(
          left: 50,
          top: 5,
          child: Container(
              height: 80,
              width: 80,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5))
                  ]),
              child: Image.network(
                '${product.image}',
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/error.png');
                },
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : Center(
                          child: CircularProgressIndicator(
                              value: (progress.cumulativeBytesLoaded /
                                      progress.expectedTotalBytes!.toInt())
                                  .toDouble()),
                        );
                },
                fit: BoxFit.contain,
              )),
        ),
        Positioned(
          right: 145,
          bottom: 25,
          child: Align(
            child: IconButton(
              icon: Icon(
                Icons.cancel_outlined,
                color: Colors.red,
              ),
              onPressed: onPressed,
            ),
          ),
        )
      ]),
    );
  }
}
