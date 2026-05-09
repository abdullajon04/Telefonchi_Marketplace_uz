import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import '../../models/message.dart';
import '../../services/locale_service.dart';
import '../../widgets/gradient_scaffold.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatScreen({super.key, required this.chatRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Chatga kirganda o'qilgan deb belgilash
    final userId = context.read<AuthService>().currentUser?.id ?? '';
    if (userId.isNotEmpty) {
      context.read<ChatService>().markAsRead(widget.chatRoom.id, userId);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final user = context.read<AuthService>().currentUser;
    if (user == null) return;

    context.read<ChatService>().sendMessage(
          chatRoomId: widget.chatRoom.id,
          senderId: user.id,
          senderName: user.name,
          text: text,
        );

    _messageController.clear();

    // Pastga scroll qilish
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final user = context.read<AuthService>().currentUser;
    final isSeller = user?.role.name == 'seller';
    final otherName =
        isSeller ? widget.chatRoom.buyerName : widget.chatRoom.sellerName;

    return GradientScaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(otherName, style: const TextStyle(fontSize: 16)),
            if (widget.chatRoom.productName.isNotEmpty)
              Text(
                widget.chatRoom.productName,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.accentCyan,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Xabarlar ro'yxati
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream:
                  context.read<ChatService>().getMessages(widget.chatRoom.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: AppTheme.accentLight),
                  );
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      locale.t('start_dialog'),
                      style: TextStyle(color: AppTheme.textHint, fontSize: 15),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == user?.id;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: isMe ? AppTheme.accentGradient : null,
                          color: isMe ? null : AppTheme.cardDark,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isMe ? 16 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (!isMe)
                              Text(
                                msg.senderName,
                                style: const TextStyle(
                                  color: AppTheme.accentCyan,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            Text(
                              msg.text,
                              style: TextStyle(
                                color:
                                    isMe ? Colors.white : AppTheme.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatTime(msg.createdAt),
                              style: TextStyle(
                                color:
                                    isMe ? Colors.white70 : AppTheme.textHint,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Xabar yozish paneli
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryDark,
              border: Border(
                top: BorderSide(
                  color: AppTheme.accentBlue.withValues(alpha: 0.15),
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText: locale.t('message_hint'),
                        hintStyle: const TextStyle(color: AppTheme.textHint),
                        filled: true,
                        fillColor: AppTheme.cardDark,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon:
                          const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
