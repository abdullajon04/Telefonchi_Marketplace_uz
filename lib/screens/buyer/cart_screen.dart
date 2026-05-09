import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../services/cart_service.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';
import '../../services/currency_service.dart';
import '../../widgets/currency_selector.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  String _formatPrice(double price, LocaleService locale) {
    return locale.formatPrice(price);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final isDark = context.watch<ThemeService>().isDark;
    return Consumer<CartService>(
      builder: (context, cartService, child) {
        final items = cartService.items;

        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: (isDark ? AppTheme.textHint : AppTheme.lightTextHint)
                      .withValues(alpha: 0.4),
                ),
                const SizedBox(height: 16),
                Text(
                  locale.t('cart_empty'),
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
                  locale.t('cart_empty_desc'),
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

        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${locale.t('cart')} (${cartService.totalQuantity})',
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.textPrimary
                          : AppTheme.lightTextPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const CurrencySelector(),
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(locale.t('clear_cart')),
                          content: Text(locale.t('clear_cart_desc')),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: Text(locale.t('cancel')),
                            ),
                            TextButton(
                              onPressed: () {
                                cartService.clearCart();
                                Navigator.pop(ctx);
                              },
                              child: Text(
                                locale.t('clear'),
                                style: TextStyle(color: AppTheme.error),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppTheme.error,
                      size: 18,
                    ),
                    label: Text(
                      locale.t('clear'),
                      style:
                          const TextStyle(color: AppTheme.error, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            // Cart items
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: AppTheme.getGlassDecoration(isDark),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Image
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppTheme.accentBlue.withValues(alpha: 0.15)
                                  : AppTheme.lightSurfaceMuted,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.phone_android,
                              color:
                                  AppTheme.accentLight.withValues(alpha: 0.5),
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: TextStyle(
                                    color: isDark
                                        ? AppTheme.textPrimary
                                        : AppTheme.lightTextPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatPrice(item.product.price, locale),
                                  style: TextStyle(
                                    color: isDark
                                        ? AppTheme.accentCyan
                                        : AppTheme.primaryDark,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Quantity controls
                                Row(
                                  children: [
                                    _buildQuantityButton(
                                      icon: Icons.remove,
                                      isDark: isDark,
                                      onTap: () {
                                        cartService.decrementQuantity(
                                          item.product.id,
                                        );
                                      },
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        '${item.quantity}',
                                        style: TextStyle(
                                          color: isDark
                                              ? AppTheme.textPrimary
                                              : AppTheme.lightTextPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    _buildQuantityButton(
                                      icon: Icons.add,
                                      isDark: isDark,
                                      onTap: () {
                                        cartService.incrementQuantity(
                                          item.product.id,
                                        );
                                      },
                                    ),
                                    const Spacer(),
                                    PriceDisplay(
                                      priceInUSD: item.totalPrice,
                                      style: TextStyle(
                                        color: isDark
                                            ? AppTheme.textPrimary
                                            : AppTheme.lightTextPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
            ),

            // Total & Checkout
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.primaryMid : AppTheme.lightSurface,
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppTheme.accentBlue.withValues(alpha: 0.2)
                        : AppTheme.lightCardBorder,
                  ),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locale.t('total'),
                          style: TextStyle(
                            color: isDark
                                ? AppTheme.textSecondary
                                : AppTheme.lightTextSecondary,
                            fontSize: 16,
                          ),
                        ),
                        PriceDisplay(
                          priceInUSD: cartService.totalAmount,
                          style: TextStyle(
                            color: isDark
                                ? AppTheme.textPrimary
                                : AppTheme.lightTextPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/checkout');
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          locale.t('checkout'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardLight : AppTheme.lightSurfaceMuted,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: isDark
                  ? AppTheme.accentBlue.withValues(alpha: 0.3)
                  : AppTheme.lightCardBorder),
        ),
        child: Icon(
          icon,
          color: isDark ? AppTheme.accentLight : AppTheme.primaryDark,
          size: 18,
        ),
      ),
    );
  }
}
