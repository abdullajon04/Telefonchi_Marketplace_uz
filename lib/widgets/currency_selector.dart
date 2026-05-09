import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/currency_service.dart';

class CurrencySelector extends StatelessWidget {
  const CurrencySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyService>(
      builder: (context, currencyService, child) {
        return PopupMenuButton<Currency>(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currencyService.currencySymbol,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  currencyService.currencyCode,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: Theme.of(context).iconTheme.color,
                ),
              ],
            ),
          ),
          onSelected: (Currency currency) {
            currencyService.setCurrency(currency);
          },
          itemBuilder: (BuildContext context) {
            return Currency.values.map((Currency currency) {
              return PopupMenuItem<Currency>(
                value: currency,
                child: Row(
                  children: [
                    Text(
                      currency.symbol,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: currency == currencyService.selectedCurrency
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        currency.name,
                        style: TextStyle(
                          color: currency == currencyService.selectedCurrency
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                      ),
                    ),
                    if (currency == currencyService.selectedCurrency)
                      Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }
}

class PriceDisplay extends StatelessWidget {
  final double priceInUSD; // Price in USD by default
  final TextStyle? style;
  final bool showCurrencyCode;

  const PriceDisplay({
    super.key,
    required this.priceInUSD,
    this.style,
    this.showCurrencyCode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyService>(
      builder: (context, currencyService, child) {
        final formattedPrice = currencyService.formatPrice(priceInUSD);
        
        return Text(
          formattedPrice,
          style: style ?? Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }
}

class ShippingCostDisplay extends StatelessWidget {
  final double cartTotalUSD;
  final bool isExpress;
  final TextStyle? style;

  const ShippingCostDisplay({
    super.key,
    required this.cartTotalUSD,
    this.isExpress = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyService>(
      builder: (context, currencyService, child) {
        final shippingCost = currencyService.formatShippingCost(
          cartTotalUSD,
          isExpress: isExpress,
        );
        
        return Text(
          shippingCost,
          style: style ?? Theme.of(context).textTheme.bodyMedium,
        );
      },
    );
  }
}
