import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/cart_service.dart';
import '../../services/chat_service.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';
import 'buyer_home_screen.dart';
import 'product_list_screen.dart';
import 'cart_screen.dart';
import 'buyer_orders_screen.dart';
import '../chat/chat_list_screen.dart';
import '../profile_screen.dart';
import '../../services/product_service.dart';
import '../../services/alert_service.dart';

class BuyerMainScreen extends StatefulWidget {
  const BuyerMainScreen({super.key});

  @override
  State<BuyerMainScreen> createState() => BuyerMainScreenState();
}

class BuyerMainScreenState extends State<BuyerMainScreen> {
  int _currentIndex = 0;
  bool _alertsChecked = false;

  final List<Widget> _screens = const [
    BuyerHomeScreen(),
    ProductListScreen(),
    CartScreen(),
    BuyerOrdersScreen(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  void switchToTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthService>().currentUser?.id ?? '';
    if (userId.isNotEmpty) {
      context.read<ChatService>().startUnreadListener(userId);
    }
    // Mahsulotlar o'zgarganda alertlarni tekshirish uchun listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productService = context.read<ProductService>();
      productService.addListener(_onProductsChanged);
      // Agar mahsulotlar allaqachon yuklangan bo'lsa, darhol tekshiramiz
      if (productService.allProducts.isNotEmpty) {
        _checkAlerts();
      }
    });
  }

  @override
  void dispose() {
    // Listenerni olib tashlash
    try {
      context.read<ProductService>().removeListener(_onProductsChanged);
    } catch (_) {}
    super.dispose();
  }

  void _onProductsChanged() {
    // Mahsulotlar yangilanganda alertlarni qayta tekshirish
    _checkAlerts();
  }

  void _checkAlerts() {
    if (!mounted) return;

    final alertService = context.read<AlertService>();
    final products = context.read<ProductService>().allProducts;

    if (products.isEmpty) return;

    for (var alert in alertService.alerts) {
      if (!alert.isTriggered) {
        // Mahsulot nomi yoki modeli alert bilan mos kelishi va narxi maqsadli narxdan past bo'lishi
        final matches = products.where((p) {
          final nameMatch =
              p.name.toLowerCase().contains(alert.productModel.toLowerCase());
          final modelMatch = p.productModel
              .toLowerCase()
              .contains(alert.productModel.toLowerCase());
          final priceMatch = p.price <= alert.targetPrice;
          return (nameMatch || modelMatch) && priceMatch;
        });

        if (matches.isNotEmpty) {
          alertService.markAsTriggered(alert.id);
          final matchedProduct = matches.first;

          if (mounted) {
            // Chiroyli bildirishnoma ko'rsatish
            _showAlertNotification(
                alert, matchedProduct.name, matchedProduct.price);
          }
        }
      }
    }
  }

  void _showAlertNotification(
      PriceAlert alert, String productName, double productPrice) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.celebration, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "🎉 ${alert.productModel} topildi!",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  "$productName — ${productPrice.toStringAsFixed(0)} so'm",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: AppTheme.success,
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(12),
      action: SnackBarAction(
        label: "Ko'rish",
        onPressed: () => switchToTab(1),
        textColor: Colors.white,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeService>().isDark;
    final bgColor = isDark ? AppTheme.primaryMid : AppTheme.lightBg;

    // Mahsulotlar o'zgarganda alertlarni reaktiv tekshirish
    final products = context.watch<ProductService>().allProducts;
    if (products.isNotEmpty && !_alertsChecked) {
      _alertsChecked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAlerts();
      });
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: _screens[_currentIndex],
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
            child: Consumer3<CartService, ChatService, LocaleService>(
              builder: (context, cartService, chatService, locale, child) {
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
                          icon: const Icon(Icons.home_outlined),
                          activeIcon: const Icon(Icons.home),
                          label: locale.t('home').toUpperCase()),
                      BottomNavigationBarItem(
                          icon: const Icon(Icons.search),
                          activeIcon: const Icon(Icons.search),
                          label: locale.t('search').toUpperCase()),
                      BottomNavigationBarItem(
                        icon: Badge(
                            isLabelVisible: cartService.itemCount > 0,
                            label: Text('${cartService.itemCount}',
                                style: const TextStyle(fontSize: 10)),
                            child: const Icon(Icons.shopping_cart_outlined)),
                        activeIcon: Badge(
                            isLabelVisible: cartService.itemCount > 0,
                            label: Text('${cartService.itemCount}',
                                style: const TextStyle(fontSize: 10)),
                            child: const Icon(Icons.shopping_cart)),
                        label: locale.t('cart').toUpperCase(),
                      ),
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
