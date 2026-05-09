import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/theme_service.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeService>().isDark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppTheme.primaryDark)
                      .withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon,
                    color: iconColor ??
                        (isDark ? AppTheme.accentLight : colorScheme.primary),
                    size: 22),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: isDark ? AppTheme.textPrimary : colorScheme.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
                color: isDark
                    ? AppTheme.textSecondary
                    : AppTheme.lightTextSecondary,
                fontSize: 13),
          ),
        ],
      ),
    );
  }
}
