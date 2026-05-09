import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Currency {
  UZS('UZS', 'сум', 'Uzbekistani Som', 12700.0),
  USD('USD', '\$', 'US Dollar', 1.0),
  RUB('RUB', '₽', 'Russian Ruble', 90.0);

  const Currency(this.code, this.symbol, this.name, this.rateToUSD);
  
  final String code;
  final String symbol;
  final String name;
  final double rateToUSD;
}

class CurrencyService extends ChangeNotifier {
  static final CurrencyService _instance = CurrencyService._internal();
  factory CurrencyService() => _instance;
  CurrencyService._internal();

  Currency _selectedCurrency = Currency.UZS;
  final Map<String, double> _exchangeRates = {
    'UZS': 12700.0, // 1 USD = 12700 UZS
    'USD': 1.0,     // Base currency
    'RUB': 90.0,    // 1 USD = 90 RUB
  };

  Currency get selectedCurrency => _selectedCurrency;
  String get currencySymbol => _selectedCurrency.symbol;
  String get currencyCode => _selectedCurrency.code;

  // Shipping prices in local currencies
  static const double standardShippingUZS = 25000.0;  // 25 ming so'm
  static const double expressShippingUZS = 50000.0;   // 50 ming so'm
  static const double freeShippingThresholdUZS = 500000.0; // 500 ming so'm
  
  // USD prices for conversion
  static const double standardShippingUSD = 5.0;
  static const double expressShippingUSD = 10.0;
  static const double freeShippingThresholdUSD = 100.0;

  // Initialize and load saved currency
  Future<void> initialize() async {
    await _loadSavedCurrency();
  }

  Future<void> _loadSavedCurrency() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCurrencyCode = prefs.getString('selected_currency') ?? 'UZS';
      _selectedCurrency = Currency.values.firstWhere(
        (currency) => currency.code == savedCurrencyCode,
        orElse: () => Currency.UZS,
      );
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Error loading saved currency: $e');
    }
  }

  Future<void> setCurrency(Currency currency) async {
    _selectedCurrency = currency;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_currency', currency.code);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Error saving currency: $e');
    }
  }

  // Convert price from USD to selected currency
  double convertPrice(double priceInUSD) {
    return priceInUSD * _selectedCurrency.rateToUSD;
  }

  // Format price with currency symbol
  // Note: price is in USD by default
  String formatPrice(double priceInUSD) {
    double convertedPrice;
    
    if (_selectedCurrency == Currency.UZS) {
      // Convert USD to UZS
      convertedPrice = priceInUSD * 12700.0;
    } else {
      // Keep in USD or convert to other currencies
      convertedPrice = priceInUSD * _selectedCurrency.rateToUSD;
    }
    
    if (_selectedCurrency == Currency.UZS) {
      return '${convertedPrice.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]} ',
      )} ${_selectedCurrency.symbol}';
    } else {
      return '${_selectedCurrency.symbol}${convertedPrice.toStringAsFixed(2)}';
    }
  }

  // Get shipping prices in selected currency
  double get standardShipping {
    switch (_selectedCurrency) {
      case Currency.UZS:
        return standardShippingUZS;
      case Currency.USD:
        return standardShippingUSD;
      case Currency.RUB:
        return standardShippingUSD * _exchangeRates['RUB']!;
      default:
        return convertPrice(standardShippingUSD);
    }
  }
  
  double get expressShipping {
    switch (_selectedCurrency) {
      case Currency.UZS:
        return expressShippingUZS;
      case Currency.USD:
        return expressShippingUSD;
      case Currency.RUB:
        return expressShippingUSD * _exchangeRates['RUB']!;
      default:
        return convertPrice(expressShippingUSD);
    }
  }
  
  double get freeShippingThreshold {
    switch (_selectedCurrency) {
      case Currency.UZS:
        return freeShippingThresholdUZS;
      case Currency.USD:
        return freeShippingThresholdUSD;
      case Currency.RUB:
        return freeShippingThresholdUSD * _exchangeRates['RUB']!;
      default:
        return convertPrice(freeShippingThresholdUSD);
    }
  }

  String get standardShippingFormatted => formatPrice(standardShipping / _selectedCurrency.rateToUSD);
  String get expressShippingFormatted => formatPrice(expressShipping / _selectedCurrency.rateToUSD);
  String get freeShippingThresholdFormatted => formatPrice(freeShippingThreshold / _selectedCurrency.rateToUSD);

  // Check if shipping is free (convert cart total to local currency)
  bool isShippingFree(double cartTotalUSD) {
    final cartTotalInLocalCurrency = cartTotalUSD * _selectedCurrency.rateToUSD;
    return cartTotalInLocalCurrency >= freeShippingThreshold;
  }

  // Calculate shipping cost in selected currency
  double calculateShippingCost(double cartTotalUSD, {bool isExpress = false}) {
    if (isShippingFree(cartTotalUSD)) {
      return 0.0;
    }
    return isExpress ? expressShipping : standardShipping;
  }

  String formatShippingCost(double cartTotalUSD, {bool isExpress = false}) {
    final cost = calculateShippingCost(cartTotalUSD, isExpress: isExpress);
    if (cost == 0.0) {
      return 'Бесплатно';
    }
    return formatPrice(cost / _selectedCurrency.rateToUSD);
  }

  // Get all available currencies
  List<Currency> get availableCurrencies => Currency.values;

  // Update exchange rates (can be called from API)
  Future<void> updateExchangeRates(Map<String, double> newRates) async {
    _exchangeRates.addAll(newRates);
    notifyListeners();
  }

  // Convert between any two currencies
  double convertBetweenCurrencies(double amount, Currency from, Currency to) {
    final amountInUSD = amount / from.rateToUSD;
    return amountInUSD * to.rateToUSD;
  }
}
