import 'package:ecommerce_app/screens/product/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/widgets/product_card.dart';
import '../../config/firebase_service.dart';
import '../../models/cart.dart';
import '../../models/products.dart';
import '../../widgets/Cart_icon_button.dart'; // Import the necessary widgets

class AllProductsScreen extends StatefulWidget {
  static const routeName = '/all_products';

  const AllProductsScreen({super.key});

  @override
  _AllProductsScreenState createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  TextEditingController searchController = TextEditingController();
  List<Products> fetchedProducts = [];
  List<Products> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    List<dynamic> productsList =
    await FirebaseService.getProductsFromFirebase();

    setState(() {
      fetchedProducts = productsList.cast<Products>();
      filteredProducts = List.from(fetchedProducts);
    });
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = List.from(fetchedProducts);
      });
    } else {
      setState(() {
        filteredProducts = fetchedProducts.where((product) {
          final titleContainsQuery =
          product.title.toLowerCase().contains(query.toLowerCase());
          return titleContainsQuery;
        }).toList();
      });
    }
  }

  void handleSearchTapped(String query) {
    filterProducts(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AllProductsAppBar(
        searchController: searchController,
        onSearchTapped: handleSearchTapped,
        pageTitle: 'All products',
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
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
                      Cart cartItem = Cart(products: product, numOfItems: 1);
                      await FirebaseService.addCartItemToFirebase(cartItem);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product added to cart')),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class AllProductsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Function(String) onSearchTapped;
  final String pageTitle;

  const AllProductsAppBar({super.key, 
    required this.searchController,
    required this.onSearchTapped,
    required this.pageTitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(120);

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
          Container(
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
          Positioned(
            top: 15,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop(); // Navigate back
              },
            ),
          ),
          const Positioned(
            top: 15,
            right: 20,
            child: CartIconButton(
              iconColor: Colors.white,
            ),
          ),
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                pageTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 45,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                onSearchTapped(searchController.text);
              },
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white,
                      width: 1.5,
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
        ],
      ),
    );
  }
}
