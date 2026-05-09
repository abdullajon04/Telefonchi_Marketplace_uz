import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/product_service.dart';
import '../../services/order_service.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';
import '../../widgets/stat_card.dart';
import '../../models/order.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Buyurtmalarni Firestore'dan yuklash
    final userId = context.read<AuthService>().currentUser?.id ?? '';
    if (userId.isNotEmpty) {
      context.read<OrderService>().loadOrdersBySeller(userId);
    }
  }

  String _formatPrice(double price, LocaleService locale) {
    final formatter = NumberFormat('#,###', 'ru_RU');
    return '${formatter.format(price)} ${locale.t('sum')}';
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppTheme.warning;
      case OrderStatus.processing:
        return AppTheme.accentLight;
      case OrderStatus.shipped:
        return AppTheme.accentCyan;
      case OrderStatus.delivered:
        return AppTheme.success;
      case OrderStatus.cancelled:
        return AppTheme.error;
    }
  }

  String _orderStatusText(OrderStatus status, LocaleService locale) {
    switch (status) {
      case OrderStatus.pending: return locale.t('status_pending');
      case OrderStatus.processing: return locale.t('status_processing');
      case OrderStatus.shipped: return locale.t('status_shipped');
      case OrderStatus.delivered: return locale.t('status_delivered');
      case OrderStatus.cancelled: return locale.t('status_cancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthService>().currentUser?.id ?? '';
    final userName = context.read<AuthService>().currentUser?.name ?? '';
    final isDark = context.watch<ThemeService>().isDark;

    return Consumer3<ProductService, OrderService, LocaleService>(
      builder: (context, productService, orderService, locale, child) {
        final myProducts = productService.getProductsBySeller(userId);
        final myOrders = orderService.getOrdersBySeller(userId);
        final totalRevenue = orderService.getTotalRevenue(userId);
        final totalSold = orderService.getTotalProductsSold(userId);

        return CustomScrollView(
          slivers: [
            // Glassmorphism AppBar
            SliverToBoxAdapter(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    color: isDark
                        ? AppTheme.primaryMid.withValues(alpha: 0.8)
                        : AppTheme.lightBg.withValues(alpha: 0.8),
                    padding: EdgeInsets.fromLTRB(
                        24, MediaQuery.of(context).padding.top + 16, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                'assets/images/telefonchi.png',
                                width: 28,
                                height: 28,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Telefonchi',
                              style: AppTheme.brandTextStyle(
                                color: isDark
                                    ? Colors.white
                                    : AppTheme.primaryDark,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.settings_outlined,
                              size: 20,
                              color: isDark
                                  ? Colors.white
                                  : AppTheme.lightTextSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Welcome header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(locale.t('welcome'),
                        style: TextStyle(
                            color: isDark
                                ? AppTheme.textSecondary
                                : AppTheme.lightTextSecondary,
                            fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(userName,
                        style: TextStyle(
                            color: isDark
                                ? AppTheme.textPrimary
                                : AppTheme.lightTextPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6)),
                  ],
                ),
              ),
            ),

            // Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: locale.t('total_products'),
                            value: '${myProducts.length}',
                            icon: Icons.inventory_2_outlined,
                            iconColor: AppTheme.accentLight,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: StatCard(
                            title: locale.t('total_orders'),
                            value: '${myOrders.length}',
                            icon: Icons.receipt_long_outlined,
                            iconColor: AppTheme.accentCyan,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: locale.t('total_sold'),
                            value: '$totalSold ${locale.t('pcs')}',
                            icon: Icons.trending_up,
                            iconColor: AppTheme.success,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: StatCard(
                            title: locale.t('total_revenue'),
                            value: _formatPrice(totalRevenue, locale),
                            icon: Icons.account_balance_wallet_outlined,
                            iconColor: AppTheme.warning,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Recent orders
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.t('orders'),
                      style: TextStyle(
                          color: isDark
                              ? AppTheme.textPrimary
                              : AppTheme.lightTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${myOrders.length} ${locale.t('all')}',
                      style: TextStyle(
                          color: isDark
                              ? AppTheme.textHint
                              : AppTheme.lightTextSecondary,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            if (myOrders.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long_outlined,
                            size: 50,
                            color: (isDark
                                    ? AppTheme.textHint
                                    : AppTheme.lightTextHint)
                                .withValues(alpha: 0.4)),
                        const SizedBox(height: 12),
                        Text(locale.t('no_orders'),
                            style: TextStyle(
                                color: isDark
                                    ? AppTheme.textSecondary
                                    : AppTheme.lightTextSecondary,
                                fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final order = myOrders[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 6),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppTheme.cardDark.withValues(alpha: 0.7)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: isDark
                                  ? AppTheme.accentBlue.withValues(alpha: 0.2)
                                  : AppTheme.lightCardBorder,
                              width: isDark ? 1 : 1.2),
                          boxShadow: [
                            if (!isDark)
                              BoxShadow(
                                  color: const Color(0xFF000666)
                                      .withValues(alpha: 0.08),
                                  blurRadius: 16,
                                  offset: Offset(0, 6)),
                            BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: isDark ? 0.3 : 0.05),
                                blurRadius: isDark ? 12 : 4,
                                offset: Offset(0, isDark ? 4 : 2)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: _statusColor(order.status)
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.shopping_bag_outlined,
                                  color: _statusColor(order.status), size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(order.buyerName,
                                      style: TextStyle(
                                          color: isDark
                                              ? AppTheme.textPrimary
                                              : AppTheme.lightTextPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${order.items.length} ${locale.t('items_word')} • ${DateFormat('dd.MM.yy').format(order.createdAt)}',
                                    style: TextStyle(
                                        color: isDark
                                            ? AppTheme.textHint
                                            : AppTheme.lightTextSecondary,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(_formatPrice(order.totalAmount, locale),
                                    style: TextStyle(
                                        color: isDark
                                            ? AppTheme.accentCyan
                                            : AppTheme.primaryDark,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: _statusColor(order.status)
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                      _orderStatusText(order.status, locale),
                                      style: TextStyle(
                                          color: _statusColor(order.status),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: myOrders.length > 5 ? 5 : myOrders.length,
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      },
    );
  }
}
