import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../services/cart_service.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';
import '../../services/wishlist_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final isDark = context.watch<ThemeService>().isDark;
    return GradientScaffold(
      appBar: AppBar(
        title: Text(locale.t('wishlist')),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer2<WishlistService, ProductService>(
        builder: (context, wishlistService, productService, child) {
          final wishlistProducts = wishlistService.productIds
              .map(productService.getProductById)
              .whereType<Product>()
              .toList();

          if (wishlistProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: (isDark ? AppTheme.textHint : AppTheme.lightTextHint)
                        .withValues(alpha: 0.45),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    locale.t('wishlist_empty'),
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.textPrimary
                          : AppTheme.lightTextPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    locale.t('wishlist_empty_desc'),
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.textSecondary
                          : AppTheme.lightTextSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: wishlistService.clear,
                      icon: const Icon(Icons.delete_outline,
                          color: AppTheme.error, size: 18),
                      label: Text(locale.t('clear'),
                          style: const TextStyle(
                              color: AppTheme.error, fontSize: 13)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.56,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: wishlistProducts.length,
                  itemBuilder: (context, index) {
                    final product = wishlistProducts[index];
                    return ProductCard(
                      product: product,
                      isFavorite: wishlistService.isFavorite(product.id),
                      onToggleFavorite: () =>
                          context.read<WishlistService>().toggle(product.id),
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/product-detail',
                        arguments: product.id,
                      ),
                      onAddToCart: () =>
                          context.read<CartService>().addToCart(product),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
