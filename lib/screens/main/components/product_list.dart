import 'package:card_swiper/card_swiper.dart';
import 'package:eShop/app_properties.dart';
import 'package:eShop/models/product.dart';
import 'package:eShop/screens/product/view_product_page.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

import '../../product/product_page.dart';

class ProductList extends StatelessWidget {
  List<Product> products;

  final SwiperController swiperController = SwiperController();
  ProductList({required this.products});

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height / 3.5;
    double cardWidth = MediaQuery.of(context).size.width / 1.8;

    return SizedBox(
      height: cardHeight,
      child: Swiper(
        key: PageStorageKey('product_list'),
        itemCount: products.length,
        itemBuilder: (_, index) {
          return ProductCard(
              height: cardHeight, width: cardWidth, product: products[index]);
        },
        scale: 0.8,
        controller: swiperController,
        viewportFraction: 0.6,
        loop: true,
        fade: 0.5,
        autoplay: true,
        autoplayDelay: 4000,
        duration: 2000,
        autoplayDisableOnInteraction: true,
        pagination: SwiperCustomPagination(
          builder: (context, config) {
            if (config!.itemCount! > 20) {
              print(
                  "The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotSwiperPaginationBuilder in this sitituation");
            }
            Color activeColor = mediumYellow;
            Color color = Colors.grey.withOpacity(.3);
            double size = 10.0;
            double space = 5.0;

            if (config.indicatorLayout != PageIndicatorLayout.NONE &&
                config.layout == SwiperLayout.DEFAULT) {
              return new PageIndicator(
                count: config.itemCount!,
                controller: config.pageController!,
                layout: config.indicatorLayout,
                size: size,
                activeColor: activeColor,
                color: color,
                space: space,
              );
            }

            List<Widget> dots = [];

            int itemCount = config.itemCount!;
            int activeIndex = config.activeIndex!;

            for (int i = 0; i < itemCount; ++i) {
              bool active = i == activeIndex;
              dots.add(Container(
                key: Key("pagination_$i"),
                margin: EdgeInsets.all(space),
                child: ClipOval(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active ? activeColor : color,
                    ),
                    width: size,
                    height: size,
                  ),
                ),
              ));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: dots,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final double height;
  final double width;

  const ProductCard({
    required this.product,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Trans().nav(ViewProductPage(product: product), context),
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
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 30),
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: mediumYellow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {},
                  color: Colors.white,
                ),
                Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.name,
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        )),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 12.0, 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          color: Color.fromRGBO(224, 69, 10, 1),
                        ),
                        child: Text(
                          '\$${product.price}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            child: Hero(
              tag: product.image + product.name,
              child: Image.network(
                product.image,
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox.shrink();
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
                height: height / 1.7,
                width: width / 1.4,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
