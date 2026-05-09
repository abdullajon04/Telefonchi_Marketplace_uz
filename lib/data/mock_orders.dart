import '../models/order.dart';

class MockOrders {
  static List<Order> getOrders() {
    return [
      Order(
        id: 'order1',
        buyerId: 'buyer1',
        sellerId: 'seller1',
        products: [
          OrderProduct(
            productId: '1',
            name: 'iPhone 15 Pro Max',
            price: 1299.99,
            quantity: 1,
            imageUrl: 'https://example.com/iphone15pro.jpg',
          ),
        ],
        totalAmount: 1299.99,
        status: OrderStatus.delivered,
        deliveryAddress: DeliveryAddress(
          street: 'Улица Амира Темура',
          house: '123',
          apartment: '45',
          city: 'Ташкент',
          district: 'Мирзо-Улугбекский',
          postalCode: '100000',
        ),
        paymentMethod: PaymentMethod.cash,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        deliveredAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Order(
        id: 'order2',
        buyerId: 'buyer2',
        sellerId: 'seller2',
        products: [
          OrderProduct(
            productId: '3',
            name: 'Samsung Galaxy S24 Ultra',
            price: 1199.99,
            quantity: 1,
            imageUrl: 'https://example.com/s24ultra.jpg',
          ),
          OrderProduct(
            productId: '4',
            name: 'Samsung Galaxy A54',
            price: 349.99,
            quantity: 2,
            imageUrl: 'https://example.com/a54.jpg',
          ),
        ],
        totalAmount: 1899.97,
        status: OrderStatus.shipped,
        deliveryAddress: DeliveryAddress(
          street: 'Улица Буюк Ипак йули',
          house: '56',
          apartment: '12',
          city: 'Ташкент',
          district: 'Чиланзарский',
          postalCode: '100001',
        ),
        paymentMethod: PaymentMethod.card,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        shippedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Order(
        id: 'order3',
        buyerId: 'buyer3',
        sellerId: 'seller3',
        products: [
          OrderProduct(
            productId: '5',
            name: 'Xiaomi 14 Ultra',
            price: 999.99,
            quantity: 1,
            imageUrl: 'https://example.com/mi14ultra.jpg',
          ),
        ],
        totalAmount: 999.99,
        status: OrderStatus.processing,
        deliveryAddress: DeliveryAddress(
          street: 'Улица Афросиаб',
          house: '78',
          apartment: '23',
          city: 'Самарканд',
          district: 'Центральный',
          postalCode: '140100',
        ),
        paymentMethod: PaymentMethod.click,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Order(
        id: 'order4',
        buyerId: 'buyer1',
        sellerId: 'seller4',
        products: [
          OrderProduct(
            productId: '7',
            name: 'Huawei P60 Pro',
            price: 899.99,
            quantity: 1,
            imageUrl: 'https://example.com/p60pro.jpg',
          ),
        ],
        totalAmount: 899.99,
        status: OrderStatus.pending,
        deliveryAddress: DeliveryAddress(
          street: 'Улица Навои',
          house: '34',
          apartment: '67',
          city: 'Бухара',
          district: 'Исторический центр',
          postalCode: '200100',
        ),
        paymentMethod: PaymentMethod.payme,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      Order(
        id: 'order5',
        buyerId: 'buyer2',
        sellerId: 'seller5',
        products: [
          OrderProduct(
            productId: '8',
            name: 'OnePlus 12',
            price: 799.99,
            quantity: 1,
            imageUrl: 'https://example.com/oneplus12.jpg',
          ),
          OrderProduct(
            productId: '10',
            name: 'Nothing Phone (2)',
            price: 599.99,
            quantity: 1,
            imageUrl: 'https://example.com/nothing2.jpg',
          ),
        ],
        totalAmount: 1399.98,
        status: OrderStatus.cancelled,
        deliveryAddress: DeliveryAddress(
          street: 'Улица Ислама Каримова',
          house: '90',
          apartment: '15',
          city: 'Фергана',
          district: 'Ферганский',
          postalCode: '150100',
        ),
        paymentMethod: PaymentMethod.cash,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        cancelledAt: DateTime.now().subtract(const Duration(days: 8)),
        cancellationReason: 'Покупатель отказался от заказа',
      ),
    ];
  }

  static List<Order> getOrdersByBuyer(String buyerId) {
    return getOrders().where((order) => order.buyerId == buyerId).toList();
  }

  static List<Order> getOrdersBySeller(String sellerId) {
    return getOrders().where((order) => order.sellerId == sellerId).toList();
  }

  static List<Order> getOrdersByStatus(OrderStatus status) {
    return getOrders().where((order) => order.status == status).toList();
  }

  static Order? getOrderById(String id) {
    try {
      return getOrders().firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }
}
