import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  final User? user;

  const OrderHistoryScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchase History', style: TextStyle(
        color: blackColor
      ),)),
      body: Column( // Wrap in a Column if you need to add other widgets
        children: [
          MyOrders(user: user),
          // Other widgets can be added here
        ],
      ),
    );
  }
}


class MyOrders extends StatelessWidget {
  const MyOrders({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('orders')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> orders =
                snapshot.data!.docs;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> orderData = orders[index].data();
                List<dynamic> orderedProducts = orderData['orderedProducts'];

                String address = orderData['address'] ?? 'N/A';
                String city = orderData['city'] ?? 'N/A';

                return Card(
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Address: $address'),
                        subtitle: Text('City: $city'),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: orderedProducts.map<Widget>((productData) {
                          return ListTile(
                            leading: AspectRatio(
                              aspectRatio: 1,
                              child: Image.asset(
                                  productData['product']['productImage']),
                            ),
                            title: Text(productData['product']['title']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Price: ${productData['product']['price']}'),
                                Text('Quantity: ${productData['numOfItems']}'),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Text('Error loading orders');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
