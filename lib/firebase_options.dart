// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyCQccu4tHohWiwg26UL85hGyr8GpaXo4IQ',
    appId: '1:45180262098:web:f434a6673c1d662b3cbf0b',
    messagingSenderId: '45180262098',
    projectId: 'baseapp-ce5ad',
    authDomain: 'baseapp-ce5ad.firebaseapp.com',
    storageBucket: 'baseapp-ce5ad.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkB5HmsqxWwe9oE9ChFKpm6Y1iBT4cOME',
    appId: '1:45180262098:android:c83e1b20278a85eb3cbf0b',
    messagingSenderId: '45180262098',
    projectId: 'baseapp-ce5ad',
    storageBucket: 'baseapp-ce5ad.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBgijMj7gmrzE1XJzs2zcIn09w9CUuv7YQ',
    appId: '1:45180262098:ios:4f3d1fdb4d9bdd8e3cbf0b',
    messagingSenderId: '45180262098',
    projectId: 'baseapp-ce5ad',
    storageBucket: 'baseapp-ce5ad.appspot.com',
    iosBundleId: 'com.example.devapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBgijMj7gmrzE1XJzs2zcIn09w9CUuv7YQ',
    appId: '1:45180262098:ios:4f3d1fdb4d9bdd8e3cbf0b',
    messagingSenderId: '45180262098',
    projectId: 'baseapp-ce5ad',
    storageBucket: 'baseapp-ce5ad.appspot.com',
    iosBundleId: 'com.example.devapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCQccu4tHohWiwg26UL85hGyr8GpaXo4IQ',
    appId: '1:45180262098:web:42ed3527eabc91523cbf0b',
    messagingSenderId: '45180262098',
    projectId: 'baseapp-ce5ad',
    authDomain: 'baseapp-ce5ad.firebaseapp.com',
    storageBucket: 'baseapp-ce5ad.appspot.com',
  );
}
