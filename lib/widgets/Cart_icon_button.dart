import 'package:flutter/material.dart';

class CartIconButton extends StatelessWidget {
  final Color iconColor;

  const CartIconButton({super.key, 
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/cart");
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.shopping_cart,
          color: iconColor,
        ),
      ),
    );
  }
}
