import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/product.dart';
import '../../services/compare_service.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_scaffold.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  String _formatPrice(double price, LocaleService locale) {
    final formatter = NumberFormat('#,###', 'ru_RU');
    return '${formatter.format(price)} ${locale.t('sum')}';
  }

  @override
  Widget build(BuildContext context) {
    final compareService = context.watch<CompareService>();
    final locale = context.watch<LocaleService>();
    final isDark = context.watch<ThemeService>().isDark;
    final products = compareService.compareList;

    return GradientScaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.compare_arrows,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('Taqqoslash'),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (products.isNotEmpty)
            TextButton.icon(
              icon:
                  const Icon(Icons.clear_all, color: AppTheme.error, size: 20),
              label: const Text('Tozalash',
                  style: TextStyle(color: AppTheme.error, fontSize: 12)),
              onPressed: () => compareService.clear(),
            ),
        ],
      ),
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.accentBlue.withValues(alpha: 0.1)
                          : AppTheme.lightSurfaceMuted,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.compare_arrows,
                      size: 56,
                      color: isDark
                          ? AppTheme.accentBlue.withValues(alpha: 0.4)
                          : AppTheme.lightTextHint,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Taqqoslash uchun hech narsa yo'q",
                    style: TextStyle(
                      color:
                          isDark ? AppTheme.textHint : AppTheme.lightTextHint,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Mahsulot sahifasidan ⚖️ tugmasini bosing",
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.textHint.withValues(alpha: 0.6)
                          : AppTheme.lightTextHint.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Product header cards
                  Row(
                    children: products
                        .map((p) => Expanded(
                              child: _buildProductHeader(
                                  p, compareService, isDark, locale),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),

                  // Comparison rows
                  _buildCompareCard(
                    icon: Icons.attach_money,
                    title: 'Narxi',
                    values: products
                        .map((p) => _formatPrice(p.price, locale))
                        .toList(),
                    isDark: isDark,
                    highlightLowest: true,
                    prices: products.map((p) => p.price).toList(),
                  ),
                  _buildCompareCard(
                    icon: Icons.phone_android,
                    title: 'Model',
                    values: products
                        .map((p) =>
                            p.productModel.isNotEmpty ? p.productModel : '—')
                        .toList(),
                    isDark: isDark,
                  ),
                  _buildCompareCard(
                    icon: Icons.verified,
                    title: 'Holati',
                    values: products
                        .map((p) => p.condition.isNotEmpty ? p.condition : '—')
                        .toList(),
                    isDark: isDark,
                  ),
                  _buildCompareCard(
                    icon: Icons.calendar_today,
                    title: 'Yili',
                    values: products
                        .map((p) => p.year != null ? '${p.year}' : '—')
                        .toList(),
                    isDark: isDark,
                  ),
                  _buildCompareCard(
                    icon: Icons.palette,
                    title: 'Rangi',
                    values: products
                        .map((p) => p.colorValue != null ? '●' : '—')
                        .toList(),
                    isDark: isDark,
                    colors: products
                        .map((p) =>
                            p.colorValue != null ? Color(p.colorValue!) : null)
                        .toList(),
                  ),
                  _buildCompareCard(
                    icon: Icons.inventory_2,
                    title: 'Omborda',
                    values: products.map((p) => '${p.stock} dona').toList(),
                    isDark: isDark,
                  ),
                  _buildCompareCard(
                    icon: Icons.store,
                    title: 'Sotuvchi',
                    values: products.map((p) => p.sellerName).toList(),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildProductHeader(Product product, CompareService compareService,
      bool isDark, LocaleService locale) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppTheme.accentBlue.withValues(alpha: 0.2)
              : AppTheme.lightCardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Remove button
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => compareService.toggleCompare(product),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.close, size: 14, color: AppTheme.error),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 80,
              height: 80,
              child: _buildProductImage(product, isDark),
            ),
          ),
          const SizedBox(height: 8),
          // Product name
          Text(
            product.name,
            style: TextStyle(
              color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Price
          Text(
            _formatPrice(product.price, locale),
            style: TextStyle(
              color: isDark ? AppTheme.accentCyan : AppTheme.primaryDark,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(Product product, bool isDark) {
    if (product.imagePath.isNotEmpty && product.imagePath.startsWith('http')) {
      return Image.network(
        product.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildImagePlaceholder(isDark),
      );
    }
    if (product.imageBase64.isNotEmpty) {
      try {
        final bytes = base64Decode(product.imageBase64);
        return Image.memory(bytes, fit: BoxFit.cover);
      } catch (_) {
        return _buildImagePlaceholder(isDark);
      }
    }
    return _buildImagePlaceholder(isDark);
  }

  Widget _buildImagePlaceholder(bool isDark) {
    return Container(
      color: isDark
          ? AppTheme.primaryLight.withValues(alpha: 0.2)
          : AppTheme.lightSurfaceMuted,
      child: Icon(
        Icons.phone_android,
        size: 32,
        color: isDark
            ? AppTheme.textHint.withValues(alpha: 0.4)
            : AppTheme.lightTextHint.withValues(alpha: 0.4),
      ),
    );
  }

  Widget _buildCompareCard({
    required IconData icon,
    required String title,
    required List<String> values,
    required bool isDark,
    bool highlightLowest = false,
    List<double>? prices,
    List<Color?>? colors,
  }) {
    double? minPrice;
    if (highlightLowest && prices != null && prices.isNotEmpty) {
      minPrice = prices.reduce((a, b) => a < b ? a : b);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.cardDark.withValues(alpha: 0.5)
            : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? AppTheme.accentBlue.withValues(alpha: 0.1)
              : AppTheme.lightCardBorder,
        ),
      ),
      child: Row(
        children: [
          // Label
          SizedBox(
            width: 90,
            child: Row(
              children: [
                Icon(icon,
                    size: 16,
                    color: isDark ? AppTheme.accentCyan : AppTheme.accentBlue),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color:
                          isDark ? AppTheme.textHint : AppTheme.lightTextHint,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Values
          ...List.generate(values.length, (i) {
            final isLowest =
                highlightLowest && prices != null && prices[i] == minPrice;
            final hasColor =
                colors != null && i < colors.length && colors[i] != null;

            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                decoration: BoxDecoration(
                  color: isLowest
                      ? AppTheme.success.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: hasColor
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: colors[i],
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white24, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: colors[i]!.withValues(alpha: 0.4),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Text(
                        values[i],
                        style: TextStyle(
                          color: isLowest
                              ? AppTheme.success
                              : (isDark
                                  ? AppTheme.textPrimary
                                  : AppTheme.lightTextPrimary),
                          fontSize: 13,
                          fontWeight:
                              isLowest ? FontWeight.w800 : FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
