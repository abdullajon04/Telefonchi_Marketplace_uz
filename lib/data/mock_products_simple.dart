import '../models/product.dart';
import '../models/category.dart';

class MockProducts {
  static List<Product> getProducts() {
    return [
      // Apple tovarlari
      Product(
        id: '1',
        sellerId: 'seller1',
        sellerName: 'Apple Store',
        name: 'iPhone 15 Pro Max',
        description:
            'Флагманский смартфон Apple с титановым корпусом и чипом A17 Pro',
        price: 1299.99,
        category: ProductCategory.smartphones,
        imagePath: 'https://picsum.photos/seed/iphone15promax/400/400.jpg',
        productModel: 'iPhone 15 Pro Max',
        condition: 'Новое',
        stock: 15,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),

      Product(
        id: '2',
        sellerId: 'seller1',
        sellerName: 'Apple Store',
        name: 'iPhone 15',
        description: 'Современный смартфон с динамической островком и USB-C',
        price: 799.99,
        category: ProductCategory.smartphones,
        imagePath: 'https://picsum.photos/seed/iphone15promax/400/400.jpg',
        productModel: 'iPhone 15',
        condition: 'Новое',
        stock: 25,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),

      // Samsung tovarlari
      Product(
        id: '3',
        sellerId: 'seller2',
        sellerName: 'Samsung Official',
        name: 'Samsung Galaxy S24 Ultra',
        description: 'Флагман Samsung со стилусом S Pen и камерой 200MP',
        price: 1199.99,
        category: ProductCategory.smartphones,
        imagePath:
            'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=400',
        productModel: 'Galaxy S24 Ultra',
        condition: 'Новое',
        stock: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),

      Product(
        id: '4',
        sellerId: 'seller2',
        sellerName: 'Samsung Official',
        name: 'Samsung Galaxy A54',
        description:
            'Средний класс с отличной камерой и долгой работой батареи',
        price: 349.99,
        category: ProductCategory.smartphones,
        imagePath:
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
        productModel: 'Galaxy A54',
        condition: 'Новое',
        stock: 30,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),

      // Xiaomi tovarlari
      Product(
        id: '5',
        sellerId: 'seller3',
        sellerName: 'Xiaomi Store',
        name: 'Xiaomi 14 Ultra',
        description: 'Флагман с камерой Leica и быстрой зарядкой',
        price: 999.99,
        category: ProductCategory.smartphones,
        imagePath:
            'https://images.unsplash.com/photo-1605236453806-b25a3a6a8f31?w=400',
        productModel: '14 Ultra',
        condition: 'Новое',
        stock: 8,
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
      ),

      Product(
        id: '6',
        sellerId: 'seller3',
        sellerName: 'Xiaomi Store',
        name: 'Xiaomi Redmi Note 13 Pro',
        description: 'Отличное соотношение цены и качества',
        price: 299.99,
        category: ProductCategory.smartphones,
        imagePath:
            'https://images.unsplash.com/photo-1605236453806-b25a3a6a8f31?w=400',
        productModel: 'Redmi Note 13 Pro',
        condition: 'Новое',
        stock: 45,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),

      // Huawei tovarlari
      Product(
        id: '7',
        sellerId: 'seller4',
        sellerName: 'Huawei Official',
        name: 'Huawei P60 Pro',
        description: 'Инновационная камера и элегантный дизайн',
        price: 899.99,
        category: ProductCategory.smartphones,
        imagePath: 'https://picsum.photos/seed/iphone15promax/400/400.jpg',
        productModel: 'P60 Pro',
        condition: 'Новое',
        stock: 10,
        createdAt: DateTime.now().subtract(const Duration(days: 22)),
      ),

      // OnePlus tovarlari
      Product(
        id: '8',
        sellerId: 'seller5',
        sellerName: 'OnePlus Store',
        name: 'OnePlus 12',
        description: 'Быстрый флагман с зарядкой 100W',
        price: 799.99,
        category: ProductCategory.smartphones,
        imagePath:
            'https://images.unsplash.com/photo-1605236453806-b25a3a6a8f31?w=400',
        productModel: 'OnePlus 12',
        condition: 'Новое',
        stock: 18,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),

      // Google Pixel tovarlari
      Product(
        id: '9',
        sellerId: 'seller6',
        sellerName: 'Google Store',
        name: 'Google Pixel 8 Pro',
        description: 'Лучший AI-смартфон с превосходной камерой',
        price: 999.99,
        category: ProductCategory.smartphones,
        imagePath: 'https://picsum.photos/seed/iphone15promax/400/400.jpg',
        productModel: 'Pixel 8 Pro',
        condition: 'Новое',
        stock: 14,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),

      // Nothing Phone tovarlari
      Product(
        id: '10',
        sellerId: 'seller7',
        sellerName: 'Nothing Store',
        name: 'Nothing Phone (2)',
        description:
            'Уникальный дизайн с прозрачным корпусом и Glyph интерфейсом',
        price: 599.99,
        category: ProductCategory.smartphones,
        imagePath:
            'https://images.unsplash.com/photo-1605236453806-b25a3a6a8f31?w=400',
        productModel: 'Phone (2)',
        condition: 'Новое',
        stock: 20,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),

      // Qo'shimcha tovarlar - Planshetlar
      Product(
        id: '11',
        sellerId: 'seller1',
        sellerName: 'Apple Store',
        name: 'iPad Pro 12.9"',
        description: 'Профессиональный планшет с чипом M2',
        price: 1099.99,
        category: ProductCategory.tablets,
        imagePath:
            'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
        productModel: 'iPad Pro 12.9"',
        condition: 'Новое',
        stock: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),

      Product(
        id: '12',
        sellerId: 'seller2',
        sellerName: 'Samsung Official',
        name: 'Samsung Galaxy Tab S9',
        description: 'Флагманский планшет с S Pen',
        price: 649.99,
        category: ProductCategory.tablets,
        imagePath:
            'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
        productModel: 'Galaxy Tab S9',
        condition: 'Новое',
        stock: 15,
        createdAt: DateTime.now().subtract(const Duration(days: 9)),
      ),

      // Aksessuarlar
      Product(
        id: '13',
        sellerId: 'seller1',
        sellerName: 'Apple Store',
        name: 'AirPods Pro 2',
        description: 'Беспроводные наушники с шумоподавлением',
        price: 249.99,
        category: ProductCategory.accessories,
        imagePath:
            'https://images.unsplash.com/photo-1588423771073-b8903fbb85b5?w=400',
        productModel: 'AirPods Pro 2',
        condition: 'Новое',
        stock: 40,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),

      Product(
        id: '14',
        sellerId: 'seller3',
        sellerName: 'Xiaomi Store',
        name: 'Xiaomi Band 8',
        description: 'Фитнес-браслет с мониторингом здоровья',
        price: 49.99,
        category: ProductCategory.accessories,
        imagePath:
            'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=400',
        productModel: 'Band 8',
        condition: 'Новое',
        stock: 50,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),

      // Knoptochni telefonlar
      Product(
        id: '15',
        sellerId: 'seller2',
        sellerName: 'Samsung Official',
        name: 'Samsung Galaxy B310',
        description: 'Надежный кнопочный телефон с долгой работой батареи',
        price: 39.99,
        category: ProductCategory.featurePhones,
        imagePath:
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
        productModel: 'Galaxy B310',
        condition: 'Новое',
        stock: 25,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),

      Product(
        id: '16',
        sellerId: 'seller4',
        sellerName: 'Huawei Official',
        name: 'Nokia 3310',
        description: 'Легендарный кнопочный телефон',
        price: 59.99,
        category: ProductCategory.featurePhones,
        imagePath:
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
        productModel: '3310',
        condition: 'Новое',
        stock: 30,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];
  }

  static List<Product> getFeaturedProducts() {
    return getProducts().where((product) => product.stock > 10).toList();
  }

  static List<Product> getProductsByCategory(ProductCategory category) {
    return getProducts()
        .where((product) => product.category == category)
        .toList();
  }

  static Product? getProductById(String id) {
    try {
      return getProducts().firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}
