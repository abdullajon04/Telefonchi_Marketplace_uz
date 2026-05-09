import 'dart:convert';

enum UserRole { seller, buyer }

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String address;
  final UserRole role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.address,
    required this.role,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? address,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      address: address ?? this.address,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'address': address,
      'role': role.name,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
      address: map['address'],
      role: UserRole.values.firstWhere((e) => e.name == map['role']),
    );
  }

  String toJson() => jsonEncode(toMap());
  factory User.fromJson(String json) => User.fromMap(jsonDecode(json));
}
