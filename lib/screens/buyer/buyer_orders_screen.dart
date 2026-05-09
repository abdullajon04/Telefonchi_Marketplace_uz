import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/order_service.dart';
import '../../models/order.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';

class BuyerOrdersScreen extends StatefulWidget {
  const BuyerOrdersScreen({super.key});

  @override
  State<BuyerOrdersScreen> createState() => _BuyerOrdersScreenState();
}

class _BuyerOrdersScreenState extends State<BuyerOrdersScreen> {
  @override
  void initState() {
    super.initState();
    // Buyurtmalarni Firestore'dan yuklash
    final userId = context.read<AuthService>().currentUser?.id ?? '';
    if (userId.isNotEmpty) {
      context.read<OrderService>().loadOrdersByBuyer(userId);
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
      case OrderStatus.pending:
        return locale.t('status_pending');
      case OrderStatus.processing:
        return locale.t('status_processing');
      case OrderStatus.shipped:
        return locale.t('status_shipped');
      case OrderStatus.delivered:
        return locale.t('status_delivered');
      case OrderStatus.cancelled:
        return locale.t('status_cancelled');
    }
  }

  String _paymentText(PaymentMethod method, LocaleService locale) {
    switch (method) {
      case PaymentMethod.online:
        return locale.t('pay_online');
      case PaymentMethod.offline:
        return locale.t('pay_offline');
    }
  }

  Future<void> _refreshOrders() async {
    final userId = context.read<AuthService>().currentUser?.id ?? '';
    if (userId.isNotEmpty) {
      await context.read<OrderService>().loadOrdersByBuyer(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthService>().currentUser?.id ?? '';
    final isDark = context.watch<ThemeService>().isDark;

    final locale = context.watch<LocaleService>();
    return Consumer<OrderService>(
      builder: (context, orderService, child) {
        final orders = orderService.getOrdersByBuyer(userId);

        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: (isDark ? AppTheme.textHint : AppTheme.lightTextHint)
                      .withValues(alpha: 0.4),
                ),
                const SizedBox(height: 16),
                Text(
                  locale.t('no_orders'),
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.textPrimary
                        : AppTheme.lightTextPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  locale.t('no_orders_desc'),
                  style: TextStyle(
                      color: isDark
                          ? AppTheme.textSecondary
                          : AppTheme.lightTextSecondary,
                      fontSize: 15),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppTheme.primaryDark,
          backgroundColor: isDark ? AppTheme.primaryMid : AppTheme.lightSurface,
          onRefresh: _refreshOrders,
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: AppTheme.getGlassDecoration(isDark),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${locale.t('order_num')} #${order.id.substring(0, 8)}',
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.textPrimary
                                  : AppTheme.lightTextPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(order.status)
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _orderStatusText(order.status, locale),
                              style: TextStyle(
                                color: _statusColor(order.status),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        DateFormat('dd.MM.yyyy HH:mm').format(order.createdAt),
                        style: TextStyle(
                          color: isDark
                              ? AppTheme.textHint
                              : AppTheme.lightTextHint,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...order.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.product.name} x${item.quantity}',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppTheme.textSecondary
                                        : AppTheme.lightTextSecondary,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                _formatPrice(item.totalPrice, locale),
                                style: TextStyle(
                                  color: isDark
                                      ? AppTheme.textPrimary
                                      : AppTheme.lightTextPrimary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Delivery info
                      if (order.deliveryInfo.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.accentCyan.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.local_shipping,
                                  color: AppTheme.accentCyan, size: 14),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  order.deliveryInfo,
                                  style: const TextStyle(
                                      color: AppTheme.accentCyan, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),

                      Divider(
                          color: isDark
                              ? AppTheme.cardLight
                              : AppTheme.lightCardBorder,
                          height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _paymentText(order.paymentMethod, locale),
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.textHint
                                  : AppTheme.lightTextHint,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _formatPrice(order.totalAmount, locale),
                            style: const TextStyle(
                              color: AppTheme.accentCyan,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Track order button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/order-tracking',
                              arguments: order,
                            );
                          },
                          icon: const Icon(Icons.track_changes, size: 16),
                          label: Text(locale.t('track_order'),
                              style: const TextStyle(fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.accentLight,
                            side: BorderSide(
                                color:
                                    AppTheme.accentBlue.withValues(alpha: 0.3)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
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
