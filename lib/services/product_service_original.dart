import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/category.dart';

class ProductService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Product> _products = [];

  List<Product> get allProducts => List.unmodifiable(_products);

  ProductService() {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .get();

      _products = snapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: doc.id,
          sellerId: data['sellerId'] ?? '',
          sellerName: data['sellerName'] ?? '',
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          category: ProductCategory.values.firstWhere(
            (c) => c.value == data['category'],
            orElse: () => ProductCategory.smartphones,
          ),
          imagePath: data['imageUrl'] ?? '',
          imageBase64: data['imageBase64'] ?? '',
          stock: data['stock'] ?? 1,
          productModel: data['productModel'] ?? '',
          condition: data['condition'] ?? '',
          colorValue: data['colorValue'],
          year: data['year'],
          location: data['location'] ?? '',
          locationLat: data['locationLat'],
          locationLng: data['locationLng'],
          createdAt: data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
        );
      }).toList();
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
      final docRef = _firestore.collection('products').doc();

      await docRef.set({
        'sellerId': product.sellerId,
        'sellerName': product.sellerName,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'category': product.category.value,
        'imageUrl': '',
        'imageBase64': product.imageBase64,
        'stock': product.stock,
        'productModel': product.productModel,
        'condition': product.condition,
        'colorValue': product.colorValue,
        'year': product.year,
        'location': product.location,
        'locationLat': product.locationLat,
        'locationLng': product.locationLng,
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint('Product added successfully with id: ${docRef.id}');

      final newProduct = product.copyWith(id: docRef.id, imagePath: '');
      _products.insert(0, newProduct);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding product: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      debugPrint('Updating product: ${product.name}, id: ${product.id}');

      await _firestore.collection('products').doc(product.id).update({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'category': product.category.value,
        'imageBase64': product.imageBase64,
        'stock': product.stock,
        'productModel': product.productModel,
        'condition': product.condition,
        'colorValue': product.colorValue,
        'year': product.year,
        'location': product.location,
        'locationLat': product.locationLat,
        'locationLng': product.locationLng,
      });

      debugPrint('Product updated successfully');

      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product.copyWith(imageBase64: product.imageBase64);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
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
      await _firestore.collection('products').doc(productId).update({
        'stock': newStock,
      });

      _products[index] = _products[index].copyWith(stock: newStock);
      notifyListeners();
    } catch (e) {
      debugPrint('Error decrementing stock: $e');
    }
  }
}
