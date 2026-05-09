import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/category.dart';

class SeedData {
  static Future<void> seedAllProducts() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final batch = firestore.batch();
    final productsCollection = firestore.collection('products');
    final usersCollection = firestore.collection('users');

    // 1. Create Seller Accounts
    final List<Map<String, String>> sellers = [
      {
        'email': 'ego@market.uz',
        'password': 'ego12345',
        'name': 'Ego Store (Farg\'ona)',
        'phone': '+998901112233',
        'address': 'Farg\'ona sh., Ego Store',
        'role': 'seller',
      },
      {
        'email': 'smartlife@market.uz',
        'password': 'smart12345',
        'name': 'Smartlife (Farg\'ona)',
        'phone': '+998904445566',
        'address': 'Farg\'ona sh., Smartlife',
        'role': 'seller',
      }
    ];

    Map<String, String> sellerEmailToUid = {};

    for (var s in sellers) {
      try {
        UserCredential credential;
        try {
          credential = await auth.createUserWithEmailAndPassword(
            email: s['email']!,
            password: s['password']!,
          );
          print('Seed: Created auth account for ${s['email']}');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            print('Seed: Account ${s['email']} already exists. Logging in to get UID...');
            credential = await auth.signInWithEmailAndPassword(
              email: s['email']!,
              password: s['password']!,
            );
          } else {
            rethrow;
          }
        }

        final uid = credential.user!.uid;
        sellerEmailToUid[s['email']!] = uid;
        
        await usersCollection.doc(uid).set({
          'name': s['name'],
          'email': s['email'],
          'phone': s['phone'],
          'address': s['address'],
          'role': s['role'],
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Seed Error for ${s['email']}: $e');
      }
    }

    // Sign out after creating/getting UIDs so user can log in manually
    await auth.signOut();

    // 2. Prepare Products with real UIDs if possible
    final String egoUid = sellerEmailToUid['ego@market.uz'] ?? 'ego_store_fergana';
    final String slUid = sellerEmailToUid['smartlife@market.uz'] ?? 'smartlife_store_fergana';

    final List<Map<String, dynamic>> allProducts = [
      // Ego Products
      {
        "id": "ego_8947",
        "sellerId": egoUid,
        "sellerName": "Ego Store (Farg'ona)",
        "name": "iPhone 17",
        "description": "Xotira: 256GB. AKB: 100% (52 Sikl). Rangi: Mist Blue. Karobka: Bor. IMEI: Ro'yxatdan o'tgan.",
        "price": 880.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 17",
        "condition": "A'lo",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "ego_QPWN279",
        "sellerId": egoUid,
        "sellerName": "Ego Store (Farg'ona)",
        "name": "MacBook Neo",
        "description": "Chip: Apple A18 Pro. Xotira: 8/256 GB. Ekran: 13\". AKB: 100%. Rangi: Blush. Karobka: Bor. Ruscha klaviatura.",
        "price": 670.0,
        "category": "laptops",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "MacBook Neo",
        "condition": "Yangi",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "ego_1458",
        "sellerId": egoUid,
        "sellerName": "Ego Store (Farg'ona)",
        "name": "iPhone Air",
        "description": "Xotira: 256GB. AKB: 100% (3 Sikl). Rangi: Black Titanium. Karobka: Bor. IMEI: Ro'yxatdan o'tgan.",
        "price": 990.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone Air",
        "condition": "Yangi kabi",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "ego_5482",
        "sellerId": egoUid,
        "sellerName": "Ego Store (Farg'ona)",
        "name": "iPhone 16e",
        "description": "Xotira: 128GB. AKB: 100%. Rangi: Black. Karobka: Bor. IMEI: Ro'yxatdan o'tgan.",
        "price": 520.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 16e",
        "condition": "A'lo",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "ego_9949",
        "sellerId": egoUid,
        "sellerName": "Ego Store (Farg'ona)",
        "name": "iPhone 13 Pro",
        "description": "Xotira: 256GB. AKB: 71%. Rangi: Sierra Blue. Karobka: Bor. IMEI: Ro'yxatdan o'tgan.",
        "price": 450.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 13 Pro",
        "condition": "Yaxshi",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "ego_GQHV2R",
        "sellerId": egoUid,
        "sellerName": "Ego Store (Farg'ona)",
        "name": "MacBook Pro 13.3\"",
        "description": "Chip: Intel Core i5 (2017). Xotira: 16/512GB. Ekran: 13.3\". AKB: 436 Sikl. Rangi: Space Grey. Karobka: Yo'q.",
        "price": 350.0,
        "category": "laptops",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "MacBook Pro 2017",
        "condition": "Yaxshi",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "ego_SZQ6LC",
        "sellerId": egoUid,
        "sellerName": "Ego Store (Farg'ona)",
        "name": "MacBook Air M1",
        "description": "Chip: Apple M1. Xotira: 8/256 GB. Ekran: 13\". AKB: 97% (29 Sikl). Rangi: Gold. Karobka: Yo'q.",
        "price": 470.0,
        "category": "laptops",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "MacBook Air M1",
        "condition": "A'lo",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "ego_0813",
        "sellerId": egoUid,
        "sellerName": "Ego Store (Farg'ona)",
        "name": "iPhone 16 Pro Max",
        "description": "Xotira: 256GB. AKB: 90%. Rangi: Desert Titanium. Karobka: Yo'q. IMEI: Ro'yxatdan o'tgan.",
        "price": 890.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 16 Pro Max",
        "condition": "A'lo",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "ego_0138",
        "sellerId": egoUid,
        "sellerName": "Ego Store (Farg'ona)",
        "name": "iPhone 15 Pro Max",
        "description": "Xotira: 256GB. AKB: 88%. Rangi: Black Titanium. Karobka: Bor. IMEI: Ro'yxatdan o'tgan.",
        "price": 770.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 15 Pro Max",
        "condition": "Yaxshi",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "ego_4974",
        "sellerId": egoUid,
        "sellerName": "Ego Store (Farg'ona)",
        "name": "iPhone 16 Pro Max 1TB",
        "description": "Xotira: 1TB. AKB: 91%. Rangi: Natural Titanium. Karobka: Bor. IMEI: Ro'yxatdan o'tgan.",
        "price": 1090.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 16 Pro Max",
        "condition": "A'lo",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      // Smartlife Products
      {
        "id": "sl_13pro_128",
        "sellerId": slUid,
        "sellerName": "Smartlife (Farg'ona)",
        "name": "iPhone 13 Pro",
        "description": "Xotira: 128GB. Batareya: 87%. Servis: 13 oy. Sug'urta: 10 mln so'm. Trade-in: Bor.",
        "price": 490.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 13 Pro",
        "condition": "Yaxshi",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "sl_14max_512",
        "sellerId": slUid,
        "sellerName": "Smartlife (Farg'ona)",
        "name": "iPhone 14 Pro Max",
        "description": "Xotira: 512GB. Batareya: 74%. Servis: 13 oy. Sug'urta: 10 mln so'm. Trade-in: Bor.",
        "price": 599.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 14 Pro Max",
        "condition": "Yaxshi",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "sl_16max_256",
        "sellerId": slUid,
        "sellerName": "Smartlife (Farg'ona)",
        "name": "iPhone 16 Pro Max",
        "description": "Xotira: 256GB. Batareya: 96%. Servis: 13 oy. Sug'urta: 10 mln so'm. Trade-in: Bor.",
        "price": 1010.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 16 Pro Max",
        "condition": "A'lo",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "sl_17max_256_blue",
        "sellerId": slUid,
        "sellerName": "Smartlife (Farg'ona)",
        "name": "iPhone 17 Pro Max Blue",
        "description": "Xotira: 256GB. Batareya: 100% (151 sikl). Servis: 13 oy. Sug'urta: 10 mln so'm. Trade-in: Bor.",
        "price": 1390.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 17 Pro Max",
        "condition": "Yangi kabi",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "sl_16pro_128",
        "sellerId": slUid,
        "sellerName": "Smartlife (Farg'ona)",
        "name": "iPhone 16 Pro",
        "description": "Xotira: 128GB. Batareya: 92%. Servis: 13 oy. Sug'urta: 10 mln so'm. Trade-in: Bor.",
        "price": 880.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 16 Pro",
        "condition": "A'lo",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "sl_17max_256",
        "sellerId": slUid,
        "sellerName": "Smartlife (Farg'ona)",
        "name": "iPhone 17 Pro Max",
        "description": "Xotira: 256GB. Batareya: 100% (104 sikl). Servis: 13 oy. Sug'urta: 10 mln so'm. Trade-in: Bor.",
        "price": 1420.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 17 Pro Max",
        "condition": "Yangi kabi",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "sl_11_64",
        "sellerId": slUid,
        "sellerName": "Smartlife (Farg'ona)",
        "name": "iPhone 11",
        "description": "Xotira: 64GB. Batareya: 84%. Servis: 13 oy. Sug'urta: 10 mln so'm. Trade-in: Bor.",
        "price": 199.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 11",
        "condition": "Yaxshi",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "sl_14max_128",
        "sellerId": slUid,
        "sellerName": "Smartlife (Farg'ona)",
        "name": "iPhone 14 Pro Max 128",
        "description": "Xotira: 128GB. Batareya: 79%. Servis: 13 oy. Sug'urta: 10 mln so'm. Trade-in: Bor.",
        "price": 549.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 14 Pro Max",
        "condition": "Yaxshi",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "sl_12promax_128",
        "sellerId": slUid,
        "sellerName": "Smartlife (Farg'ona)",
        "name": "iPhone 12 Pro Max",
        "description": "Xotira: 128GB. Batareya: 80%. Servis: 13 oy. Sug'urta: 10 mln so'm. Trade-in: Bor.",
        "price": 390.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 12 Pro Max",
        "condition": "Yaxshi",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "sl_17max_256_final",
        "sellerId": slUid,
        "sellerName": "Smartlife (Farg'ona)",
        "name": "iPhone 17 Pro Max 256",
        "description": "Xotira: 256GB. Batareya: 100% (147 sikl). Servis: 13 oy. Sug'urta: 10 mln so'm. Trade-in: Bor.",
        "price": 1380.0,
        "category": "smartphones",
        "imageUrl": "",
        "imageBase64": "",
        "stock": 1,
        "productModel": "iPhone 17 Pro Max",
        "condition": "Yangi kabi",
        "location": "Farg'ona",
        "createdAt": FieldValue.serverTimestamp(),
      }
    ];

    for (var p in allProducts) {
      final docRef = productsCollection.doc(p['id']);
      final doc = await docRef.get();
      if (!doc.exists) {
        batch.set(docRef, p);
      } else {
        print('Seed: Product ${p['id']} already exists, skipping to preserve data.');
      }
    }

    await batch.commit();
    print('Seed: Added ${allProducts.length} products with correct seller UIDs');
  }
}
