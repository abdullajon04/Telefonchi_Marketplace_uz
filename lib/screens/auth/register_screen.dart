import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/order_service.dart';
import '../../services/locale_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _register(UserRole role) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService = context.read<AuthService>();
    final error = await authService.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      address: _addressController.text.trim(),
      role: role,
    );

    setState(() => _isLoading = false);

    if (error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppTheme.error),
        );
      }
      return;
    }

    if (mounted) {
      final user = authService.currentUser;
      if (user != null) {
        final orderService = context.read<OrderService>();
        if (role == UserRole.seller) {
          orderService.loadOrdersBySeller(user.id);
        } else {
          orderService.loadOrdersByBuyer(user.id);
        }
      }
      final route = role == UserRole.seller ? '/seller-main' : '/buyer-main';
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    }
  }

  Future<void> _socialRegister(UserRole role) async {
    setState(() => _isLoading = true);
    final error =
        await context.read<AuthService>().signInWithGoogle(role: role);
    setState(() => _isLoading = false);

    if (!mounted) {
      return;
    }

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppTheme.warning),
      );
      return;
    }

    final user = context.read<AuthService>().currentUser;
    if (user == null) {
      return;
    }
    final orderService = context.read<OrderService>();
    if (user.role == UserRole.seller) {
      orderService.loadOrdersBySeller(user.id);
    } else {
      orderService.loadOrdersByBuyer(user.id);
    }
    final route = user.role == UserRole.seller ? '/seller-main' : '/buyer-main';
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.lightTextPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          style:
              const TextStyle(color: AppTheme.lightTextPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: AppTheme.lightTextHint, fontSize: 14),
            filled: true,
            fillColor: AppTheme.lightInputBg,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.lightCardBorder)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.lightCardBorder)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: AppTheme.primaryDark, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.error)),
            prefixIcon: Icon(icon, size: 18, color: AppTheme.lightTextHint),
            suffixIcon: suffixIcon,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleService>();
    final role = ModalRoute.of(context)?.settings.arguments as UserRole? ??
        UserRole.buyer;

    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      body: Stack(
        children: [
          // Background decorative blurs
          Positioned(
              top: -192,
              right: -192,
              child: Container(
                  width: 384,
                  height: 384,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE0E0FF).withValues(alpha: 0.2)))),
          Positioned(
              bottom: 100,
              left: -192,
              child: Container(
                  width: 384,
                  height: 384,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE4E2E1).withValues(alpha: 0.3)))),

          SingleChildScrollView(
            child: Column(
              children: [
                // Hero Section
                Container(
                  width: double.infinity,
                  height: 192,
                  decoration:
                      const BoxDecoration(gradient: AppTheme.heroGradient),
                  child: Stack(
                    children: [
                      // Pattern overlay
                      Positioned.fill(
                          child: Opacity(
                              opacity: 0.2,
                              child: Container(color: Colors.transparent))),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/telefonchi.png',
                                width: 62,
                                height: 62,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Telefonchi',
                              style: AppTheme.brandTextStyle(
                                color: Colors.white,
                                size: 46,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Auth Card — glassmorphism style
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(33),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.lightSurface.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppTheme.lightCardBorder),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFF101828)
                                      .withValues(alpha: 0.08),
                                  blurRadius: 28,
                                  offset: const Offset(0, 12))
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tab Toggle
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppTheme.lightTabBg,
                                      borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryDark,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: const Color(0xFF101828)
                                                      .withValues(alpha: 0.12),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 1))
                                            ],
                                          ),
                                          child: Text(locale.t('register'),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () =>
                                              Navigator.pushReplacementNamed(
                                                  context, '/login'),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Text(locale.t('login'),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: AppTheme
                                                        .lightTextSecondary,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Title
                                Text(
                                  locale.t('create_account'),
                                  style: const TextStyle(
                                      color: AppTheme.lightTextPrimary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.6),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  locale.t('join_marketplace'),
                                  style: const TextStyle(
                                      color: AppTheme.lightTextSecondary,
                                      fontSize: 14),
                                ),

                                const SizedBox(height: 24),

                                // Form fields
                                _buildInput(
                                  controller: _nameController,
                                  label: locale.t('your_name'),
                                  hint: 'John Doe',
                                  icon: Icons.person_outline,
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                          ? locale.t('required_field')
                                          : null,
                                ),
                                const SizedBox(height: 16),
                                _buildInput(
                                  controller: _emailController,
                                  label: locale.t('email'),
                                  hint: 'john@example.com',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return locale.t('required_field');
                                    }
                                    if (!v.contains('@')) {
                                      return locale.t('enter_valid_email');
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                _buildInput(
                                  controller: _phoneController,
                                  label: locale.t('phone_number'),
                                  hint: '+998 XX XXX XX XX',
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                          ? locale.t('required_field')
                                          : null,
                                ),
                                const SizedBox(height: 16),
                                _buildInput(
                                  controller: _addressController,
                                  label: locale.t('address'),
                                  hint: '123 Design St, Tashkent',
                                  icon: Icons.location_on_outlined,
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                          ? locale.t('required_field')
                                          : null,
                                ),
                                const SizedBox(height: 16),
                                _buildInput(
                                  controller: _passwordController,
                                  label: locale.t('password'),
                                  hint:
                                      '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                                  icon: Icons.lock_outline,
                                  obscureText: _obscurePassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppTheme.lightTextHint,
                                        size: 20),
                                    onPressed: () => setState(() =>
                                        _obscurePassword = !_obscurePassword),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return locale.t('required_field');
                                    }
                                    if (v.length < 6) {
                                      return locale.t('min_6_chars');
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 24),

                                // Submit button — gradient
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: AppTheme.heroGradient,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.1),
                                            blurRadius: 15,
                                            offset: const Offset(0, 10))
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : () => _register(role),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white))
                                          : Text(locale.t('create_account'),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Divider
                                Row(
                                  children: [
                                    Expanded(
                                        child: Divider(
                                            color: const Color(0xFFC6C5D4)
                                                .withValues(alpha: 0.2))),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(locale.t('or_continue_with'),
                                          style: const TextStyle(
                                              color:
                                                  AppTheme.lightTextSecondary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    Expanded(
                                        child: Divider(
                                            color: const Color(0xFFC6C5D4)
                                                .withValues(alpha: 0.2))),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // Social logins
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _isLoading
                                        ? null
                                        : () => _socialRegister(role),
                                    icon: const Icon(Icons.g_mobiledata,
                                        size: 24),
                                    label: const Text('Google'),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Terms text
                                Center(
                                  child: Text.rich(
                                    TextSpan(
                                      text: '${locale.t('agree_terms')} ',
                                      style: const TextStyle(
                                          color: AppTheme.lightTextSecondary,
                                          fontSize: 12),
                                      children: [
                                        TextSpan(
                                            text: locale.t('terms_of_service'),
                                            style: const TextStyle(
                                                color:
                                                    AppTheme.lightTextPrimary,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(text: ' ${locale.t('and')} '),
                                        TextSpan(
                                            text: locale.t('privacy_policy'),
                                            style: const TextStyle(
                                                color:
                                                    AppTheme.lightTextPrimary,
                                                fontWeight: FontWeight.w600)),
                                        const TextSpan(text: '.'),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
