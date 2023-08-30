import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app/config/firebase_service.dart';
import '../../models/cart.dart';
import '../../models/category.dart';
import '../../models/products.dart';
import '../../widgets/Cart_icon_button.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_title.dart';
import '../product/product_details_screen.dart';
import '../product/search_result_screen.dart';
import 'category_product_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Products> fetchedProducts = [];
  List<Products> filteredProducts = [];
  TextEditingController searchController = TextEditingController();
  List<Products> homeScreenProducts = []; // Separate list for home screen

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    List<dynamic> productsList =
        await FirebaseService.getProductsFromFirebase();

    setState(() {
      fetchedProducts = productsList.cast<Products>();
      filteredProducts = List.from(fetchedProducts);
      homeScreenProducts = List.from(fetchedProducts);
    });
  }

  void filterProducts(String query) {
    print("Filtering products for query: $query");
    setState(() {
      if (query.isEmpty) {
        filteredProducts = List.from(fetchedProducts);
      } else {
        filteredProducts = fetchedProducts.where((product) {
          final titleContainsQuery =
              product.title.toLowerCase().contains(query.toLowerCase());
          print("${product.title} - Contains query? $titleContainsQuery");
          return titleContainsQuery;
        }).toList();
      }
      print("Filtered Products Count: ${filteredProducts.length}");
    });
  }

  void handleSearchTapped() {
    print("Search tapped. Query: ${searchController.text}");
    filterProducts(
        searchController.text); // Apply filtering to the search results
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultScreen(
          products:
              filteredProducts, // Pass filtered products to the search results page
          searchController: searchController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        searchController: searchController,
        onSearchTapped: (query) {
          filterProducts(query);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultScreen(
                products: filteredProducts,
                searchController: searchController,
              ),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            ProductsBanner(),
            SectionTitle(
              sectionName: 'Categories',
              pressMore: () {
                Navigator.pushNamed(context, "/all_categories");
              },
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: demoCategories.length,
                      itemBuilder: (context, index) {
                        final category = demoCategories[index];
                        return CategoryCard(
                          title: category.title,
                          image: category.categoryImage,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryProductsScreen(category, categoryImage: category.categoryImage,)
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SectionTitle(
              sectionName: 'Products',
              pressMore: () {
                Navigator.pushNamed(context, "/all_products");
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homeScreenProducts.length,
                itemBuilder: (context, index) {
                  final product = homeScreenProducts[index];
                  return ProductCard(
                    products: product,
                    press: () {
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
                        SnackBar(
                            content: Text('Added to Cart: ${product.title}')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsBanner extends StatelessWidget {
  final List<String> sliderImages = [
    'asset/images/slider1.png',
    'asset/images/slider2.png',
    'asset/images/slider3.png',
    'asset/images/slider4.png',
  ];

  ProductsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
      ),
      items: sliderImages.map((imagePath) {
        return Container(
          width: double.infinity,
          height: 200,
          alignment: Alignment.center,
          child: Image.asset(
            imagePath,
            height: 150,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String image;
  final GestureTapCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 10.0),
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10,
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Function(String) onSearchTapped;

  const CustomAppBar({super.key, 
    required this.searchController,
    required this.onSearchTapped,
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
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
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


