import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../theme/app_theme.dart';
import '../../services/product_service.dart';
import '../../services/cart_service.dart';
import '../../services/auth_service.dart';
import '../../services/review_service.dart';
import '../../services/chat_service.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';
import '../../services/compare_service.dart';
import '../../widgets/gradient_scaffold.dart';
import '../chat/chat_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _formatPrice(double price) {
    return context.read<LocaleService>().formatPrice(price);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final isDark = context.watch<ThemeService>().isDark;
    final productId = ModalRoute.of(context)?.settings.arguments as String?;
    if (productId == null) {
      return Scaffold(body: Center(child: Text(locale.t('product_not_found'))));
    }

    final product = context.read<ProductService>().getProductById(productId);
    if (product == null) {
      return Scaffold(body: Center(child: Text(locale.t('product_not_found'))));
    }

    final authService = context.read<AuthService>();
    final isBuyer = authService.isBuyer;

    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.transparent : AppTheme.lightBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(locale.t('details')),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            color: isDark ? AppTheme.accentCyan : AppTheme.primaryDark,
            onPressed: () {
              final compareService = context.read<CompareService>();
              compareService.toggleCompare(product);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(compareService.isComparing(product.id)
                    ? "Taqqoslash ro'yxatiga qo'shildi"
                    : "Taqqoslashdan olib tashlandi"),
                action: SnackBarAction(
                  label: "Ko'rish",
                  onPressed: () => Navigator.pushNamed(context, '/compare'),
                ),
              ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    isDark
                        ? AppTheme.accentBlue.withValues(alpha: 0.2)
                        : AppTheme.lightSurfaceMuted,
                    isDark
                        ? AppTheme.primaryDark.withValues(alpha: 0.3)
                        : AppTheme.lightSurface,
                  ],
                ),
              ),
              child: _buildProductImage(product, locale),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      locale.t(product.category.localeKey),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Name
                  Text(
                    product.name,
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.textPrimary
                          : AppTheme.lightTextPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Price
                  Text(
                    _formatPrice(product.price),
                    style: TextStyle(
                      color:
                          isDark ? AppTheme.accentCyan : AppTheme.primaryDark,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Stock info
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: product.stock > 0
                          ? AppTheme.success.withValues(alpha: 0.15)
                          : AppTheme.error.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          product.stock > 0
                              ? Icons.check_circle_outline
                              : Icons.cancel_outlined,
                          color: product.stock > 0
                              ? AppTheme.success
                              : AppTheme.error,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          product.stock > 0
                              ? '${locale.t('in_stock')}: ${product.stock} ${locale.t('pcs')}'
                              : locale.t('out_of_stock'),
                          style: TextStyle(
                            color: product.stock > 0
                                ? AppTheme.success
                                : AppTheme.error,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Seller info
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: AppTheme.getGlassDecoration(isDark),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.accentBlue.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.store,
                            color: AppTheme.accentLight,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locale.t('seller'),
                                style: TextStyle(
                                  color: isDark
                                      ? AppTheme.textHint
                                      : AppTheme.lightTextHint,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                product.sellerName,
                                style: TextStyle(
                                  color: isDark
                                      ? AppTheme.textPrimary
                                      : AppTheme.lightTextPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isBuyer)
                          IconButton(
                            onPressed: () async {
                              final user = authService.currentUser;
                              if (user == null) return;
                              try {
                                final chatService = context.read<ChatService>();
                                final room =
                                    await chatService.getOrCreateChatRoom(
                                  buyerId: user.id,
                                  buyerName: user.name,
                                  sellerId: product.sellerId,
                                  sellerName: product.sellerName,
                                  productId: product.id,
                                  productName: product.name,
                                );
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ChatScreen(chatRoom: room),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Ошибка: $e'),
                                      backgroundColor: AppTheme.error,
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.chat_outlined,
                              color: AppTheme.accentLight,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Product attributes
                  if (product.productModel.isNotEmpty ||
                      product.condition.isNotEmpty ||
                      product.colorValue != null ||
                      product.year != null)
                    Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: AppTheme.getGlassDecoration(isDark),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.t('attributes'),
                              style: TextStyle(
                                  color: isDark
                                      ? AppTheme.textPrimary
                                      : AppTheme.lightTextPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),
                          if (product.productModel.isNotEmpty)
                            _buildAttrRow(Icons.phone_android,
                                locale.t('model'), product.productModel,
                                isDark: isDark),
                          if (product.condition.isNotEmpty)
                            _buildAttrRow(
                              product.condition == 'Янги'
                                  ? Icons.fiber_new
                                  : Icons.recycling,
                              locale.t('condition'),
                              product.condition,
                              isDark: isDark,
                            ),
                          if (product.colorValue != null)
                            _buildAttrRow(Icons.palette, locale.t('color'), '',
                                color: Color(product.colorValue!),
                                isDark: isDark),
                          if (product.year != null)
                            _buildAttrRow(Icons.calendar_today,
                                locale.t('year'), '${product.year}',
                                isDark: isDark),
                        ],
                      ),
                    ),

                  // Location info with mini-map
                  if (product.location.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: AppTheme.getGlassDecoration(isDark),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.locationLat != null &&
                              product.locationLng != null)
                            SizedBox(
                              height: 150,
                              child: AbsorbPointer(
                                child: FlutterMap(
                                  options: MapOptions(
                                    initialCenter: LatLng(product.locationLat!,
                                        product.locationLng!),
                                    initialZoom: 14,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName:
                                          'com.example.mobile_marketplace',
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point: LatLng(product.locationLat!,
                                              product.locationLng!),
                                          width: 40,
                                          height: 40,
                                          child: const Icon(Icons.location_pin,
                                              color: Colors.red, size: 40),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: AppTheme.error, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    product.location,
                                    style: TextStyle(
                                        color: isDark
                                            ? AppTheme.textPrimary
                                            : AppTheme.lightTextPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Description
                  Text(
                    locale.t('description'),
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.textPrimary
                          : AppTheme.lightTextPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.textSecondary
                          : AppTheme.lightTextSecondary,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Reviews section
                  _buildReviewsSection(
                      product.id, isBuyer, authService, locale, isDark),
                  const SizedBox(height: 24),

                  // Add to Cart button (only for buyers)
                  Visibility(
                    visible: isBuyer,
                    child: Builder(
                      builder: (context) {
                        final cartService = context.watch<CartService>();
                        final inCart = cartService.isInCart(product.id);
                        return SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (inCart) {
                                cartService.removeFromCart(product.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(locale.t('removed_from_cart')),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              } else {
                                cartService.addToCart(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(locale.t('added_to_cart')),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              inCart
                                  ? Icons.remove_shopping_cart
                                  : Icons.add_shopping_cart,
                            ),
                            label: Text(
                              inCart
                                  ? locale.t('remove_from_cart')
                                  : locale.t('add_to_cart'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: inCart
                                  ? AppTheme.error.withValues(alpha: 0.8)
                                  : AppTheme.accentBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static final Map<String, Color> _colorMap = {
    'Қора': const Color(0xFF000000),
    'Оқ': const Color(0xFFFFFFFF),
    'Кумуш': const Color(0xFFC0C0C0),
    'Кулранг': const Color(0xFF808080),
    'Қизил': const Color(0xFFE53935),
    'Кўк': const Color(0xFF1E88E5),
    'Яшил': const Color(0xFF43A047),
    'Сариқ': const Color(0xFFFDD835),
    'Тилла': const Color(0xFFFFD700),
    'Пушти': const Color(0xFFE91E63),
    'Бинафша': const Color(0xFF8E24AA),
    'Тўқ кўк': const Color(0xFF1A237E),
    'Оч кўк': const Color(0xFF81D4FA),
    'Апелсин': const Color(0xFFFF9800),
    'Жигарранг': const Color(0xFF795548),
    'Мовий': const Color(0xFF00BCD4),
  };

  String _getColorName(Color color) {
    for (final entry in _colorMap.entries) {
      if (entry.value == color) return entry.key;
    }
    return color.toString();
  }

  Widget _buildAttrRow(IconData icon, String label, String value,
      {Color? color, required bool isDark}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.accentLight),
          const SizedBox(width: 10),
          Text('$label: ',
              style: TextStyle(
                  color: isDark ? AppTheme.textHint : AppTheme.lightTextHint,
                  fontSize: 13)),
          if (color != null) ...[
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white24),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              _getColorName(color),
              style: TextStyle(
                  color:
                      isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
                  fontSize: 13),
            ),
          ] else
            Text(value,
                style: TextStyle(
                    color: isDark
                        ? AppTheme.textPrimary
                        : AppTheme.lightTextPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(String productId, bool isBuyer,
      AuthService authService, LocaleService locale, bool isDark) {
    return Consumer<ReviewService>(
      builder: (context, reviewService, child) {
        // Sharhlarni yuklash (birinchi marta)
        final reviews = reviewService.getReviewsForProduct(productId);
        final avgRating = reviewService.getAverageRating(productId);
        final reviewCount = reviewService.getReviewCount(productId);

        // initState o'rniga bu yerda lazy load
        if (reviews.isEmpty && reviewCount == 0) {
          reviewService.loadReviewsForProduct(productId);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      locale.t('reviews'),
                      style: TextStyle(
                        color: isDark
                            ? AppTheme.textPrimary
                            : AppTheme.lightTextPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (reviewCount > 0) ...[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.warning.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: AppTheme.warning, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              avgRating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: AppTheme.warning,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' ($reviewCount)',
                              style: TextStyle(
                                color: isDark
                                    ? AppTheme.textHint
                                    : AppTheme.lightTextHint,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                if (isBuyer)
                  TextButton.icon(
                    onPressed: () async {
                      final user = authService.currentUser;
                      if (user == null) return;
                      final orderIds = await reviewService
                          .getReviewableOrderIds(user.id, productId);
                      if (orderIds.isEmpty) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text(locale.t('review_only_after_receive')),
                              backgroundColor: AppTheme.warning,
                            ),
                          );
                        }
                        return;
                      }
                      if (context.mounted) {
                        _showAddReviewDialog(productId, orderIds.first,
                            authService, reviewService, locale);
                      }
                    },
                    icon: const Icon(Icons.rate_review,
                        size: 16, color: AppTheme.accentLight),
                    label: Text(
                      locale.t('write_review'),
                      style: const TextStyle(
                          color: AppTheme.accentLight, fontSize: 13),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            if (reviews.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.getGlassDecoration(isDark),
                child: Center(
                  child: Text(
                    locale.t('no_reviews'),
                    style: TextStyle(
                        color:
                            isDark ? AppTheme.textHint : AppTheme.lightTextHint,
                        fontSize: 14),
                  ),
                ),
              )
            else
              ...reviews.take(5).map((review) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: AppTheme.getGlassDecoration(isDark),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              review.buyerName,
                              style: TextStyle(
                                color: isDark
                                    ? AppTheme.textPrimary
                                    : AppTheme.lightTextPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: List.generate(
                                  5,
                                  (i) => Icon(
                                        i < review.rating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: AppTheme.warning,
                                        size: 16,
                                      )),
                            ),
                          ],
                        ),
                        if (review.comment.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            review.comment,
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.textSecondary
                                  : AppTheme.lightTextSecondary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                        if (review.imageBase64List.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: review.imageBase64List.length,
                              itemBuilder: (_, i) => GestureDetector(
                                onTap: () =>
                                    _showFullImage(review.imageBase64List[i]),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: MemoryImage(base64Decode(
                                          review.imageBase64List[i])),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Text(
                          DateFormat('dd.MM.yyyy').format(review.createdAt),
                          style: TextStyle(
                              color: isDark
                                  ? AppTheme.textHint
                                  : AppTheme.lightTextHint,
                              fontSize: 11),
                        ),
                      ],
                    ),
                  )),
          ],
        );
      },
    );
  }

  void _showFullImage(String base64Str) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(ctx),
          child: InteractiveViewer(
            child: Image.memory(
              base64Decode(base64Str),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  void _showAddReviewDialog(
      String productId,
      String orderId,
      AuthService authService,
      ReviewService reviewService,
      LocaleService locale) {
    double selectedRating = 5;
    final commentController = TextEditingController();
    final List<String> selectedImages = [];

    Future<void> pickImage(StateSetter setDialogState) async {
      try {
        final picker = ImagePicker();
        final image = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 800,
          imageQuality: 70,
        );
        if (image != null) {
          final bytes = await image.readAsBytes();
          final base64Str = base64Encode(bytes);
          setDialogState(() {
            if (selectedImages.length < 3) {
              selectedImages.add(base64Str);
            }
          });
        }
      } catch (e) {
        debugPrint('Error picking image: $e');
      }
    }

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(locale.t('write_review')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Star rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setDialogState(() => selectedRating = index + 1.0);
                      },
                      icon: Icon(
                        index < selectedRating ? Icons.star : Icons.star_border,
                        color: AppTheme.warning,
                        size: 32,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: commentController,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: locale.t('your_review'),
                    hintText: locale.t('your_review'),
                  ),
                ),
                const SizedBox(height: 12),
                // Rasm qo'shish
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: selectedImages.length >= 3
                          ? null
                          : () => pickImage(setDialogState),
                      icon: const Icon(Icons.camera_alt, size: 16),
                      label: Text('Фото (${selectedImages.length}/3)',
                          style: const TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.accentLight,
                        side: BorderSide(
                            color: AppTheme.accentBlue.withValues(alpha: 0.3)),
                      ),
                    ),
                  ],
                ),
                if (selectedImages.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedImages.length,
                      itemBuilder: (_, i) => Stack(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: MemoryImage(
                                    base64Decode(selectedImages[i])),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setDialogState(
                                    () => selectedImages.removeAt(i));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: AppTheme.error,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(locale.t('cancel')),
            ),
            TextButton(
              onPressed: () async {
                final user = authService.currentUser;
                if (user == null) return;
                Navigator.pop(ctx);
                final error = await reviewService.addReview(
                  productId: productId,
                  orderId: orderId,
                  buyerId: user.id,
                  buyerName: user.name,
                  rating: selectedRating,
                  comment: commentController.text.trim(),
                  imageBase64List: selectedImages,
                );
                if (mounted) {
                  if (error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(error),
                          backgroundColor: AppTheme.error),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(locale.t('review_thanks')),
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  }
                }
              },
              child: Text(locale.t('send')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(product, LocaleService locale) {
    // Firebase Storage URL
    if (product.imagePath.isNotEmpty && product.imagePath.startsWith('http')) {
      return Image.network(
        product.imagePath,
        fit: BoxFit.contain,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _buildImagePlaceholder(locale),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.accentLight,
            ),
          );
        },
      );
    }
    // Base64 image
    if (product.imageBase64.isNotEmpty) {
      try {
        return Image.memory(
          base64Decode(product.imageBase64),
          fit: BoxFit.contain,
          width: double.infinity,
          errorBuilder: (_, __, ___) => _buildImagePlaceholder(locale),
        );
      } catch (e) {
        return _buildImagePlaceholder(locale);
      }
    }
    return _buildImagePlaceholder(locale);
  }

  Widget _buildImagePlaceholder(LocaleService locale) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.phone_android,
            size: 80,
            color: AppTheme.accentLight.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 8),
          Text(
            locale.t('image'),
            style: TextStyle(
              color: AppTheme.textHint.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
