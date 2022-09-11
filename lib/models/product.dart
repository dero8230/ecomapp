import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  String image;
  String name;
  String description;
  double price;
  String category;
  List<String> tags;
  String id;
  int quantity;
  Product(this.image, this.name, this.description, this.price, this.category,
      this.tags, this.id, this.quantity);
  Product.fromJson(DocumentSnapshot json)
      : image = json['image'] as String,
        name = json['name'] as String,
        description = json['description'] as String,
        price = (json['price']).toDouble(),
        category = json['category'] as String,
        tags = List<String>.from(json['tags']),
        id = json.id,
        quantity = 1;

  Map<String, dynamic> toJson() => {
        'image': image,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'tags': tags,
        'id': id,
        'quantity': quantity,
        'firstLetter': name.characters.first.toLowerCase(),
      };
}
