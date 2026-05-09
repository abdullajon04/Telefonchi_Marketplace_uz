import '../models/product.dart';
import '../models/category.dart';

class MockProducts {
  static List<Product> getProducts() {
    return [
      // iPhone tovarlari
      Product(
        id: '1',
        sellerId: 'seller1',
        sellerName: 'Apple Store',
        name: 'iPhone 15 Pro Max',
        description:
            'Флагманский смартфон Apple с титановым корпусом и чипом A17 Pro',
        price: 1299.99,
        category: ProductCategory.smartphones,
        imagePath:
            'https://images.unsplash.com/photo-1592286115803-a1c2b3f5a9c5?w=400',
        productModel: 'iPhone 15 Pro Max',
        condition: 'Новое',
        stock: 15,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),

      Product(
        id: '2',
        name: 'iPhone 15',
        description: 'Современный смартфон с динамической островком и USB-C',
        price: 799.99,
        imageUrl:
            'https://images.unsplash.com/photo-1592286115803-a1c2b3f5a9c5?w=400',
        category: ProductCategory.smartphone,
        brand: 'Apple',
        model: 'iPhone 15',
        condition: 'Новое',
        sellerId: 'seller1',
        sellerName: 'Apple Store',
        rating: 4.6,
        reviews: 156,
        stock: 25,
        specifications: {
          'Экран': '6.1" Super Retina XDR',
          'Процессор': 'A16 Bionic',
          'Память': '128GB',
          'Камера': '48MP + 12MP',
          'Батарея': '3349 мАч',
          'Цвет': 'Черный'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),

      // Samsung tovarlari
      Product(
        id: '3',
        name: 'Samsung Galaxy S24 Ultra',
        description: 'Флагман Samsung со стилусом S Pen и камерой 200MP',
        price: 1199.99,
        imageUrl:
            'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=400',
        category: ProductCategory.smartphone,
        brand: 'Samsung',
        model: 'Galaxy S24 Ultra',
        condition: 'Новое',
        sellerId: 'seller2',
        sellerName: 'Samsung Official',
        rating: 4.7,
        reviews: 189,
        stock: 12,
        specifications: {
          'Экран': '6.8" Dynamic AMOLED 2X',
          'Процессор': 'Snapdragon 8 Gen 3',
          'Память': '256GB',
          'Камера': '200MP + 50MP + 12MP + 10MP',
          'Батарея': '5000 мАч',
          'Цвет': 'Титановый фиолетовый'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),

      Product(
        id: '4',
        name: 'Samsung Galaxy A54',
        description:
            'Средний класс с отличной камерой и долгой работой батареи',
        price: 349.99,
        imageUrl:
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
        category: ProductCategory.smartphone,
        brand: 'Samsung',
        model: 'Galaxy A54',
        condition: 'Новое',
        sellerId: 'seller2',
        sellerName: 'Samsung Official',
        rating: 4.4,
        reviews: 98,
        stock: 30,
        specifications: {
          'Экран': '6.4" Super AMOLED',
          'Процессор': 'Exynos 1380',
          'Память': '128GB',
          'Камера': '50MP + 12MP + 5MP',
          'Батарея': '5000 мАч',
          'Цвет': 'Белый'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),

      // Xiaomi tovarlari
      Product(
        id: '5',
        name: 'Xiaomi 14 Ultra',
        description: 'Флагман с камерой Leica и быстрой зарядкой',
        price: 999.99,
        imageUrl:
            'https://images.unsplash.com/photo-1605236453806-b25a3a6a8f31?w=400',
        category: ProductCategory.smartphone,
        brand: 'Xiaomi',
        model: '14 Ultra',
        condition: 'Новое',
        sellerId: 'seller3',
        sellerName: 'Xiaomi Store',
        rating: 4.5,
        reviews: 145,
        stock: 8,
        specifications: {
          'Экран': '6.73" AMOLED',
          'Процессор': 'Snapdragon 8 Gen 3',
          'Память': '512GB',
          'Камера': '50MP + 50MP + 50MP + 12MP',
          'Батарея': '5300 мАч',
          'Цвет': 'Черный'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
      ),

      Product(
        id: '6',
        name: 'Xiaomi Redmi Note 13 Pro',
        description: 'Отличное соотношение цены и качества',
        price: 299.99,
        imageUrl:
            'https://images.unsplash.com/photo-1605236453806-b25a3a6a8f31?w=400',
        category: ProductCategory.smartphone,
        brand: 'Xiaomi',
        model: 'Redmi Note 13 Pro',
        condition: 'Новое',
        sellerId: 'seller3',
        sellerName: 'Xiaomi Store',
        rating: 4.3,
        reviews: 267,
        stock: 45,
        specifications: {
          'Экран': '6.67" AMOLED',
          'Процессор': 'Snapdragon 7s Gen 2',
          'Память': '256GB',
          'Камера': '200MP + 8MP + 2MP',
          'Батарея': '5100 мАч',
          'Цвет': 'Синий'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),

      // Huawei tovarlari
      Product(
        id: '7',
        name: 'Huawei P60 Pro',
        description: 'Инновационная камера и элегантный дизайн',
        price: 899.99,
        imageUrl:
            'https://images.unsplash.com/photo-1592286115803-a1c2b3f5a9c5?w=400',
        category: ProductCategory.smartphone,
        brand: 'Huawei',
        model: 'P60 Pro',
        condition: 'Новое',
        sellerId: 'seller4',
        sellerName: 'Huawei Official',
        rating: 4.2,
        reviews: 78,
        stock: 10,
        specifications: {
          'Экран': '6.67" LTPO OLED',
          'Процессор': 'Snapdragon 8+ Gen 1',
          'Память': '256GB',
          'Камера': '48MP + 48MP + 13MP',
          'Батарея': '4815 мАч',
          'Цвет': 'Кирпичный'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 22)),
      ),

      // OnePlus tovarlari
      Product(
        id: '8',
        name: 'OnePlus 12',
        description: 'Быстрый флагман с зарядкой 100W',
        price: 799.99,
        imageUrl:
            'https://images.unsplash.com/photo-1605236453806-b25a3a6a8f31?w=400',
        category: ProductCategory.smartphone,
        brand: 'OnePlus',
        model: 'OnePlus 12',
        condition: 'Новое',
        sellerId: 'seller5',
        sellerName: 'OnePlus Store',
        rating: 4.6,
        reviews: 112,
        stock: 18,
        specifications: {
          'Экран': '6.82" AMOLED',
          'Процессор': 'Snapdragon 8 Gen 3',
          'Память': '256GB',
          'Камера': '50MP + 48MP + 32MP',
          'Батарея': '5400 мАч',
          'Цвет': 'Зеленый'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),

      // Google Pixel tovarlari
      Product(
        id: '9',
        name: 'Google Pixel 8 Pro',
        description: 'Лучший AI-смартфон с превосходной камерой',
        price: 999.99,
        imageUrl:
            'https://images.unsplash.com/photo-1592286115803-a1c2b3f5a9c5?w=400',
        category: ProductCategory.smartphone,
        brand: 'Google',
        model: 'Pixel 8 Pro',
        condition: 'Новое',
        sellerId: 'seller6',
        sellerName: 'Google Store',
        rating: 4.7,
        reviews: 203,
        stock: 14,
        specifications: {
          'Экран': '6.7" LTPO OLED',
          'Процессор': 'Google Tensor G3',
          'Память': '256GB',
          'Камера': '50MP + 48MP + 12MP',
          'Батарея': '5050 мАч',
          'Цвет': 'Бирюзовый'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),

      // Nothing Phone tovarlari
      Product(
        id: '10',
        name: 'Nothing Phone (2)',
        description:
            'Уникальный дизайн с прозрачным корпусом и Glyph интерфейсом',
        price: 599.99,
        imageUrl:
            'https://images.unsplash.com/photo-1605236453806-b25a3a6a8f31?w=400',
        category: ProductCategory.smartphone,
        brand: 'Nothing',
        model: 'Phone (2)',
        condition: 'Новое',
        sellerId: 'seller7',
        sellerName: 'Nothing Store',
        rating: 4.4,
        reviews: 167,
        stock: 20,
        specifications: {
          'Экран': '6.7" LTPO OLED',
          'Процессор': 'Snapdragon 8+ Gen 1',
          'Память': '256GB',
          'Камера': '50MP + 50MP',
          'Батарея': '4700 мАч',
          'Цвет': 'Серый'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),

      // Qo'shimcha tovarlar
      Product(
        id: '11',
        name: 'iPad Pro 12.9"',
        description: 'Профессиональный планшет с чипом M2',
        price: 1099.99,
        imageUrl:
            'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
        category: ProductCategory.tablets,
        brand: 'Apple',
        model: 'iPad Pro 12.9"',
        condition: 'Новое',
        sellerId: 'seller1',
        sellerName: 'Apple Store',
        rating: 4.9,
        reviews: 89,
        stock: 12,
        specifications: {
          'Экран': '12.9" Liquid Retina XDR',
          'Процессор': 'M2',
          'Память': '256GB',
          'Камера': '12MP + 10MP',
          'Батарея': '10758 мАч',
          'Цвет': 'Космический серый'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),

      Product(
        id: '12',
        name: 'Samsung Galaxy Tab S9',
        description: 'Флагманский планшет с S Pen',
        price: 649.99,
        imageUrl:
            'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
        category: ProductCategory.tablets,
        brand: 'Samsung',
        model: 'Galaxy Tab S9',
        condition: 'Новое',
        sellerId: 'seller2',
        sellerName: 'Samsung Official',
        rating: 4.6,
        reviews: 67,
        stock: 15,
        specifications: {
          'Экран': '11" Dynamic AMOLED 2X',
          'Процессор': 'Snapdragon 8 Gen 2',
          'Память': '128GB',
          'Камера': '13MP + 6MP',
          'Батарея': '8400 мАч',
          'Цвет': 'Бежевый'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 9)),
      ),

      Product(
        id: '13',
        name: 'Apple Watch Series 9',
        description: 'Умные часы с датчиком здоровья',
        price: 399.99,
        imageUrl:
            'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=400',
        category: ProductCategory.smartwatches,
        brand: 'Apple',
        model: 'Watch Series 9',
        condition: 'Новое',
        sellerId: 'seller1',
        sellerName: 'Apple Store',
        rating: 4.7,
        reviews: 145,
        stock: 25,
        specifications: {
          'Экран': '1.9" LTPO OLED',
          'Процессор': 'S9 SiP',
          'Память': '64GB',
          'Водонепроницаемость': '50м',
          'Батарея': '18 часов',
          'Цвет': 'Розовый'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),

      Product(
        id: '14',
        name: 'AirPods Pro 2',
        description: 'Беспроводные наушники с шумоподавлением',
        price: 249.99,
        imageUrl:
            'https://images.unsplash.com/photo-1588423771073-b8903fbb85b5?w=400',
        category: ProductCategory.headphones,
        brand: 'Apple',
        model: 'AirPods Pro 2',
        condition: 'Новое',
        sellerId: 'seller1',
        sellerName: 'Apple Store',
        rating: 4.8,
        reviews: 312,
        stock: 40,
        specifications: {
          'Тип': 'TWS',
          'Шумоподавление': 'Активное',
          'Батарея': '6 часов + 30 часов кейс',
          'Подключение': 'Bluetooth 5.3',
          'Цвет': 'Белый'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),

      Product(
        id: '15',
        name: 'MacBook Air M2',
        description: 'Ультратонкий ноутбук с чипом M2',
        price: 999.99,
        imageUrl:
            'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400',
        category: ProductCategory.laptops,
        brand: 'Apple',
        model: 'MacBook Air M2',
        condition: 'Новое',
        sellerId: 'seller1',
        sellerName: 'Apple Store',
        rating: 4.9,
        reviews: 78,
        stock: 8,
        specifications: {
          'Экран': '13.6" Liquid Retina',
          'Процессор': 'M2',
          'Память': '8GB RAM, 256GB SSD',
          'Батарея': '18 часов',
          'Вес': '1.24 кг',
          'Цвет': 'Серебристый'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),

      Product(
        id: '16',
        name: 'Samsung Galaxy Watch 6',
        description: 'Умные часы с круглым дисплеем',
        price: 299.99,
        imageUrl:
            'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=400',
        category: ProductCategory.smartwatches,
        brand: 'Samsung',
        model: 'Galaxy Watch 6',
        condition: 'Новое',
        sellerId: 'seller2',
        sellerName: 'Samsung Official',
        rating: 4.5,
        reviews: 98,
        stock: 20,
        specifications: {
          'Экран': '1.3" Super AMOLED',
          'Процессор': 'Exynos W920',
          'Память': '16GB',
          'Водонепроницаемость': '5ATM',
          'Батарея': '40 часов',
          'Цвет': 'Черный'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 11)),
      ),

      Product(
        id: '17',
        name: 'Sony WH-1000XM5',
        description: 'Премиальные наушники с шумоподавлением',
        price: 399.99,
        imageUrl:
            'https://images.unsplash.com/photo-1588423771073-b8903fbb85b5?w=400',
        category: ProductCategory.headphones,
        brand: 'Sony',
        model: 'WH-1000XM5',
        condition: 'Новое',
        sellerId: 'seller2',
        sellerName: 'Samsung Official',
        rating: 4.7,
        reviews: 156,
        stock: 18,
        specifications: {
          'Тип': 'Полноразмерные',
          'Шумоподавление': 'Активное',
          'Батарея': '30 часов',
          'Подключение': 'Bluetooth 5.2, 3.5mm',
          'Цвет': 'Черный'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),

      Product(
        id: '18',
        name: 'Dell XPS 13',
        description: 'Ультрабук с InfinityEdge дисплеем',
        price: 1199.99,
        imageUrl:
            'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400',
        category: ProductCategory.laptops,
        brand: 'Dell',
        model: 'XPS 13',
        condition: 'Новое',
        sellerId: 'seller5',
        sellerName: 'OnePlus Store',
        rating: 4.6,
        reviews: 45,
        stock: 6,
        specifications: {
          'Экран': '13.4" InfinityEdge FHD+',
          'Процессор': 'Intel Core i7-1360P',
          'Память': '16GB RAM, 512GB SSD',
          'Батарея': '12 часов',
          'Вес': '1.17 кг',
          'Цвет': 'Платиновый серебро'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 13)),
      ),

      Product(
        id: '19',
        name: 'Xiaomi Pad 6',
        description: 'Бюджетный планшет с высокой производительностью',
        price: 299.99,
        imageUrl:
            'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
        category: ProductCategory.tablets,
        brand: 'Xiaomi',
        model: 'Pad 6',
        condition: 'Новое',
        sellerId: 'seller3',
        sellerName: 'Xiaomi Store',
        rating: 4.4,
        reviews: 89,
        stock: 22,
        specifications: {
          'Экран': '11" IPS LCD',
          'Процессор': 'Snapdragon 870',
          'Память': '6GB RAM, 128GB',
          'Камера': '13MP + 8MP',
          'Батарея': '8840 мАч',
          'Цвет': 'Голубой'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      ),

      Product(
        id: '20',
        name: 'JBL Tune 750BTNC',
        description: 'Беспроводные наушники с шумоподавлением',
        price: 89.99,
        imageUrl:
            'https://images.unsplash.com/photo-1588423771073-b8903fbb85b5?w=400',
        category: ProductCategory.headphones,
        brand: 'JBL',
        model: 'Tune 750BTNC',
        condition: 'Новое',
        sellerId: 'seller3',
        sellerName: 'Xiaomi Store',
        rating: 4.2,
        reviews: 67,
        stock: 35,
        specifications: {
          'Тип': 'Накладные',
          'Шумоподавление': 'Гибридное',
          'Батарея': '15 часов',
          'Подключение': 'Bluetooth 5.0',
          'Цвет': 'Черный'
        },
        createdAt: DateTime.now().subtract(const Duration(days: 16)),
      ),
    ];
  }

  static List<Product> getFeaturedProducts() {
    return getProducts().where((product) => product.rating >= 4.5).toList();
  }

  static List<Product> getProductsByCategory(ProductCategory category) {
    return getProducts()
        .where((product) => product.category == category)
        .toList();
  }

  static List<Product> getProductsByBrand(String brand) {
    return getProducts().where((product) => product.brand == brand).toList();
  }

  static Product? getProductById(String id) {
    try {
      return getProducts().firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}
