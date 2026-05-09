import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../theme/app_theme.dart';
import '../../models/order.dart';
import '../../services/auth_service.dart';
import '../../services/cart_service.dart';
import '../../services/order_service.dart';
import '../../services/product_service.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../services/currency_service.dart';
import 'location_picker_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _paymentMethod = PaymentMethod.offline;
  DeliveryMethod _deliveryMethod = DeliveryMethod.yandexGo;
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  double get _deliveryPriceUSD {
    final uzsRate = Currency.UZS.rateToUSD;
    switch (_deliveryMethod) {
      case DeliveryMethod.pickup:
        return 0;
      case DeliveryMethod.yandexGo:
        return 25000 / uzsRate;
      case DeliveryMethod.uzumTezkor:
        return 20000 / uzsRate;
      case DeliveryMethod.btsExpress:
        return 35000 / uzsRate;
    }
  }

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthService>().currentUser;
    if (user != null) {
      _addressController.text = user.address;
      _phoneController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _deliveryMethodText(DeliveryMethod method, LocaleService locale) {
    switch (method) {
      case DeliveryMethod.pickup:
        return locale.t('pickup');
      case DeliveryMethod.yandexGo: return locale.t('yandex_go');
      case DeliveryMethod.uzumTezkor: return locale.t('uzum_tezkor');
      case DeliveryMethod.btsExpress: return locale.t('bts_express');
    }
  }

  String _paymentMethodText(PaymentMethod method, LocaleService locale) {
    switch (method) {
      case PaymentMethod.online:
        return locale.t('pay_online');
      case PaymentMethod.offline:
        return locale.t('pay_offline');
    }
  }

  String _formatPrice(double priceUSD) {
    final currencyService = context.read<CurrencyService>();
    return currencyService.formatPrice(priceUSD);
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

  String _deliveryPriceText(DeliveryMethod method) {
    final locale = context.read<LocaleService>();
    switch (method) {
      case DeliveryMethod.pickup:
        return locale.t('delivery_free');
      case DeliveryMethod.yandexGo:
        return locale.t('delivery_yandex_desc');
      case DeliveryMethod.uzumTezkor:
        return locale.t('delivery_uzum_desc');
      case DeliveryMethod.btsExpress:
        return locale.t('delivery_bts_desc');
    }
  }

  double? _selectedLat;
  double? _selectedLng;

  Future<void> _openMapPicker() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          initialLat: _selectedLat,
          initialLng: _selectedLng,
          initialAddress: _addressController.text,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedLat = result['lat'] as double;
        _selectedLng = result['lng'] as double;
        final address = result['address'] as String;
        if (address.isNotEmpty) {
          _addressController.text = address;
        }
      });
    }
  }

  Future<void> _placeOrder() async {
    final authService = context.read<AuthService>();
    final cartService = context.read<CartService>();
    final orderService = context.read<OrderService>();
    final productService = context.read<ProductService>();
    final user = authService.currentUser!;

    final locale = context.read<LocaleService>();
    final isDark = context.read<ThemeService>().isDark;
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(locale.t('enter_address')),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    try {
      await orderService.placeOrder(
        buyerId: user.id,
        buyerName: user.name,
        buyerAddress: _addressController.text.trim(),
        buyerPhone: _phoneController.text.trim(),
        items: cartService.items,
        totalAmount: cartService.totalAmount + _deliveryPriceUSD,
        paymentMethod: _paymentMethod,
        deliveryMethod: _deliveryMethod,
        deliveryPrice: _deliveryPriceUSD,
        productService: productService,
      );

      cartService.clearCart();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${locale.t('order_error')}: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.primaryMid : AppTheme.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Lottie.network(
                'https://lottie.host/f2b6e5dc-78ea-4647-8587-c468be5a3352/vuJkiJaLMJ.json',
                repeat: false,
                animate: true,
                errorBuilder: (context, error, stackTrace) {
                  return const _SuccessBadgeAnimation();
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              locale.t('order_placed'),
              style: TextStyle(
                color:
                    isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              locale.t('order_placed_desc'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: isDark
                      ? AppTheme.textSecondary
                      : AppTheme.lightTextSecondary,
                  fontSize: 14),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: Text(locale.t('great')),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final currency = context.watch<CurrencyService>();
    final isDark = context.watch<ThemeService>().isDark;
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.transparent : AppTheme.lightBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(locale.t('checkout')),
      ),
      body: Consumer<CartService>(
        builder: (context, cartService, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery info
                Text(
                  locale.t('delivery_info'),
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.textPrimary
                        : AppTheme.lightTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _addressController,
                  style: TextStyle(
                      color: isDark
                          ? AppTheme.textPrimary
                          : AppTheme.lightTextPrimary),
                  decoration: InputDecoration(
                    labelText: locale.t('delivery_address'),
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    suffixIcon: IconButton(
                      onPressed: _openMapPicker,
                      icon: const Icon(Icons.map, color: AppTheme.accentCyan),
                      tooltip: locale.t('pick_on_map'),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openMapPicker,
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: Text(locale.t('pick_on_map'),
                        style: const TextStyle(fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.accentCyan,
                      side: BorderSide(
                          color: AppTheme.accentBlue.withValues(alpha: 0.3)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneController,
                  style: TextStyle(
                      color: isDark
                          ? AppTheme.textPrimary
                          : AppTheme.lightTextPrimary),
                  decoration: InputDecoration(
                    labelText: locale.t('phone'),
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),

                // Delivery method
                Text(
                  locale.t('delivery_method'),
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.textPrimary
                        : AppTheme.lightTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...DeliveryMethod.values.map(
                  (method) => GestureDetector(
                    onTap: () {
                      setState(() => _deliveryMethod = method);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _deliveryMethod == method
                            ? AppTheme.accentBlue.withValues(alpha: 0.15)
                            : (isDark
                                ? AppTheme.cardDark.withValues(alpha: 0.5)
                                : AppTheme.lightSurface),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _deliveryMethod == method
                              ? AppTheme.accentBlue
                              : (isDark
                                  ? AppTheme.accentBlue.withValues(alpha: 0.2)
                                  : AppTheme.lightCardBorder),
                          width: _deliveryMethod == method ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _deliveryIcon(method),
                            color: _deliveryMethod == method
                                ? AppTheme.accentLight
                                : (isDark
                                    ? AppTheme.textHint
                                    : AppTheme.lightTextHint),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _deliveryMethodText(method, locale),
                                  style: TextStyle(
                                    color: _deliveryMethod == method
                                        ? (isDark
                                            ? AppTheme.textPrimary
                                            : AppTheme.lightTextPrimary)
                                        : (isDark
                                            ? AppTheme.textSecondary
                                            : AppTheme.lightTextSecondary),
                                    fontWeight: _deliveryMethod == method
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  _deliveryPriceText(method),
                                  style: const TextStyle(
                                    color: AppTheme.accentCyan,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_deliveryMethod == method)
                            const Icon(
                              Icons.check_circle,
                              color: AppTheme.accentLight,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Payment method
                Text(
                  locale.t('payment_method'),
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.textPrimary
                        : AppTheme.lightTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...PaymentMethod.values.map(
                  (method) => GestureDetector(
                    onTap: () {
                      setState(() => _paymentMethod = method);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _paymentMethod == method
                            ? AppTheme.accentBlue.withValues(alpha: 0.15)
                            : (isDark
                                ? AppTheme.cardDark.withValues(alpha: 0.5)
                                : AppTheme.lightSurface),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _paymentMethod == method
                              ? AppTheme.accentBlue
                              : (isDark
                                  ? AppTheme.accentBlue.withValues(alpha: 0.2)
                                  : AppTheme.lightCardBorder),
                          width: _paymentMethod == method ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            method == PaymentMethod.online
                                ? Icons.credit_card
                                : Icons.money,
                            color: _paymentMethod == method
                                ? AppTheme.accentLight
                                : (isDark
                                    ? AppTheme.textHint
                                    : AppTheme.lightTextHint),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _paymentMethodText(method, locale),
                            style: TextStyle(
                              color: _paymentMethod == method
                                  ? (isDark
                                      ? AppTheme.textPrimary
                                      : AppTheme.lightTextPrimary)
                                  : (isDark
                                      ? AppTheme.textSecondary
                                      : AppTheme.lightTextSecondary),
                              fontWeight: _paymentMethod == method
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          const Spacer(),
                          if (_paymentMethod == method)
                            const Icon(
                              Icons.check_circle,
                              color: AppTheme.accentLight,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Order summary
                Text(
                  locale.t('total'),
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.textPrimary
                        : AppTheme.lightTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.getGlassDecoration(isDark),
                  child: Column(
                    children: [
                      ...cartService.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
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
                                _formatPrice(item.totalPrice),
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
                      Divider(
                          color: isDark
                              ? AppTheme.cardLight
                              : AppTheme.lightCardBorder),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            locale.t('total'),
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.textPrimary
                                  : AppTheme.lightTextPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _formatPrice(cartService.totalAmount),
                            style: const TextStyle(
                              color: AppTheme.accentCyan,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_deliveryPriceUSD > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locale.t('delivery_price'),
                          style: TextStyle(
                              color: isDark
                                  ? AppTheme.textSecondary
                                  : AppTheme.lightTextSecondary,
                              fontSize: 14),
                        ),
                        Text(
                          _formatPrice(_deliveryPriceUSD),
                          style: const TextStyle(
                            color: AppTheme.accentCyan,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Place order button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _placeOrder,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      locale.t('place_order'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SuccessBadgeAnimation extends StatelessWidget {
  const _SuccessBadgeAnimation();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
              ),
              const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.success,
                size: 62,
              ),
              const Positioned(
                top: 18,
                right: 20,
                child:
                    Icon(Icons.auto_awesome, color: AppTheme.warning, size: 14),
              ),
              const Positioned(
                bottom: 18,
                left: 20,
                child: Icon(Icons.auto_awesome,
                    color: AppTheme.accentCyan, size: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
