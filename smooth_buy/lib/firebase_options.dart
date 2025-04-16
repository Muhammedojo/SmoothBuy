// firebase_options.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _firebaseAndroid;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _firebaseIOS;
    }
    throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform');
  }

  static const FirebaseOptions _firebaseAndroid = FirebaseOptions(
    apiKey: 'AIzaSyAWIMQh5LKYdb1veA4t4B5alPW-5vHsGaA',
    appId: '1:607575888417:android:a0bd683e3b6969ff638960',
    messagingSenderId: '607575888417',
    projectId: 'cool-fee-management',
   // databaseURL: 'YOUR_DATABASE_URL',
    storageBucket: 'cool-fee-management.firebasestorage.app',
   // androidClientId: 'YOUR_ANDROID_CLIENT_ID',
  );

  static const FirebaseOptions _firebaseIOS = FirebaseOptions(
    apiKey: 'AIzaSyDYeHgR4_fErU3mVVP8veUDJlmQ0EZFAKM',
    appId: '1:607575888417:ios:8566f264710edb51638960',
    messagingSenderId: '607575888417',
    projectId: 'cool-fee-management',
   // databaseURL: 'YOUR_DATABASE_URL',
    storageBucket: 'cool-fee-management.firebasestorage.app',
   // iosClientId: 'YOUR_IOS_CLIENT_ID',
   // androidClientId: 'YOUR_ANDROID_CLIENT_ID',
  );
}
