import 'dart:convert';
import 'cart_item.dart';

enum OrderStatus {
  pending('В ожидании'),
  processing('В обработке'),
  shipped('Отправлен'),
  delivered('Доставлен'),
  cancelled('Отменён');

  final String displayName;
  const OrderStatus(this.displayName);
}

enum PaymentMethod {
  online('Онлайн оплата'),
  offline('Оплата при получении');

  final String displayName;
  const PaymentMethod(this.displayName);
}

enum DeliveryMethod {
  pickup('Самовывоз'),
  yandexGo('Yandex Go (шахар ичи)'),
  uzumTezkor('Uzum Tezkor (шахар ичи)'),
  btsExpress('BTS Express (бошқа вилоятлар)');

  final String displayName;
  const DeliveryMethod(this.displayName);
}

class Order {
  final String id;
  final String buyerId;
  final String buyerName;
  final String buyerAddress;
  final String buyerPhone;
  final List<CartItem> items;
  final double totalAmount;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final DeliveryMethod deliveryMethod;
  final String deliveryInfo; // avtomatik yetkazish ma'lumoti
  final double deliveryPrice;
  final DateTime? estimatedDelivery;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.buyerAddress,
    required this.buyerPhone,
    required this.items,
    required this.totalAmount,
    this.status = OrderStatus.pending,
    required this.paymentMethod,
    this.deliveryMethod = DeliveryMethod.yandexGo,
    this.deliveryInfo = '',
    this.deliveryPrice = 0,
    this.estimatedDelivery,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Order copyWith({
    String? id,
    String? buyerId,
    String? buyerName,
    String? buyerAddress,
    String? buyerPhone,
    List<CartItem>? items,
    double? totalAmount,
    OrderStatus? status,
    PaymentMethod? paymentMethod,
    DeliveryMethod? deliveryMethod,
    String? deliveryInfo,
    double? deliveryPrice,
    DateTime? estimatedDelivery,
    DateTime? createdAt,
  }) {
    return Order(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      buyerAddress: buyerAddress ?? this.buyerAddress,
      buyerPhone: buyerPhone ?? this.buyerPhone,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      deliveryInfo: deliveryInfo ?? this.deliveryInfo,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerAddress': buyerAddress,
      'buyerPhone': buyerPhone,
      'items': items.map((i) => i.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status.name,
      'paymentMethod': paymentMethod.name,
      'deliveryMethod': deliveryMethod.name,
      'deliveryInfo': deliveryInfo,
      'deliveryPrice': deliveryPrice,
      'estimatedDelivery': estimatedDelivery?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] ?? '',
      buyerId: map['buyerId'] ?? '',
      buyerName: map['buyerName'] ?? '',
      buyerAddress: map['buyerAddress'] ?? '',
      buyerPhone: map['buyerPhone'] ?? '',
      items: (map['items'] as List).map((i) => CartItem.fromMap(i)).toList(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (p) => p.name == map['paymentMethod'],
        orElse: () => PaymentMethod.offline,
      ),
      deliveryMethod: DeliveryMethod.values.firstWhere(
        (d) => d.name == map['deliveryMethod'],
        orElse: () => DeliveryMethod.yandexGo,
      ),
      deliveryInfo: map['deliveryInfo'] ?? map['trackingNumber'] ?? '',
      deliveryPrice: (map['deliveryPrice'] as num?)?.toDouble() ?? 0,
      estimatedDelivery: map['estimatedDelivery'] != null
          ? DateTime.parse(map['estimatedDelivery'])
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());
  factory Order.fromJson(String json) => Order.fromMap(jsonDecode(json));
}
