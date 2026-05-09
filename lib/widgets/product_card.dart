import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../services/locale_service.dart';
import '../services/review_service.dart';
import '../services/theme_service.dart';
import '../services/currency_service.dart';
import 'package:intl/intl.dart';
import 'currency_selector.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onToggleFavorite;
  final bool isFavorite;
  final bool showAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.onToggleFavorite,
    this.isFavorite = false,
    this.showAddToCart = true,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _heartAnimating = false;

  String _formatPrice(double price) {
    return context.read<LocaleService>().formatPrice(price);
  }

  Future<void> _handleFavoriteTap() async {
    widget.onToggleFavorite?.call();
    setState(() => _heartAnimating = true);
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (mounted) {
      setState(() => _heartAnimating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeService>().isDark;
    final locale = context.watch<LocaleService>();
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.cardDark.withValues(alpha: 0.7)
              : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isDark
                  ? AppTheme.accentBlue.withValues(alpha: 0.2)
                  : AppTheme.lightCardBorder,
              width: isDark ? 1 : 1.2),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                  color: const Color(0xFF101828).withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 10)),
            BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: isDark ? 12 : 4,
                offset: Offset(0, isDark ? 4 : 1)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 0.85,
                    child: Container(
                      width: double.infinity,
                      color: isDark
                          ? AppTheme.primaryLight.withValues(alpha: 0.3)
                          : AppTheme.lightSurfaceMuted,
                      child: _buildImage(),
                    ),
                  ),
                  // Wishlist button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: _handleFavoriteTap,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.88),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1))
                          ],
                        ),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutBack,
                          scale: _heartAnimating ? 1.35 : 1.0,
                          child: Icon(
                            widget.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 14,
                            color: widget.isFavorite
                                ? AppTheme.error
                                : (isDark
                                    ? AppTheme.primaryDark
                                    : const Color(0xFF1A1C1C)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale
                              .t(widget.product.category.localeKey)
                              .toUpperCase(),
                          style: TextStyle(
                            color: isDark
                                ? AppTheme.textHint
                                : AppTheme.lightTextSecondary,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        PriceDisplay(
                          priceInUSD: widget.product.price,
                          style: TextStyle(
                            color: isDark
                                ? AppTheme.textPrimary
                                : AppTheme.lightTextPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Consumer<ReviewService>(
                          builder: (context, reviewService, child) {
                            final avg = reviewService
                                .getAverageRating(widget.product.id);
                            final count =
                                reviewService.getReviewCount(widget.product.id);
                            if (count == 0) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: AppTheme.warning, size: 12),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${avg.toStringAsFixed(1)} ($count)',
                                    style: TextStyle(
                                        color: isDark
                                            ? AppTheme.textHint
                                            : AppTheme.lightTextSecondary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatPrice(widget.product.price),
                          style: TextStyle(
                            color: isDark ? Colors.white : colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.showAddToCart &&
                            widget.onAddToCart != null &&
                            widget.product.stock > 0) ...[
                          const SizedBox(height: 6),
                          SizedBox(
                            width: double.infinity,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: AppTheme.heroGradient,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryDark
                                        .withValues(alpha: 0.22),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: widget.onAddToCart,
                                icon: const Icon(Icons.local_shipping_outlined,
                                    size: 14),
                                label: Text(
                                  locale.t('add_to_cart'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.product.imagePath.isNotEmpty &&
        widget.product.imagePath.startsWith('http')) {
      return Image.network(
        widget.product.imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: AppTheme.primaryDark,
            ),
          );
        },
      );
    }
    if (widget.product.imageBase64.isNotEmpty) {
      try {
        return Image.memory(base64Decode(widget.product.imageBase64),
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, __, ___) => _buildPlaceholder());
      } catch (e) {
        return _buildPlaceholder();
      }
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(Icons.phone_android,
          size: 50, color: AppTheme.lightTextHint.withValues(alpha: 0.3)),
    );
  }
}
