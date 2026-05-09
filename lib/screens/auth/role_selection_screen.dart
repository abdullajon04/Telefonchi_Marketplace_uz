import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/user.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final themeService = context.watch<ThemeService>();
    final isDark = themeService.isDark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF060D1F) : AppTheme.lightBg,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.backgroundGradient : null,
          color: isDark ? null : AppTheme.lightBg,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton<AppLanguage>(
                      icon: Icon(
                        Icons.language,
                        color:
                            isDark ? Colors.white : AppTheme.lightTextPrimary,
                      ),
                      onSelected: (lang) =>
                          context.read<LocaleService>().setLanguage(lang),
                      itemBuilder: (context) => AppLanguage.values
                          .map(
                            (lang) => PopupMenuItem<AppLanguage>(
                              value: lang,
                              child: Text(lang.name.toUpperCase()),
                            ),
                          )
                          .toList(),
                    ),
                    IconButton(
                      onPressed: () =>
                          context.read<ThemeService>().toggleTheme(),
                      icon: Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                        color:
                            isDark ? Colors.white : AppTheme.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Brand icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (isDark ? Colors.white : AppTheme.lightTextPrimary)
                          .withValues(alpha: 0.15),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/telefonchi.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  locale.t('welcome'),
                  style: TextStyle(
                      color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8),
                ),
                const SizedBox(height: 8),
                Text(
                  locale.t('choose_role'),
                  style: TextStyle(
                      color:
                          (isDark ? Colors.white : AppTheme.lightTextSecondary)
                              .withValues(alpha: 0.8),
                      fontSize: 14),
                ),

                const SizedBox(height: 48),

                // Buyer Card
                _buildRoleCard(
                  context: context,
                  locale: locale,
                  isDark: isDark,
                  title: locale.t('buyer'),
                  subtitle: locale.t('buyer_subtitle'),
                  icon: Icons.shopping_bag_outlined,
                  bulletPoints: [
                    locale.t('buyer_feature_1'),
                    locale.t('buyer_feature_2')
                  ],
                  buttonLabel:
                      '${locale.t('enter_as')} ${locale.t('buyer').toUpperCase()} \u2192',
                  role: UserRole.buyer,
                ),
                const SizedBox(height: 24),

                // Seller Card
                _buildRoleCard(
                  context: context,
                  locale: locale,
                  isDark: isDark,
                  title: locale.t('seller'),
                  subtitle: locale.t('seller_subtitle'),
                  icon: Icons.store_outlined,
                  bulletPoints: [
                    locale.t('seller_feature_1'),
                    locale.t('seller_feature_2')
                  ],
                  buttonLabel:
                      '${locale.t('enter_as')} ${locale.t('seller').toUpperCase()} \u2192',
                  role: UserRole.seller,
                ),

                const SizedBox(height: 32),

                // Trusted by section
                Text(
                  locale.t('have_account'),
                  style: TextStyle(
                      color:
                          (isDark ? Colors.white : AppTheme.lightTextSecondary)
                              .withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: Text(
                    locale.t('login'),
                    style: TextStyle(
                        color: isDark ? Colors.white : AppTheme.primaryDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required LocaleService locale,
    required bool isDark,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> bulletPoints,
    required String buttonLabel,
    required UserRole role,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withValues(alpha: 0.06) : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppTheme.lightCardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppTheme.lightSurfaceMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: isDark ? Colors.white : AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            title,
            style: TextStyle(
                color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.6)
                    : AppTheme.lightTextSecondary,
                fontSize: 14),
          ),

          const SizedBox(height: 16),

          // Bullet points
          ...bulletPoints.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 14,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : AppTheme.lightTextHint),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(
                      point,
                      style: TextStyle(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.5)
                              : AppTheme.lightTextSecondary,
                          fontSize: 13),
                    )),
                  ],
                ),
              )),

          const SizedBox(height: 16),

          // Enter button
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, '/register', arguments: role),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: AppTheme.heroGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF000666).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6))
                ],
              ),
              child: Text(
                buttonLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
