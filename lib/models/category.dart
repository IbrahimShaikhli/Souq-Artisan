
class Category {
  final int id;
  final String title;
  final String description;
  final String categoryImage;

  Category({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryImage,
  });
}

List<Category> demoCategories = [
  Category(
    id: 1,
    title: 'Clothing',
    description: 'Explore a wide range of clothing items',
    categoryImage: 'asset/images/clothes.jpg',
  ),
  Category(
    id: 2,
    title: 'Jewelry',
    description: 'Discover unique artisanal jewelry pieces',
    categoryImage: 'asset/images/jewerly.jpg',
  ),
  Category(
    id: 3,
    title: 'Home Decor',
    description: 'Enhance your living space with handmade decor',
    categoryImage: 'asset/images/Artisan-Decor.jpg',
  ),
];

