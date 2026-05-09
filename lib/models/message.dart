class ChatRoom {
  final String id;
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final String sellerName;
  final String productId;
  final String productName;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadBuyer;
  final int unreadSeller;

  ChatRoom({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.sellerId,
    required this.sellerName,
    this.productId = '',
    this.productName = '',
    this.lastMessage = '',
    DateTime? lastMessageAt,
    this.unreadBuyer = 0,
    this.unreadSeller = 0,
  }) : lastMessageAt = lastMessageAt ?? DateTime.now();

  ChatRoom copyWith({
    String? id,
    String? buyerId,
    String? buyerName,
    String? sellerId,
    String? sellerName,
    String? productId,
    String? productName,
    String? lastMessage,
    DateTime? lastMessageAt,
    int? unreadBuyer,
    int? unreadSeller,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadBuyer: unreadBuyer ?? this.unreadBuyer,
      unreadSeller: unreadSeller ?? this.unreadSeller,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buyerId': buyerId,
      'buyerName': buyerName,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'productId': productId,
      'productName': productName,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'unreadBuyer': unreadBuyer,
      'unreadSeller': unreadSeller,
    };
  }

  factory ChatRoom.fromMap(String id, Map<String, dynamic> map) {
    return ChatRoom(
      id: id,
      buyerId: map['buyerId'] ?? '',
      buyerName: map['buyerName'] ?? '',
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageAt: map['lastMessageAt'] != null
          ? DateTime.parse(map['lastMessageAt'])
          : DateTime.now(),
      unreadBuyer: map['unreadBuyer'] ?? 0,
      unreadSeller: map['unreadSeller'] ?? 0,
    );
  }
}

class Message {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime createdAt;
  final bool isRead;

  Message({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.senderName,
    required this.text,
    DateTime? createdAt,
    this.isRead = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory Message.fromMap(String id, Map<String, dynamic> map) {
    return Message(
      id: id,
      chatRoomId: map['chatRoomId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      text: map['text'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      isRead: map['isRead'] ?? false,
    );
  }
}
