class MockStatistics {
  static Map<String, dynamic> getSellerStatistics(String sellerId) {
    return {
      'totalProducts': 15,
      'totalSales': 1250,
      'totalRevenue': 2450000.0, // UZS
      'averageRating': 4.8,
      'monthlySales': {
        'Январь': 98,
        'Февраль': 112,
        'Март': 125,
        'Апрель': 145,
        'Май': 167,
        'Июнь': 189,
        'Июль': 201,
        'Август': 178,
        'Сентябрь': 156,
        'Октябрь': 143,
        'Ноябрь': 167,
        'Декабрь': 195,
      },
      'topProducts': [
        {'name': 'iPhone 15 Pro Max', 'sales': 234, 'revenue': 304000.0},
        {'name': 'iPhone 15', 'sales': 189, 'revenue': 151000.0},
        {'name': 'iPhone 14', 'sales': 145, 'revenue': 99900.0},
        {'name': 'iPad Pro', 'sales': 98, 'revenue': 124000.0},
        {'name': 'AirPods Pro', 'sales': 267, 'revenue': 80100.0},
      ],
      'customerSatisfaction': 92.5, // percentage
      'responseTime': 15.2, // minutes average
      'returnRate': 2.3, // percentage
    };
  }

  static Map<String, dynamic> getPlatformStatistics() {
    return {
      'totalUsers': 15420,
      'totalSellers': 156,
      'totalProducts': 2340,
      'totalOrders': 8967,
      'totalRevenue': 45600000.0, // UZS
      'monthlyGrowth': 23.5, // percentage
      'userRetention': 78.9, // percentage
      'conversionRate': 4.2, // percentage
      'averageOrderValue': 5085.0, // UZS
      'topCategories': [
        {'category': 'Смартфоны', 'count': 1567, 'percentage': 67.2},
        {'category': 'Планшеты', 'count': 234, 'percentage': 10.0},
        {'category': 'Аксессуары', 'count': 189, 'percentage': 8.1},
        {'category': 'Умные часы', 'count': 145, 'percentage': 6.2},
        {'category': 'Наушники', 'count': 198, 'percentage': 8.5},
      ],
      'topBrands': [
        {'brand': 'Apple', 'count': 567, 'percentage': 24.3},
        {'brand': 'Samsung', 'count': 445, 'percentage': 19.1},
        {'brand': 'Xiaomi', 'count': 389, 'percentage': 16.7},
        {'brand': 'Huawei', 'count': 234, 'percentage': 10.0},
        {'brand': 'OnePlus', 'count': 189, 'percentage': 8.1},
      ],
      'geographicDistribution': [
        {'city': 'Ташкент', 'count': 5678, 'percentage': 36.8},
        {'city': 'Самарканд', 'count': 2345, 'percentage': 15.2},
        {'city': 'Бухара', 'count': 1890, 'percentage': 12.3},
        {'city': 'Фергана', 'count': 1567, 'percentage': 10.2},
        {'city': 'Наманган', 'count': 1234, 'percentage': 8.0},
        {'city': 'Андижан', 'count': 1123, 'percentage': 7.3},
        {'city': 'Другие', 'count': 1583, 'percentage': 10.2},
      ],
    };
  }

  static List<Map<String, dynamic>> getDailySales(int days) {
    final List<Map<String, dynamic>> sales = [];
    final DateTime now = DateTime.now();

    for (int i = days - 1; i >= 0; i--) {
      final DateTime date = now.subtract(Duration(days: i));
      final int salesCount = (50 + (i * 3) + (i % 7 * 10)).abs();
      final double revenue = salesCount * 5085.0 + (i * 1000);

      sales.add({
        'date': date,
        'sales': salesCount,
        'revenue': revenue,
      });
    }

    return sales;
  }

  static Map<String, dynamic> getUserStatistics(String userId) {
    return {
      'totalOrders': 12,
      'totalSpent': 61020.0, // UZS
      'favoriteCategory': 'Смартфоны',
      'averageOrderValue': 5085.0,
      'lastOrderDate': DateTime.now().subtract(const Duration(days: 5)),
      'favoriteBrands': ['Apple', 'Samsung', 'Xiaomi'],
      'savedProducts': 8,
      'reviewsCount': 5,
      'averageRatingGiven': 4.6,
      'membershipLevel': 'Золотой',
      'loyaltyPoints': 1250,
    };
  }
}
