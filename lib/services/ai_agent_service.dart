import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/product.dart';

class AiAgentService extends ChangeNotifier {
  late GenerativeModel _model;
  ChatSession? _chatSession;
  bool _isInit = false;

  AiAgentService() {
    _init();
  }

  void _init() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint("No GEMINI_API_KEY environment variable. AI won't work.");
      return;
    }

    _model = GenerativeModel(
      model: 'gemini-flash-latest',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.9,
      ),
    );
    _isInit = true;
  }

  /// Buyer chat
  Future<String> sendChatMessage(
      String message, List<Product> availableProducts, String locale) async {
    if (!_isInit)
      return "AI xizmati hozircha ishlamayapti (API Kalit kiritilmagan).";

    if (_chatSession == null) {
      final contextBuf = StringBuffer();
      contextBuf.writeln(
          "Sen O'zbekistondagi 'Telefonchi' onlayn do'konida ishlovchi xaridorlar bo'yicha maslahatchisan.");
      contextBuf.writeln(
          "Foydalanuvchi tilida javob berishing kerak, asosan O'zbek tilida (Lotin yoki Kirill alifbosida). Qisqa, do'stona va yordamchi bo'l. Emoji ishlatsang bo'ladi.");
      contextBuf.writeln(
          "Bizning hozirgi mahsulotlarimiz (ombordagi qoldiq va narxlar shular, ulardan tashqariga chiqma):");

      for (final p in availableProducts) {
        contextBuf.writeln(
          "- ${p.name} (Model: ${p.productModel}, Holati: ${p.condition}, "
          "Narxi: ${p.price} s'om, Ombor: ${p.stock} dona, Sotuvchi: ${p.sellerName}) "
          "- ${p.description}",
        );
      }

      contextBuf.writeln(
          "\nFoydalanuvchi so'rovlariga mos telefonlarni tavsiya qil, yoki ilova orqali qanday xarid qilish mumkinligini tushuntir.");

      _chatSession = _model.startChat(history: [
        Content.text(contextBuf.toString()),
        Content.model([TextPart("Tushundim! Maslahat berishga tayyorman.")])
      ]);
    }

    try {
      final response = await _chatSession!.sendMessage(Content.text(message));
      return response.text ?? "Vaqtinchalik xatolik ro'y berdi.";
    } catch (e) {
      debugPrint('AI Error: $e');
      return "Kechirasiz, men hozir bandman, iltimos keyinroq qayta urining. ($e)";
    }
  }

  /// Seller description generator — kreativ va tovar holatiga qarab yozadi
  Future<String> generateDescription(String title, String category,
      String model, String condition, int year) async {
    if (!_isInit) return "Zo'r sifatdagi $title, arzon narxda sotiladi!";

    try {
      final conditionInfo = condition == 'Янги'
          ? "Bu mahsulot YANGI, hech ishlatilmagan. Qutisi ochilmagan, zavod holatida. Bu jihatni ta'kidla!"
          : condition == 'Ишлатилган'
              ? "Bu mahsulot ISHLATILGAN (bu yomon emas!). Yaxshi qaralgan, ishlashi a'lo. Narxi qulay ekanligi va sifati hali zo'r ekanligini ta'kidla."
              : "Holati haqida ma'lumot yo'q, umumiy yaxshi sifatli deb yoz.";

      final yearInfo = year > 0
          ? "Chiqarilgan yili: $year. ${year >= 2024 ? 'Eng yangi model!' : year >= 2022 ? 'Zamonaviy model.' : 'Ishonchli va sinab ko\'rilgan model.'}"
          : "";

      final prompt = '''
Sen O'zbekistondagi eng yaxshi telefon sotuvchisisan. Professional va jozibali tarzda mahsulot ta'rifi yoz.

MUHIM QOIDALAR:
1. Mahsulot HOLATIGA alohida e'tibor ber:
   $conditionInfo
2. $yearInfo
3. O'zbek tilida (lotin alifbosida) yoz
4. 3-4 qator bo'lsin, emojilar ishlat 📱✨🔥💎
5. Xaridor ishonchi va qiziqishini oshir
6. Narxidan gapirma, faqat sifat va xususiyatlarini maqta
7. "Tez oling!" yoki "Cheklangan miqdorda!" kabi shoshilinch so'zlar qo'sh

Mahsulot ma'lumotlari:
- Nomi: $title
- Kategoriya: $category
- Model: $model
- Holati: $condition
- Yili: $year

Faqat ta'rif matnini qaytar, boshqa hech narsa yozma.
''';
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text?.trim() ??
          "Ajoyib sifatdagi $title — eng yaxshi tanlov! 🔥";
    } catch (e) {
      debugPrint('AI Gen Error: $e');
      // Fallback: holatga qarab oddiy tavsif
      if (condition == 'Янги') {
        return "✨ Yangi $title! Qutisi ochilmagan, zavod holatida. Sifatiga 100% kafolat! Tez oling! 🔥";
      }
      return "📱 $title — yaxshi holatda, ishlashi a'lo darajada! Qulay narxda sifatli qurilma! 💎";
    }
  }
}
