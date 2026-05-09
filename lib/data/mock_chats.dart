import '../models/chat_message.dart';

class MockChats {
  static List<ChatMessage> getChatMessages(String roomId) {
    switch (roomId) {
      case 'chat1':
        return [
          ChatMessage(
            id: 'msg1',
            roomId: 'chat1',
            senderId: 'buyer1',
            senderName: 'Али',
            text: 'Добрый день! iPhone 15 Pro Max в наличии?',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg2',
            roomId: 'chat1',
            senderId: 'seller1',
            senderName: 'Apple Store',
            text:
                'Добрый день! Да, iPhone 15 Pro Max есть на складе. Цвета: черный, белый, синий.',
            timestamp:
                DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg3',
            roomId: 'chat1',
            senderId: 'buyer1',
            senderName: 'Али',
            text: 'Какая доставка по Ташкенту?',
            timestamp:
                DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg4',
            roomId: 'chat1',
            senderId: 'seller1',
            senderName: 'Apple Store',
            text:
                'Доставка по Ташкенту 1-2 дня, стоимость 20 000 сум. Есть самовывоз из нашего магазина на проспекте Мустакиллик.',
            timestamp:
                DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg5',
            roomId: 'chat1',
            senderId: 'buyer1',
            senderName: 'Али',
            text: 'Отлично, заказываю! Как оформить?',
            timestamp:
                DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
            isRead: true,
          ),
        ];

      case 'chat2':
        return [
          ChatMessage(
            id: 'msg6',
            roomId: 'chat2',
            senderId: 'buyer2',
            senderName: 'Даврон',
            text: 'Здравствуйте! Есть ли скидка на Samsung Galaxy S24 Ultra?',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg7',
            roomId: 'chat2',
            senderId: 'seller2',
            senderName: 'Samsung Official',
            text:
                'Здравствуйте! Сейчас на S24 Ultra действует скидка 5% при покупке с чехлом и защитным стеклом.',
            timestamp:
                DateTime.now().subtract(const Duration(hours: 2, minutes: 50)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg8',
            roomId: 'chat2',
            senderId: 'buyer2',
            senderName: 'Даврон',
            text: 'А какая комплектация? Оригинальная?',
            timestamp:
                DateTime.now().subtract(const Duration(hours: 2, minutes: 40)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg9',
            roomId: 'chat2',
            senderId: 'seller2',
            senderName: 'Samsung Official',
            text:
                'Да, только оригинальная комплектация: телефон, зарядное устройство, кабель, инструкция, гарантийный талон.',
            timestamp:
                DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
            isRead: true,
          ),
        ];

      case 'chat3':
        return [
          ChatMessage(
            id: 'msg10',
            roomId: 'chat3',
            senderId: 'buyer3',
            senderName: 'Малика',
            text: 'Xiaomi 14 Ultra qancha turadi?',
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg11',
            roomId: 'chat3',
            senderId: 'seller3',
            senderName: 'Xiaomi Store',
            text:
                'Assalomu alaykum! Xiaomi 14 Ultra narxi 999 000 so\'m. Barcha ranglari bor.',
            timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg12',
            roomId: 'chat3',
            senderId: 'buyer3',
            senderName: 'Малика',
            text: 'Bo\'lib to\'lash mumkinmi?',
            timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg13',
            roomId: 'chat3',
            senderId: 'seller3',
            senderName: 'Xiaomi Store',
            text:
                'Ha, 12 oyga 0% bo\'lib tolash mumkin. Batafsil ma\'lumot uchun do\'konimizga tashrif buyuring.',
            timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
            isRead: true,
          ),
        ];

      default:
        return [];
    }
  }

  static List<String> getChatRooms() {
    return ['chat1', 'chat2', 'chat3'];
  }

  static Map<String, String> getChatRoomInfo(String roomId) {
    switch (roomId) {
      case 'chat1':
        return {
          'roomId': 'chat1',
          'participantId': 'seller1',
          'participantName': 'Apple Store',
          'lastMessage': 'Отлично, заказываю! Как оформить?',
          'lastMessageTime': '1 час назад',
          'unreadCount': '0',
          'isOnline': 'true',
        };
      case 'chat2':
        return {
          'roomId': 'chat2',
          'participantId': 'seller2',
          'participantName': 'Samsung Official',
          'lastMessage': 'Да, только оригинальная комплектация...',
          'lastMessageTime': '2 часа назад',
          'unreadCount': '0',
          'isOnline': 'true',
        };
      case 'chat3':
        return {
          'roomId': 'chat3',
          'participantId': 'seller3',
          'participantName': 'Xiaomi Store',
          'lastMessage': 'Ha, 12 oyga 0% bo\'lib tolash mumkin...',
          'lastMessageTime': '15 минут назад',
          'unreadCount': '0',
          'isOnline': 'false',
        };
      default:
        return {};
    }
  }
}
