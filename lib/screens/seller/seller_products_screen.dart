import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/product_service.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';

class SellerProductsScreen extends StatelessWidget {
  const SellerProductsScreen({super.key});

  String _formatPrice(double price, LocaleService locale) {
    final formatter = NumberFormat('#,###', 'ru_RU');
    return '${formatter.format(price)} ${locale.t('sum')}';
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final userId = context.read<AuthService>().currentUser?.id ?? '';
    final isDark = context.watch<ThemeService>().isDark;

    return Consumer<ProductService>(
      builder: (context, productService, child) {
        final products = productService.getProductsBySeller(userId);

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined,
                    size: 80,
                    color: (isDark ? AppTheme.textHint : AppTheme.lightTextHint)
                        .withValues(alpha: 0.4)),
                const SizedBox(height: 16),
                Text(locale.t('no_products_seller'),
                    style: TextStyle(
                        color: isDark
                            ? AppTheme.textPrimary
                            : AppTheme.lightTextPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(locale.t('add_first_product'),
                    style: TextStyle(
                        color: isDark
                            ? AppTheme.textSecondary
                            : AppTheme.lightTextSecondary,
                        fontSize: 15)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/add-product'),
                  icon: const Icon(Icons.add),
                  label: Text(locale.t('add_product')),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${locale.t('my_products')} (${products.length})',
                    style: TextStyle(
                        color: isDark
                            ? AppTheme.textPrimary
                            : AppTheme.lightTextPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: AppTheme.getGlassDecoration(isDark),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppTheme.accentBlue.withValues(alpha: 0.15)
                                  : AppTheme.lightBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.phone_android,
                                color: isDark
                                    ? AppTheme.accentLight
                                        .withValues(alpha: 0.5)
                                    : AppTheme.lightTextHint,
                                size: 30),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.name,
                                    style: TextStyle(
                                        color: isDark
                                            ? AppTheme.textPrimary
                                            : AppTheme.lightTextPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text(locale.t(product.category.localeKey),
                                    style: TextStyle(
                                        color: isDark
                                            ? AppTheme.accentLight
                                                .withValues(alpha: 0.7)
                                            : AppTheme.lightTextSecondary,
                                        fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(_formatPrice(product.price, locale),
                                    style: TextStyle(
                                        color: isDark
                                            ? AppTheme.accentCyan
                                            : AppTheme.primaryDark,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/add-product',
                                    arguments: product),
                                icon: Icon(Icons.edit_outlined,
                                    color: isDark
                                        ? AppTheme.accentLight
                                        : AppTheme.primaryDark,
                                    size: 20),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(locale.t('delete_product')),
                                      content:
                                          Text('Удалить "${product.name}"?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: Text(locale.t('cancel'))),
                                        TextButton(
                                          onPressed: () {
                                            productService
                                                .deleteProduct(product.id);
                                            Navigator.pop(ctx);
                                          },
                                          child: Text(
                                              locale.t('delete_confirm'),
                                              style: TextStyle(
                                                  color: AppTheme.error)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.delete_outline,
                                    color: AppTheme.error, size: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
