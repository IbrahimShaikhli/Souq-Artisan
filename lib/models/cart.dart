import 'models.dart';

class Cart {
  final String docId;
  final Products products;
  final int numOfItems;

  Cart({
    this.docId = '', // Make docId parameter optional with default value
    required this.products,
    required this.numOfItems,
  });

  // Factory method to create a cart from a map
  factory Cart.fromMap(String docId, Map<String, dynamic> map) {
    return Cart(
      docId: docId,
      products: Products.fromMap(map['product']),
      numOfItems: map['numOfItems'],
    );
  }

  // Convert cart to a map
  Map<String, dynamic> toMap() {
    return {
      'product': products.toMap(), // Make sure the Products class has a toMap method
      'numOfItems': numOfItems,
    };
  }
}
