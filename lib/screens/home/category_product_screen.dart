import 'package:flutter/material.dart';

import '../../config/firebase_service.dart';
import '../../models/cart.dart';
import '../../models/category.dart';
import '../../models/products.dart';
import '../../widgets/Cart_icon_button.dart';
import '../../widgets/product_card.dart';
import '../product/product_details_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  final Category category; // Assuming you have a 'Category' object
  final String categoryImage;
  const CategoryProductsScreen(this.category, {super.key, required this.categoryImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CategoryProductsAppBar(category: category, categoryImage: categoryImage ),
      body: FutureBuilder<List<Products>>(
        future: FirebaseService.getProductsFromFirebase(), // Fetch all products
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Filter products by category
            List<Products> categoryProducts = snapshot.data!
                .where((product) => product.categoryId == category.id)
                .toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: categoryProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = categoryProducts[index];
                  return ProductCard(
                    products: product,
                    press: () async {
                      Navigator.pushNamed(
                        context,
                        ProductDetailsScreen.routeName,
                        arguments: ProductDetailsArguments(product: product),
                      );
                    },
                    addToCartPress: () async {
                      await FirebaseService.addCartItemToFirebase(
                        Cart(products: product, numOfItems: 1),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added to Cart: ${product.title}')),
                      );
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}





class CategoryProductsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Category category;
  final String categoryImage;

  const CategoryProductsAppBar({Key? key, required this.category, required this.categoryImage})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(90);

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
          bottomLeft: Radius.circular(45),
          bottomRight: Radius.circular(45),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            blurRadius: 5,
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepOrange, Colors.deepOrangeAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45),
                  bottomRight: Radius.circular(45),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  categoryImage, // Use the provided category image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Spacer(),
                    Text(
                      category.title, // Display category title
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const CartIconButton(iconColor: Colors.white),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

