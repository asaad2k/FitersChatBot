import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAncvLjlbT6hmiDEwC_e0WrEOfs_ktIifk",
            authDomain: "smartai-b0cb5.firebaseapp.com",
            projectId: "smartai-b0cb5",
            storageBucket: "smartai-b0cb5.appspot.com",
            messagingSenderId: "657776712487",
            appId: "1:657776712487:web:33b228a325b0dbaaa4a702",
            measurementId: "G-81R8Q2Q091"));
  } else {
    await Firebase.initializeApp();
  }
}
