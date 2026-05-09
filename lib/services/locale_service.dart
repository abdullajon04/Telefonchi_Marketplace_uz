import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

enum AppLanguage { uz, ru, en }

class LocaleService extends ChangeNotifier {
  AppLanguage _language = AppLanguage.uz;

  AppLanguage get language => _language;
  String get languageCode => _language.name;

  String get languageLabel {
    switch (_language) {
      case AppLanguage.uz:
        return "O'zbekcha";
      case AppLanguage.ru:
        return 'Русский';
      case AppLanguage.en:
        return 'English';
    }
  }

  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
  }

  String t(String key) {
    return (_translations[key]?[_language.name]) ?? key;
  }

  String formatPrice(double price) {
    // Standard format for USD: $ 1,234
    final formatter = NumberFormat('#,###', 'en_US');
    return '\$ ${formatter.format(price)}';
  }

  static final Map<String, Map<String, String>> _translations = {
    // ===== Common =====
    'app_name': {'uz': 'Telefonchi', 'ru': 'Telefonchi', 'en': 'Telefonchi'},
    'app_subtitle': {
      'uz': 'Mobil telefonlar marketplace',
      'ru': 'Маркетплейс мобильных телефонов',
      'en': 'Mobile phone marketplace'
    },
    'cancel': {'uz': 'Bekor', 'ru': 'Отмена', 'en': 'Cancel'},
    'save': {'uz': 'Saqlash', 'ru': 'Сохранить', 'en': 'Save'},
    'saving': {
      'uz': 'Saqlanmoqda...',
      'ru': 'Сохранение...',
      'en': 'Saving...'
    },
    'delete': {'uz': "O'chirish", 'ru': 'Удалить', 'en': 'Delete'},
    'back': {'uz': 'Orqaga', 'ru': 'Назад', 'en': 'Back'},
    'yes': {'uz': 'Ha', 'ru': 'Да', 'en': 'Yes'},
    'no': {'uz': "Yo'q", 'ru': 'Нет', 'en': 'No'},
    'error': {'uz': 'Xatolik', 'ru': 'Ошибка', 'en': 'Error'},
    'required_field': {
      'uz': 'Majburiy maydon',
      'ru': 'Обязательное поле',
      'en': 'Required field'
    },
    'clear': {'uz': 'Tozalash', 'ru': 'Очистить', 'en': 'Clear'},
    'all': {'uz': 'Barchasi', 'ru': 'Все', 'en': 'All'},
    'pickup': {'uz': 'Olib ketish', 'ru': 'Самовывоз', 'en': 'Pickup'},
    'yandex_go': {'uz': 'Yandex Go (shahar ichida)', 'ru': 'Yandex Go (в пределах города)', 'en': 'Yandex Go (in city)'},
    'uzum_tezkor': {'uz': 'Uzum Tezkor (shahar ichida)', 'ru': 'Uzum Tezkor (в пределах города)', 'en': 'Uzum Tezkor (in city)'},
    'bts_express': {'uz': 'BTS Express (viloyatlarga)', 'ru': 'BTS Express (другие регионы)', 'en': 'BTS Express (other regions)'},
    'details': {'uz': 'Batafsil', 'ru': 'Подробности', 'en': 'Details'},
    'sum': {'uz': '\$', 'ru': '\$', 'en': '\$'},

    // ===== Auth =====
    'welcome': {
      'uz': 'Xush kelibsiz! 👋',
      'ru': 'Добро пожаловать! 👋',
      'en': 'Welcome! 👋'
    },
    'choose_role': {
      'uz': 'Rolingizni tanlang',
      'ru': 'Выберите вашу роль',
      'en': 'Choose your role'
    },
    'buyer': {'uz': 'Xaridor', 'ru': 'Покупатель', 'en': 'Buyer'},
    'seller': {'uz': 'Sotuvchi', 'ru': 'Продавец', 'en': 'Seller'},
    'buyer_subtitle': {
      'uz': 'Eng yaxshi narxlarda telefon xarid qiling',
      'ru': 'Покупайте телефоны по лучшим ценам',
      'en': 'Buy phones at the best prices'
    },
    'seller_subtitle': {
      'uz': 'Platformada telefon soting',
      'ru': 'Продавайте телефоны на платформе',
      'en': 'Sell phones on the platform'
    },
    'buyer_feature_1': {
      'uz': 'Premium telefonlarni toping',
      'ru': 'Находите премиум телефоны',
      'en': 'Browse exclusive digital assets'
    },
    'buyer_feature_2': {
      'uz': 'Xavfsiz to\'lov tizimi',
      'ru': 'Безопасная система оплаты',
      'en': 'Secure payment system'
    },
    'seller_feature_1': {
      'uz': 'Mahsulotlaringizni boshqaring',
      'ru': 'Управляйте вашими товарами',
      'en': 'Manage your listings'
    },
    'seller_feature_2': {
      'uz': 'Analitika va hisobotlar',
      'ru': 'Аналитика и отчёты',
      'en': 'Analytics and reports'
    },
    'enter_as': {'uz': 'Kirish:', 'ru': 'Войти как', 'en': 'ENTER AS'},
    'login': {'uz': 'Kirish', 'ru': 'Войти', 'en': 'Login'},
    'login_title': {
      'uz': 'Hisobga kirish',
      'ru': 'Вход в аккаунт',
      'en': 'Login to account'
    },
    'login_subtitle': {
      'uz': 'Kirish uchun ma\'lumotlaringizni kiriting',
      'ru': 'Введите ваши данные для входа',
      'en': 'Enter your credentials to login'
    },
    'register': {
      'uz': "Ro'yxatdan o'tish",
      'ru': 'Зарегистрироваться',
      'en': 'Register'
    },
    'registration': {
      'uz': "Ro'yxatdan o'tish",
      'ru': 'Регистрация',
      'en': 'Registration'
    },
    'have_account': {
      'uz': 'Hisobingiz bormi? ',
      'ru': 'Уже есть аккаунт? ',
      'en': 'Already have an account? '
    },
    'no_account': {
      'uz': 'Hisobingiz yoqmi? ',
      'ru': 'Нет аккаунта? ',
      'en': 'No account? '
    },
    'email_or_phone': {
      'uz': 'Email yoki telefon',
      'ru': 'Email или телефон',
      'en': 'Email or phone'
    },
    'password': {'uz': 'Parol', 'ru': 'Пароль', 'en': 'Password'},
    'forgot_password': {
      'uz': 'Parolni unutdingizmi?',
      'ru': 'Забыли пароль?',
      'en': 'Forgot password?'
    },
    'reset_password': {
      'uz': 'Parolni tiklash',
      'ru': 'Сброс пароля',
      'en': 'Reset password'
    },
    'reset_password_desc': {
      'uz': 'Parolni tiklash uchun emailni kiriting',
      'ru': 'Введите email для сброса пароля',
      'en': 'Enter email to reset password'
    },
    'send': {'uz': 'Yuborish', 'ru': 'Отправить', 'en': 'Send'},
    'reset_email_sent': {
      'uz': 'Parol tiklash xati pochtangizga yuborildi',
      'ru': 'Письмо для сброса пароля отправлено на вашу почту',
      'en': 'Password reset email sent'
    },
    'enter_valid_email': {
      'uz': "To'g'ri email kiriting",
      'ru': 'Введите корректный email',
      'en': 'Enter a valid email'
    },
    'email': {
      'uz': 'Elektron pochta',
      'ru': 'Электронная почта',
      'en': 'Email'
    },
    'phone': {'uz': 'Telefon', 'ru': 'Телефон', 'en': 'Phone'},
    'phone_number': {
      'uz': 'Telefon raqam',
      'ru': 'Номер телефона',
      'en': 'Phone number'
    },
    'address': {'uz': 'Manzil', 'ru': 'Адрес', 'en': 'Address'},
    'your_name': {'uz': 'Ismingiz', 'ru': 'Ваше имя', 'en': 'Your name'},
    'store_name': {
      'uz': "Do'kon nomi",
      'ru': 'Название магазина',
      'en': 'Store name'
    },
    'min_6_chars': {
      'uz': 'Kamida 6 ta belgi',
      'ru': 'Минимум 6 символов',
      'en': 'Minimum 6 characters'
    },
    'create_account': {
      'uz': 'Hisob yaratish',
      'ru': 'Создать аккаунт',
      'en': 'Create Account'
    },
    'join_marketplace': {
      'uz': 'Marketplace\'ga qo\'shiling',
      'ru': 'Присоединяйтесь к маркетплейсу',
      'en': 'Join our curated marketplace'
    },
    'or_continue_with': {
      'uz': 'Yoki davom eting',
      'ru': 'Или продолжите с',
      'en': 'Or continue with'
    },
    'agree_terms': {
      'uz': 'Ro\'yxatdan o\'tib, siz qabul qilasiz',
      'ru': 'Регистрируясь, вы соглашаетесь с',
      'en': 'By signing up, you agree to our'
    },
    'terms_of_service': {
      'uz': 'Foydalanish shartlari',
      'ru': 'Условия использования',
      'en': 'Terms of Service'
    },
    'privacy_policy': {
      'uz': 'Maxfiylik siyosati',
      'ru': 'Политика конфиденциальности',
      'en': 'Privacy Policy'
    },
    'and': {'uz': 'va', 'ru': 'и', 'en': 'and'},
    'demo_data': {
      'uz': 'Demo kirish ma\'lumotlari:',
      'ru': 'Демо данные для входа:',
      'en': 'Demo login data:'
    },

    // ===== Navigation =====
    'home': {'uz': 'Asosiy', 'ru': 'Главная', 'en': 'Home'},
    'search': {'uz': 'Qidiruv', 'ru': 'Поиск', 'en': 'Search'},
    'cart': {'uz': 'Savat', 'ru': 'Корзина', 'en': 'Cart'},
    'orders': {'uz': 'Buyurtmalar', 'ru': 'Заказы', 'en': 'Orders'},
    'wishlist': {'uz': 'Sevimlilar', 'ru': 'Избранное', 'en': 'Wishlist'},
    'chat': {'uz': 'Chat', 'ru': 'Чат', 'en': 'Chat'},
    'profile': {'uz': 'Profil', 'ru': 'Профиль', 'en': 'Profile'},
    'wishlist_empty': {
      'uz': 'Sevimlilar bo‘sh',
      'ru': 'Список избранного пуст',
      'en': 'Wishlist is empty'
    },
    'wishlist_empty_desc': {
      'uz': 'Mahsulotni yurakcha orqali saqlang',
      'ru': 'Добавляйте товары нажатием на сердечко',
      'en': 'Save products by tapping the heart icon'
    },
    'dashboard': {'uz': 'Boshqaruv', 'ru': 'Панель', 'en': 'Dashboard'},
    'products': {'uz': 'Mahsulotlar', 'ru': 'Товары', 'en': 'Products'},

    // ===== Products =====
    'search_phones': {
      'uz': 'Telefon qidirish...',
      'ru': 'Поиск телефонов...',
      'en': 'Search phones...'
    },
    'popular_products': {
      'uz': 'Ommabop mahsulotlar',
      'ru': 'Популярные товары',
      'en': 'Popular products'
    },
    'products_count': {'uz': 'ta mahsulot', 'ru': 'товаров', 'en': 'products'},
    'no_products': {
      'uz': 'Bu kategoriyada mahsulot yoq',
      'ru': 'Нет товаров в этой категории',
      'en': 'No products in this category'
    },
    'not_found': {
      'uz': 'Hech narsa topilmadi',
      'ru': 'Ничего не найдено',
      'en': 'Nothing found'
    },
    'found': {'uz': 'Topildi', 'ru': 'Найдено', 'en': 'Found'},
    'in_stock': {'uz': 'Mavjud', 'ru': 'В наличии', 'en': 'In stock'},
    'out_of_stock': {
      'uz': 'Tugagan',
      'ru': 'Нет в наличии',
      'en': 'Out of stock'
    },
    'pcs': {'uz': 'dona', 'ru': 'шт.', 'en': 'pcs'},
    'product_not_found': {
      'uz': 'Mahsulot topilmadi',
      'ru': 'Товар не найден',
      'en': 'Product not found'
    },
    'description': {'uz': 'Tavsif', 'ru': 'Описание', 'en': 'Description'},
    'add_to_cart': {
      'uz': 'Savatga qo\'shish',
      'ru': 'Добавить в корзину',
      'en': 'Add to cart'
    },
    'remove_from_cart': {
      'uz': 'Savatdan olib tashlash',
      'ru': 'Убрать из корзины',
      'en': 'Remove from cart'
    },
    'added_to_cart': {
      'uz': 'Savatga qo\'shildi',
      'ru': 'Добавлено в корзину',
      'en': 'Added to cart'
    },
    'removed_from_cart': {
      'uz': 'Savatdan olib tashlandi',
      'ru': 'Удалено из корзины',
      'en': 'Removed from cart'
    },
    'reviews': {'uz': 'Sharhlar', 'ru': 'Отзывы', 'en': 'Reviews'},
    'write_review': {
      'uz': 'Sharh yozish',
      'ru': 'Написать отзыв',
      'en': 'Write a review'
    },
    'your_review': {
      'uz': 'Sharh matni',
      'ru': 'Текст отзыва',
      'en': 'Review text'
    },
    'no_reviews': {
      'uz': 'Hali sharhlar yoq',
      'ru': 'Пока нет отзывов',
      'en': 'No reviews yet'
    },
    'review_thanks': {
      'uz': 'Sharh uchun rahmat!',
      'ru': 'Спасибо за отзыв!',
      'en': 'Thanks for your review!'
    },
    'attributes': {
      'uz': 'Xususiyatlar',
      'ru': 'Характеристики',
      'en': 'Attributes'
    },
    'model': {'uz': 'Model', 'ru': 'Модель', 'en': 'Model'},
    'condition': {'uz': 'Holati', 'ru': 'Состояние', 'en': 'Condition'},
    'new_cond': {'uz': 'Yangi', 'ru': 'Новый', 'en': 'New'},
    'used_cond': {'uz': 'Ishlatilgan', 'ru': 'Б/У', 'en': 'Used'},
    'color': {'uz': 'Rangi', 'ru': 'Цвет', 'en': 'Color'},
    'year': {'uz': 'Yili', 'ru': 'Год', 'en': 'Year'},
    'location': {'uz': 'Manzil', 'ru': 'Адрес', 'en': 'Location'},

    // ===== Cart =====
    'cart_empty': {
      'uz': 'Savat bo\'sh',
      'ru': 'Корзина пуста',
      'en': 'Cart is empty'
    },
    'cart_empty_desc': {
      'uz': 'Xarid qilish uchun mahsulot qo\'shing',
      'ru': 'Добавьте товары для покупки',
      'en': 'Add products to buy'
    },
    'clear_cart': {
      'uz': 'Savatni tozalash?',
      'ru': 'Очистить корзину?',
      'en': 'Clear cart?'
    },
    'clear_cart_desc': {
      'uz': 'Barcha mahsulotlar savatdan olib tashlanadi.',
      'ru': 'Все товары будут удалены из корзины.',
      'en': 'All items will be removed from cart.'
    },
    'total': {'uz': 'Jami:', 'ru': 'Итого:', 'en': 'Total:'},
    'checkout': {
      'uz': 'Buyurtma berish',
      'ru': 'Оформить заказ',
      'en': 'Checkout'
    },

    // ===== Checkout =====
    'delivery_address': {
      'uz': 'Yetkazish manzili',
      'ru': 'Адрес доставки',
      'en': 'Delivery address'
    },
    'enter_address': {
      'uz': 'Yetkazish manzilini kiriting',
      'ru': 'Укажите адрес доставки',
      'en': 'Enter delivery address'
    },
    'payment_method': {
      'uz': "To'lov usuli",
      'ru': 'Способ оплаты',
      'en': 'Payment method'
    },
    'delivery_method': {
      'uz': 'Yetkazish usuli',
      'ru': 'Способ доставки',
      'en': 'Delivery method'
    },
    'delivery_price': {
      'uz': 'Yetkazish narxi',
      'ru': 'Стоимость доставки',
      'en': 'Delivery price'
    },
    'order_total': {
      'uz': 'Buyurtma summasi',
      'ru': 'Сумма заказа',
      'en': 'Order total'
    },
    'place_order': {
      'uz': 'Buyurtma berish',
      'ru': 'Оформить заказ',
      'en': 'Place order'
    },
    'order_error': {
      'uz': 'Buyurtma berishda xatolik',
      'ru': 'Ошибка при оформлении',
      'en': 'Order error'
    },
    'order_placed': {
      'uz': 'Buyurtma rasmiylashtirildi!',
      'ru': 'Заказ оформлен!',
      'en': 'Order placed!'
    },
    'order_placed_desc': {
      'uz':
          'Buyurtmangiz muvaffaqiyatli rasmiylashtirildi.\nSotuvchi siz bilan bog\'lanadi.',
      'ru': 'Ваш заказ успешно оформлен.\nПродавец свяжется с вами.',
      'en':
          'Your order has been placed successfully.\nThe seller will contact you.'
    },
    'great': {'uz': 'Ajoyib!', 'ru': 'Отлично!', 'en': 'Great!'},

    // ===== Orders =====
    'my_orders': {'uz': 'Buyurtmalarim', 'ru': 'Мои заказы', 'en': 'My orders'},
    'no_orders': {
      'uz': 'Buyurtmalar yoq',
      'ru': 'Нет заказов',
      'en': 'No orders'
    },
    'no_orders_desc': {
      'uz': 'Buyurtmalaringiz bu yerda ko\'rinadi',
      'ru': 'Ваши заказы появятся здесь',
      'en': 'Your orders will appear here'
    },
    'order_status': {
      'uz': 'Buyurtma holati',
      'ru': 'Статус заказа',
      'en': 'Order status'
    },
    'pending': {'uz': 'Kutilmoqda', 'ru': 'Ожидание', 'en': 'Pending'},
    'confirmed': {'uz': 'Tasdiqlandi', 'ru': 'Подтверждён', 'en': 'Confirmed'},
    'shipped': {'uz': 'Yetkazilmoqda', 'ru': 'Отправлен', 'en': 'Shipped'},
    'delivered': {'uz': 'Yetkazildi', 'ru': 'Доставлен', 'en': 'Delivered'},
    'cancelled': {'uz': 'Bekor qilindi', 'ru': 'Отменён', 'en': 'Cancelled'},
    'delivery_info': {
      'uz': 'Yetkazish ma\'lumotlari',
      'ru': 'Информация о доставке',
      'en': 'Delivery info'
    },
    'track_order': {
      'uz': 'Buyurtmani kuzatish',
      'ru': 'Отследить заказ',
      'en': 'Track order'
    },

    // ===== Seller =====
    'add_product': {
      'uz': 'Mahsulot qo\'shish',
      'ru': 'Добавить товар',
      'en': 'Add product'
    },
    'edit_product': {
      'uz': 'Tahrirlash',
      'ru': 'Редактировать',
      'en': 'Edit product'
    },
    'product_name': {
      'uz': 'Mahsulot nomi',
      'ru': 'Название товара',
      'en': 'Product name'
    },
    'price': {'uz': 'Narx', 'ru': 'Цена', 'en': 'Price'},
    'stock': {
      'uz': 'Miqdor (sklad)',
      'ru': 'Количество (склад)',
      'en': 'Stock quantity'
    },
    'category': {'uz': 'Kategoriya', 'ru': 'Категория', 'en': 'Category'},
    'image': {'uz': 'Rasm', 'ru': 'Фото', 'en': 'Image'},
    'pick_image': {
      'uz': 'Rasm tanlash',
      'ru': 'Выбрать фото',
      'en': 'Pick image'
    },
    'change_image': {
      'uz': 'Rasmni o\'zgartirish',
      'ru': 'Изменить фото',
      'en': 'Change image'
    },
    'location_from': {
      'uz': 'Manzil (qayerdan yuboriladi)',
      'ru': 'Адрес (откуда отправка)',
      'en': 'Location (ship from)'
    },
    'pick_on_map': {
      'uz': 'Xaritadan tanlash',
      'ru': 'Выбрать на карте',
      'en': 'Pick on map'
    },
    'total_products': {
      'uz': 'Jami mahsulotlar',
      'ru': 'Всего товаров',
      'en': 'Total products'
    },
    'total_orders': {
      'uz': 'Jami buyurtmalar',
      'ru': 'Всего заказов',
      'en': 'Total orders'
    },
    'total_sold': {'uz': 'Sotilgan', 'ru': 'Продано', 'en': 'Sold'},
    'total_revenue': {
      'uz': 'Jami daromad',
      'ru': 'Общий доход',
      'en': 'Total revenue'
    },
    'update_status': {
      'uz': 'Holatni yangilash',
      'ru': 'Обновить статус',
      'en': 'Update status'
    },
    'no_products_seller': {
      'uz': 'Mahsulotlar yoq',
      'ru': 'Нет товаров',
      'en': 'No products'
    },
    'add_first_product': {
      'uz': 'Birinchi mahsulotni qo\'shing',
      'ru': 'Добавьте свой первый товар',
      'en': 'Add your first product'
    },
    'my_products': {
      'uz': 'Mening mahsulotlarim',
      'ru': 'Мои товары',
      'en': 'My products'
    },
    'delete_product': {
      'uz': 'Mahsulotni o\'chirish?',
      'ru': 'Удалить товар?',
      'en': 'Delete product?'
    },
    'delete_confirm': {'uz': 'O\'chirish', 'ru': 'Удалить', 'en': 'Delete'},
    'no_orders_seller_desc': {
      'uz': 'Xaridorlardan buyurtmalar bu yerda ko\'rinadi',
      'ru': 'Заказы от покупателей появятся здесь',
      'en': 'Orders from buyers will appear here'
    },

    // ===== Profile =====
    'edit': {'uz': 'Tahrirlash', 'ru': 'Редактировать', 'en': 'Edit'},
    'profile_updated': {
      'uz': 'Profil yangilandi',
      'ru': 'Профиль обновлён',
      'en': 'Profile updated'
    },
    'logout': {
      'uz': 'Hisobdan chiqish',
      'ru': 'Выйти из аккаунта',
      'en': 'Logout'
    },
    'logout_confirm': {
      'uz': 'Hisobdan chiqmoqchimisiz?',
      'ru': 'Выйти из аккаунта?',
      'en': 'Logout from account?'
    },
    'logout_desc': {
      'uz': 'Rostdan chiqmoqchimisiz?',
      'ru': 'Вы уверены, что хотите выйти?',
      'en': 'Are you sure you want to logout?'
    },
    'user_not_found': {
      'uz': 'Foydalanuvchi topilmadi',
      'ru': 'Пользователь не найден',
      'en': 'User not found'
    },
    'language': {'uz': 'Til', 'ru': 'Язык', 'en': 'Language'},
    'theme': {'uz': 'Mavzu', 'ru': 'Тема', 'en': 'Theme'},
    'dark_theme': {'uz': "Qorong'i", 'ru': 'Тёмная', 'en': 'Dark'},
    'light_theme': {'uz': "Yorug'", 'ru': 'Светлая', 'en': 'Light'},
    'contact_us': {
      'uz': 'Biz bilan bog\'lanish',
      'ru': 'Связаться с нами',
      'en': 'Contact us'
    },
    'contact_desc': {
      'uz': 'Savollaringiz bo\'lsa yozing',
      'ru': 'Напишите если есть вопросы',
      'en': 'Write if you have questions'
    },
    'ai_support': {'uz': 'AI Yordam', 'ru': 'AI Помощь', 'en': 'AI Support'},
    'ai_support_desc': {
      'uz': 'Savollaringizga tezkor javob',
      'ru': 'Быстрые ответы на вопросы',
      'en': 'Quick answers to questions'
    },
    'settings': {'uz': 'Sozlamalar', 'ru': 'Настройки', 'en': 'Settings'},

    // ===== Chat =====
    'chats': {'uz': 'Chatlar', 'ru': 'Чаты', 'en': 'Chats'},
    'no_chats': {'uz': 'Chatlar yoq', 'ru': 'Нет чатов', 'en': 'No chats'},
    'type_message': {
      'uz': 'Xabar yozing...',
      'ru': 'Напишите сообщение...',
      'en': 'Type a message...'
    },
    'no_messages': {
      'uz': 'Xabarlar yoq',
      'ru': 'Нет сообщений',
      'en': 'No messages'
    },
    'start_chat_from_product': {
      'uz': 'Mahsulot sahifasidan dialog boshlang',
      'ru': 'Начните диалог из карточки товара',
      'en': 'Start a chat from a product page'
    },
    'start_dialog': {
      'uz': 'Dialogni boshlang...',
      'ru': 'Начните диалог...',
      'en': 'Start a conversation...'
    },
    'message_hint': {
      'uz': 'Xabar...',
      'ru': 'Сообщение...',
      'en': 'Message...'
    },
    'nothing_found': {
      'uz': 'Hech narsa topilmadi',
      'ru': 'Ничего не найдено',
      'en': 'Nothing found'
    },
    'new_condition': {'uz': 'Yangi', 'ru': 'Новый', 'en': 'New'},
    'used_condition': {'uz': 'Ishlatilgan', 'ru': 'Б/У', 'en': 'Used'},

    // ===== Filter =====
    'filter': {'uz': 'Filtr', 'ru': 'Фильтр', 'en': 'Filter'},
    'price_range': {'uz': 'Narx', 'ru': 'Цена', 'en': 'Price'},
    'reset_filters': {'uz': 'Tozalash', 'ru': 'Сбросить', 'en': 'Reset'},

    // ===== Add/Edit Product =====
    'product_photo': {
      'uz': 'Mahsulot rasmi',
      'ru': 'Фото товара',
      'en': 'Product photo'
    },
    'other': {'uz': 'Boshqa...', 'ru': 'Другое...', 'en': 'Other...'},
    'type_model': {
      'uz': 'Modelni yozing',
      'ru': 'Введите модель',
      'en': 'Type model'
    },
    'review_only_after_receive': {
      'uz': 'Faqat mahsulotni olganingizdan so\'ng sharh qoldirishingiz mumkin',
      'ru': 'Отзыв можно оставить только после получения товара',
      'en': 'You can only leave a review after receiving the product'
    },
    'choose_color': {
      'uz': 'Rangni tanlang',
      'ru': 'Выберите цвет',
      'en': 'Choose color'
    },
    'year_hint': {
      'uz': 'Masalan: 2024',
      'ru': 'Например: 2024',
      'en': 'E.g.: 2024'
    },
    'mfg_year': {
      'uz': 'Ishlab chiqarilgan yili',
      'ru': 'Год выпуска',
      'en': 'Manufacturing year'
    },

    // ===== AI Chat =====
    'ai_chat_title': {
      'uz': 'AI Yordamchi',
      'ru': 'AI Помощник',
      'en': 'AI Assistant'
    },
    'ai_greeting': {
      'uz':
          'Salom! Men Telefonchi AI yordamchisiman. Savollaringizga javob berishga tayyorman. Nima haqida so\'ramoqchisiz?',
      'ru':
          'Привет! Я AI помощник Telefonchi. Готов ответить на ваши вопросы. О чём хотите спросить?',
      'en':
          'Hello! I\'m Telefonchi AI assistant. Ready to answer your questions. What would you like to ask?',
    },
    'ask_question': {
      'uz': 'Savol yozing...',
      'ru': 'Задайте вопрос...',
      'en': 'Ask a question...'
    },

    // ===== Categories =====
    'cat_smartphones': {
      'uz': 'Smartfonlar',
      'ru': 'Смартфоны',
      'en': 'Smartphones'
    },
    'cat_feature_phones': {
      'uz': 'Tugmali telefonlar',
      'ru': 'Кнопочные телефоны',
      'en': 'Feature phones'
    },
    'cat_accessories': {
      'uz': 'Aksessuarlar',
      'ru': 'Аксессуары',
      'en': 'Accessories'
    },
    'cat_tablets': {'uz': 'Planshetlar', 'ru': 'Планшеты', 'en': 'Tablets'},
    'cat_laptops': {'uz': 'Noutbuklar', 'ru': 'Ноутбуки', 'en': 'Laptops'},
    'cat_smartwatches': {
      'uz': 'Aqlli soatlar',
      'ru': 'Умные часы',
      'en': 'Smartwatches'
    },
    'cat_headphones': {
      'uz': 'Quloqchinlar',
      'ru': 'Наушники',
      'en': 'Headphones'
    },

    // ===== Order Statuses =====
    'status_pending': {'uz': 'Kutilmoqda', 'ru': 'В ожидании', 'en': 'Pending'},
    'status_processing': {
      'uz': 'Jarayonda',
      'ru': 'В обработке',
      'en': 'Processing'
    },
    'status_shipped': {'uz': 'Yuborildi', 'ru': 'Отправлен', 'en': 'Shipped'},
    'status_delivered': {
      'uz': 'Yetkazildi',
      'ru': 'Доставлен',
      'en': 'Delivered'
    },
    'status_cancelled': {
      'uz': 'Bekor qilindi',
      'ru': 'Отменён',
      'en': 'Cancelled'
    },

    // ===== Payment Methods =====
    'pay_online': {
      'uz': 'Onlayn to\'lov',
      'ru': 'Онлайн оплата',
      'en': 'Online payment'
    },
    'pay_offline': {
      'uz': 'Qabul qilganda to\'lov',
      'ru': 'Оплата при получении',
      'en': 'Cash on delivery'
    },

    // ===== Delivery Methods =====
    'delivery_pickup': {
      'uz': 'O\'zi olib ketish',
      'ru': 'Самовывоз',
      'en': 'Pickup'
    },
    'delivery_yandex': {
      'uz': 'Yandex Go (shahar ichi)',
      'ru': 'Yandex Go (в пределах города)',
      'en': 'Yandex Go (within city)'
    },
    'delivery_uzum': {
      'uz': 'Uzum Tezkor (shahar ichi)',
      'ru': 'Uzum Tezkor (в пределах города)',
      'en': 'Uzum Tezkor (within city)'
    },
    'delivery_bts': {
      'uz': 'BTS Express (boshqa viloyatlar)',
      'ru': 'BTS Express (другие регионы)',
      'en': 'BTS Express (other regions)'
    },
    'delivery_free': {'uz': 'Bepul', 'ru': 'Бесплатно', 'en': 'Free'},
    'delivery_yandex_desc': {
      'uz': '25 000 so\'m • 1-3 soat • shahar ichi',
      'ru': '25 000 сум • 1-3 часа • в пределах города',
      'en': '25,000 sum • 1-3 hours • within city'
    },
    'delivery_uzum_desc': {
      'uz': '20 000 so\'m • 2-4 soat • shahar ichi',
      'ru': '20 000 сум • 2-4 часа • в пределах города',
      'en': '20,000 sum • 2-4 hours • within city'
    },
    'delivery_bts_desc': {
      'uz': '35 000 so\'m • 1-3 kun • boshqa viloyatlar',
      'ru': '35 000 сум • 1-3 дня • другие регионы',
      'en': '35,000 sum • 1-3 days • other regions'
    },

    // ===== Order Tracking =====
    'order_not_found': {
      'uz': 'Buyurtma topilmadi',
      'ru': 'Заказ не найден',
      'en': 'Order not found'
    },
    'order_num': {'uz': 'Buyurtma', 'ru': 'Заказ', 'en': 'Order'},
    'delivery_status': {
      'uz': 'Yetkazish holati',
      'ru': 'Статус доставки',
      'en': 'Delivery status'
    },
    'delivery_details': {
      'uz': 'Yetkazish ma\'lumoti',
      'ru': 'Информация о доставке',
      'en': 'Delivery details'
    },
    'order_details': {
      'uz': 'Buyurtma tafsilotlari',
      'ru': 'Детали заказа',
      'en': 'Order details'
    },
    'order_date': {
      'uz': 'Buyurtma sanasi',
      'ru': 'Дата заказа',
      'en': 'Order date'
    },
    'payment_type': {
      'uz': 'To\'lov usuli',
      'ru': 'Способ оплаты',
      'en': 'Payment method'
    },
    'items_count': {'uz': 'Mahsulotlar', 'ru': 'Товаров', 'en': 'Items'},
    'delivery_word': {'uz': 'Yetkazish', 'ru': 'Доставка', 'en': 'Delivery'},
    'expected_delivery': {
      'uz': 'Kutilayotgan yetkazish',
      'ru': 'Ожидаемая доставка',
      'en': 'Expected delivery'
    },
    'confirm_delivery': {
      'uz': 'Qabul qilishni tasdiqlash',
      'ru': 'Подтвердить получение',
      'en': 'Confirm delivery'
    },
    'confirm_delivery_q': {
      'uz': 'Qabul qilishni tasdiqlaysizmi?',
      'ru': 'Подтвердить получение?',
      'en': 'Confirm delivery?'
    },
    'confirm_delivery_desc': {
      'uz': 'Buyurtmani sog\'-salomat olganingizni tasdiqlaysizmi?',
      'ru': 'Вы подтверждаете, что получили заказ в целости?',
      'en': 'Do you confirm that you received the order intact?'
    },
    'yes_received': {
      'uz': 'Ha, oldim',
      'ru': 'Да, получил',
      'en': 'Yes, received'
    },
    'delivery_confirmed': {
      'uz': 'Yetkazish tasdiqlandi!',
      'ru': 'Доставка подтверждена!',
      'en': 'Delivery confirmed!'
    },
    'order_cancelled': {
      'uz': 'Buyurtma bekor qilindi',
      'ru': 'Заказ отменён',
      'en': 'Order cancelled'
    },

    // Timeline steps
    'timeline_placed': {
      'uz': 'Buyurtma rasmiylashtirildi',
      'ru': 'Заказ оформлен',
      'en': 'Order placed'
    },
    'timeline_placed_sub': {
      'uz': 'Qayta ishlanishi kutilmoqda',
      'ru': 'Ожидание обработки',
      'en': 'Awaiting processing'
    },
    'timeline_processing': {
      'uz': 'Jarayonda',
      'ru': 'В обработке',
      'en': 'Processing'
    },
    'timeline_processing_sub': {
      'uz': 'Sotuvchi tayyorlamoqda',
      'ru': 'Продавец подготавливает',
      'en': 'Seller is preparing'
    },
    'timeline_shipped': {'uz': 'Yuborildi', 'ru': 'Отправлен', 'en': 'Shipped'},
    'timeline_shipped_sub': {
      'uz': 'Yetkazish xizmatiga topshirildi',
      'ru': 'Передан в службу доставки',
      'en': 'Handed to delivery service'
    },
    'timeline_delivered': {
      'uz': 'Yetkazildi',
      'ru': 'Доставлен',
      'en': 'Delivered'
    },
    'timeline_delivered_sub': {
      'uz': 'Buyurtma qabul qilindi',
      'ru': 'Заказ получен',
      'en': 'Order received'
    },

    // ===== Dashboard / Seller =====
    'items_word': {'uz': 'ta mahsulot', 'ru': 'товар(ов)', 'en': 'item(s)'},

    // ===== Banner =====
    'banner_title': {
      'uz': 'Ishonchli\nTelefonlar',
      'ru': 'Надёжные\nТелефоны',
      'en': 'Trusted\nPhones'
    },
    'banner_subtitle': {
      'uz': 'Telefonchi bilan tez, oson va xavfsiz xarid qiling',
      'ru': 'Покупайте быстро, легко и безопасно с Telefonchi',
      'en': 'Buy fast, easy and safe with Telefonchi'
    },

    // ===== Profile hardcoded =====
    'profile_updated_msg': {
      'uz': 'Profil yangilandi',
      'ru': 'Профиль обновлён',
      'en': 'Profile updated'
    },
  };
}
