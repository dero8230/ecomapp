import 'dart:math' as math;

import '../../models/product.dart';

class ProductDataCard {
  ProductDataCard({
    this.image = '',
    this.name = '',
    this.startColor = '',
    this.endColor = '',
    this.tags,
    this.sales = 0,
  });

  String image;
  String name;
  String startColor;
  String endColor;
  List<String>? tags;
  int sales;

  static List<ProductDataCard> tabIconsList = <ProductDataCard>[
    ProductDataCard(
      image: 'assets/fitness_app/breakfast.png',
      name: 'Breakfast',
      sales: 525,
      tags: <String>['Bread,', 'Peanut butter,', 'Apple'],
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    ProductDataCard(
      image: 'assets/fitness_app/lunch.png',
      name: 'Lunch',
      sales: 602,
      tags: <String>['Salmon,', 'Mixed veggies,', 'Avocado'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    ProductDataCard(
      image: 'assets/fitness_app/snack.png',
      name: 'Snack',
      sales: 0,
      tags: <String>['Recommend:', '800 kcal'],
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    ProductDataCard(
      image: 'assets/fitness_app/dinner.png',
      name: 'Dinner',
      sales: 0,
      tags: <String>['Recommend:', '703 kcal'],
      startColor: '#6F72CA',
      endColor: '#1E1466',
    ),
  ];
  static List<ProductDataCard> generateProductDataCards(
          List<Product> product) =>
      [
        ProductDataCard(
          image: product[0].image,
          name: product[0].name,
          sales: math.Random().nextInt(500),
          tags: product[0].tags,
          startColor: '#FA7D82',
          endColor: '#FFB295',
        ),
        ProductDataCard(
          image: product[1].image,
          name: product[1].name,
          sales: math.Random().nextInt(500),
          tags: product[1].tags,
          startColor: '#FA7D82',
          endColor: '#1E1466',
        ),
        ProductDataCard(
          image: product[2].image,
          name: product[2].name,
          sales: math.Random().nextInt(500),
          tags: product[2].tags,
          startColor: '#738AE6',
          endColor: '#5C5EDD',
        )
      ];
}
