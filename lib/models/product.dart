import 'dart:convert';
import 'category.dart';

class Product {
  final String id;
  final String sellerId;
  final String sellerName;
  final String name;
  final String description;
  final double price;
  final ProductCategory category;
  final String imagePath;
  final String imageBase64; // Base64 encoded image for web
  final int stock; // количество на складе
  final String productModel; // iPhone 15, Samsung Galaxy, etc.
  final String condition; // Yangi, Ishlatilgan
  final int? colorValue; // Color as int (0xFFRRGGBB)
  final int? year; // ishlab chiqarilgan yil
  final String location; // manzil
  final double? locationLat;
  final double? locationLng;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imagePath = '',
    this.imageBase64 = '',
    this.stock = 1,
    this.productModel = '',
    this.condition = '',
    this.colorValue,
    this.year,
    this.location = '',
    this.locationLat,
    this.locationLng,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Product copyWith({
    String? id,
    String? sellerId,
    String? sellerName,
    String? name,
    String? description,
    double? price,
    ProductCategory? category,
    String? imagePath,
    String? imageBase64,
    int? stock,
    String? productModel,
    String? condition,
    int? colorValue,
    int? year,
    String? location,
    double? locationLat,
    double? locationLng,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      imageBase64: imageBase64 ?? this.imageBase64,
      stock: stock ?? this.stock,
      productModel: productModel ?? this.productModel,
      condition: condition ?? this.condition,
      colorValue: colorValue ?? this.colorValue,
      year: year ?? this.year,
      location: location ?? this.location,
      locationLat: locationLat ?? this.locationLat,
      locationLng: locationLng ?? this.locationLng,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'name': name,
      'description': description,
      'price': price,
      'category': category.value,
      'imagePath': imagePath,
      'imageBase64': imageBase64,
      'stock': stock,
      'productModel': productModel,
      'condition': condition,
      'colorValue': colorValue,
      'year': year,
      'location': location,
      'locationLat': locationLat,
      'locationLng': locationLng,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      category: ProductCategory.values.firstWhere(
        (c) => c.value == map['category'],
        orElse: () => ProductCategory.smartphones,
      ),
      imagePath: map['imagePath'] ?? '',
      imageBase64: map['imageBase64'] ?? '',
      stock: map['stock'] ?? 1,
      productModel: map['productModel'] ?? '',
      condition: map['condition'] ?? '',
      colorValue: map['colorValue'] as int?,
      year: map['year'] as int?,
      location: map['location'] ?? '',
      locationLat: (map['locationLat'] as num?)?.toDouble(),
      createdAt: map['createdAt'] == null
          ? DateTime.now()
          : (map['createdAt'] is DateTime
              ? map['createdAt'] as DateTime
              : (map['createdAt'].runtimeType.toString() == 'Timestamp'
                  ? (map['createdAt'] as dynamic).toDate()
                  : DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now())),
    );
  }

  String toJson() => jsonEncode(toMap());
  factory Product.fromJson(String json) => Product.fromMap(jsonDecode(json));

  // Get stock status text
  String get stockStatus {
    if (stock > 10) return 'В наличии';
    if (stock > 0) return 'Осталось мало: $stock шт.';
    return 'Нет в наличии';
  }

  // Check if product is in stock
  bool get isInStock => stock > 0;

  // Get category display name
  String get categoryDisplayName {
    return category.displayName;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, category: $category}';
  }
}
