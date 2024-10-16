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
    apiKey: 'AIzaSyBaMUDAm5QxY-Qpt_tOw1O5ZnF94KUtJMU',
    appId: '1:44757863823:web:3c462da984158911974ffa',
    messagingSenderId: '44757863823',
    projectId: 'vavfoods-30f66',
    authDomain: 'vavfoods-30f66.firebaseapp.com',
    storageBucket: 'vavfoods-30f66.appspot.com',
    measurementId: 'G-7CRXQMGZ32',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYy7G1LHXpsdFi-ZgFoLXBFcuK423RQ7E',
    appId: '1:44757863823:android:89adf5a8ed875f43974ffa',
    messagingSenderId: '44757863823',
    projectId: 'vavfoods-30f66',
    storageBucket: 'vavfoods-30f66.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCtx6T0oYUBI3qzqRGjZC5WcXO7aXUHfFs',
    appId: '1:44757863823:ios:a678136002da1e93974ffa',
    messagingSenderId: '44757863823',
    projectId: 'vavfoods-30f66',
    storageBucket: 'vavfoods-30f66.appspot.com',
    iosBundleId: 'com.example.vavFoodsAdminApp',
  );
}
