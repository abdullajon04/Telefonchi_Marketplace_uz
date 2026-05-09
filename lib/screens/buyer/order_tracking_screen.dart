import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../services/order_service.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';
import '../../models/order.dart';
import '../../widgets/gradient_scaffold.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }

  String _formatPrice(double price, LocaleService locale) {
    final formatter = NumberFormat('#,###', 'ru_RU');
    return '${formatter.format(price)} ${locale.t('sum')}';
  }

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)?.settings.arguments as Order?;
    final locale = context.watch<LocaleService>();
    final isDark = context.watch<ThemeService>().isDark;

    if (order == null) {
      return GradientScaffold(
        appBar: null,
        body: Center(child: Text(locale.t('order_not_found'))),
      );
    }

    return GradientScaffold(
      appBar: AppBar(
          title: Text('${locale.t('order_num')} #${order.id.substring(0, 8)}')),
      body: Consumer<OrderService>(
        builder: (context, orderService, child) {
          // Yangilangan buyurtmani topish
          final currentOrder = orderService.allOrders
                  .where((o) => o.id == order.id)
                  .firstOrNull ??
              order;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery method card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.getGlassDecoration(isDark),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _deliveryIcon(currentOrder.deliveryMethod),
                          color: AppTheme.accentLight,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _deliveryDisplayName(
                                  currentOrder.deliveryMethod, locale),
                              style: TextStyle(
                                color: isDark
                                    ? AppTheme.textPrimary
                                    : AppTheme.lightTextPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentOrder.buyerAddress,
                              style: TextStyle(
                                color: isDark
                                    ? AppTheme.textSecondary
                                    : AppTheme.lightTextSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Delivery info
                if (currentOrder.deliveryInfo.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppTheme.getGlassDecoration(isDark),
                    child: Row(
                      children: [
                        const Icon(Icons.local_shipping,
                            color: AppTheme.accentCyan, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locale.t('delivery_details'),
                                style: TextStyle(
                                    color: isDark
                                        ? AppTheme.textHint
                                        : AppTheme.lightTextHint,
                                    fontSize: 12),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                currentOrder.deliveryInfo,
                                style: TextStyle(
                                  color: isDark
                                      ? AppTheme.accentLight
                                      : AppTheme.primaryDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Status timeline
                Text(
                  locale.t('delivery_status'),
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.textPrimary
                        : AppTheme.lightTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTimeline(currentOrder, locale, isDark),
                const SizedBox(height: 24),

                // Confirm delivery button (for buyer)
                if (currentOrder.status == OrderStatus.shipped)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(locale.t('confirm_delivery_q')),
                            content: Text(locale.t('confirm_delivery_desc')),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text(locale.t('no')),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(locale.t('yes_received')),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await orderService.confirmDelivery(currentOrder.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(locale.t('delivery_confirmed')),
                                backgroundColor: AppTheme.success,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.check_circle),
                      label: Text(
                        locale.t('confirm_delivery'),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.success,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                // Order info
                const SizedBox(height: 24),
                Text(
                  locale.t('order_details'),
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.textPrimary
                        : AppTheme.lightTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(locale.t('order_date'),
                    _formatDate(currentOrder.createdAt), isDark),
                _buildInfoRow(
                    locale.t('payment_type'),
                    _paymentDisplayName(currentOrder.paymentMethod, locale),
                    isDark),
                _buildInfoRow(locale.t('items_count'),
                    '${currentOrder.items.length} ${locale.t('pcs')}', isDark),
                if (currentOrder.deliveryPrice > 0)
                  _buildInfoRow(
                    locale.t('delivery_word'),
                    _formatPrice(currentOrder.deliveryPrice, locale),
                    isDark,
                  ),
                if (currentOrder.estimatedDelivery != null)
                  _buildInfoRow(
                    locale.t('expected_delivery'),
                    DateFormat('dd.MM.yyyy')
                        .format(currentOrder.estimatedDelivery!),
                    isDark,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _deliveryDisplayName(DeliveryMethod method, LocaleService locale) {
    switch (method) {
      case DeliveryMethod.pickup:
        return locale.t('delivery_pickup');
      case DeliveryMethod.yandexGo:
        return locale.t('delivery_yandex');
      case DeliveryMethod.uzumTezkor:
        return locale.t('delivery_uzum');
      case DeliveryMethod.btsExpress:
        return locale.t('delivery_bts');
    }
  }

  String _paymentDisplayName(PaymentMethod method, LocaleService locale) {
    switch (method) {
      case PaymentMethod.online:
        return locale.t('pay_online');
      case PaymentMethod.offline:
        return locale.t('pay_offline');
    }
  }

  Widget _buildTimeline(Order order, LocaleService locale, bool isDark) {
    final steps = [
      _TimelineStep(
        title: locale.t('timeline_placed'),
        subtitle: locale.t('timeline_placed_sub'),
        icon: Icons.receipt_long,
        isCompleted: true,
        isActive: order.status == OrderStatus.pending,
      ),
      _TimelineStep(
        title: locale.t('timeline_processing'),
        subtitle: locale.t('timeline_processing_sub'),
        icon: Icons.inventory_2,
        isCompleted: order.status.index >= OrderStatus.processing.index,
        isActive: order.status == OrderStatus.processing,
      ),
      _TimelineStep(
        title: locale.t('timeline_shipped'),
        subtitle: order.deliveryInfo.isNotEmpty
            ? order.deliveryInfo
            : locale.t('timeline_shipped_sub'),
        icon: Icons.local_shipping,
        isCompleted: order.status.index >= OrderStatus.shipped.index,
        isActive: order.status == OrderStatus.shipped,
      ),
      _TimelineStep(
        title: locale.t('timeline_delivered'),
        subtitle: locale.t('timeline_delivered_sub'),
        icon: Icons.check_circle,
        isCompleted: order.status == OrderStatus.delivered,
        isActive: order.status == OrderStatus.delivered,
      ),
    ];

    if (order.status == OrderStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.cancel, color: AppTheme.error, size: 28),
            const SizedBox(width: 12),
            Text(
              locale.t('order_cancelled'),
              style: const TextStyle(
                color: AppTheme.error,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicator column
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: step.isCompleted || step.isActive
                          ? AppTheme.accentGradient
                          : null,
                      color: step.isCompleted || step.isActive
                          ? null
                          : (isDark
                              ? AppTheme.cardDark
                              : AppTheme.lightSurfaceMuted),
                      border: !step.isCompleted && !step.isActive
                          ? Border.all(
                              color: isDark
                                  ? AppTheme.textHint
                                  : AppTheme.lightTextHint,
                              width: 1.5)
                          : null,
                    ),
                    child: Icon(
                      step.icon,
                      size: 16,
                      color: step.isCompleted || step.isActive
                          ? Colors.white
                          : (isDark
                              ? AppTheme.textHint
                              : AppTheme.lightTextHint),
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      color: step.isCompleted
                          ? AppTheme.accentLight
                          : (isDark
                              ? AppTheme.cardDark
                              : AppTheme.lightCardBorder),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(
                        color: step.isActive
                            ? AppTheme.accentLight
                            : step.isCompleted
                                ? (isDark
                                    ? AppTheme.textPrimary
                                    : AppTheme.lightTextPrimary)
                                : (isDark
                                    ? AppTheme.textHint
                                    : AppTheme.lightTextHint),
                        fontSize: 15,
                        fontWeight:
                            step.isActive ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step.subtitle,
                      style: TextStyle(
                        color: step.isActive
                            ? (isDark
                                ? AppTheme.textSecondary
                                : AppTheme.lightTextSecondary)
                            : (isDark
                                ? AppTheme.textHint
                                : AppTheme.lightTextHint),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: isDark ? AppTheme.textHint : AppTheme.lightTextHint,
                  fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _deliveryIcon(DeliveryMethod method) {
    switch (method) {
      case DeliveryMethod.pickup:
        return Icons.store;
      case DeliveryMethod.yandexGo:
        return Icons.local_taxi;
      case DeliveryMethod.uzumTezkor:
        return Icons.flash_on;
      case DeliveryMethod.btsExpress:
        return Icons.local_shipping;
    }
  }
}

class _TimelineStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isCompleted;
  final bool isActive;

  _TimelineStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isCompleted = false,
    this.isActive = false,
  });
}
