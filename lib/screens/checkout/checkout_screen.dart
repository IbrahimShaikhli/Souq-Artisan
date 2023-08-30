import 'package:flutter/material.dart';
import 'package:ecommerce_app/config/firebase_service.dart';
import '../../consts/colors.dart';
import '../../models/cart.dart';
import '../../models/order.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../cart/cart_screen.dart';

class CheckoutScreen extends StatefulWidget {
  static String routeName = '/checkout';

  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CheckoutAppBar(pageTitle: 'Checkout'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: SizedBox(
            height: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Information',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your city',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Payment Information',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: cardNumberController,
                  decoration: const InputDecoration(
                    hintText: 'Card Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: expiryController,
                  decoration: const InputDecoration(
                    hintText: 'Expiry (MM/YY)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: cvcController,
                  decoration: const InputDecoration(
                    hintText: 'CVC',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Product Information',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                const CheckoutProductsSection(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CheckoutBottom(
        addressController: addressController,
        cityController: cityController,
        cardNumberController: cardNumberController,
        expiryController: expiryController,
        cvcController: cvcController,
      ),
    );
  }
}

class CheckoutBottom extends StatelessWidget {
  const CheckoutBottom({
    Key? key,
    required this.addressController,
    required this.cityController,
    required this.cardNumberController,
    required this.expiryController,
    required this.cvcController,
  }) : super(key: key);

  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController cardNumberController;
  final TextEditingController expiryController;
  final TextEditingController cvcController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xffdaddada).withOpacity(0.4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 300,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Order now'),
              onPressed: () async {
                List<Cart> cartItemsList = await FirebaseService.getCartItemsFromFirebase();

                if (cartItemsList.isNotEmpty) {
                  Orders order = Orders(
                    orderId: UniqueKey().toString(),
                    orderedProducts: cartItemsList,
                    address: addressController.text,
                    city: cityController.text,
                    timestamp: DateTime.now(),
                    cardNumber: cardNumberController.text,
                    expiry: expiryController.text,
                    cvc: cvcController.text,
                  );

                  await FirebaseService.placeOrder(order);
                  await FirebaseService.clearCart(); // Clear the cart

                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Order Placed'),
                        content: const Text('Your order has been placed successfully.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const BottomNavBar()));
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutProductsSection extends StatelessWidget {
  const CheckoutProductsSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cart>>(
      future: FirebaseService.getCartItemsFromFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final cartItemsList = snapshot.data!;
          if (cartItemsList.isNotEmpty) {
            return Expanded(
              child: ListView.builder(
                itemCount: cartItemsList.length,
                itemBuilder: (context, index) {
                  return CartItemCard(cart: cartItemsList[index]);
                },
              ),
            );
          } else {
            return const Text('No cart items available.');
          }
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Text('No data available.');
        }
      },
    );
  }
}

class CheckoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;

  const CheckoutAppBar({Key? key, required this.pageTitle}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepOrange, Colors.deepOrangeAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            blurRadius: 5,
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  pageTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
