import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../data/mock_products_simple.dart';

class ProductService extends ChangeNotifier {
  List<Product> _products = [];

  List<Product> get allProducts => List.unmodifiable(_products);

  ProductService() {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      // Mock ma'lumotlardan foydalanamiz
      _products = MockProducts.getProducts();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading products: $e');
      }
    }
  }

  Future<void> refreshProducts() async {
    await _loadProducts();
  }

  List<Product> getProductsBySeller(String sellerId) {
    return _products.where((p) => p.sellerId == sellerId).toList();
  }

  List<Product> getProductsByCategory(ProductCategory category) {
    return _products.where((p) => p.category == category).toList();
  }

  List<Product> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return _products
        .where(
          (p) =>
              p.name.toLowerCase().contains(lowerQuery) ||
              p.description.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  List<Product> filterByPrice(double minPrice, double maxPrice) {
    return _products
        .where((p) => p.price >= minPrice && p.price <= maxPrice)
        .toList();
  }

  List<Product> searchAndFilter({
    String? query,
    ProductCategory? category,
    double? minPrice,
    double? maxPrice,
    String? condition,
    String? productModel,
  }) {
    var results = List<Product>.from(_products);

    if (query != null && query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      results = results
          .where(
            (p) =>
                p.name.toLowerCase().contains(lowerQuery) ||
                p.description.toLowerCase().contains(lowerQuery) ||
                p.productModel.toLowerCase().contains(lowerQuery) ||
                p.sellerName.toLowerCase().contains(lowerQuery),
          )
          .toList();
    }

    if (category != null) {
      results = results.where((p) => p.category == category).toList();
    }

    if (minPrice != null) {
      results = results.where((p) => p.price >= minPrice).toList();
    }

    if (maxPrice != null) {
      results = results.where((p) => p.price <= maxPrice).toList();
    }

    if (condition != null && condition.isNotEmpty) {
      results = results.where((p) => p.condition == condition).toList();
    }

    if (productModel != null && productModel.isNotEmpty) {
      results = results.where((p) => p.productModel == productModel).toList();
    }

    return results;
  }

  Future<void> addProduct(Product product) async {
    try {
      debugPrint(
          'Adding product: ${product.name}, sellerId: ${product.sellerId}');

      // Mock ma'lumotlarga qo'shamiz
      final newProduct = product.copyWith(
          id: DateTime.now().millisecondsSinceEpoch.toString());
      _products.insert(0, newProduct);
      notifyListeners();

      debugPrint('Product added successfully');
    } catch (e) {
      debugPrint('Error adding product: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      debugPrint('Updating product: ${product.name}, id: ${product.id}');

      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }

      debugPrint('Product updated successfully');
    } catch (e) {
      debugPrint('Error updating product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      _products.removeWhere((p) => p.id == productId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting product: $e');
    }
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Zakaz berilganda stockni kamaytirish
  Future<void> decrementStock(String productId, int quantity) async {
    try {
      final index = _products.indexWhere((p) => p.id == productId);
      if (index == -1) return;

      final newStock = (_products[index].stock - quantity).clamp(0, 999999);
      _products[index] = _products[index].copyWith(stock: newStock);
      notifyListeners();
    } catch (e) {
      debugPrint('Error decrementing stock: $e');
    }
  }
}
