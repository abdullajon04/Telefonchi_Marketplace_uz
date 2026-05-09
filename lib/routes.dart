import 'package:flutter/material.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/buyer/buyer_main_screen.dart';
import 'screens/buyer/product_detail_screen.dart';
import 'screens/buyer/checkout_screen.dart';
import 'screens/buyer/order_tracking_screen.dart';
import 'screens/seller/seller_main_screen.dart';
import 'screens/seller/add_edit_product_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'screens/buyer/compare_screen.dart';
import 'screens/buyer/alerts_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String roleSelection = '/role-selection';
  static const String register = '/register';
  static const String login = '/login';
  static const String buyerMain = '/buyer-main';
  static const String productDetail = '/product-detail';
  static const String checkout = '/checkout';
  static const String orderTracking = '/order-tracking';
  static const String sellerMain = '/seller-main';
  static const String addProduct = '/add-product';
  static const String aiChat = '/ai-chat';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        roleSelection: (context) => const RoleSelectionScreen(),
        register: (context) => const RegisterScreen(),
        login: (context) => const LoginScreen(),
        buyerMain: (context) => const BuyerMainScreen(),
        productDetail: (context) => const ProductDetailScreen(),
        checkout: (context) => const CheckoutScreen(),
        orderTracking: (context) => const OrderTrackingScreen(),
        sellerMain: (context) => const SellerMainScreen(),
        addProduct: (context) => const AddEditProductScreen(),
        aiChat: (context) => const AiChatScreen(),
        '/compare': (context) => const CompareScreen(),
        '/alerts': (context) => const AlertsScreen(),
      };
}
