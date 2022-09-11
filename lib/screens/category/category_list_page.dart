import 'package:eShop/app_properties.dart';
import 'package:eShop/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components/staggered_category_card.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  List<Category> searchResults = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    searchResults = getCat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xffF9F9F9).withOpacity(.5),
      child: Container(
        margin: const EdgeInsets.only(top: kToolbarHeight),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment(-1, 0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Category List',
                  style: TextStyle(
                    color: darkGrey,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: kPrimaryColor.withOpacity(.5)),
                    hintText: 'Search',
                    prefixIcon: SvgPicture.asset(
                      'assets/icons/search_icon.svg',
                      fit: BoxFit.scaleDown,
                      color: kPrimaryColor,
                    )),
                onChanged: (value) {
                  if (value.isEmpty) {
                    searchResults = getCat();
                    setState(() {});
                    return;
                  }
                  if (value.isNotEmpty) {
                    List<Category> tempList = [];
                    getCat().forEach((category) {
                      if (category.category.toLowerCase().contains(value)) {
                        tempList.add(category);
                      }
                    });
                    setState(() {
                      searchResults = tempList;
                    });
                  }
                },
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (_, index) => Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: StaggeredCardCard(
                    categoryId: searchResults[index].id,
                    begin: searchResults[index].begin,
                    end: searchResults[index].end,
                    categoryName: searchResults[index].category,
                    assetPath: searchResults[index].image,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Category> getCat() {
    List<Category> categories = [
      Category(
        0,
        Color(0xffFCE183),
        Color(0xffF68D7F),
        'Gadgets',
        'https://firebasestorage.googleapis.com/v0/b/weshop8230.appspot.com/o/products%2Fjeans_5.png?alt=media&token=8cafa14f-9175-43ae-a3c4-8d9d6e58c3b3',
      ),
      Category(
        1,
        Color(0xffF749A2),
        Color(0xffFF7375),
        'Clothes',
        'https://firebasestorage.googleapis.com/v0/b/weshop8230.appspot.com/o/products%2Fjeans_5.png?alt=media&token=8cafa14f-9175-43ae-a3c4-8d9d6e58c3b3',
      ),
      Category(
        2,
        Color(0xff00E9DA),
        Color(0xff5189EA),
        'Fashion',
        'https://firebasestorage.googleapis.com/v0/b/weshop8230.appspot.com/o/products%2Fjeans_5.png?alt=media&token=8cafa14f-9175-43ae-a3c4-8d9d6e58c3b3',
      ),
      Category(
        3,
        Color(0xffAF2D68),
        Color(0xff632376),
        'Home',
        'https://firebasestorage.googleapis.com/v0/b/weshop8230.appspot.com/o/products%2Fjeans_5.png?alt=media&token=8cafa14f-9175-43ae-a3c4-8d9d6e58c3b3',
      ),
      Category(
        4,
        Color(0xff36E892),
        Color(0xff33B2B9),
        'Beauty',
        'https://firebasestorage.googleapis.com/v0/b/weshop8230.appspot.com/o/products%2Fjeans_5.png?alt=media&token=8cafa14f-9175-43ae-a3c4-8d9d6e58c3b3',
      ),
      Category(
        5,
        Color(0xffF123C4),
        Color(0xff668CEA),
        'Appliances',
        'https://firebasestorage.googleapis.com/v0/b/weshop8230.appspot.com/o/products%2Fjeans_5.png?alt=media&token=8cafa14f-9175-43ae-a3c4-8d9d6e58c3b3',
      ),
      Category(
        6,
        Color(0xff09efb2),
        Color(0xff41578d),
        'Others',
        'https://firebasestorage.googleapis.com/v0/b/weshop8230.appspot.com/o/products%2Fjeans_5.png?alt=media&token=8cafa14f-9175-43ae-a3c4-8d9d6e58c3b3',
      ),
    ];
    return categories;
  }
}
