# Kamchiliklarni Tuzatish Rejasi

Siz ilovadan sinab ko'rganingizda 4 ta asosiy kamchilik chiqqanini aytdingiz. Men barchasining ildizini aniqladim va quyida ularni qanday mukammallashtirish bo'yicha rejani tuzdim:

## Yechiladigan 4 ta vazifa

### 1️⃣ Dizayn va Razmerlar (Order panel & Mahsulotlar)
- **Kuzatuv paneli dizayni:** Zakazning detallari ёзилган `order_tracking_screen.dart` sahifasida ranglar **faqat qora tema uchun qotirib qo'yilgan** (`AppTheme.textPrimary`). Shuning uchun Oq fonda u oqik-kulrang bo'lib umuman ko'rinmayapti. Buni telefonning hozirgi yorug'/qorong'i (Light/Dark) rejimiga moslashadigan qilib o'zgartiraman (`colorScheme.onSurface`).
- **Mahsulot kartochkasi:** Dastlabki ekrandagi mahsulot kartochkalari orasidagi masofa va "Savatga qo'shish" knopkasi ekrandan chiqib ketyapti. Buning sababi — Ommabop mahsulotlar spiskasi (`ListView` va `GridView`) ning `childAspectRatio` (tomonlar nisbati) qiymati hamma telefon uchun to'g'ri hisoblanmagan. Kartochka dizaynini biroz ihchamlashtiramiz.

### 2️⃣ Ilovadan o'z-o'zidan chiqib ketish xatosi (Splash Screen)
- **Sababi:** Ilovani qayta ochganingizda aylanma logotipi bor `splash_screen.dart` sahifasi ishga tushadi. U "Foydalanuvchi profilni to'liq yuklamasida"n oldin darhol auth statusini tekshirib qo'yyapti. Kutish jarayoni buzilgan. Natijada ilova sizni "Akauntdan chiqib ketdi" deb o'ylab, avtorizatsiyaga qaytarib yuboryapti.
- **Yechim:** `AuthService` ning to'liq ishga tushishini (interneti va keshni tekshirishini) kutadigan aniq `await` funksiyasini yozaman. Shunda profilingiz butun umr saqlanadi.

### 3️⃣ Google Avtorizatsiya ishlamsligi (INVALID_APP_ID)
- **Sababi:** Dasturimizning bazasi (Firebase) Android ilovasi uchun sozlanmagan (`google-services.json` yo'q), lekin ilovada Google tugmasi turibdi. Tizim paket nomimizni (`com.example.mobile_marketplace`) internet bazasidan topa olmagani uchun xato beryapti.
- **Yechim:** Google orqali kirish tugmasini faqat Web va maxsus sozlangan Android doirasida ishlaydigan qilish kerak yoxud bu tugmani hozircha o'chirib, o'rnini yopamiz. Baribir odamlar elektron pochta + parol / SMS orqali muammosiz kira oladilar. Dasturiy tarafdan Google loginni xavfsizlashtiraman.

### 4️⃣ AI Agent ishlamasligi 
- **Sababi:** Ilova yurganda u "Sun'iy intellekt API parolini" `.env` degan maxfiy fayldan qidiradi. Lekin `main.dart` ichida fayl manzili `env/app_env` deb yozilgan, asli u `assets/env/app_env` papkasida turibdi! Bir dona so'z tushib qolgani uchun AI tizimi kalitni topolmay havoga aylanib yotibdi.
- **Yechim:** Bu yo'lni to'g'rilab muammoni joyida uzamiz.

## Open Questions

> [!WARNING]
> Google login tugmasi o'rniga faqat pochta/parol orqali kirish kifoya qiladimi (hozircha shuni vaqtinchalik o'chirib qo'yaqolaymi, chunki play market ga chiqquncha uni ulash murakkab)? Qolgan dizayn va AI xatosini tasdiqlasangiz, yechimga o'taman! Veb va dizaynning hamma detallari to'liq hal etiladi.
