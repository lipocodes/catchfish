import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/list_group_model.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/new_player_model.dart';
import 'package:catchfish/injection_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RemoteDatasource {
  Future<Either<Failure, bool>> deleteGroup(String groupName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("groups")
          .where('groupName', isEqualTo: groupName)
          .get();
      await FirebaseFirestore.instance
          .collection("groups")
          .doc(querySnapshot.docs[0].id)
          .delete();
      return const Right(true);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  //warning: I haven't has a new player yet
  Future<Either<Failure, bool>> addPlayerToGroup(String groupName) async {
    try {
      //the caller to this function needs to define newPlayerModel
      NewPlayerModel newPlayerModel = sl.get<NewPlayerModel>();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("groups")
          .where('groupName', isEqualTo: groupName)
          .get();

      List listPlayers = querySnapshot.docs[0]['players'];
      listPlayers.add(newPlayerModel);

      FirebaseFirestore.instance
          .collection('groups')
          .doc(querySnapshot.docs[0].id)
          .update({"players": FieldValue.arrayUnion(listPlayers)});
      return const Right(true);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, List>> getPlayersForSelectedGroup(
      String selectedGroupName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("groups")
          .where('groupName', isEqualTo: selectedGroupName)
          .get();
      return Right(querySnapshot.docs[0]['players']);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  // returns all group names that have < 10 players
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
        return const Right(true);
      }

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
        return const Right(1);
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
        return const Right([]);
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
        return const Right(true);
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
        return const Right(true);
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

  Future<Either<Failure, ListGroupModel>> retreiveListGroups() async {
    List<String> listGroups = [];
    try {
      final groupsDB =
          await FirebaseFirestore.instance.collection("groups").get();
      List<QueryDocumentSnapshot> docs = groupsDB.docs;

      for (int a = 0; a < docs.length; a++) {
        listGroups.add(docs[a]['groupName']);
      }
      ListGroupModel listGroupModel = ListGroupModel(list: listGroups);
      return Right(listGroupModel);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> addUserToGroup(
      String groupName, String yourName) async {
    try {
      final groupsDB =
          await FirebaseFirestore.instance.collection("groups").get();
      List<QueryDocumentSnapshot> docs = groupsDB.docs;
      for (int a = 0; a < docs.length; a++) {
        String gName = docs[a]['groupName'];
        if (gName == groupName) {
          List listPlayers = docs[a]['players'];
          NewPlayerModel newPlayerModel =
              NewPlayerModel(playerName: yourName, image: "", caughtFish: []);
          Map map = newPlayerModel.toJson();
          listPlayers.add(map);
          await FirebaseFirestore.instance
              .collection("groups")
              .doc(docs[a].id)
              .set({
            "players": listPlayers,
          }, SetOptions(merge: true));
          //we run it because we have found the right group & added user to it.
          return const Right(true);
        }
      }
      //we get here if no existing group was the right one
      return Left(GeneralFailure());
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> createNewGroup(
      String groupName, String yourName) async {
    try {
      var newGroup = {'groupName': groupName, 'players': []};
      await FirebaseFirestore.instance.collection("groups").add(newGroup);
      addUserToGroup(groupName, yourName);
      return const Right(true);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
