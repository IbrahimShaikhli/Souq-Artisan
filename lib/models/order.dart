import 'cart.dart';

class Orders {
  final String orderId;
  final List<Cart> orderedProducts;
  final String address;
  final String city;
  final String cardNumber; // Add card number field
  final String expiry;     // Add expiry field
  final String cvc;        // Add cvc field
  final DateTime timestamp;

  Orders({
    required this.orderId,
    required this.orderedProducts,
    required this.address,
    required this.city,
    required this.cardNumber,
    required this.expiry,
    required this.cvc,
    required this.timestamp,
  });
}
