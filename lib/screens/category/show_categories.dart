import 'package:eShop/screens/main/components/tab_view.dart';
import 'package:flutter/material.dart';

import '../../app_properties.dart';

class ShowCategories extends StatefulWidget {
  const ShowCategories({required this.initialCategory});
  final int initialCategory;
  @override
  State<ShowCategories> createState() => _ShowCategoriesState();
}

class _ShowCategoriesState extends State<ShowCategories>
    with TickerProviderStateMixin<ShowCategories> {
  late final TabController tabController;
  final List<String> categories = [
    'Gadgets',
    'Clothes',
    'Fashion',
    'Home',
    'Beauty',
    'Appliances',
    'Other',
  ];
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: categories.length,
      vsync: this,
      initialIndex: widget.initialCategory,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Categories"),
        bottom: TabBar(
          controller: tabController,
          tabs: categories.map((category) {
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
        ),
      ),
      body:
          CategoryTabView(categories: categories, tabController: tabController),
    );
  }
}
