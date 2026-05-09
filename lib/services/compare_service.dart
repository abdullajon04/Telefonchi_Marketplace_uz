import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CompareService extends ChangeNotifier {
  final List<Product> _compareList = [];

  List<Product> get compareList => List.unmodifiable(_compareList);
  int get count => _compareList.length;
  bool get isFull => _compareList.length >= 3;

  bool isComparing(String productId) =>
      _compareList.any((p) => p.id == productId);

  void toggleCompare(Product product) {
    if (isComparing(product.id)) {
      _compareList.removeWhere((p) => p.id == product.id);
    } else {
      if (isFull) {
        // Remove the oldest to add the new one, or just throw error/ignore.
        // We'll replace the first one.
        _compareList.removeAt(0);
      }
      _compareList.add(product);
    }
    notifyListeners();
  }

  void clear() {
    _compareList.clear();
    notifyListeners();
  }
}
