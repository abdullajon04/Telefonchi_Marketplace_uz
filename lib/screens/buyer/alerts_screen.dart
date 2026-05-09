import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/alert_service.dart';
import '../../services/locale_service.dart';
import '../../services/theme_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_scaffold.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final _modelController = TextEditingController();
  final _priceController = TextEditingController();

  String _formatPrice(double price) {
    final locale = context.read<LocaleService>();
    final formatter = NumberFormat('#,###', 'ru_RU');
    return '${formatter.format(price)} ${locale.t('sum')}';
  }

  @override
  void dispose() {
    _modelController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _addAlert() {
    final model = _modelController.text.trim();
    final priceStr = _priceController.text.trim();
    if (model.isEmpty || priceStr.isEmpty) return;

    final price = double.tryParse(priceStr);
    if (price == null || price <= 0) return;

    context.read<AlertService>().addAlert(model, price);
    _modelController.clear();
    _priceController.clear();
    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ '$model' uchun kutish saqlandi!"),
        backgroundColor: AppTheme.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alertService = context.watch<AlertService>();
    final isDark = context.watch<ThemeService>().isDark;
    final alerts = alertService.alerts;

    return GradientScaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.notifications_active,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('Kutish varaqasi'),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add alert form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardDark : AppTheme.lightCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: isDark
                        ? AppTheme.accentBlue.withValues(alpha: 0.2)
                        : AppTheme.lightCardBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.add_alert,
                          size: 18,
                          color: isDark
                              ? AppTheme.accentCyan
                              : AppTheme.accentBlue),
                      const SizedBox(width: 8),
                      Text("Yangi kutish",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark
                                ? AppTheme.textPrimary
                                : AppTheme.lightTextPrimary,
                          )),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _modelController,
                    style: TextStyle(
                        color: isDark
                            ? AppTheme.textPrimary
                            : AppTheme.lightTextPrimary),
                    decoration: InputDecoration(
                      hintText: 'Qaysi model (masalan: iPhone 15 Pro)',
                      hintStyle: TextStyle(
                          color: isDark
                              ? AppTheme.textHint
                              : AppTheme.lightTextHint,
                          fontSize: 13),
                      prefixIcon: const Icon(Icons.phone_android, size: 18),
                      filled: true,
                      fillColor:
                          isDark ? AppTheme.primaryMid : AppTheme.lightSurface,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: isDark
                                  ? AppTheme.textPrimary
                                  : AppTheme.lightTextPrimary),
                          decoration: InputDecoration(
                            hintText: "Maqsadli narx (so'm)",
                            hintStyle: TextStyle(
                                color: isDark
                                    ? AppTheme.textHint
                                    : AppTheme.lightTextHint,
                                fontSize: 13),
                            prefixIcon:
                                const Icon(Icons.attach_money, size: 18),
                            filled: true,
                            fillColor: isDark
                                ? AppTheme.primaryMid
                                : AppTheme.lightSurface,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _addAlert,
                            borderRadius: BorderRadius.circular(12),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              child: Text('Saqlash',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "💡 Narx tushganda yoki shu model sotuvga chiqqanda sizga xabar beramiz",
                    style: TextStyle(
                      color:
                          isDark ? AppTheme.textHint : AppTheme.lightTextHint,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Alerts list
            Expanded(
              child: alerts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none,
                              size: 48,
                              color: isDark
                                  ? AppTheme.textHint.withValues(alpha: 0.4)
                                  : AppTheme.lightTextHint),
                          const SizedBox(height: 12),
                          Text(
                            "Hozircha kutish varaqasi bo'sh",
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.textHint
                                  : AppTheme.lightTextHint,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: alerts.length,
                      itemBuilder: (context, index) {
                        final alert = alerts[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color:
                                isDark ? AppTheme.cardDark : AppTheme.lightCard,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: alert.isTriggered
                                  ? AppTheme.success.withValues(alpha: 0.4)
                                  : (isDark
                                      ? AppTheme.accentBlue
                                          .withValues(alpha: 0.15)
                                      : AppTheme.lightCardBorder),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 4),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: alert.isTriggered
                                    ? AppTheme.success.withValues(alpha: 0.15)
                                    : AppTheme.accentBlue
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                alert.isTriggered
                                    ? Icons.check_circle
                                    : Icons.notifications_active,
                                color: alert.isTriggered
                                    ? AppTheme.success
                                    : (isDark
                                        ? AppTheme.accentCyan
                                        : AppTheme.accentBlue),
                                size: 22,
                              ),
                            ),
                            title: Text(
                              alert.productModel,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppTheme.textPrimary
                                    : AppTheme.lightTextPrimary,
                              ),
                            ),
                            subtitle: Text(
                              alert.isTriggered
                                  ? "✅ Topildi! Narx: ${_formatPrice(alert.targetPrice)} gacha"
                                  : "Maqsad: ${_formatPrice(alert.targetPrice)}",
                              style: TextStyle(
                                color: alert.isTriggered
                                    ? AppTheme.success
                                    : (isDark
                                        ? AppTheme.textSecondary
                                        : AppTheme.lightTextSecondary),
                                fontSize: 13,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: AppTheme.error, size: 20),
                              onPressed: () =>
                                  alertService.removeAlert(alert.id),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
