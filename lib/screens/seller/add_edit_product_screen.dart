import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_theme.dart';
import '../../models/product.dart';
import '../../models/category.dart';
import '../../services/auth_service.dart';
import '../../services/product_service.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';
import '../../services/ai_agent_service.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/custom_text_field.dart';
import '../buyer/location_picker_screen.dart';

class AddEditProductScreen extends StatefulWidget {
  const AddEditProductScreen({super.key});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController(text: '1');
  ProductCategory _selectedCategory = ProductCategory.smartphones;
  bool _isEditing = false;
  Product? _existingProduct;
  String _imageBase64 = '';
  Uint8List? _imageBytes;
  bool _isLoading = false;
  String _location = '';
  double? _locationLat;
  double? _locationLng;
  String _productModel = '';
  String _condition = '';
  Color? _selectedColor;
  int? _selectedYear;
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final product = ModalRoute.of(context)?.settings.arguments as Product?;
    if (product != null && !_isEditing) {
      _isEditing = true;
      _existingProduct = product;
      _nameController.text = product.name;
      _descriptionController.text = product.description;
      _priceController.text = product.price.toStringAsFixed(0);
      _stockController.text = product.stock.toString();
      _selectedCategory = product.category;
      if (product.imageBase64.isNotEmpty) {
        _imageBase64 = product.imageBase64;
        _imageBytes = base64Decode(product.imageBase64);
      }
      _location = product.location;
      _locationLat = product.locationLat;
      _locationLng = product.locationLng;
      _productModel = product.productModel;
      _condition = product.condition;
      if (product.colorValue != null) {
        _selectedColor = Color(product.colorValue!);
      }
      _selectedYear = product.year;
      if (product.year != null) _yearController.text = '${product.year}';
      _modelController.text = product.productModel;
    }
  }

  static final Map<String, Color> _presetColors = {
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

  Future<void> _openMapPicker() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          initialLat: _locationLat,
          initialLng: _locationLng,
          initialAddress: _location.isNotEmpty ? _location : null,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _locationLat = result['lat'] as double;
        _locationLng = result['lng'] as double;
        _location = result['address'] as String;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageBase64 = base64Encode(bytes);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при выборе фото: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  /// Kategoriyaga mos modellar ro'yxati
  List<String> _getModelsForCategory() {
    switch (_selectedCategory) {
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
          'Google Pixel',
          'Honor'
        ];
      case ProductCategory.featurePhones:
        return ['Nokia', 'Samsung', 'Philips', 'Fly', 'Alcatel', 'Texet'];
      case ProductCategory.tablets:
        return [
          'iPad',
          'Samsung Tab',
          'Huawei MatePad',
          'Xiaomi Pad',
          'Lenovo Tab',
          'Amazon Fire'
        ];
      case ProductCategory.accessories:
        return [
          'Chexol',
          'Zaryadka',
          'Naushnik',
          'Ekran himoyasi',
          'Powerbank',
          'Kabel'
        ];
      case ProductCategory.laptops:
        return [
          'MacBook',
          'Dell',
          'HP',
          'Lenovo',
          'Asus',
          'Acer',
          'Microsoft Surface'
        ];
      case ProductCategory.smartwatches:
        return [
          'Apple Watch',
          'Samsung Galaxy Watch',
          'Xiaomi Watch',
          'Huawei Watch',
          'Amazfit',
          'Garmin'
        ];
      case ProductCategory.headphones:
        return ['AirPods', 'Sony', 'Bose', 'JBL', 'Xiaomi', 'Samsung', 'Beats'];
    }
  }

  Widget _buildProductAttributes() {
    final isDark = context.watch<ThemeService>().isDark;
    final models = _getModelsForCategory();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Хусусиятлар',
          style: TextStyle(
              color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 14),

        // Model selection
        Text('Модель',
            style: TextStyle(
                color: isDark
                    ? AppTheme.textSecondary
                    : AppTheme.lightTextSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...models.map((m) {
              final isSelected = _productModel == m;
              return GestureDetector(
                onTap: () => setState(() {
                  _productModel = m;
                  _modelController.text = m;
                }),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppTheme.accentGradient : null,
                    color: isSelected
                        ? null
                        : (isDark
                            ? AppTheme.cardDark
                            : AppTheme.lightSurfaceMuted),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : AppTheme.accentBlue.withValues(alpha: 0.3)),
                  ),
                  child: Text(m,
                      style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                  ? AppTheme.textSecondary
                                  : AppTheme.lightTextSecondary),
                          fontSize: 12)),
                ),
              );
            }),
            // Custom input chip
            GestureDetector(
              onTap: () {
                final isCustom = !models.contains(_productModel);
                if (!isCustom) {
                  setState(() {
                    _productModel = '';
                    _modelController.clear();
                  });
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: !models.contains(_productModel) &&
                          _productModel.isNotEmpty
                      ? AppTheme.accentBlue.withValues(alpha: 0.3)
                      : (isDark
                          ? AppTheme.cardDark
                          : AppTheme.lightSurfaceMuted),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppTheme.accentBlue.withValues(alpha: 0.3)),
                ),
                child: const Text('Бошқа...',
                    style:
                        TextStyle(color: AppTheme.accentLight, fontSize: 12)),
              ),
            ),
          ],
        ),
        // Custom model text field
        if (!models.contains(_productModel) ||
            _productModel.isEmpty && _modelController.text.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextField(
              controller: _modelController,
              style: TextStyle(
                  color:
                      isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
                  fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Моделни ёзинг',
                hintStyle: TextStyle(
                    color: isDark ? AppTheme.textHint : AppTheme.lightTextHint,
                    fontSize: 13),
                filled: true,
                fillColor: isDark ? AppTheme.cardDark : AppTheme.lightSurface,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              onChanged: (v) => _productModel = v.trim(),
            ),
          ),

        const SizedBox(height: 18),

        // Condition (Holati)
        Text('Ҳолати',
            style: TextStyle(
                color: isDark
                    ? AppTheme.textSecondary
                    : AppTheme.lightTextSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildConditionChip('Янги', Icons.fiber_new, isDark),
            const SizedBox(width: 10),
            _buildConditionChip('Ишлатилган', Icons.recycling, isDark),
          ],
        ),

        const SizedBox(height: 18),

        // Color picker — preset swatches
        Text('Ранги',
            style: TextStyle(
                color: isDark
                    ? AppTheme.textSecondary
                    : AppTheme.lightTextSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _presetColors.entries.map((entry) {
            final isSelected = _selectedColor == entry.value;
            final isLight = entry.value.computeLuminance() > 0.7;
            return GestureDetector(
              onTap: () => setState(() {
                _selectedColor = entry.value;
              }),
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: entry.value,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.accentCyan
                            : (isLight ? Colors.grey : Colors.white24),
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: entry.value.withValues(alpha: 0.5),
                                  blurRadius: 6)
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? Icon(Icons.check,
                            size: 18,
                            color: isLight ? Colors.black : Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    entry.key,
                    style: TextStyle(
                      color: isSelected
                          ? (isDark
                              ? AppTheme.textPrimary
                              : AppTheme.lightTextPrimary)
                          : (isDark
                              ? AppTheme.textHint
                              : AppTheme.lightTextHint),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 18),

        // Year — manual input
        Text('Ишлаб чиқарилган йили',
            style: TextStyle(
                color: isDark
                    ? AppTheme.textSecondary
                    : AppTheme.lightTextSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: _yearController,
          style: TextStyle(
              color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
              fontSize: 14),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Масалан: 2024',
            hintStyle: TextStyle(
                color: isDark ? AppTheme.textHint : AppTheme.lightTextHint,
                fontSize: 13),
            prefixIcon: const Icon(Icons.calendar_today, size: 18),
            filled: true,
            fillColor: isDark ? AppTheme.cardDark : AppTheme.lightSurface,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          onChanged: (v) {
            _selectedYear = int.tryParse(v.trim());
          },
        ),
      ],
    );
  }

  Widget _buildConditionChip(String label, IconData icon, bool isDark) {
    final isSelected = _condition == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _condition = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected ? AppTheme.accentGradient : null,
            color: isSelected
                ? null
                : (isDark ? AppTheme.cardDark : AppTheme.lightSurfaceMuted),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : AppTheme.accentBlue.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: isSelected
                      ? Colors.white
                      : (isDark
                          ? AppTheme.textSecondary
                          : AppTheme.lightTextSecondary)),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? AppTheme.textSecondary
                              : AppTheme.lightTextSecondary),
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = context.read<AuthService>();
    final productService = context.read<ProductService>();
    final user = authService.currentUser;
    final locale = context.read<LocaleService>();

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Siz avtorizatsiyadan o\'tmadingiz. Qaytadan kiring.'),
          backgroundColor: AppTheme.error,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final product = Product(
        id: _existingProduct?.id ?? '',
        sellerId: user.id,
        sellerName: user.name,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0,
        category: _selectedCategory,
        imageBase64: _imageBase64,
        stock: int.tryParse(_stockController.text.trim()) ?? 1,
        imagePath: _existingProduct?.imagePath ?? '',
        productModel: _productModel,
        condition: _condition,
        // ignore: deprecated_member_use
        colorValue: _selectedColor?.value,
        year: _selectedYear,
        location: _location,
        locationLat: _locationLat,
        locationLng: _locationLng,
      );

      if (_existingProduct != null) {
        await productService.updateProduct(product);
      } else {
        await productService.addProduct(product);
      }

      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _existingProduct != null
                  ? locale.t('product_updated')
                  : locale.t('product_added'),
            ),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error saving product: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${locale.t('error')}: $e'),
            backgroundColor: AppTheme.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
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
        title: Text(_existingProduct != null
            ? locale.t('edit_product')
            : locale.t('add_product')),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.cardDark.withValues(alpha: 0.5)
                            : AppTheme.lightSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppTheme.accentBlue.withValues(alpha: 0.3)
                              : AppTheme.lightCardBorder,
                        ),
                        image: _imageBytes != null
                            ? DecorationImage(
                                image: MemoryImage(_imageBytes!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _imageBytes == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 48,
                                  color: AppTheme.accentLight
                                      .withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  locale.t('pick_image'),
                                  style: TextStyle(
                                    color: isDark
                                        ? AppTheme.textSecondary
                                        : AppTheme.lightTextSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'JPG, PNG',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppTheme.textHint
                                        : AppTheme.lightTextHint,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          : Stack(
                              children: [
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: _pickImage,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  CustomTextField(
                    controller: _nameController,
                    label: locale.t('product_name'),
                    prefixIcon: Icons.phone_android,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return locale.t('required_field');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _descriptionController,
                    label: locale.t('description'),
                    prefixIcon: Icons.description_outlined,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return locale.t('required_field');
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon: const Text("🪄"),
                      label: Text(
                        "AI yordamida yozish",
                        style: TextStyle(
                          color: isDark
                              ? AppTheme.accentCyan
                              : AppTheme.accentBlue,
                        ),
                      ),
                      onPressed: () async {
                        final title = _nameController.text;
                        final model = _modelController.text;
                        final year = int.tryParse(_yearController.text) ?? 2024;

                        if (title.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Avval mahsulot nomini yozing!")));
                          return;
                        }

                        setState(() {
                          _descriptionController.text = "AI o'ylamoqda...";
                        });

                        final aiService = context.read<AiAgentService>();
                        final result = await aiService.generateDescription(
                          title,
                          locale.t(_selectedCategory.localeKey),
                          model,
                          _condition,
                          year,
                        );

                        if (mounted) {
                          setState(() {
                            _descriptionController.text = result;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          controller: _priceController,
                          label: '${locale.t('price')} (${locale.t('sum')})',
                          prefixIcon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return locale.t('required_field');
                            }
                            if (double.tryParse(value.trim()) == null) {
                              return locale.t('error');
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _stockController,
                          label: locale.t('stock'),
                          prefixIcon: Icons.inventory,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return locale.t('required_field');
                            }
                            final stock = int.tryParse(value.trim());
                            if (stock == null || stock < 0) {
                              return locale.t('error');
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Category selector
                  Text(
                    locale.t('category'),
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.textSecondary
                          : AppTheme.lightTextSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: ProductCategory.values.map((category) {
                      final isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategory = category);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            gradient:
                                isSelected ? AppTheme.accentGradient : null,
                            color: isSelected
                                ? null
                                : (isDark
                                    ? AppTheme.cardDark
                                    : AppTheme.lightSurfaceMuted),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : AppTheme.accentBlue.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            locale.t(category.localeKey),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? AppTheme.textSecondary
                                      : AppTheme.lightTextSecondary),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Product attributes section
                  _buildProductAttributes(),
                  const SizedBox(height: 24),

                  // Location picker
                  Text(
                    locale.t('location_from'),
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.textSecondary
                          : AppTheme.lightTextSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _openMapPicker,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.cardDark.withValues(alpha: 0.5)
                            : AppTheme.lightSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? AppTheme.accentBlue.withValues(alpha: 0.3)
                              : AppTheme.lightCardBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _location.isNotEmpty
                                ? Icons.location_on
                                : Icons.add_location_alt,
                            color: _location.isNotEmpty
                                ? AppTheme.success
                                : (isDark
                                    ? AppTheme.textHint
                                    : AppTheme.lightTextHint),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _location.isNotEmpty
                                  ? _location
                                  : locale.t('pick_on_map'),
                              style: TextStyle(
                                color: _location.isNotEmpty
                                    ? (isDark
                                        ? AppTheme.textPrimary
                                        : AppTheme.lightTextPrimary)
                                    : (isDark
                                        ? AppTheme.textHint
                                        : AppTheme.lightTextHint),
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.chevron_right,
                              color: isDark
                                  ? AppTheme.textHint
                                  : AppTheme.lightTextHint),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _saveProduct,
                      icon: Icon(
                        _existingProduct != null ? Icons.save : Icons.add,
                      ),
                      label: Text(
                        _existingProduct != null
                            ? locale.t('save')
                            : locale.t('add_product'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: AppTheme.accentCyan),
                    const SizedBox(height: 16),
                    Text(
                      locale.t('saving'),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
