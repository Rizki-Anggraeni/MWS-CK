import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

/// Quick script to test Firebase initialization
Future<void> testFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _log('✅ Firebase initialized successfully!');
    _log('   Project ID: ${Firebase.app().options.projectId}');
    _log('   App ID: ${Firebase.app().options.appId}');
    _log('   Messaging Sender ID: ${Firebase.app().options.messagingSenderId}');
  } catch (e) {
    _log('❌ Firebase initialization failed: $e');
  }
}

void _log(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
