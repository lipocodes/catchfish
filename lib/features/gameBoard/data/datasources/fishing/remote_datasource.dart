import 'package:catchfish/core/errors/failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class RemoteDatasource {
  // returns all groups that have < 10 players
  Future<Either<Failure, List>> getExistingGroups() async {
    try {
      List listGroups = [];
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("groups").get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        var a = querySnapshot.docs[i];
        List listPlayers = a['players'];
        if (listPlayers.length < 10) {
          listGroups.add(a['groupName']);
        }
      }
      return Right(listGroups);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> updateLevelPlayer(int newLevel) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final User? user = auth.currentUser;
      final uid = user?.uid;
      if (uid == null) {
        return Left(GeneralFailure());
      }
      //what is the doc ID of this user

      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userDoc.docs[0].id)
          .set({
        "level": newLevel,
      }, SetOptions(merge: true));
      return const Right(true);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, int>> getLevelPlayer() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final User? user = auth.currentUser;
      final uid = user?.uid;
      if (uid == null) {
        return Left(GeneralFailure());
      }
      //what is the doc ID of this user

      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();
      int levelPlayer = userDoc.docs[0].data()['level'];
      return Right(levelPlayer);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, List>> getPersonalShop() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final User? user = auth.currentUser;
      final uid = user?.uid;
      if (uid == null) {
        return Left(GeneralFailure());
      }
      //what is the doc ID of this user
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();
      List caughtFish = userDoc.docs[0].data()['caughtFish'];
      return Right(caughtFish);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> addFishPersonalShop(String detailsFish) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      List caughtFish = [];
      final User? user = auth.currentUser;
      final uid = user?.uid;
      if (uid == null) {
        return Left(GeneralFailure());
      }
      //what is the doc ID of this user
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();
      caughtFish = userDoc.docs[0].data()['caughtFish'];
      caughtFish.add(detailsFish);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userDoc.docs[0].id)
          .set({
        "caughtFish": caughtFish,
      }, SetOptions(merge: true));
      return const Right(true);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> removeFishPersonalShop(
      String detailsFish) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      List caughtFish = [];
      final User? user = auth.currentUser;
      final uid = user?.uid;
      if (uid == null) {
        return Left(GeneralFailure());
      }
      //what is the doc ID of this user
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();
      caughtFish = userDoc.docs[0].data()['caughtFish'];
      caughtFish.remove(detailsFish);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userDoc.docs[0].id)
          .set({
        "caughtFish": caughtFish,
      }, SetOptions(merge: true));
      return const Right(true);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
