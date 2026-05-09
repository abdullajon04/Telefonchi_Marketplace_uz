enum ProductCategory {
  smartphones('cat_smartphones', 'smartphones'),
  featurePhones('cat_feature_phones', 'feature_phones'),
  accessories('cat_accessories', 'accessories'),
  tablets('cat_tablets', 'tablets'),
  laptops('cat_laptops', 'laptops'),
  smartwatches('cat_smartwatches', 'smartwatches'),
  headphones('cat_headphones', 'headphones');

  final String localeKey;
  final String value;
  const ProductCategory(this.localeKey, this.value);

  // Fallback displayName (used when locale is not available)
  String get displayName {
    switch (this) {
      case smartphones:
        return 'Смартфоны';
      case featurePhones:
        return 'Кнопочные телефоны';
      case accessories:
        return 'Аксессуары';
      case tablets:
        return 'Планшеты';
      case laptops:
        return 'Ноутбуки';
      case smartwatches:
        return 'Умные часы';
      case headphones:
        return 'Наушники';
    }
  }
}
