import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PriceAlert {
  final String id;
  final String productModel;
  final double targetPrice;
  bool isTriggered;

  PriceAlert({
    required this.id,
    required this.productModel,
    required this.targetPrice,
    this.isTriggered = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'productModel': productModel,
        'targetPrice': targetPrice,
        'isTriggered': isTriggered,
      };

  factory PriceAlert.fromMap(Map<String, dynamic> map) => PriceAlert(
        id: map['id'],
        productModel: map['productModel'],
        targetPrice: map['targetPrice'],
        isTriggered: map['isTriggered'] ?? false,
      );
}

class AlertService extends ChangeNotifier {
  static const String _storageKey = 'price_alerts';
  final List<PriceAlert> _alerts = [];

  List<PriceAlert> get alerts => List.unmodifiable(_alerts);

  AlertService() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_storageKey);
    if (saved != null) {
      _alerts.clear();
      for (final s in saved) {
        _alerts.add(PriceAlert.fromMap(jsonDecode(s)));
      }
      notifyListeners();
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _alerts.map((a) => jsonEncode(a.toMap())).toList();
    await prefs.setStringList(_storageKey, encoded);
  }

  Future<void> addAlert(String productModel, double targetPrice) async {
    final alert = PriceAlert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productModel: productModel,
      targetPrice: targetPrice,
    );
    _alerts.add(alert);
    notifyListeners();
    await _persist();
  }

  Future<void> removeAlert(String id) async {
    _alerts.removeWhere((a) => a.id == id);
    notifyListeners();
    await _persist();
  }

  Future<void> markAsTriggered(String id) async {
    final idx = _alerts.indexWhere((a) => a.id == id);
    if (idx != -1) {
      _alerts[idx].isTriggered = true;
      notifyListeners();
      await _persist();
    }
  }
}
