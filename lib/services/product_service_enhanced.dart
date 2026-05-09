import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../data/mock_products.dart';
import '../data/mock_sellers.dart';

class ProductService extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<Product> _featuredProducts = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  List<Product> get featuredProducts => _featuredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ProductService() {
    loadProducts();
  }

  // Mahsulotlarni yuklash
  Future<void> loadProducts() async {
    _setLoading(true);
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      _products = MockProducts.getProducts();
      _filteredProducts = List.from(_products);
      _featuredProducts = MockProducts.getFeaturedProducts();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load products: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Qidiruv va filtratsiya
  List<Product> searchAndFilter({
    String? query,
    ProductCategory? category,
    double? minPrice,
    double? maxPrice,
    String? condition,
    String? brand,
    double? minRating,
    bool? inStock,
  }) {
    var results = List<Product>.from(_products);

    // Text search
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      results = results
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q) ||
              p.model.toLowerCase().contains(q) ||
              p.brand.toLowerCase().contains(q) ||
              p.sellerName.toLowerCase().contains(q))
          .toList();
    }

    // Category filter
    if (category != null) {
      results = results.where((p) => p.category == category).toList();
    }

    // Price range filter
    if (minPrice != null) {
      results = results.where((p) => p.price >= minPrice).toList();
    }
    if (maxPrice != null) {
      results = results.where((p) => p.price <= maxPrice).toList();
    }

    // Condition filter
    if (condition != null) {
      results = results.where((p) => p.condition == condition).toList();
    }

    // Brand filter
    if (brand != null) {
      results = results.where((p) => p.brand == brand).toList();
    }

    // Rating filter
    if (minRating != null) {
      results = results.where((p) => p.rating >= minRating).toList();
    }

    // Stock filter
    if (inStock == true) {
      results = results.where((p) => p.stock > 0).toList();
    }

    _filteredProducts = results;
    notifyListeners();
    return results;
  }

  // Kategoriyaga oid mahsulotlar
  List<Product> getProductsByCategory(ProductCategory category) {
    return _products.where((p) => p.category == category).toList();
  }

  // Brendga oid mahsulotlar
  List<Product> getProductsByBrand(String brand) {
    return _products.where((p) => p.brand == brand).toList();
  }

  // Mahsulotni ID bo'yicha olish
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Sotuvchining mahsulotlari
  List<Product> getProductsBySeller(String sellerId) {
    return _products.where((p) => p.sellerId == sellerId).toList();
  }

  // O'xshash mahsulotlar
  List<Product> getSimilarProducts(Product product, {int limit = 5}) {
    return _products
        .where((p) =>
            p.id != product.id &&
            (p.category == product.category || p.brand == product.brand))
        .take(limit)
        .toList();
  }

  // Trend mahsulotlar
  List<Product> getTrendingProducts({int limit = 10}) {
    // Sort by rating and reviews count
    final sorted = List<Product>.from(_products);
    sorted.sort((a, b) {
      final scoreA = a.rating * a.reviews;
      final scoreB = b.rating * b.reviews;
      return scoreB.compareTo(scoreA);
    });
    return sorted.take(limit).toList();
  }

  // Yangi mahsulotlar
  List<Product> getNewProducts({int limit = 10}) {
    final sorted = List<Product>.from(_products);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(limit).toList();
  }

  // Chegirma mahsulotlari (simulated)
  List<Product> getDiscountProducts({int limit = 10}) {
    // Simulate discount by showing some products with "special" condition
    return _products
        .where((p) => p.condition == 'Новое' && p.stock > 5)
        .take(limit)
        .toList();
  }

  // Mahsulotni yangilash
  Future<void> updateProduct(Product product) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        _filteredProducts = List.from(_products);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update product: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Mahsulotni qo'shish
  Future<void> addProduct(Product product) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _products.insert(0, product);
      _filteredProducts = List.from(_products);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add product: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Mahsulotni o'chirish
  Future<void> deleteProduct(String productId) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _products.removeWhere((p) => p.id == productId);
      _filteredProducts = List.from(_products);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete product: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Narx oralig'ini olish
  Map<String, double> getPriceRange() {
    if (_products.isEmpty) {
      return {'min': 0.0, 'max': 0.0};
    }

    final prices = _products.map((p) => p.price).toList();
    prices.sort();

    return {
      'min': prices.first,
      'max': prices.last,
    };
  }

  // Barcha brendlar ro'yxati
  List<String> getAllBrands() {
    final brands = _products.map((p) => p.brand).toSet().toList();
    brands.sort();
    return brands;
  }

  // Mahsulotlarni yangilash (refresh)
  Future<void> refresh() async {
    await loadProducts();
  }

  // Loading state ni boshqarish
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Xatolikni tozalash
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
