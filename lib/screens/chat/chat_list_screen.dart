import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthService>().currentUser?.id ?? '';
    if (userId.isNotEmpty) {
      context.read<ChatService>().loadChatRooms(userId);
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return DateFormat('HH:mm').format(date);
    }
    return DateFormat('dd.MM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthService>().currentUser?.id ?? '';
    final isSeller =
        context.read<AuthService>().currentUser?.role.name == 'seller';
    final isDark = context.watch<ThemeService>().isDark;

    final locale = context.watch<LocaleService>();
    return Consumer<ChatService>(
      builder: (context, chatService, child) {
        final rooms = chatService.chatRooms;

        if (rooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline,
                    size: 64,
                    color: (isDark ? AppTheme.textHint : AppTheme.lightTextHint)
                        .withValues(alpha: 0.3)),
                const SizedBox(height: 16),
                Text(
                  locale.t('no_messages'),
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.textSecondary
                        : AppTheme.lightTextSecondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  locale.t('start_chat_from_product'),
                  style: TextStyle(
                      color:
                          isDark ? AppTheme.textHint : AppTheme.lightTextHint,
                      fontSize: 14),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppTheme.primaryDark,
          backgroundColor: isDark ? AppTheme.primaryMid : AppTheme.lightSurface,
          onRefresh: () => chatService.loadChatRooms(userId),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              final otherName = isSeller ? room.buyerName : room.sellerName;
              final initial =
                  otherName.isNotEmpty ? otherName[0].toUpperCase() : '?';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(chatRoom: room),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: AppTheme.getGlassDecoration(isDark),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    otherName,
                                    style: TextStyle(
                                      color: isDark
                                          ? AppTheme.textPrimary
                                          : AppTheme.lightTextPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  _formatTime(room.lastMessageAt),
                                  style: TextStyle(
                                    color: isDark
                                        ? AppTheme.textHint
                                        : AppTheme.lightTextHint,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            if (room.productName.isNotEmpty)
                              Text(
                                room.productName,
                                style: const TextStyle(
                                  color: AppTheme.accentCyan,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            Text(
                              room.lastMessage.isNotEmpty
                                  ? room.lastMessage
                                  : locale.t('no_messages'),
                              style: TextStyle(
                                color: room.lastMessage.isNotEmpty
                                    ? (isDark
                                        ? AppTheme.textSecondary
                                        : AppTheme.lightTextSecondary)
                                    : (isDark
                                        ? AppTheme.textHint
                                        : AppTheme.lightTextHint),
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
