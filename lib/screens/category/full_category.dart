import 'package:eShop/app_properties.dart';
import 'package:eShop/screens/product/view_product_page.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/product.dart';

class FullCategory extends StatefulWidget {
  const FullCategory({required this.category, required this.pageStorageKey});
  final String category;
  final PageStorageKey pageStorageKey;
  @override
  State<FullCategory> createState() => _FullCategoryState();
}

class _FullCategoryState extends State<FullCategory> {
  late Future<List<Product>> getCategory;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    getCategory = FireStorage.getCategory(widget.category);
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Product>>(
        future: getCategory,
        builder: (context, snapshot) {
          //return loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // return error if snapshot has error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(snapshot.error.toString().format(),
                      style: TextStyle(color: Colors.grey[600])),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                    ),
                    child: Text("try again",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () => setState(() {
                      getCategory = FireStorage.getCategory(widget.category);
                    }),
                  ),
                ],
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "nothing found",
                  style: TextStyle(color: Colors.grey[400]),
                ),
              );
            }
            return SmartRefresher(
              header: WaterDropHeader(),
              controller: refreshController,
              enablePullDown: true,
              onRefresh: () {
                setState(() {
                  getCategory = FireStorage.getCategory(widget.category);
                });
                refreshController.refreshCompleted();
              },
              child: ListView.builder(
                key: widget.pageStorageKey,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final product = snapshot.data![index];
                  return ListTile(
                    title: Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text("\$${product.price.toString()}"),
                    trailing: Hero(
                        tag: product.image,
                        child: Image.network(product.image)),
                    onTap: () {
                      Trans().nav(ViewProductPage(product: product), context);
                    },
                  );
                },
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
