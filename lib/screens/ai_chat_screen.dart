import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/locale_service.dart';
import '../services/theme_service.dart';
import '../widgets/gradient_scaffold.dart';
import '../services/ai_agent_service.dart';
import '../services/product_service.dart';

class _ChatMsg {
  final String text;
  final bool isUser;
  _ChatMsg(this.text, {this.isUser = false});
}

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMsg> _messages = [];

  @override
  void initState() {
    super.initState();
    final locale = context.read<LocaleService>();
    _messages.add(_ChatMsg(locale.t('ai_greeting')));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMsg(text, isUser: true));
    });
    _controller.clear();
    _scrollToBottom();

    final aiService = context.read<AiAgentService>();
    final productService = context.read<ProductService>();
    final locale = context.read<LocaleService>();

    final answer = await aiService.sendChatMessage(
      text,
      productService.allProducts,
      locale.language.name,
    );

    if (mounted) {
      setState(() {
        _messages.add(_ChatMsg(answer));
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final isDark = context.watch<ThemeService>().isDark;

    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text(locale.t('ai_chat_title')),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildBubble(msg, isDark);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.primaryMid : Colors.white,
              border: Border(
                  top: BorderSide(
                      color: isDark
                          ? AppTheme.accentBlue.withValues(alpha: 0.15)
                          : AppTheme.lightCardBorder)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: locale.t('ask_question'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor:
                            isDark ? AppTheme.cardDark : AppTheme.lightBg,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                      ),
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
                      icon: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
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

  Widget _buildBubble(_ChatMsg msg, bool isDark) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          gradient: msg.isUser ? AppTheme.accentGradient : null,
          color: msg.isUser
              ? null
              : (isDark ? AppTheme.cardDark : AppTheme.lightCard),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
            bottomRight: Radius.circular(msg.isUser ? 4 : 16),
          ),
          border: msg.isUser
              ? null
              : Border.all(
                  color: isDark
                      ? AppTheme.accentBlue.withValues(alpha: 0.2)
                      : AppTheme.lightCardBorder),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: msg.isUser
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
