import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';
import 'seller_dashboard_screen.dart';
import 'seller_products_screen.dart';
import 'seller_orders_screen.dart';
import '../chat/chat_list_screen.dart';
import '../profile_screen.dart';

class SellerMainScreen extends StatefulWidget {
  const SellerMainScreen({super.key});

  @override
  State<SellerMainScreen> createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends State<SellerMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SellerDashboardScreen(),
    SellerProductsScreen(),
    SellerOrdersScreen(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthService>().currentUser?.id ?? '';
    if (userId.isNotEmpty) {
      context.read<ChatService>().startUnreadListener(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeService>().isDark;
    final bgColor = isDark ? AppTheme.primaryMid : AppTheme.lightBg;

    return Scaffold(
      backgroundColor: bgColor,
      body: _screens[_currentIndex],
      floatingActionButton: _currentIndex <= 1
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/add-product'),
              backgroundColor: AppTheme.primaryDark,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.primaryMid.withValues(alpha: 0.85)
                  : Colors.white.withValues(alpha: 0.95),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              border: Border(
                  top: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : AppTheme.lightCardBorder)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, -4))
              ],
            ),
            child: Consumer2<ChatService, LocaleService>(
              builder: (context, chatService, locale, child) {
                final unread = chatService.unreadCount;
                return Theme(
                  data: Theme.of(context).copyWith(
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      backgroundColor: Colors.transparent,
                      selectedItemColor:
                          isDark ? Colors.white : AppTheme.primaryDark,
                      unselectedItemColor: isDark
                          ? AppTheme.textHint
                          : AppTheme.lightTextSecondary,
                      selectedLabelStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.275),
                      unselectedLabelStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.275),
                      type: BottomNavigationBarType.fixed,
                      elevation: 0,
                    ),
                  ),
                  child: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) => setState(() => _currentIndex = index),
                    items: [
                      BottomNavigationBarItem(
                          icon: const Icon(Icons.dashboard_outlined),
                          activeIcon: const Icon(Icons.dashboard),
                          label: locale.t('dashboard').toUpperCase()),
                      BottomNavigationBarItem(
                          icon: const Icon(Icons.inventory_2_outlined),
                          activeIcon: const Icon(Icons.inventory_2),
                          label: locale.t('products').toUpperCase()),
                      BottomNavigationBarItem(
                          icon: const Icon(Icons.receipt_long_outlined),
                          activeIcon: const Icon(Icons.receipt_long),
                          label: locale.t('orders').toUpperCase()),
                      BottomNavigationBarItem(
                        icon: Badge(
                            isLabelVisible: unread > 0,
                            label: Text('$unread',
                                style: const TextStyle(fontSize: 10)),
                            child: const Icon(Icons.chat_bubble_outline)),
                        activeIcon: Badge(
                            isLabelVisible: unread > 0,
                            label: Text('$unread',
                                style: const TextStyle(fontSize: 10)),
                            child: const Icon(Icons.chat_bubble)),
                        label: locale.t('chat').toUpperCase(),
                      ),
                      BottomNavigationBarItem(
                          icon: const Icon(Icons.person_outline),
                          activeIcon: const Icon(Icons.person),
                          label: locale.t('profile').toUpperCase()),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
