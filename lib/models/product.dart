import 'package:cloud_firestore/cloud_firestore.dart';

class Produc {
  String image;
  String name;
  String description;
  double price;

  Produc(this.image, this.name, this.description, this.price);
}

class Product {
  String image;
  String name;
  String description;
  String price;

  Product({this.image, this.name, this.description, this.price});

  factory Product.fromDocument(DocumentSnapshot doc) {
    return Product(
      image: doc['image'],
      name: doc["name"],
      description: doc["description"],
      price: doc["price"],
    );
  }
}
