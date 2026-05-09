import '../models/seller.dart';

class MockSellers {
  static List<Seller> getSellers() {
    return [
      Seller(
        id: 'seller1',
        name: 'Apple Store',
        email: 'apple@telfonchi.uz',
        phone: '+998901234567',
        description: 'Официальный дилер Apple в Узбекистане',
        logo: 'https://example.com/apple_logo.png',
        rating: 4.9,
        totalProducts: 15,
        totalSales: 1250,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      Seller(
        id: 'seller2',
        name: 'Samsung Official',
        email: 'samsung@telfonchi.uz',
        phone: '+998902345678',
        description: 'Авторизованный партнер Samsung',
        logo: 'https://example.com/samsung_logo.png',
        rating: 4.8,
        totalProducts: 22,
        totalSales: 980,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
      ),
      Seller(
        id: 'seller3',
        name: 'Xiaomi Store',
        email: 'xiaomi@telfonchi.uz',
        phone: '+998903456789',
        description: 'Официальный магазин Xiaomi',
        logo: 'https://example.com/xiaomi_logo.png',
        rating: 4.6,
        totalProducts: 18,
        totalSales: 756,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 280)),
      ),
      Seller(
        id: 'seller4',
        name: 'Huawei Official',
        email: 'huawei@telfonchi.uz',
        phone: '+998904567890',
        description: 'Дистрибьютор Huawei в Узбекистане',
        logo: 'https://example.com/huawei_logo.png',
        rating: 4.5,
        totalProducts: 12,
        totalSales: 432,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 250)),
      ),
      Seller(
        id: 'seller5',
        name: 'OnePlus Store',
        email: 'oneplus@telfonchi.uz',
        phone: '+998905678901',
        description: 'Магазин смартфонов OnePlus',
        logo: 'https://example.com/oneplus_logo.png',
        rating: 4.4,
        totalProducts: 8,
        totalSales: 234,
        isVerified: false,
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
      ),
      Seller(
        id: 'seller6',
        name: 'Google Store',
        email: 'google@telfonchi.uz',
        phone: '+998906789012',
        description: 'Официальный партнер Google',
        logo: 'https://example.com/google_logo.png',
        rating: 4.7,
        totalProducts: 6,
        totalSales: 567,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
      ),
      Seller(
        id: 'seller7',
        name: 'Nothing Store',
        email: 'nothing@telfonchi.uz',
        phone: '+998907890123',
        description: 'Эксклюзивный дилер Nothing',
        logo: 'https://example.com/nothing_logo.png',
        rating: 4.3,
        totalProducts: 4,
        totalSales: 189,
        isVerified: false,
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
      ),
    ];
  }

  static Seller? getSellerById(String id) {
    try {
      return getSellers().firstWhere((seller) => seller.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Seller> getVerifiedSellers() {
    return getSellers().where((seller) => seller.isVerified).toList();
  }
}
