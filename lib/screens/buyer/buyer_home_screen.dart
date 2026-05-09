import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/category.dart';
import '../../services/product_service.dart';
import '../../services/cart_service.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';
import '../../services/wishlist_service.dart';
import '../../services/compare_service.dart';
import '../../widgets/product_card.dart';
import 'buyer_main_screen.dart';
import 'wishlist_screen.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  ProductCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeService>().isDark;
    final colorScheme = Theme.of(context).colorScheme;
    return Consumer<ProductService>(
      builder: (context, productService, child) {
        final locale = context.watch<LocaleService>();
        final wishlistCount = context.watch<WishlistService>().count;
        final compareCount = context.watch<CompareService>().count;
        final products = _selectedCategory != null
            ? productService.getProductsByCategory(_selectedCategory!)
            : productService.allProducts;

        return RefreshIndicator(
          color: AppTheme.primaryDark,
          backgroundColor: isDark ? AppTheme.primaryMid : AppTheme.lightSurface,
          onRefresh: () => productService.refreshProducts(),
          child: CustomScrollView(
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
                                      : colorScheme.primary,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const WishlistScreen(),
                                    ),
                                  ),
                                  child: Badge(
                                    isLabelVisible: wishlistCount > 0,
                                    label: Text('$wishlistCount',
                                        style: const TextStyle(fontSize: 10)),
                                    child: Icon(
                                      Icons.favorite_border,
                                      size: 20,
                                      color: isDark
                                          ? Colors.white
                                          : AppTheme.lightTextSecondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/alerts'),
                                  child: Icon(Icons.notifications_outlined,
                                      size: 20,
                                      color: isDark
                                          ? Colors.white
                                          : AppTheme.lightTextSecondary),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/compare'),
                                  child: Badge(
                                    isLabelVisible: compareCount > 0,
                                    label: Text('$compareCount',
                                        style: const TextStyle(fontSize: 10)),
                                    child: Icon(
                                      Icons.compare_arrows_outlined,
                                      size: 20,
                                      color: isDark
                                          ? Colors.white
                                          : AppTheme.lightTextSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: GestureDetector(
                    onTap: () {
                      final mainScreenState = context
                          .findAncestorStateOfType<BuyerMainScreenState>();
                      mainScreenState?.switchToTab(1);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.cardDark.withValues(alpha: 0.7)
                            : AppTheme.lightSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: isDark
                            ? null
                            : Border.all(color: AppTheme.lightCardBorder),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search,
                              color: isDark
                                  ? AppTheme.textHint
                                  : AppTheme.lightTextHint,
                              size: 18),
                          const SizedBox(width: 12),
                          Text(
                            locale.t('search_phones'),
                            style: TextStyle(
                                color: isDark
                                    ? AppTheme.textHint
                                    : AppTheme.lightTextHint,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Category chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                    height: 42,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        _buildCategoryChip(
                          label: locale.t('all'),
                          isSelected: _selectedCategory == null,
                          onTap: () => setState(() => _selectedCategory = null),
                          isDark: isDark,
                        ),
                        ...ProductCategory.values.map(
                          (category) => _buildCategoryChip(
                            label: locale.t(category.localeKey),
                            isSelected: _selectedCategory == category,
                            onTap: () =>
                                setState(() => _selectedCategory = category),
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Hero Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: AppTheme.heroGradient,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Stack(
                      children: [
                        // Decorative blur
                        Positioned(
                            bottom: -40,
                            right: -40,
                            child: Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        Colors.white.withValues(alpha: 0.1)))),
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFFFDBD0),
                                    borderRadius: BorderRadius.circular(9999)),
                                child: const Text('TELEFONCHI',
                                    style: TextStyle(
                                        color: Color(0xFF7B2E12),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1)),
                              ),
                              const SizedBox(height: 12),
                              Text(locale.t('banner_title'),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      height: 1.2)),
                              const SizedBox(height: 8),
                              Text(locale.t('banner_subtitle'),
                                  style: TextStyle(
                                      color: const Color(0xFFE0E0FF),
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Section title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCategory != null
                            ? locale.t(_selectedCategory!.localeKey)
                            : locale.t('popular_products'),
                        style: TextStyle(
                            color: isDark
                                ? AppTheme.textPrimary
                                : colorScheme.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${products.length} ${locale.t('products_count')}',
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

              // Products grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: products.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Icon(Icons.inventory_2_outlined,
                                    size: 60,
                                    color: (isDark
                                            ? AppTheme.textHint
                                            : AppTheme.lightTextHint)
                                        .withValues(alpha: 0.5)),
                                const SizedBox(height: 16),
                                Text(locale.t('no_products'),
                                    style: TextStyle(
                                        color: isDark
                                            ? AppTheme.textSecondary
                                            : AppTheme.lightTextSecondary,
                                        fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.51,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = products[index];
                            return ProductCard(
                              product: product,
                              isFavorite: context
                                  .watch<WishlistService>()
                                  .isFavorite(product.id),
                              onToggleFavorite: () => context
                                  .read<WishlistService>()
                                  .toggle(product.id),
                              onTap: () => Navigator.pushNamed(
                                  context, '/product-detail',
                                  arguments: product.id),
                              onAddToCart: () {
                                context.read<CartService>().addToCart(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${product.name} ${locale.t('added_to_cart')}'),
                                    duration: const Duration(seconds: 1),
                                    action: SnackBarAction(
                                      label: locale.t('cart'),
                                      textColor: AppTheme.primaryDark,
                                      onPressed: () {
                                        final mainScreenState =
                                            context.findAncestorStateOfType<
                                                BuyerMainScreenState>();
                                        mainScreenState?.switchToTab(2);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          childCount: products.length,
                        ),
                      ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(
      {required String label,
      required bool isSelected,
      required VoidCallback onTap,
      required bool isDark}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : AppTheme.primaryDark)
              : (isDark
                  ? AppTheme.cardDark.withValues(alpha: 0.7)
                  : AppTheme.lightSurfaceMuted),
          borderRadius: BorderRadius.circular(9999),
          border: isDark
              ? null
              : Border.all(
                  color: isSelected
                      ? AppTheme.primaryDark
                      : AppTheme.lightCardBorder,
                ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (isDark ? AppTheme.primaryDark : Colors.white)
                : (isDark ? AppTheme.textSecondary : AppTheme.lightTextPrimary),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
