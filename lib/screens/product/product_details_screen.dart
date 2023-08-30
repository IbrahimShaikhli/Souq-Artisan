import 'package:flutter/material.dart';
import '../../config/firebase_service.dart';
import '../../models/cart.dart';
import '../../models/products.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = '/details';

  const ProductDetailsScreen({super.key});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final GlobalKey<_QuantityTextState> _quantityTextKey = GlobalKey();
  int quantity = 1; // Initialize the quantity to 1

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments args =
    ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    final product = args.product;

    final double imageHeight = MediaQuery.of(context).size.height * 0.6;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Implement bag button behavior
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: imageHeight,
              child: Image.asset(
                product.productImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize:
            (1.0 * imageHeight) / MediaQuery.of(context).size.height,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, -5),
                      blurRadius: 10,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDragIndicator(context),
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        product.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price: AED ${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18, color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              // Decrease the quantity logic
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                                _quantityTextKey.currentState!.updateQuantity(quantity);
                              }
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          const SizedBox(width: 20),
                          QuantityText(
                            key: _quantityTextKey,
                            quantity: quantity,
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            onPressed: () {
                              // Increase the quantity logic
                              setState(() {
                                quantity++;
                              });
                              _quantityTextKey.currentState!.updateQuantity(quantity);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 30,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: InkWell(
                onTap: () async {
                  // Create a new Cart instance with the selected product and quantity
                  Cart cartItem = Cart(products: product, numOfItems: quantity);

                  // Add the cart item to Firebase
                  await FirebaseService.addCartItemToFirebase(cartItem);

                  // Display a success message or navigate to a confirmation screen
                  // For example:
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product added to cart')));
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragIndicator(BuildContext context) {
    return Center(
      child: Container(
        width: 50,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(2),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}

class QuantityText extends StatefulWidget {
  final int quantity;
  const QuantityText({Key? key, required this.quantity}) : super(key: key);

  @override
  _QuantityTextState createState() => _QuantityTextState();
}

class _QuantityTextState extends State<QuantityText> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
  }

  void updateQuantity(int newQuantity) {
    setState(() {
      _quantity = newQuantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _quantity.toString(), // Display the updated quantity
      style: const TextStyle(fontSize: 18),
    );
  }
}

class ProductDetailsArguments {
  final Products product;

  ProductDetailsArguments({required this.product});
}
