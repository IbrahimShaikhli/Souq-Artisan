import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart.dart';
import '../models/products.dart';
import 'package:ecommerce_app/models/order.dart';

class FirebaseService {
  // Function to get a list of products from Firebase
  static Future<List<Products>> getProductsFromFirebase() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('products').get();

    List<Products> productsList = snapshot.docs
        .map((DocumentSnapshot doc) => Products.fromSnapshot(doc))
        .toList();

    return productsList;
  }

  // Function to add a new product to Firebase
  static Future<void> addProductToFirebase(
      Map<String, dynamic> productData) async {
    await FirebaseFirestore.instance.collection('products').add(productData);
  }

  static Future<void> addCartItemToFirebase(Cart cartItem) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc();
      await cartRef.set({
        'product': cartItem.products.toMap(), // Convert product to map
        'numOfItems': cartItem.numOfItems,
      });
    }
  }

  static Future<List<Cart>> getCartItemsFromFirebase() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      List<Cart> cartItemsList = snapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Cart(
          docId: doc.id,
          products: Products.fromMap(data['product']),
          numOfItems: data['numOfItems'],
        );
      }).toList();

      return cartItemsList;
    } else {
      return []; // Return an empty list or handle not authenticated users
    }
  }

  static Future<void> removeCartItemFromFirebase(Cart cartItem) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(cartItem.docId);
      await cartRef.delete();
    }
  }

  static Future<void> placeOrder(Orders order) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference orderRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc();
      await orderRef.set({
        'orderId': order.orderId,
        'orderedProducts':
            order.orderedProducts.map((cart) => cart.toMap()).toList(),
        'address': order.address,
        'city': order.city,
        'timestamp': order.timestamp,
        'cardNumber' : order.cardNumber,
        'expiry' : order.expiry,
        'cvc' : order.cvc
      });
    }
  }
  static Future<void> clearCart() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference cartCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');

      QuerySnapshot snapshot = await cartCollection.get();

      // Delete all cart items
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }
  }

}
