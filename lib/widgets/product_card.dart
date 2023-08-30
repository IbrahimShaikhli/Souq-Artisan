import 'package:flutter/material.dart';
import '../models/products.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.productWidth = 160, // Increased the productWidth
    this.aspectRatio = 1.2, // Increased the aspectRatio
    required this.products,
    required this.press,
    required this.addToCartPress,
  }) : super(key: key);

  final double productWidth, aspectRatio;
  final Products products;
  final GestureTapCallback press;
  final GestureTapCallback addToCartPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: productWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10), // Increased padding
              width: 140, // Increased the width
              height: 140, // Increased the height
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(products.productImage, fit: BoxFit.contain), // Adjusted the image fit
            ),
            const SizedBox(height: 5),
            Text(
              products.title,
              style: const TextStyle(fontSize: 17),
              maxLines: 2,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "AED ${products.price}",
                  style: const TextStyle(color: Colors.red),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: addToCartPress,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_shopping_cart),
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
