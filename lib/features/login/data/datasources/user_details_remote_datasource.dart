import 'package:catchfish/features/login/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

//save/retreive user details from DB
class UserDetailsRemoteDataSource {
  late final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  late SharedPreferences _prefs;

  saveUserToDB(UserEntity userEntity) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String? token;
    String id = "";
    String uid = "";
    try {
      final User? user = auth.currentUser;
      uid = user!.uid;
      final firestoreInstance = FirebaseFirestore.instance;
      _prefs = await SharedPreferences.getInstance();
      //retreive FCM token
      token = await _fcm.getToken() ?? "";

      QuerySnapshot res = await firestoreInstance
          .collection("users")
          .where('email', isEqualTo: userEntity.email)
          .get();
      int playerLevel = res.docs[0]['level'];
      //when Login with a user having already an acoount in Users collection: need to update pref
      _prefs = await SharedPreferences.getInstance();
      _prefs.setInt("playerLevel", playerLevel);

      id = res.docs[0].id;

      await FirebaseFirestore.instance.collection('users').doc(id).update({
        'displayName': userEntity.displayName,
        'email': userEntity.email,
        'photoURL': userEntity.photoURL,
        'phoneNumber': userEntity.phoneNumber,
        'FCMToken': token,
      });
    } catch (e) {
      _prefs = await SharedPreferences.getInstance();
      _prefs.setInt("playerLevel", 1);
      await FirebaseFirestore.instance.collection('users').add({
        'displayName': userEntity.displayName,
        'email': userEntity.email,
        'photoURL': userEntity.photoURL,
        'phoneNumber': userEntity.phoneNumber,
        'FCMToken': token,
        "caughtFish": [],
        "personalCollection": [],
        "inventory": [],
        "lastInventoryUpdateDB": 0,
        "level": 1,
        "prizeValues": {
          'inventoryBaits': 0,
          'inventoryMoney': 0,
          'inventoryXP': 0
        },
        "uid": uid,
      });
      print("eeeeeeeeeeeeeee saveUserToDB()" + e.toString());
    }
  }
}
