import 'package:catchfish/features/login/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//save/retreive user details from DB
class UserDetailsRemoteDataSource {
  saveUserToDB(UserEntity userEntity) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;

      QuerySnapshot res = await firestoreInstance
          .collection("users")
          .where('email', isEqualTo: userEntity.email)
          .get();

      //user already has a document on DB so we need to update the doc
      if (res.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(res.docs[0].id)
            .update({
          'displayName': userEntity.displayName,
          'email': userEntity.email,
          'photoURL': userEntity.photoURL,
          'phoneNumber': userEntity.phoneNumber
        });
      } else {
        //need to add a new doc to DB
        await FirebaseFirestore.instance.collection('users').add({
          'displayName': userEntity.displayName,
          'email': userEntity.email,
          'photoURL': userEntity.photoURL,
          'phoneNumber': userEntity.phoneNumber
        });
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeee=" + e.toString());
    }
  }
}
