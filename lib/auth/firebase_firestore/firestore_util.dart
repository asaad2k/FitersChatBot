import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartai/auth/firebase_firestore/thread_model.dart';

import '../firebase_auth/firebase_user_provider.dart';
import 'firestore_constatnts.dart';

class FirebaseUtil {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static AuthUserInfo sessionModel = AuthUserInfo();

  static Future getUserFromUid() async {
    try{
    DocumentSnapshot documentSnapshot = await db
        .collection(FireStoreConstance.userCollection)
        .doc(auth.currentUser!.uid)
        .get();

    if (documentSnapshot.data() != null) {
      Map<String, dynamic>? map =
          documentSnapshot.data() as Map<String, dynamic>?;
      sessionModel = AuthUserInfo.fromJson(map!);
    }}catch(e){}
  }

  static Future insertNewUser({
    required AuthUserInfo userApp,
  }) async {
    try {
      await db
          .collection(FireStoreConstance.userCollection)
          .doc(userApp.uid)
          .set(userApp.toJson());

      sessionModel
        ..uid = userApp.uid
        ..displayName = userApp.displayName
        ..email = userApp.email;
    } catch (e) {
      print(e.toString());
    }
  }

  static Future updateUser(AuthUserInfo userApp) async {
    DocumentReference doc =
        db.collection(FireStoreConstance.userCollection).doc(userApp.uid);

    sessionModel = userApp;

    await doc.set(userApp.toJson());
  }

  static Future<String> resetEmail(String newEmail) async {
    String message='';
    final firebaseUser = auth.currentUser!;
    await firebaseUser
        .updateEmail(newEmail)
        .then(
          (value) => message = 'success',
        )
        .catchError((onError) {
      debugPrint('adel : ${onError.toString()}');
      return message = 'error';
    });
    return message;
  }

  static Future<String> createNewThread(String title) async {
    try {
      DocumentReference doc = db
          .collection(FireStoreConstance.threadCollection)
          .doc(sessionModel.uid)
          .collection(FireStoreConstance.chatsCollection)
          .doc();

      await doc.set({
        'id': doc.id,
        'title': title,
        'chatList': [],
      });
      return doc.id;
    } catch (e) {
      return '';
    }
  }

  static Future deleteThread(String id) async {
    try {
      await db
          .collection(FireStoreConstance.threadCollection)
          .doc(sessionModel.uid)
          .collection(FireStoreConstance.chatsCollection)
          .doc(id)
          .delete();
    } catch (e) {
      print('dddddd$e');
    }
  }

  static Future sendNewMessage(
      {required String id, required ChatModel chatModel}) async {
    try {
      db
          .collection(FireStoreConstance.threadCollection)
          .doc(sessionModel.uid)
          .collection(FireStoreConstance.chatsCollection)
          .doc(id)
          .update({
        'chatList': FieldValue.arrayUnion([
          {
            'message': chatModel.message,
            'isUser': chatModel.isUser,
          }
        ])
      });
    } catch (e) {
      return '';
    }
  }

  static Future<List<ChatModel>> getChatById(String threadId) async {
    DocumentSnapshot documentSnapshot = await db
        .collection(FireStoreConstance.threadCollection)
        .doc(FirebaseUtil.sessionModel.uid)
        .collection(FireStoreConstance.chatsCollection)
        .doc(threadId)
        .get();

    if (documentSnapshot.data() != null) {
      Map<String, dynamic>? map =
          documentSnapshot.data() as Map<String, dynamic>?;
      final ThreadModel threadModel = ThreadModel.fromJson(map!);
      return threadModel.chatList!;
    }
    return [];
  }

  static Future saveUserInPref(String email, String password) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString('email_user', email);
    await pref.setString('password_user', password);
  }

  static Future removeUserData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

     await pref.remove('email_user');
    await pref.remove('password_user');

  }

  static Future signInWithEmail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    String email = pref.getString('email_user')!;
    String password = pref.getString('password_user')!;

    await auth.signInWithEmailAndPassword(email: email, password: password);
  }
}
