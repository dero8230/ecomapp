import 'package:eShop/models/product.dart';
import 'package:eShop/models/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ndialog/ndialog.dart';

import '../app_properties.dart';
import '../screens/product/product_page.dart';
import '../screens/product/view_product_page.dart';

class RProductCard extends StatelessWidget {
  const RProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;
  final double value = 30;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
      child: Container(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onLongPress: () {
            NDialog(
              dialogStyle: DialogStyle(
                backgroundColor: yellow,
                contentPadding: EdgeInsets.zero,
              ),
              title: Text(
                product.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              content: ProductPage(product: product),
            ).show(context);
          },
          onTap: () => Trans().nav(ViewProductPage(product: product), context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(value),
                      topRight: Radius.circular(value),
                      bottomLeft: Radius.circular(value),
                      bottomRight: Radius.circular(value),
                    ),
                  ),
                  child: Hero(
                    tag: product.image,
                    child: Image.network(
                      product.image,
                      errorBuilder: (context, error, stackTrace) =>
                          SizedBox.shrink(),
                      loadingBuilder: (context, child, progress) =>
                      progress == null
                          ? child
                          : Center(
                        child: CircularProgressIndicator(
                            value: (progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                                    .toInt())
                                .toDouble()),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.name,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price}",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                      height: getProportionateScreenWidth(28),
                      width: getProportionateScreenWidth(28),
                      decoration: BoxDecoration(
                        color: false
                            ? kPrimaryColor.withOpacity(0.15)
                            : kSecondaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/HeartIcon_2.svg",
                        color: false ? Color(0xFFFF4848) : Color(0xFFDBDEE4),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
