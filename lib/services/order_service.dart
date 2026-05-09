import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as app;
import '../models/cart_item.dart';
import '../services/product_service.dart';

class OrderService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<app.Order> _orders = [];

  List<app.Order> get allOrders => List.unmodifiable(_orders);

  OrderService() {
    // Orders are loaded per user when needed
  }

  Future<void> loadOrdersByBuyer(String buyerId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('buyerId', isEqualTo: buyerId)
          .get();

      _orders = snapshot.docs.map((doc) => _orderFromDoc(doc)).toList();
      _orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading buyer orders: $e');
    }
  }

  Future<void> loadOrdersBySeller(String sellerId) async {
    try {
      final snapshot = await _firestore.collection('orders').get();

      _orders = snapshot.docs
          .map((doc) => _orderFromDoc(doc))
          .where((order) =>
              order.items.any((item) => item.product.sellerId == sellerId))
          .toList();
      _orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading seller orders: $e');
    }
  }

  app.Order _orderFromDoc(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return app.Order(
      id: doc.id,
      buyerId: data['buyerId'] ?? '',
      buyerName: data['buyerName'] ?? '',
      buyerAddress: data['buyerAddress'] ?? '',
      buyerPhone: data['buyerPhone'] ?? '',
      items: (data['items'] as List? ?? [])
          .map((i) => CartItem.fromMap(i as Map<String, dynamic>))
          .toList(),
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0,
      status: app.OrderStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => app.OrderStatus.pending,
      ),
      paymentMethod: app.PaymentMethod.values.firstWhere(
        (p) => p.name == data['paymentMethod'],
        orElse: () => app.PaymentMethod.offline,
      ),
      deliveryMethod: app.DeliveryMethod.values.firstWhere(
        (d) => d.name == data['deliveryMethod'],
        orElse: () => app.DeliveryMethod.yandexGo,
      ),
      deliveryInfo: data['deliveryInfo'] ?? data['trackingNumber'] ?? '',
      deliveryPrice: (data['deliveryPrice'] as num?)?.toDouble() ?? 0,
      estimatedDelivery: data['estimatedDelivery'] != null
          ? DateTime.parse(data['estimatedDelivery'])
          : null,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] is Timestamp
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.tryParse(data['createdAt'].toString()) ??
                  DateTime.now())
          : DateTime.now(),
    );
  }

  Future<app.Order> placeOrder({
    required String buyerId,
    required String buyerName,
    required String buyerAddress,
    required String buyerPhone,
    required List<CartItem> items,
    required double totalAmount,
    required app.PaymentMethod paymentMethod,
    app.DeliveryMethod deliveryMethod = app.DeliveryMethod.yandexGo,
    double deliveryPrice = 0,
    ProductService? productService,
  }) async {
    final docRef = await _firestore.collection('orders').add({
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerAddress': buyerAddress,
      'buyerPhone': buyerPhone,
      'items': items.map((i) => i.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': app.OrderStatus.pending.name,
      'paymentMethod': paymentMethod.name,
      'deliveryMethod': deliveryMethod.name,
      'deliveryInfo': '',
      'deliveryPrice': deliveryPrice,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final order = app.Order(
      id: docRef.id,
      buyerId: buyerId,
      buyerName: buyerName,
      buyerAddress: buyerAddress,
      buyerPhone: buyerPhone,
      items: List.from(items),
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      deliveryMethod: deliveryMethod,
      deliveryPrice: deliveryPrice,
      status: app.OrderStatus.pending,
    );

    _orders.insert(0, order);

    // Stockni kamaytirish
    if (productService != null) {
      for (final item in items) {
        await productService.decrementStock(item.product.id, item.quantity);
      }
    }

    notifyListeners();
    return order;
  }

  List<app.Order> getOrdersByBuyer(String buyerId) {
    return _orders.where((o) => o.buyerId == buyerId).toList();
  }

  List<app.Order> getOrdersBySeller(String sellerId) {
    return _orders
        .where(
          (o) => o.items.any((item) => item.product.sellerId == sellerId),
        )
        .toList();
  }

  /// Yetkazish usuli bo'yicha avtomatik info generatsiya
  String _generateDeliveryInfo(app.DeliveryMethod method) {
    final colors = ['Oq', 'Qora', 'Kumush', 'Ko\'k', 'Qizil', 'Kulrang'];
    final nums =
        List.generate(3, (_) => (DateTime.now().microsecond % 10).toString())
            .join('');
    switch (method) {
      case app.DeliveryMethod.yandexGo:
        final color = colors[DateTime.now().second % colors.length];
        final plate = '${nums[0]}${nums[1]}A${nums[2]}${nums[0]}${nums[1]}DA';
        return 'Yandex Go • $color Cobalt • $plate';
      case app.DeliveryMethod.uzumTezkor:
        return 'Uzum Tezkor • Kuryer #${DateTime.now().millisecond}';
      case app.DeliveryMethod.btsExpress:
        return 'BTS Express • Pochta #BTS${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      case app.DeliveryMethod.pickup:
        return 'Самовывоз';
    }
  }

  Future<void> updateOrderStatus(String orderId, app.OrderStatus status) async {
    try {
      final index = _orders.indexWhere((o) => o.id == orderId);
      final updateData = <String, dynamic>{'status': status.name};

      // Shipped bo'lganda avtomatik deliveryInfo generatsiya
      if (status == app.OrderStatus.shipped && index != -1) {
        final info = _generateDeliveryInfo(_orders[index].deliveryMethod);
        updateData['deliveryInfo'] = info;
      }

      await _firestore.collection('orders').doc(orderId).update(updateData);

      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          status: status,
          deliveryInfo: updateData['deliveryInfo'] as String? ??
              _orders[index].deliveryInfo,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating order status: $e');
    }
  }

  Future<void> confirmDelivery(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': app.OrderStatus.delivered.name,
      });

      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          status: app.OrderStatus.delivered,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error confirming delivery: $e');
    }
  }

  // Seller analytics
  int getTotalProductsSold(String sellerId) {
    int count = 0;
    for (final order in _orders) {
      for (final item in order.items) {
        if (item.product.sellerId == sellerId) {
          count += item.quantity;
        }
      }
    }
    return count;
  }

  double getTotalRevenue(String sellerId) {
    double revenue = 0;
    for (final order in _orders) {
      for (final item in order.items) {
        if (item.product.sellerId == sellerId) {
          revenue += item.totalPrice;
        }
      }
    }
    return revenue;
  }

  int getTotalOrders(String sellerId) {
    return getOrdersBySeller(sellerId).length;
  }
}
