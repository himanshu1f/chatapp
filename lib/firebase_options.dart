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
    apiKey: 'AIzaSyDUsA0GzNipMMfNV7XlsT03ZP8lxv82U3c',
    appId: '1:847114241927:web:2daca1c6a0ac5c0a89b522',
    messagingSenderId: '847114241927',
    projectId: 'chat-app-bb519',
    authDomain: 'chat-app-bb519.firebaseapp.com',
    storageBucket: 'chat-app-bb519.appspot.com',
    measurementId: 'G-SWWR2E1J5X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBbLzfKS30iYu5Er4heZg7-LC5u9cEJutA',
    appId: '1:847114241927:android:39e26770eaa119f089b522',
    messagingSenderId: '847114241927',
    projectId: 'chat-app-bb519',
    storageBucket: 'chat-app-bb519.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjMtZN0pvZrQgSexrYlT8ZwtLleG01CGA',
    appId: '1:847114241927:ios:1ad2c955a83edf3289b522',
    messagingSenderId: '847114241927',
    projectId: 'chat-app-bb519',
    storageBucket: 'chat-app-bb519.appspot.com',
    androidClientId: '847114241927-djgn1rancd56qsnq8upegbbusbr8onk7.apps.googleusercontent.com',
    iosClientId: '847114241927-5oenj7jn06iqc74cobst65g77v8s1vqj.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBjMtZN0pvZrQgSexrYlT8ZwtLleG01CGA',
    appId: '1:847114241927:ios:1ad2c955a83edf3289b522',
    messagingSenderId: '847114241927',
    projectId: 'chat-app-bb519',
    storageBucket: 'chat-app-bb519.appspot.com',
    androidClientId: '847114241927-djgn1rancd56qsnq8upegbbusbr8onk7.apps.googleusercontent.com',
    iosClientId: '847114241927-5oenj7jn06iqc74cobst65g77v8s1vqj.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatapp',
  );
}
