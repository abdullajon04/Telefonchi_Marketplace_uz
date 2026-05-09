class Seller {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String description;
  final String logo;
  final double rating;
  final int totalProducts;
  final int totalSales;
  final bool isVerified;
  final DateTime createdAt;

  Seller({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.description,
    required this.logo,
    required this.rating,
    required this.totalProducts,
    required this.totalSales,
    required this.isVerified,
    required this.createdAt,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalProducts: json['totalProducts'] ?? 0,
      totalSales: json['totalSales'] ?? 0,
      isVerified: json['isVerified'] ?? false,
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'description': description,
      'logo': logo,
      'rating': rating,
      'totalProducts': totalProducts,
      'totalSales': totalSales,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Seller && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
