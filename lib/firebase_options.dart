import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAY2Iz65nNdaZXMr3Lv-0YWRGN9hXSZTZ0',
    appId: '1:556634802335:web:43de3770af7d979feefaaa',
    messagingSenderId: '556634802335',
    projectId: 'mobile-market-221de',
    authDomain: 'mobile-market-221de.firebaseapp.com',
    storageBucket: 'mobile-market-221de.firebasestorage.app',
  );

  // Android and iOS use the same config for now
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAsuSh1uWLbaNUabg59qwIm8lZpOPqPg90',
    appId: '1:556634802335:android:c5d7830a0353083feefaaa',
    messagingSenderId: '556634802335',
    projectId: 'mobile-market-221de',
    storageBucket: 'mobile-market-221de.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAY2Iz65nNdaZXMr3Lv-0YWRGN9hXSZTZ0',
    appId: '1:556634802335:web:43de3770af7d979feefaaa',
    messagingSenderId: '556634802335',
    projectId: 'mobile-market-221de',
    storageBucket: 'mobile-market-221de.firebasestorage.app',
    iosBundleId: 'com.example.mobileMarketplace',
  );
}
