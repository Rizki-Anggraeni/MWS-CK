// File generated manually from Firebase Console SDK config
// Project: mws-tubes
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCUm1RbpecOz75UgDjFh64eUTOfwu-6pY8',
    appId: '1:564547243693:web:c64f01cbad192022db8024',
    messagingSenderId: '564547243693',
    projectId: 'mws-tubes',
    authDomain: 'mws-tubes.firebaseapp.com',
    storageBucket: 'mws-tubes.firebasestorage.app',
    measurementId: 'G-E0SV502CW0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUm1RbpecOz75UgDjFh64eUTOfwu-6pY8',
    appId: '1:564547243693:android:a0d9c8b018777e3edb8024',
    messagingSenderId: '564547243693',
    projectId: 'mws-tubes',
    storageBucket: 'mws-tubes.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUm1RbpecOz75UgDjFh64eUTOfwu-6pY8',
    appId: '1:564547243693:ios:a5eedbf688a42f7fdb8024',
    messagingSenderId: '564547243693',
    projectId: 'mws-tubes',
    storageBucket: 'mws-tubes.firebasestorage.app',
    iosBundleId: 'com.example.catatanKeuangan',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCUm1RbpecOz75UgDjFh64eUTOfwu-6pY8',
    appId: '1:564547243693:ios:a5eedbf688a42f7fdb8024',
    messagingSenderId: '564547243693',
    projectId: 'mws-tubes',
    storageBucket: 'mws-tubes.firebasestorage.app',
    iosBundleId: 'com.example.catatanKeuangan',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCUm1RbpecOz75UgDjFh64eUTOfwu-6pY8',
    appId: '1:564547243693:web:c64f01cbad192022db8024',
    messagingSenderId: '564547243693',
    projectId: 'mws-tubes',
    authDomain: 'mws-tubes.firebaseapp.com',
    storageBucket: 'mws-tubes.firebasestorage.app',
    measurementId: 'G-E0SV502CW0',
  );
}
