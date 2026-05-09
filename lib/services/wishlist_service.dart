import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistService extends ChangeNotifier {
  static const String _storageKey = 'wishlist_product_ids';
  final Set<String> _productIds = <String>{};

  Set<String> get productIds => Set.unmodifiable(_productIds);
  int get count => _productIds.length;

  WishlistService() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_storageKey) ?? <String>[];
    _productIds
      ..clear()
      ..addAll(saved);
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, _productIds.toList());
  }

  bool isFavorite(String productId) => _productIds.contains(productId);

  Future<void> toggle(String productId) async {
    if (_productIds.contains(productId)) {
      _productIds.remove(productId);
    } else {
      _productIds.add(productId);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> remove(String productId) async {
    if (_productIds.remove(productId)) {
      notifyListeners();
      await _persist();
    }
  }

  Future<void> clear() async {
    _productIds.clear();
    notifyListeners();
    await _persist();
  }
}
