// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDzW48kwwZMflbS--FU478KuEDUxPXkxZU',
    appId: '1:458423086246:web:859cd691cf6456aa575867',
    messagingSenderId: '458423086246',
    projectId: 'financialapp-45ce4',
    authDomain: 'financialapp-45ce4.firebaseapp.com',
    storageBucket: 'financialapp-45ce4.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0TkkxD15x6fx_0AuClF5xc64E849I4oY',
    appId: '1:458423086246:android:9bca78772e4cd1bd575867',
    messagingSenderId: '458423086246',
    projectId: 'financialapp-45ce4',
    storageBucket: 'financialapp-45ce4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUFEBwvvmZTepwm8w1ZHLVsG1ce6sAqro',
    appId: '1:458423086246:ios:78301e28a6db9037575867',
    messagingSenderId: '458423086246',
    projectId: 'financialapp-45ce4',
    storageBucket: 'financialapp-45ce4.appspot.com',
    iosBundleId: 'com.example.myBank',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCUFEBwvvmZTepwm8w1ZHLVsG1ce6sAqro',
    appId: '1:458423086246:ios:1eb17cc008668649575867',
    messagingSenderId: '458423086246',
    projectId: 'financialapp-45ce4',
    storageBucket: 'financialapp-45ce4.appspot.com',
    iosBundleId: 'com.example.myBank.RunnerTests',
  );
}
