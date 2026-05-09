# Техническая спецификация: Mobile Market

## 1. Общая информация

| Параметр | Значение |
|----------|----------|
| Название | Mobile Market |
| Платформа | Android |
| Фреймворк | Flutter (Dart) |
| Архитектура | Provider + Service Layer |
| Мин. версия Android | API 21 (Android 5.0) |
| Целевая версия | API 34 (Android 14) |

## 2. Технический стек

### Фронтенд
- **Flutter SDK** — кроссплатформенный UI фреймворк
- **Dart** — язык программирования
- **Provider** — управление состоянием (State Management)
- **Google Fonts** — шрифт Inter
- **intl** — форматирование чисел и дат

### Хранение данных (демо-версия)
- In-memory хранилище (модели Dart)
- Готово к миграции на Firebase / REST API

### Потенциальный бэкенд (для продакшена)
- Firebase Authentication + Firestore
- или Python (FastAPI/Django) + PostgreSQL
- Firebase Storage для изображений

## 3. Архитектура приложения

```
lib/
├── main.dart                # Точка входа
├── routes.dart              # Маршрутизация
├── theme/
│   └── app_theme.dart       # Тема и стили
├── models/
│   ├── user.dart            # Модель пользователя
│   ├── product.dart         # Модель товара
│   ├── category.dart        # Категории товаров
│   ├── cart_item.dart       # Элемент корзины
│   └── order.dart           # Модель заказа
├── services/
│   ├── auth_service.dart    # Сервис авторизации
│   ├── product_service.dart # Сервис товаров
│   ├── cart_service.dart    # Сервис корзины
│   └── order_service.dart   # Сервис заказов
├── widgets/
│   ├── gradient_scaffold.dart   # Фоновый градиент
│   ├── product_card.dart        # Карточка товара
│   ├── stat_card.dart           # Карточка статистики
│   ├── custom_text_field.dart   # Текстовое поле
│   └── category_chip.dart       # Фильтр категории
└── screens/
    ├── auth/
    │   ├── splash_screen.dart           # Экран загрузки
    │   ├── role_selection_screen.dart    # Выбор роли
    │   ├── register_screen.dart         # Регистрация
    │   └── login_screen.dart            # Вход
    ├── buyer/
    │   ├── buyer_main_screen.dart        # Главный экран покупателя
    │   ├── buyer_home_screen.dart        # Домашняя страница
    │   ├── product_list_screen.dart      # Список товаров
    │   ├── product_detail_screen.dart    # Подробности товара
    │   ├── cart_screen.dart              # Корзина
    │   ├── checkout_screen.dart          # Оформление заказа
    │   └── buyer_orders_screen.dart      # Заказы покупателя
    ├── seller/
    │   ├── seller_main_screen.dart           # Главный экран продавца
    │   ├── seller_dashboard_screen.dart      # Панель управления
    │   ├── seller_products_screen.dart       # Товары продавца
    │   ├── add_edit_product_screen.dart      # Добавить/редактировать
    │   └── seller_orders_screen.dart         # Заказы продавца
    └── profile_screen.dart                   # Профиль
```

## 4. Модели данных

### User (Пользователь)
| Поле | Тип | Описание |
|------|-----|----------|
| id | String | Уникальный идентификатор |
| name | String | Имя / название магазина |
| email | String | Электронная почта |
| phone | String | Номер телефона |
| password | String | Пароль (хеш в продакшене) |
| address | String | Адрес |
| role | UserRole | Роль: seller / buyer |

### Product (Товар)
| Поле | Тип | Описание |
|------|-----|----------|
| id | String | Уникальный идентификатор |
| sellerId | String | ID продавца |
| sellerName | String | Имя продавца |
| name | String | Название товара |
| description | String | Описание |
| price | double | Цена (сум) |
| category | ProductCategory | Категория |
| imagePath | String | Путь к изображению |
| createdAt | DateTime | Дата создания |

### Order (Заказ)
| Поле | Тип | Описание |
|------|-----|----------|
| id | String | Уникальный идентификатор |
| buyerId | String | ID покупателя |
| buyerName | String | Имя покупателя |
| buyerAddress | String | Адрес доставки |
| buyerPhone | String | Телефон покупателя |
| items | List\<CartItem\> | Список товаров |
| totalAmount | double | Общая сумма |
| status | OrderStatus | Статус заказа |
| paymentMethod | PaymentMethod | Способ оплаты |
| createdAt | DateTime | Дата создания |

## 5. Экраны приложения

### Экраны авторизации
1. **Splash Screen** — анимированный экран загрузки с логотипом
2. **Role Selection** — выбор роли (Продавец/Покупатель)
3. **Register** — форма регистрации с валидацией
4. **Login** — вход с демо-данными

### Экраны покупателя (5 вкладок)
1. **Главная** — категории, популярные товары
2. **Поиск** — поиск и фильтрация по категории/цене
3. **Корзина** — управление корзиной
4. **Заказы** — история заказов
5. **Профиль** — личные данные, выход

### Экраны продавца (4 вкладки)
1. **Панель** — статистика (товары, заказы, продажи, выручка)
2. **Товары** — список товаров с редактирование/удалением
3. **Заказы** — управление заказами, изменение статуса
4. **Профиль** — данные магазина, выход

## 6. Безопасность
- Валидация форм на клиенте
- Проверка email на уникальность
- Минимальная длина пароля: 6 символов
- Раздельные интерфейсы для ролей
