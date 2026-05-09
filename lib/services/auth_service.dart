import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsis;
import '../models/user.dart' as app;

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  app.User? _currentUser;
  final Completer<void> _initCompleter = Completer<void>();

  app.User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isSeller => _currentUser?.role == app.UserRole.seller;
  bool get isBuyer => _currentUser?.role == app.UserRole.buyer;
  bool get isInitCompleted => _initCompleter.isCompleted;
  Future<void> get initializationDone => _initCompleter.future;

  AuthService() {
    _init();
  }

  Future<void> _init() async {
    try {
      // Listen to auth state changes
      _auth.authStateChanges().listen((User? firebaseUser) async {
        if (firebaseUser != null) {
          await _loadUserProfile(firebaseUser.uid);
        } else {
          _currentUser = null;
        }
        notifyListeners();
      });
    } finally {
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    }
  }

  Future<void> _loadUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _currentUser = app.User(
          id: uid,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          phone: data['phone'] ?? '',
          password: '', // password stored in Firebase Auth
          address: data['address'] ?? '',
          role: data['role'] == 'seller'
              ? app.UserRole.seller
              : app.UserRole.buyer,
        );
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
    required app.UserRole role,
  }) async {
    try {
      // Create user in Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // Save user profile in Firestore
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'role': role.name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _currentUser = app.User(
        id: uid,
        name: name,
        email: email,
        phone: phone,
        password: '',
        address: address,
        role: role,
      );

      notifyListeners();
      return null; // success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Пользователь с таким email уже существует';
        case 'weak-password':
          return 'Пароль слишком простой (минимум 6 символов)';
        case 'invalid-email':
          return 'Неверный формат email';
        default:
          return 'Ошибка регистрации: ${e.message}';
      }
    } catch (e) {
      return 'Ошибка: $e';
    }
  }

  Future<String?> login(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Wait a moment for auth state listener to update user profile
      await Future.delayed(const Duration(milliseconds: 500));

      if (_currentUser == null) {
        // Manually load if listener hasn't fired yet
        final user = _auth.currentUser;
        if (user != null) {
          await _loadUserProfile(user.uid);
          notifyListeners();
        }
      }

      return null; // success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Пользователь не найден';
        case 'wrong-password':
          return 'Неверный пароль';
        case 'invalid-email':
          return 'Неверный формат email';
        case 'invalid-credential':
          return 'Неверный email или пароль';
        default:
          return 'Ошибка входа: ${e.message}';
      }
    } catch (e) {
      return 'Ошибка: $e';
    }
  }

  Future<void> _ensureUserProfile(User user, app.UserRole role) async {
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': user.displayName ?? user.email?.split('@').first ?? 'User',
        'email': user.email ?? '',
        'phone': '',
        'address': '',
        'role': role.name,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    await _loadUserProfile(user.uid);
    notifyListeners();
  }

  Future<String?> _signInWithProvider({
    required AuthProvider provider,
    required app.UserRole role,
    required String providerName,
  }) async {
    try {
      UserCredential credential;
      if (kIsWeb) {
        credential = await _auth.signInWithPopup(provider);
      } else {
        credential = await _auth.signInWithProvider(provider);
      }

      final user = credential.user;
      if (user == null) {
        return '$providerName orqali kirishda xatolik yuz berdi';
      }

      await _ensureUserProfile(user, role);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'operation-not-allowed') {
        return '$providerName avtorizatsiyasi Firebase’da yoqilmagan.';
      }
      return '$providerName avtorizatsiyasi xatosi: ${e.message}';
    } catch (e) {
      return '$providerName avtorizatsiyasi xatosi: $e';
    }
  }

  Future<String?> signInWithGoogle({required app.UserRole role}) async {
    try {
      // 6.x versiyada GoogleSignIn() konstruktori ishlatiladi
      final googleSignIn = gsis.GoogleSignIn(
        clientId: kIsWeb
            ? '556634802335-kv5f2qel3jh32ki45a4qh09nj2dkhjn6.apps.googleusercontent.com'
            : null,
      );

      final gsis.GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return 'Google orqali kirish bekor qilindi';

      final gsis.GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) return 'Google orqali kirishda xatolik yuz berdi';

      await _ensureUserProfile(user, role);
      return null;
    } catch (e) {
      debugPrint('Google Auth Error: $e');
      return 'Google avtorizatsiyasi xatosi: $e';
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Пользователь с таким email не найден';
        case 'invalid-email':
          return 'Неверный формат email';
        default:
          return 'Ошибка: ${e.message}';
      }
    } catch (e) {
      return 'Ошибка при сбросе пароля: $e';
    }
  }

  Future<String?> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    if (_currentUser == null) return 'Пользователь не авторизован';

    try {
      final updates = <String, dynamic>{};
      if (name != null && name.isNotEmpty) updates['name'] = name;
      if (phone != null && phone.isNotEmpty) updates['phone'] = phone;
      if (address != null && address.isNotEmpty) updates['address'] = address;

      if (updates.isEmpty) return 'Нет данных для обновления';

      await _firestore
          .collection('users')
          .doc(_currentUser!.id)
          .update(updates);

      _currentUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        phone: phone ?? _currentUser!.phone,
        address: address ?? _currentUser!.address,
      );

      notifyListeners();
      return null; // success
    } catch (e) {
      return 'Ошибка обновления: $e';
    }
  }

  void logout() {
    _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  app.User? getUserById(String id) {
    // For now return current user if IDs match
    if (_currentUser?.id == id) return _currentUser;
    return null;
  }

  // Create demo users in Firebase (run once)
  Future<void> createDemoUsers() async {
    final demoUsers = [
      {
        'email': 'alisher@market.uz',
        'password': '123456',
        'name': 'Алишер Магазин',
        'phone': '+998901234567',
        'address': 'Ташкент, ул. Навои, 15',
        'role': 'seller',
      },
      {
        'email': 'techstore@market.uz',
        'password': '123456',
        'name': 'TechStore UZ',
        'phone': '+998907654321',
        'address': 'Самарканд, ул. Регистан, 8',
        'role': 'seller',
      },
      {
        'email': 'bobur@mail.uz',
        'password': '123456',
        'name': 'Бобур Каримов',
        'phone': '+998911112233',
        'address': 'Ташкент, ул. Амира Темура, 22',
        'role': 'buyer',
      },
    ];

    for (final userData in demoUsers) {
      try {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: userData['email']!,
          password: userData['password']!,
        );
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'name': userData['name'],
          'email': userData['email'],
          'phone': userData['phone'],
          'address': userData['address'],
          'role': userData['role'],
          'createdAt': FieldValue.serverTimestamp(),
        });
        // Sign out after creating each demo user
        await _auth.signOut();
      } catch (e) {
        debugPrint(
            'Demo user ${userData['email']} already exists or error: $e');
      }
    }
  }
}
