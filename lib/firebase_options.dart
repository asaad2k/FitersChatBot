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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCrh_KqCJ54WHCN_yJ5mCLKGFHGXm50bOY',
    appId: '1:699465922676:web:3a32bd353d540844af3921',
    messagingSenderId: '699465922676',
    projectId: 'smart-ai-50798',
    authDomain: 'smart-ai-50798.firebaseapp.com',
    storageBucket: 'smart-ai-50798.appspot.com',
    measurementId: 'G-RJEYH2CZHK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAreADlCuulyRkB4VITgJdTLVyP-hJTH78',
    appId: '1:699465922676:android:f5e5a3e821464d16af3921',
    messagingSenderId: '699465922676',
    projectId: 'smart-ai-50798',
    storageBucket: 'smart-ai-50798.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBKUXovTLkNda2mbAkT4ySpfSCOhQCy0Ls',
    appId: '1:699465922676:ios:40fff71790ea1767af3921',
    messagingSenderId: '699465922676',
    projectId: 'smart-ai-50798',
    storageBucket: 'smart-ai-50798.appspot.com',
    iosBundleId: 'com.example.smartgptmain',
  );

}