import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/screens/cart/bloc/cart_bloc.dart'; // Import your CartBloc
import 'package:ecommerce_app/models/cart.dart';
import '../../consts/colors.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CartBloc>(context).add(FetchCartItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(color: blackColor),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                itemCount: state.cartItems.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE6E6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        children: [Spacer(), Icon(Icons.delete)],
                      ),
                    ),
                    onDismissed: (direction) {
                      BlocProvider.of<CartBloc>(context).add(
                        RemoveCartItem(state.cartItems[index]),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Item removed from cart")),
                      );
                    },
                    child: CartItemCard(cart: state.cartItems[index]),
                  ),
                ),
              ),
            );
          } else if (state is CartError) {
            return const Text('An error occurred');
          }
          return Container();
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            double totalAmount = state.cartItems.fold(
              0, (sum, item) => sum + (item.products.price * item.numOfItems),
            );

            return CheckoutBottom(cartItems: state.cartItems, totalAmount: totalAmount);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class CheckoutBottom extends StatelessWidget {
  final List<Cart> cartItems;
  final double totalAmount;

  const CheckoutBottom({super.key, 
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    bool isCartEmpty = cartItems.isEmpty; // Check if the cart is empty

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
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.receipt,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
                const Spacer(),
                const Text('Add voucher code'),
                const SizedBox(
                  width: 10,
                ),
                const Icon(Icons.arrow_right),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Total:\n',
                    children: [
                      TextSpan(
                        text: 'AED ${totalAmount.toStringAsFixed(2)}', // Use the provided totalAmount
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 190,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCartEmpty
                          ? Colors.grey // Change color if cart is empty
                          : Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isCartEmpty
                        ? null // Disable button if cart is empty
                        : () {
                      Navigator.pushNamed(context, '/checkout');
                    },
                    child: const Text('Checkout'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class CartItemCard extends StatelessWidget {
  final Cart cart;

  const CartItemCard({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(cart.products.productImage),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              cart.products.title,
              style: const TextStyle(fontSize: 16),
            ),
            Text.rich(
              TextSpan(
                text: "AED ${cart.products.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.deepOrange,
                ),
                children: [
                  TextSpan(
                    text: " x${cart.numOfItems}",
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
