// import 'package:flutter/material.dart';
// import '../models/products.dart';
// import '../models/category.dart';
//
// class ProductSearch {
//   static List<Products> searchAndFilterProducts({
//     required List<Products> allProducts,
//     required List<Category> allCategories,
//     String searchText = '',
//     String selectedCategory = 'All',
//   }) {
//     List<Products> filteredProducts = allProducts;
//
//     if (selectedCategory != 'All') {
//       final selectedCategoryId = allCategories
//           .firstWhere((category) => category.title == selectedCategory)
//           .id;
//
//       filteredProducts = filteredProducts
//           .where((product) => product.categoryId == selectedCategoryId)
//           .toList();
//     }
//
//     if (searchText.isNotEmpty) {
//       filteredProducts = filteredProducts
//           .where((product) =>
//           product.title.toLowerCase().contains(searchText.toLowerCase()))
//           .toList();
//     }
//
//     return filteredProducts;
//   }
// }
