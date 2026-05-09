import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'utils/seed_data.dart';
import 'theme/app_theme.dart';
import 'routes.dart';
import 'services/auth_service.dart';
import 'services/product_service.dart';
import 'services/cart_service.dart';
import 'services/order_service.dart';
import 'services/review_service.dart';
import 'services/chat_service.dart';
import 'services/locale_service.dart';
import 'services/theme_service.dart';
import 'services/wishlist_service.dart';
import 'services/currency_service.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/ai_agent_service.dart';
import 'services/compare_service.dart';
import 'services/alert_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("App starting: Initializing Firebase...");
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase initialized successfully.");

    // Seed products from Ego and Smartlife (Remove after first run)
    // await SeedData.seedAllProducts();
    debugPrint("Database seeded successfully.");
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  debugPrint("Loading .env file...");
  await _loadEnv();
  debugPrint("Env loaded. Running app...");

  runApp(const MobileMarketApp());
}

Future<void> _loadEnv() async {
  try {
    await dotenv.load(fileName: ".env");
    
    // Initialize currency service
    final currencyService = CurrencyService();
    await currencyService.initialize();
    
  } catch (e) {
    debugPrint("Env file not loaded: $e");
  }
}

class MobileMarketApp extends StatelessWidget {
  const MobileMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => OrderService()),
        ChangeNotifierProvider(create: (_) => ReviewService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
        ChangeNotifierProvider(create: (_) => LocaleService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => WishlistService()),
        ChangeNotifierProvider(create: (_) => CurrencyService()),
        ChangeNotifierProvider(create: (_) => AiAgentService()),
        ChangeNotifierProvider(create: (_) => CompareService()),
        ChangeNotifierProvider(create: (_) => AlertService()),
      ],
      child: Consumer2<ThemeService, LocaleService>(
        builder: (context, themeService, localeService, child) {
          return MaterialApp(
            title: 'Telefonchi',
            debugShowCheckedModeBanner: false,
            theme:
                themeService.isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
