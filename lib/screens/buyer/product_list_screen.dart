import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../services/cart_service.dart';
import '../../services/theme_service.dart';
import '../../services/wishlist_service.dart';
import '../../services/compare_service.dart';
import '../../widgets/product_card.dart';
import '../../services/locale_service.dart';
import '../../widgets/category_chip.dart';
import '../../services/currency_service.dart';
import '../../widgets/currency_selector.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();
  ProductCategory? _selectedCategory;
  RangeValues _priceRange = const RangeValues(0, 20000000);
  bool _showFilters = false;
  String _searchQuery = '';
  String? _selectedCondition;
  String? _selectedModel;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    final isDark = context.watch<ThemeService>().isDark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.accentGradient : null,
          color: isSelected
              ? null
              : (isDark ? AppTheme.cardLight : AppTheme.lightSurfaceMuted),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark
                      ? AppTheme.accentBlue.withValues(alpha: 0.2)
                      : AppTheme.lightCardBorder,
                ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark
                    ? AppTheme.textSecondary
                    : AppTheme.lightTextSecondary),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return context.read<LocaleService>().formatPrice(price);
  }

  List<Product> _getFilteredProducts(ProductService productService) {
    return productService.searchAndFilter(
      query: _searchQuery.isNotEmpty ? _searchQuery : null,
      category: _selectedCategory,
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      condition: _selectedCondition,
      productModel: _selectedModel,
    );
  }

  List<String> _getModelsForCategory() {
    if (_selectedCategory == null) {
      return [
        'iPhone',
        'Samsung',
        'Xiaomi',
        'Huawei',
        'Nokia',
        'iPad',
        'Oppo',
        'Realme'
      ];
    }
    switch (_selectedCategory!) {
      case ProductCategory.smartphones:
        return [
          'iPhone',
          'Samsung',
          'Xiaomi',
          'Huawei',
          'Oppo',
          'Vivo',
          'Realme',
          'OnePlus',
          'Honor'
        ];
      case ProductCategory.featurePhones:
        return ['Nokia', 'Samsung', 'Philips', 'Fly', 'Alcatel'];
      case ProductCategory.tablets:
        return [
          'iPad',
          'Samsung Tab',
          'Huawei MatePad',
          'Xiaomi Pad',
          'Lenovo Tab'
        ];
      case ProductCategory.accessories:
        return ['Chexol', 'Zaryadka', 'Naushnik', 'Powerbank', 'Kabel'];
      case ProductCategory.laptops:
        return ['MacBook', 'Dell', 'HP', 'Lenovo', 'Asus', 'Acer'];
      case ProductCategory.smartwatches:
        return [
          'Apple Watch',
          'Samsung Galaxy Watch',
          'Xiaomi Watch',
          'Huawei Watch'
        ];
      case ProductCategory.headphones:
        return ['AirPods', 'Sony', 'Bose', 'JBL', 'Xiaomi', 'Samsung'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final isDark = context.watch<ThemeService>().isDark;
    return Consumer<ProductService>(
      builder: (context, productService, child) {
        final products = _getFilteredProducts(productService);

        return Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        color: isDark
                            ? AppTheme.textPrimary
                            : AppTheme.lightTextPrimary,
                        fontSize: 15,
                      ),
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                      decoration: InputDecoration(
                        hintText: locale.t('search_phones'),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: AppTheme.textHint,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const CurrencySelector(),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() => _showFilters = !_showFilters);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _showFilters
                            ? AppTheme.accentBlue
                            : (isDark
                                ? AppTheme.cardDark.withValues(alpha: 0.7)
                                : AppTheme.lightSurface),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.accentBlue.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        Icons.tune,
                        color:
                            _showFilters ? Colors.white : AppTheme.accentLight,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter panel
            if (_showFilters)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.getGlassDecoration(isDark),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locale.t('category'),
                        style: TextStyle(
                          color: isDark
                              ? AppTheme.textSecondary
                              : AppTheme.lightTextSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() => _selectedCategory = null);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: _selectedCategory == null
                                    ? AppTheme.accentGradient
                                    : null,
                                color: _selectedCategory != null
                                    ? (isDark
                                        ? AppTheme.cardLight
                                        : AppTheme.lightSurfaceMuted)
                                    : null,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                locale.t('all'),
                                style: TextStyle(
                                  color: _selectedCategory == null
                                      ? Colors.white
                                      : (isDark
                                          ? AppTheme.textSecondary
                                          : AppTheme.lightTextSecondary),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          ...ProductCategory.values.map(
                            (cat) => CategoryChip(
                              category: cat,
                              isSelected: _selectedCategory == cat,
                              onTap: () {
                                setState(() => _selectedCategory = cat);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Holati filtri
                      Text(
                        locale.t('condition'),
                        style: TextStyle(
                          color: isDark
                              ? AppTheme.textSecondary
                              : AppTheme.lightTextSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildFilterChip(
                              locale.t('all'), _selectedCondition == null, () {
                            setState(() => _selectedCondition = null);
                          }),
                          const SizedBox(width: 8),
                          _buildFilterChip(locale.t('new_condition'),
                              _selectedCondition == 'Янги', () {
                            setState(() => _selectedCondition = 'Янги');
                          }),
                          const SizedBox(width: 8),
                          _buildFilterChip(locale.t('used_condition'),
                              _selectedCondition == 'Ишлатилган', () {
                            setState(() => _selectedCondition = 'Ишлатилган');
                          }),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Model filtri
                      Text(
                        locale.t('model'),
                        style: TextStyle(
                          color: isDark
                              ? AppTheme.textSecondary
                              : AppTheme.lightTextSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFilterChip(
                              locale.t('all'), _selectedModel == null, () {
                            setState(() => _selectedModel = null);
                          }),
                          ..._getModelsForCategory()
                              .map((m) => _buildFilterChip(
                                    m,
                                    _selectedModel == m,
                                    () => setState(() => _selectedModel = m),
                                  )),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Text(
                        '${locale.t('price')}: ${_formatPrice(_priceRange.start)} — ${_formatPrice(_priceRange.end)}',
                        style: TextStyle(
                          color: isDark
                              ? AppTheme.textSecondary
                              : AppTheme.lightTextSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 20000000,
                        divisions: 40,
                        activeColor: AppTheme.accentBlue,
                        inactiveColor: AppTheme.cardLight,
                        onChanged: (values) {
                          setState(() => _priceRange = values);
                        },
                      ),

                      // Filtrni tozalash
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = null;
                              _selectedCondition = null;
                              _selectedModel = null;
                              _priceRange = const RangeValues(0, 20000000);
                            });
                          },
                          icon: const Icon(Icons.clear_all, size: 18),
                          label: Text(locale.t('clear'),
                              style: const TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(
                              foregroundColor: isDark
                                  ? AppTheme.textHint
                                  : AppTheme.lightTextHint),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Results count
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${locale.t('found')}: ${products.length}',
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.textSecondary
                          : AppTheme.lightTextSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Consumer<CompareService>(
                    builder: (context, compareService, child) {
                      return TextButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/compare'),
                        icon: const Icon(Icons.compare_arrows, size: 18),
                        label: Text('Compare (${compareService.count})'),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Products
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60,
                            color: AppTheme.textHint.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            locale.t('nothing_found'),
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.51,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          isFavorite: context
                              .watch<WishlistService>()
                              .isFavorite(product.id),
                          onToggleFavorite: () => context
                              .read<WishlistService>()
                              .toggle(product.id),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/product-detail',
                              arguments: product.id,
                            );
                          },
                          onAddToCart: () {
                            context.read<CartService>().addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product.name} ${locale.t('added_to_cart')}',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
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
