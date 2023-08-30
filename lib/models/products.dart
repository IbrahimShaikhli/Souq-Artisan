import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  final int id;
  final String title, description;
  final int categoryId;
  final double price, rating;
  final bool isPopular, isSpecial;
  final String productImage;

  Products({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.rating,
    required this.description,
    required this.price,
    required this.isPopular,
    required this.isSpecial,
    required this.productImage,
  });

  // Convert product data to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category' : categoryId,
      'rating': rating,
      'description': description,
      'price': price,
      'isPopular': isPopular,
      'isSpecial': isSpecial,
      'productImage': productImage,
    };
  }

  // Factory method to create a product from a map
  factory Products.fromMap(Map<String, dynamic> map) {
    return Products(
      id: map['id'],
      title: map['title'],
      categoryId: map['category'],
      rating: map['rating'],
      description: map['description'],
      price: map['price'],
      isPopular: map['isPopular'],
      isSpecial: map['isSpecial'],
      productImage: map['productImage'],
    );
  }

  // Factory method to create a product from a document snapshot
  factory Products.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Products.fromMap(data);
  }
}
