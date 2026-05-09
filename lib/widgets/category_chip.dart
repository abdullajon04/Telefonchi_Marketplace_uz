import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/category.dart';
import '../services/locale_service.dart';
import '../services/theme_service.dart';

class CategoryChip extends StatelessWidget {
  final ProductCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeService>().isDark;
    final locale = context.watch<LocaleService>();
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.accentGradient : null,
          color: isSelected
              ? null
              : (isDark
                  ? AppTheme.cardDark.withValues(alpha: 0.7)
                  : AppTheme.lightSurfaceMuted),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark
                    ? AppTheme.accentBlue.withValues(alpha: 0.3)
                    : AppTheme.lightCardBorder),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.accentBlue.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          locale.t(category.localeKey),
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark
                    ? AppTheme.textSecondary
                    : AppTheme.lightTextSecondary),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
