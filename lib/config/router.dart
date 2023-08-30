import 'package:ecommerce_app/screens/checkout/checkout_screen.dart';
import 'package:ecommerce_app/screens/product/all_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/screens/screens.dart';
import '../screens/home/all_categories_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  ForgetPasswordScreen.routeName: (context) => ForgetPasswordScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  ProductDetailsScreen.routeName: (context) => const ProductDetailsScreen(),
  AllCategoriesScreen.routeName: (context) => const AllCategoriesScreen(),
  AllProductsScreen.routeName: (context) => const AllProductsScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  CheckoutScreen.routeName: (context) => const CheckoutScreen()
};