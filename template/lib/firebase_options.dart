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
    apiKey: 'AIzaSyAhjUwXo7u-b77D56MAITIZgx_yoUEKxrI',
    appId: '1:376681021589:web:5d9ac8b4579580d9275b9c',
    messagingSenderId: '376681021589',
    projectId: 'pond-automation-1',
    authDomain: 'pond-automation-1.firebaseapp.com',
    storageBucket: 'pond-automation-1.appspot.com',
    measurementId: 'G-YM12W5HFLE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXUFgnfxMSnjI6BgWYXJ4C0DW2tPtExFk',
    appId: '1:376681021589:android:b7999f3a990a2af2275b9c',
    messagingSenderId: '376681021589',
    projectId: 'pond-automation-1',
    storageBucket: 'pond-automation-1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCsHgUvVvsM5KNmsy_p2i7HjNEbPBNS-Rc',
    appId: '1:376681021589:ios:ffdc61ddeb02d260275b9c',
    messagingSenderId: '376681021589',
    projectId: 'pond-automation-1',
    storageBucket: 'pond-automation-1.appspot.com',
    iosBundleId: 'com.example.template',
  );
}