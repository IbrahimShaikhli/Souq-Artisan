import 'package:ecommerce_app/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/screens/product/product_details_screen.dart';
import '../../config/firebase_service.dart';
import '../../models/cart.dart';
import '../../models/products.dart';
import '../../widgets/Cart_icon_button.dart';
import '../../widgets/product_card.dart';

class SearchResultScreen extends StatelessWidget {
  final List<Products> products;
  final TextEditingController searchController;

  const SearchResultScreen({super.key, 
    required this.products,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    print("Received Products Count: ${products.length}");
    return Scaffold(
      appBar: SearchResultsAppBar(
          searchController: searchController,
          onSearchTapped: (text) {
            // Handle search logic
          }),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
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
      ),
    );
  }
}

class SearchResultsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Function(String) onSearchTapped;

  const SearchResultsAppBar({super.key, 
    required this.searchController,
    required this.onSearchTapped,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            blurRadius: 5,
            color: Colors.grey.withOpacity(0.1),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
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
                  'asset/images/soq.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 10),
              child: GestureDetector(
                onTap: () {
                  onSearchTapped(searchController.text);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        const Icon(Icons.search, color: Colors.white),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: searchController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search Item",
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: whiteColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })),
          const Positioned(
            top: 15,
            right: 20,
            child: CartIconButton(
              iconColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
