import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<ChatRoom> _chatRooms = [];
  List<ChatRoom> get chatRooms => List.unmodifiable(_chatRooms);

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;
  StreamSubscription? _unreadBuyerSub;
  StreamSubscription? _unreadSellerSub;

  /// Foydalanuvchining barcha chat xonalarini yuklash
  Future<void> loadChatRooms(String userId) async {
    try {
      // Buyer sifatida
      final buyerSnap = await _firestore
          .collection('chatRooms')
          .where('buyerId', isEqualTo: userId)
          .get();

      // Seller sifatida
      final sellerSnap = await _firestore
          .collection('chatRooms')
          .where('sellerId', isEqualTo: userId)
          .get();

      final rooms = <ChatRoom>[];
      for (final doc in buyerSnap.docs) {
        rooms.add(ChatRoom.fromMap(doc.id, doc.data()));
      }
      for (final doc in sellerSnap.docs) {
        if (!rooms.any((r) => r.id == doc.id)) {
          rooms.add(ChatRoom.fromMap(doc.id, doc.data()));
        }
      }

      rooms.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
      _chatRooms.clear();
      _chatRooms.addAll(rooms);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading chat rooms: $e');
    }
  }

  /// Chat xonasini topish yoki yangi yaratish
  Future<ChatRoom> getOrCreateChatRoom({
    required String buyerId,
    required String buyerName,
    required String sellerId,
    required String sellerName,
    String productId = '',
    String productName = '',
  }) async {
    try {
      // Mavjud xonani qidirish
      final existing = await _firestore
          .collection('chatRooms')
          .where('buyerId', isEqualTo: buyerId)
          .where('sellerId', isEqualTo: sellerId)
          .get();

      if (existing.docs.isNotEmpty) {
        final doc = existing.docs.first;
        return ChatRoom.fromMap(doc.id, doc.data());
      }

      // Yangi chat xonasi yaratish
      final room = ChatRoom(
        id: '',
        buyerId: buyerId,
        buyerName: buyerName,
        sellerId: sellerId,
        sellerName: sellerName,
        productId: productId,
        productName: productName,
      );

      final docRef = await _firestore.collection('chatRooms').add(room.toMap());

      final newRoom = ChatRoom(
        id: docRef.id,
        buyerId: buyerId,
        buyerName: buyerName,
        sellerId: sellerId,
        sellerName: sellerName,
        productId: productId,
        productName: productName,
      );

      _chatRooms.insert(0, newRoom);
      notifyListeners();
      return newRoom;
    } catch (e) {
      debugPrint('Error creating chat room: $e');
      rethrow;
    }
  }

  /// Xabarlarni real-time stream sifatida olish
  Stream<List<Message>> getMessages(String chatRoomId) {
    return _firestore
        .collection('messages')
        .where('chatRoomId', isEqualTo: chatRoomId)
        .snapshots()
        .map((snapshot) {
      final messages = snapshot.docs.map((doc) {
        return Message.fromMap(doc.id, doc.data());
      }).toList();
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return messages;
    });
  }

  /// Xabar yuborish
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    try {
      final message = Message(
        id: '',
        chatRoomId: chatRoomId,
        senderId: senderId,
        senderName: senderName,
        text: text,
      );

      await _firestore.collection('messages').add(message.toMap());

      // Chat xonasini yangilash + unread oshirish
      final roomDoc =
          await _firestore.collection('chatRooms').doc(chatRoomId).get();
      final roomData = roomDoc.data();
      final isBuyer = roomData?['buyerId'] == senderId;

      await _firestore.collection('chatRooms').doc(chatRoomId).update({
        'lastMessage': text,
        'lastMessageAt': DateTime.now().toIso8601String(),
        // Qarama-qarshi tomonga unread qo'shish
        if (isBuyer) 'unreadSeller': FieldValue.increment(1),
        if (!isBuyer) 'unreadBuyer': FieldValue.increment(1),
      });

      // Lokal ro'yxatni yangilash
      final index = _chatRooms.indexWhere((r) => r.id == chatRoomId);
      if (index != -1) {
        _chatRooms[index] = _chatRooms[index].copyWith(
          lastMessage: text,
          lastMessageAt: DateTime.now(),
        );
        _chatRooms.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  /// Real-time unread listener
  void startUnreadListener(String userId) {
    _unreadBuyerSub?.cancel();
    _unreadSellerSub?.cancel();

    // Buyer sifatida chatRooms'ni kuzatish
    _unreadBuyerSub = _firestore
        .collection('chatRooms')
        .where('buyerId', isEqualTo: userId)
        .snapshots()
        .listen((snap) {
      _recalculateUnread(userId, snap.docs, true);
    });

    // Seller sifatida chatRooms'ni kuzatish
    _unreadSellerSub = _firestore
        .collection('chatRooms')
        .where('sellerId', isEqualTo: userId)
        .snapshots()
        .listen((snap) {
      _recalculateUnread(userId, snap.docs, false);
    });
  }

  int _buyerUnread = 0;
  int _sellerUnread = 0;

  void _recalculateUnread(
      String userId, List<QueryDocumentSnapshot> docs, bool isBuyer) {
    int count = 0;
    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (isBuyer) {
        count += (data['unreadBuyer'] as num?)?.toInt() ?? 0;
      } else {
        count += (data['unreadSeller'] as num?)?.toInt() ?? 0;
      }
    }
    if (isBuyer) {
      _buyerUnread = count;
    } else {
      _sellerUnread = count;
    }
    _unreadCount = _buyerUnread + _sellerUnread;
    notifyListeners();
  }

  /// Chatga kirganda o'qilgan deb belgilash
  Future<void> markAsRead(String chatRoomId, String userId) async {
    try {
      // Chat xonasini topish
      final doc =
          await _firestore.collection('chatRooms').doc(chatRoomId).get();
      if (!doc.exists) return;
      final data = doc.data()!;
      final isBuyer = data['buyerId'] == userId;

      await _firestore.collection('chatRooms').doc(chatRoomId).update({
        if (isBuyer) 'unreadBuyer': 0,
        if (!isBuyer) 'unreadSeller': 0,
      });
    } catch (e) {
      debugPrint('Error marking as read: $e');
    }
  }

  void stopUnreadListener() {
    _unreadBuyerSub?.cancel();
    _unreadSellerSub?.cancel();
  }
}
