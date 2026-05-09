import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';
import '../models/order.dart' as app;

class ReviewService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, List<Review>> _reviewsByProduct = {};

  List<Review> getReviewsForProduct(String productId) {
    return _reviewsByProduct[productId] ?? [];
  }

  double getAverageRating(String productId) {
    final reviews = _reviewsByProduct[productId];
    if (reviews == null || reviews.isEmpty) return 0;
    final sum = reviews.fold<double>(0, (s, r) => s + r.rating);
    return sum / reviews.length;
  }

  int getReviewCount(String productId) {
    return _reviewsByProduct[productId]?.length ?? 0;
  }

  Future<void> loadReviewsForProduct(String productId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('productId', isEqualTo: productId)
          .get();

      final reviews = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Review.fromMap(data);
      }).toList();
      reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _reviewsByProduct[productId] = reviews;

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading reviews: $e');
    }
  }

  /// Yetkazilgan va hali otziv yozilmagan orderlar ro'yxatini qaytaradi
  Future<List<String>> getReviewableOrderIds(
      String buyerId, String productId) async {
    try {
      // Yetkazilgan buyurtmalar
      final orderSnap = await _firestore
          .collection('orders')
          .where('buyerId', isEqualTo: buyerId)
          .where('status', isEqualTo: app.OrderStatus.delivered.name)
          .get();

      final deliveredOrderIds = <String>[];
      for (final doc in orderSnap.docs) {
        final items = doc.data()['items'] as List? ?? [];
        for (final item in items) {
          final product = item['product'] as Map<String, dynamic>?;
          if (product != null && product['id'] == productId) {
            deliveredOrderIds.add(doc.id);
          }
        }
      }

      if (deliveredOrderIds.isEmpty) return [];

      // Allaqachon otziv yozilgan orderlar
      final reviewSnap = await _firestore
          .collection('reviews')
          .where('buyerId', isEqualTo: buyerId)
          .where('productId', isEqualTo: productId)
          .get();

      final reviewedOrderIds = reviewSnap.docs
          .map((doc) => doc.data()['orderId']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      return deliveredOrderIds
          .where((id) => !reviewedOrderIds.contains(id))
          .toList();
    } catch (e) {
      debugPrint('Error checking review eligibility: $e');
      return [];
    }
  }

  /// canReview — hali otziv yozilmagan order bormi
  Future<bool> canReview(String buyerId, String productId) async {
    final ids = await getReviewableOrderIds(buyerId, productId);
    return ids.isNotEmpty;
  }

  Future<String?> addReview({
    required String productId,
    required String orderId,
    required String buyerId,
    required String buyerName,
    required double rating,
    required String comment,
    List<String> imageBase64List = const [],
  }) async {
    try {
      // Tekshirish: shu order uchun allaqachon sharh bormi
      final existing = await _firestore
          .collection('reviews')
          .where('orderId', isEqualTo: orderId)
          .where('buyerId', isEqualTo: buyerId)
          .where('productId', isEqualTo: productId)
          .get();

      if (existing.docs.isNotEmpty) {
        return 'Вы уже оставили отзыв по этому заказу';
      }

      final docRef = await _firestore.collection('reviews').add({
        'productId': productId,
        'orderId': orderId,
        'buyerId': buyerId,
        'buyerName': buyerName,
        'rating': rating,
        'comment': comment,
        'imageBase64List': imageBase64List,
        'createdAt': DateTime.now().toIso8601String(),
      });

      final review = Review(
        id: docRef.id,
        productId: productId,
        orderId: orderId,
        buyerId: buyerId,
        buyerName: buyerName,
        rating: rating,
        comment: comment,
        imageBase64List: imageBase64List,
      );

      _reviewsByProduct.putIfAbsent(productId, () => []);
      _reviewsByProduct[productId]!.insert(0, review);
      notifyListeners();
      return null; // success
    } catch (e) {
      return 'Ошибка: $e';
    }
  }

  Future<String?> deleteReview(String reviewId, String productId) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).delete();
      _reviewsByProduct[productId]?.removeWhere((r) => r.id == reviewId);
      notifyListeners();
      return null;
    } catch (e) {
      return 'Ошибка удаления: $e';
    }
  }
}
