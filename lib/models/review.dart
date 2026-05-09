import 'dart:convert';

class Review {
  final String id;
  final String productId;
  final String orderId; // qaysi buyurtma uchun
  final String buyerId;
  final String buyerName;
  final double rating; // 1.0 - 5.0
  final String comment;
  final List<String> imageBase64List; // Rasm rasmlar (base64)
  final DateTime createdAt;

  Review({
    required this.id,
    required this.productId,
    this.orderId = '',
    required this.buyerId,
    required this.buyerName,
    required this.rating,
    this.comment = '',
    this.imageBase64List = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Review copyWith({
    String? id,
    String? productId,
    String? orderId,
    String? buyerId,
    String? buyerName,
    double? rating,
    String? comment,
    List<String>? imageBase64List,
    DateTime? createdAt,
  }) {
    return Review(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      orderId: orderId ?? this.orderId,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      imageBase64List: imageBase64List ?? this.imageBase64List,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'orderId': orderId,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'rating': rating,
      'comment': comment,
      'imageBase64List': imageBase64List,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] ?? '',
      productId: map['productId'] ?? '',
      orderId: map['orderId'] ?? '',
      buyerId: map['buyerId'] ?? '',
      buyerName: map['buyerName'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      comment: map['comment'] ?? '',
      imageBase64List: (map['imageBase64List'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());
  factory Review.fromJson(String json) => Review.fromMap(jsonDecode(json));
}
