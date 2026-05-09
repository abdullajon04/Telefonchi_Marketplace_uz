# Руководство по установке Flutter и запуску приложения

## 1. Установка Flutter SDK

### Шаг 1: Скачать Flutter SDK
1. Перейдите на [flutter.dev/docs/get-started/install/windows](https://flutter.dev/docs/get-started/install/windows)
2. Скачайте последний стабильный релиз Flutter SDK (zip-файл)
3. Распакуйте в папку, например: `C:\flutter`

> ⚠️ **Важно**: Не устанавливайте Flutter в папку, требующую права администратора (например, `C:\Program Files`)

### Шаг 2: Добавить Flutter в PATH
1. Откройте **Поиск Windows** → «Изменение системных переменных среды»
2. Нажмите **Переменные среды**
3. В разделе **Системные переменных** найдите `Path` → **Изменить**
4. Нажмите **Создать** и добавьте путь: `C:\flutter\bin`
5. Нажмите **ОК** во всех окнах
6. Перезапустите терминал

### Шаг 3: Проверить установку
```bash
flutter --version
flutter doctor
```

## 2. Установка Android SDK

### Вариант A: Через Android Studio (рекомендуется)
1. Скачайте [Android Studio](https://developer.android.com/studio)
2. Установите Android Studio
3. При первом запуске установите:
   - Android SDK
   - Android SDK Command-line Tools
   - Android SDK Build-Tools
   - Android Emulator
4. Создайте эмулятор: **Tools → Device Manager → Create Device**

### Вариант B: Только командная строка
```bash
# Скачайте command-line tools с developer.android.com
# Установите SDK:
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

### Настройка переменных среды Android
```
ANDROID_HOME = C:\Users\<user>\AppData\Local\Android\Sdk
PATH += %ANDROID_HOME%\platform-tools
PATH += %ANDROID_HOME%\emulator
```

## 3. Принять лицензии Android
```bash
flutter doctor --android-licenses
```
Нажмите `y` для всех лицензий.

## 4. Проверить настройку
```bash
flutter doctor
```
Все пункты должны быть отмечены ✓

## 5. Запуск приложения Mobile Market

### Шаг 1: Перейти в папку проекта
```bash
cd c:\Users\A\Downloads\mobil_pr
```

### Шаг 2: Установить зависимости
```bash
flutter pub get
```

### Шаг 3: Проверить код
```bash
flutter analyze
```

### Шаг 4: Запустить на эмуляторе
```bash
# Список доступных устройств
flutter devices

# Запуск на эмуляторе или подключённом телефоне
flutter run
```

### Шаг 5: Сборка APK
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```
APK файл будет в: `build/app/outputs/flutter-apk/app-release.apk`

## 6. Запуск на реальном устройстве

1. Включите **Режим разработчика** на телефоне:
   - Настройки → О телефоне → 7 раз нажмите «Номер сборки»
2. Включите **Отладка по USB**:
   - Настройки → Для разработчиков → Отладка по USB
3. Подключите телефон к компьютеру через USB
4. Разрешите отладку на телефоне
5. Запустите: `flutter run`

## 7. Демо-данные для входа

| Роль | Email | Пароль |
|------|-------|--------|
| Покупатель | bobur@mail.uz | 123456 |
| Продавец | alisher@market.uz | 123456 |
| Продавец | techstore@market.uz | 123456 |
