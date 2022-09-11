import 'package:eShop/screens/category/full_category.dart';
import 'package:flutter/material.dart';

import '../../../models/product.dart';
import 'recommended_list.dart';

class TabView extends StatelessWidget {
  final TabController tabController;
  final List<Product> products;
  TabView({
    required this.tabController,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
        physics: BouncingScrollPhysics(),
        controller: tabController,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 16.0,
              ),
              Flexible(child: RecommendedList(products: products)),
            ],
          ),
          Column(children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Flexible(child: RecommendedList(products: products)),
          ]),
          Column(children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Flexible(child: RecommendedList(products: products)),
          ]),
          Column(children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Flexible(child: RecommendedList(products: products)),
          ]),
          Column(children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Flexible(child: RecommendedList(products: products)),
          ]),
        ]);
  }
}

class CategoryTabView extends StatefulWidget {
  const CategoryTabView({
    required this.categories,
    required this.tabController,
  });
  final List<String> categories;
  final TabController tabController;
  @override
  State<CategoryTabView> createState() => _CategoryTabViewState();
}

class _CategoryTabViewState extends State<CategoryTabView> {
  final List<PageStorageKey> _pageStorageKeys = [
    PageStorageKey('Gadgets'),
    PageStorageKey('Clothes'),
    PageStorageKey('Fashion'),
    PageStorageKey('Home'),
    PageStorageKey('Beauty'),
    PageStorageKey('Appliances'),
    PageStorageKey('Other'),
  ];

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: BouncingScrollPhysics(),
      controller: widget.tabController,
      children: widget.categories.map((category) {
        return FullCategory(
            category: category,
            pageStorageKey:
                _pageStorageKeys[widget.categories.indexOf(category)]);
      }).toList(),
    );
  }
}
/*
class CategoryTabBar extends StatefulWidget {
  const CategoryTabBar({
    required this.categories,
    required this.tabController,
  });
  final List<String> categories;
  final TabController tabController;
  @override
  State<CategoryTabBar> createState() => _CategoryTabBarState();
}

class _CategoryTabBarState extends State<CategoryTabBar> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: widget.tabController,
      tabs: widget.categories.map((category) {
        return Tab(
          text: category,
        );
      }).toList(),
      labelStyle: TextStyle(fontSize: 16.0),
      unselectedLabelStyle: TextStyle(
        fontSize: 14.0,
      ),
      labelColor: darkGrey,
      unselectedLabelColor: Color.fromRGBO(0, 0, 0, 0.5),
      isScrollable: true,
    );
  }
}*/
