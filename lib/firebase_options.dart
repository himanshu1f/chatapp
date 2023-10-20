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
    apiKey: 'AIzaSyAGM5n6-l8fGGrVPi3CTqT4ua4zhDavbFw',
    appId: '1:328261895786:web:be6718f159f8847ea02c13',
    messagingSenderId: '328261895786',
    projectId: 'chat-41843',
    authDomain: 'chat-41843.firebaseapp.com',
    storageBucket: 'chat-41843.appspot.com',
    measurementId: 'G-BD778CSTDZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAAHPgI8-SXKFH84GwrWzoo5iLr-x5SSBY',
    appId: '1:328261895786:android:e79d3f4ba0c59fa4a02c13',
    messagingSenderId: '328261895786',
    projectId: 'chat-41843',
    storageBucket: 'chat-41843.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBCkmKDjS8JXGgSRh3LOwZNM4Ae9SMw3TU',
    appId: '1:328261895786:ios:bb236f9abd83f5daa02c13',
    messagingSenderId: '328261895786',
    projectId: 'chat-41843',
    storageBucket: 'chat-41843.appspot.com',
    androidClientId: '328261895786-drs63dc1vpbqe53uipg8fm53qtd5n9uq.apps.googleusercontent.com',
    iosClientId: '328261895786-s4flv5kmj3o6g6i9e4o59rlmp312uomo.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBCkmKDjS8JXGgSRh3LOwZNM4Ae9SMw3TU',
    appId: '1:328261895786:ios:bb236f9abd83f5daa02c13',
    messagingSenderId: '328261895786',
    projectId: 'chat-41843',
    storageBucket: 'chat-41843.appspot.com',
    androidClientId: '328261895786-drs63dc1vpbqe53uipg8fm53qtd5n9uq.apps.googleusercontent.com',
    iosClientId: '328261895786-s4flv5kmj3o6g6i9e4o59rlmp312uomo.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatapp',
  );
}
