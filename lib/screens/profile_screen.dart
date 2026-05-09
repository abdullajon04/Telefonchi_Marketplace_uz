import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/locale_service.dart';
import '../services/theme_service.dart';
import '../widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _isSaving = false;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthService>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_isEditing) {
      // Отменить редактирование — сбросить значения
      final user = context.read<AuthService>().currentUser;
      _nameController.text = user?.name ?? '';
      _phoneController.text = user?.phone ?? '';
      _addressController.text = user?.address ?? '';
    }
    setState(() => _isEditing = !_isEditing);
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    final authService = context.read<AuthService>();
    final error = await authService.updateProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
    );
    setState(() {
      _isSaving = false;
      _isEditing = false;
    });
    if (mounted) {
      final locale = context.read<LocaleService>();
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppTheme.error),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(locale.t('profile_updated_msg')),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    }
  }

  void _showLanguagePicker() {
    final locale = context.read<LocaleService>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(locale.t('language'),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 16),
              ...AppLanguage.values.map((lang) {
                final labels = {
                  'uz': "🇺🇿  O'zbekcha",
                  'ru': '🇷🇺  Русский',
                  'en': '🇬🇧  English'
                };
                final isSelected = locale.language == lang;
                return ListTile(
                  title: Text(labels[lang.name]!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle,
                          color: AppTheme.accentBlue)
                      : null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  tileColor: isSelected
                      ? AppTheme.accentBlue.withValues(alpha: 0.1)
                      : null,
                  onTap: () {
                    locale.setLanguage(lang);
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                );
              }),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'abdullajon.778899@icloud.com',
      queryParameters: {'subject': 'Telefonchi - Yordam'},
    );
    try {
      await launchUrl(uri);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('abdullajon.778899@icloud.com ga yozing')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final themeService = context.watch<ThemeService>();
    final isDark = themeService.isDark;

    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser;
        if (user == null) {
          return Center(child: Text(locale.t('user_not_found')));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentBlue.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: user.role.name == 'seller'
                      ? const LinearGradient(
                          colors: [Color(0xFF00897B), Color(0xFF4DB6AC)])
                      : AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  user.role.name == 'seller'
                      ? '🏪 ${locale.t('seller')}'
                      : '🛒 ${locale.t('buyer')}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 24),

              // Edit / Cancel toggle
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _toggleEdit,
                  icon: Icon(_isEditing ? Icons.close : Icons.edit_outlined,
                      color: AppTheme.accentLight, size: 18),
                  label: Text(
                    _isEditing ? locale.t('cancel') : locale.t('edit'),
                    style: const TextStyle(
                        color: AppTheme.accentLight, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Info cards / Edit fields
              if (_isEditing) ...[
                CustomTextField(
                  controller: _nameController,
                  label: user.role.name == 'seller'
                      ? locale.t('store_name')
                      : locale.t('your_name'),
                  prefixIcon: user.role.name == 'seller'
                      ? Icons.store
                      : Icons.person_outline,
                ),
                const SizedBox(height: 12),
                _buildInfoTile(
                    Icons.email_outlined, 'Email', user.email, isDark),
                const SizedBox(height: 4),
                CustomTextField(
                  controller: _phoneController,
                  label: locale.t('phone'),
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _addressController,
                  label: locale.t('address'),
                  prefixIcon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveProfile,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.save),
                    label: Text(
                      _isSaving ? locale.t('saving') : locale.t('save'),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14))),
                  ),
                ),
              ] else ...[
                _buildInfoTile(
                    Icons.email_outlined, 'Email', user.email, isDark),
                _buildInfoTile(Icons.phone_outlined, locale.t('phone'),
                    user.phone, isDark),
                _buildInfoTile(Icons.location_on_outlined, locale.t('address'),
                    user.address, isDark),
              ],
              const SizedBox(height: 24),

              // ===== SETTINGS SECTION =====
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  locale.t('settings'),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),

              // Language
              _buildSettingsTile(
                icon: Icons.language,
                title: locale.t('language'),
                subtitle: locale.languageLabel,
                onTap: _showLanguagePicker,
                isDark: isDark,
              ),

              // Theme
              _buildSettingsTile(
                icon: isDark ? Icons.dark_mode : Icons.light_mode,
                title: locale.t('theme'),
                subtitle:
                    isDark ? locale.t('dark_theme') : locale.t('light_theme'),
                trailing: Switch(
                  value: isDark,
                  onChanged: (v) => themeService.setDark(v),
                  activeColor: AppTheme.accentBlue,
                ),
                isDark: isDark,
              ),

              // AI Support
              _buildSettingsTile(
                icon: Icons.smart_toy_outlined,
                title: locale.t('ai_support'),
                subtitle: locale.t('ai_support_desc'),
                onTap: () => Navigator.pushNamed(context, '/ai-chat'),
                isDark: isDark,
              ),

              // Contact us
              _buildSettingsTile(
                icon: Icons.mail_outline,
                title: locale.t('contact_us'),
                subtitle: 'abdullajon.778899@icloud.com',
                onTap: _sendEmail,
                isDark: isDark,
              ),

              const SizedBox(height: 24),

              // Logout button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(locale.t('logout_confirm')),
                        content: Text(locale.t('logout_desc')),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(locale.t('cancel')),
                          ),
                          TextButton(
                            onPressed: () {
                              authService.logout();
                              Navigator.pop(ctx);
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/role-selection', (route) => false);
                            },
                            child: Text(locale.t('logout'),
                                style: const TextStyle(color: AppTheme.error)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout, color: AppTheme.error),
                  label: Text(locale.t('logout'),
                      style: const TextStyle(
                          color: AppTheme.error,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.error),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // App version
              Text(
                'Telefonchi v1.0.0',
                style: TextStyle(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                    fontSize: 12),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoTile(
      IconData icon, String label, String value, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.getGlassDecoration(isDark),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accentBlue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.accentLight, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 12)),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: AppTheme.getGlassDecoration(isDark),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.accentLight, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          color: Theme.of(context).hintColor, fontSize: 12)),
                ],
              ),
            ),
            if (trailing != null)
              trailing
            else if (onTap != null)
              Icon(Icons.chevron_right,
                  color: Theme.of(context).hintColor, size: 20),
          ],
        ),
      ),
    );
  }
}
