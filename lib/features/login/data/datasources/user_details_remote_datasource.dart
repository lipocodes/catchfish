import 'package:catchfish/features/login/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

//save/retreive user details from DB
class UserDetailsRemoteDataSource {
  late final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  late SharedPreferences _prefs;

  saveUserToDB(UserEntity userEntity) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      _prefs = await SharedPreferences.getInstance();
      //retreive FCM token
      String? token = await _fcm.getToken() ?? "";
      print("Token=" + token.toString());
      QuerySnapshot res = await firestoreInstance
          .collection("users")
          .where('email', isEqualTo: userEntity.email)
          .get();

      String id = res.docs[0].id;

      //user already has a document on DB so we need to update the doc
      if (res.docs.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(id).update({
          'displayName': userEntity.displayName,
          'email': userEntity.email,
          'photoURL': userEntity.photoURL,
          'phoneNumber': userEntity.phoneNumber,
          'FCMToken': token,
        });
      } else {
        //need to add a new doc to DB
        await FirebaseFirestore.instance.collection('users').add({
          'displayName': userEntity.displayName,
          'email': userEntity.email,
          'photoURL': userEntity.photoURL,
          'phoneNumber': userEntity.phoneNumber,
          'FCMToken': token,
        });
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeee=" + e.toString());
    }
  }
}
