import 'dart:math';

import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/list_group_model.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/new_player_model.dart';
import 'package:catchfish/features/lobby/domain/entities/prize_values_entity.dart';
import 'package:catchfish/features/settings/data/models/inventory_model.dart';
import 'package:catchfish/injection_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteDatasource {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
          for (int b = 0; b < listPlayers.length; b++) {
            String name = listPlayers[b]['playerName'];
            if (yourName == name) {
              return const Right(false);
            }
          }
          NewPlayerModel newPlayerModel = NewPlayerModel(
              playerName: yourName,
              image: "",
              caughtFish: [],
              timeLastCaughtFish: 0);
          Map map = newPlayerModel.toJson();
          listPlayers.add(map);
          await FirebaseFirestore.instance
              .collection("groups")
              .doc(docs[a].id)
              .set({
            "players": listPlayers,
          }, SetOptions(merge: true));
          final SharedPreferences prefs = await _prefs;
          prefs.setString("groupName", groupName);
          prefs.setString("yourName", yourName);

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
      var newGroup = {
        'groupName': groupName,
        "gameStarted": false,
        'players': []
      };
      await FirebaseFirestore.instance.collection("groups").add(newGroup);
      addUserToGroup(groupName, yourName);
      return const Right(true);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> updateCaughtFishInGroups(
      String caughtFishDetails) async {
    try {
      final SharedPreferences prefs = await _prefs;
      String groupName = prefs.getString(
            "groupName",
          ) ??
          "";
      String yourName = prefs.getString(
            "yourName",
          ) ??
          "";

      final groupsDB =
          await FirebaseFirestore.instance.collection("groups").get();
      List<QueryDocumentSnapshot> docs = groupsDB.docs;
      for (int a = 0; a < docs.length; a++) {
        String gName = docs[a]['groupName'];
        if (gName == groupName) {
          List listPlayers = docs[a]['players'];
          for (int b = 0; b < listPlayers.length; b++) {
            if (listPlayers[b]['playerName'] == yourName) {
              List listCaughtFish = listPlayers[b]['caughtFish'];
              listCaughtFish.add(caughtFishDetails);
              int timeLastCaughtFish = DateTime.now().millisecondsSinceEpoch;
              NewPlayerModel newPlayerModel = NewPlayerModel(
                  playerName: yourName,
                  image: "",
                  caughtFish: listCaughtFish,
                  timeLastCaughtFish: timeLastCaughtFish);
              Map map = newPlayerModel.toJson();
              listPlayers[b] = map;
              await FirebaseFirestore.instance
                  .collection("groups")
                  .doc(docs[a].id)
                  .set({
                "players": listPlayers,
              }, SetOptions(merge: true));
              return const Right(true);
            }
          }
        }
      }
      return Left(GeneralFailure());
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> addFishPersonalShop(String detailsFish) async {
    //save new fish in the relevant pref
    sl.get<LocalDatasourcePrefs>().addFishPersonalShop(detailsFish);
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

  Future<Either<Failure, List<String>>> getGameResults() async {
    List<String> listAcheivements = [];
    try {
      final SharedPreferences prefs = await _prefs;
      String groupName = prefs.getString(
            "groupName",
          ) ??
          "";
      String yourName = prefs.getString(
            "yourName",
          ) ??
          "";
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("groups")
          .where('groupName', isEqualTo: groupName)
          .get();
      List listPlayers = querySnapshot.docs[0]['players'];
      //going over list of players
      for (int a = 0; a < listPlayers.length; a++) {
        List caughtFish = listPlayers[a]['caughtFish'];
        String playerName = listPlayers[a]['playerName'];
        int caughtFishValue = 0;
        //going over the list of caught fish of this player
        for (int b = 0; b < caughtFish.length; b++) {
          String str = caughtFish[b];
          List list = str.split("^^^");
          caughtFishValue += int.parse(list[1]);
        }
        listAcheivements.add(playerName + "^^^" + caughtFishValue.toString());
      }
      //we need to sort players by their caughtFishValue
      for (int a = 0; a < listAcheivements.length; a++) {
        for (int b = a + 1; b < listAcheivements.length; b++) {
          String str1 = listAcheivements[a];
          List list1 = str1.split("^^^");
          int caughtFishValue1 = int.parse(list1[1]);
          String str2 = listAcheivements[b];
          List list2 = str2.split("^^^");
          int caughtFishValue2 = int.parse(list2[1]);
          if (caughtFishValue1 < caughtFishValue2) {
            String temp = listAcheivements[a];
            listAcheivements[a] = listAcheivements[b];
            listAcheivements[b] = temp;
          }
        }
      }

      //no need to this group anymore because the game is over & we retreived each players acheivements
      if (listPlayers[0]['playerName'] == yourName) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          deleteGroup(groupName);
        });
      }
      return Right(listAcheivements);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, int>> retreiveNumPlayers() async {
    try {
      final SharedPreferences prefs = await _prefs;
      String groupName = prefs.getString(
            "groupName",
          ) ??
          "";
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("groups")
          .where('groupName', isEqualTo: groupName)
          .get();
      List listPlayers = querySnapshot.docs[0]['players'];
      return Right(listPlayers.length);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, bool>> hasGameStarted() async {
    try {
      final SharedPreferences prefs = await _prefs;
      String groupName = prefs.getString(
            "groupName",
          ) ??
          "";
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("groups")
          .where('groupName', isEqualTo: groupName)
          .get();
      return Right(querySnapshot.docs[0]['gameStarted']);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, String>> getGroupLeader() async {
    try {
      final SharedPreferences prefs = await _prefs;
      String groupName = prefs.getString(
            "groupName",
          ) ??
          "";
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("groups")
          .where('groupName', isEqualTo: groupName)
          .get();
      List listPlayers = querySnapshot.docs[0]['players'];

      return Right(listPlayers[0]['playerName']);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, bool>> startGame() async {
    try {
      final SharedPreferences prefs = await _prefs;
      String groupName = prefs.getString(
            "groupName",
          ) ??
          "";
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("groups")
          .where('groupName', isEqualTo: groupName)
          .get();

      FirebaseFirestore.instance
          .collection('groups')
          .doc(querySnapshot.docs[0].id)
          .update({"gameStarted": true});
      return (const Right(true));
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeee");
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, String>> getNamePlayerCaughtFish() async {
    try {
      int timeNow = DateTime.now().millisecondsSinceEpoch;
      final SharedPreferences prefs = await _prefs;
      String groupName = prefs.getString(
            "groupName",
          ) ??
          "";
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("groups")
          .where('groupName', isEqualTo: groupName)
          .get();
      List listPlayers = querySnapshot.docs[0]['players'];
      for (int b = 0; b < listPlayers.length; b++) {
        String name = listPlayers[b]['playerName'];
        int timeLastCaughtFish = listPlayers[b]['timeLastCaughtFish'];
        if (timeNow - timeLastCaughtFish < 1000) {
          return Right(name);
        }
      }
      return const Right("");
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, List>> rejectPriceOffer(int index) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    List listItems = [];
    List caughtFish = [];
    try {
      final User? user = auth.currentUser;
      final uid = user?.uid;
      if (uid == null) {
        return Left(GeneralFailure());
      }
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();
      caughtFish = userDoc.docs[0].data()['caughtFish'];
      String temp = caughtFish[index];
      List<String> list = temp.split("^^^");
      int numRejections = int.parse(list[4]);

      //if user hasn't rejected 3 price offers yet
      if (numRejections < 2) {
        //update number of past offer rejection
        numRejections += 1;
        list[4] = numRejections.toString();
        //randomize a new price offer
        var random = Random();
        int randomInt = random.nextInt(20);

        int oldPriceOffer = int.parse(list[1]);
        int newPriceOffer = (oldPriceOffer * (randomInt * 0.1)).toInt();
        list[1] = newPriceOffer.toString();
        //recreate the String to be saved to DB for this fish
        String newFishDetails = "";
        for (int a = 0; a < list.length; a++) {
          if (a == list.length - 1) {
            newFishDetails += list[a];
          } else {
            newFishDetails += list[a] + "^^^";
          }
        }
        caughtFish[index] = newFishDetails;
        //save new data to DB

        FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.docs[0].id)
            .update({"caughtFish": caughtFish});
        listItems = caughtFish;
      } else {
        caughtFish.removeAt(index);

        FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.docs[0].id)
            .update({"caughtFish": caughtFish});
        listItems = caughtFish;
      }
      return Right(listItems);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, List>> acceptPriceOffer(int index) async {
    List listItems = [];
    List caughtFish = [];
    int inventoryMoney = 0;
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final User? user = auth.currentUser;
      final uid = user?.uid;
      if (uid == null) {
        return Left(GeneralFailure());
      }
      //get content of Private Collection
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();
      //retreive current money value
      caughtFish = userDoc.docs[0].data()['caughtFish'];
      String temp = caughtFish[index];
      List<String> list = temp.split("^^^");
      int priceFish = int.parse(list[1]);
      inventoryMoney = userDoc.docs[0].data()['prizeValues']['inventoryMoney'];
      inventoryMoney += priceFish;
      //update inventoryMoney after selling the fish
      PrizeValuesEntity prizeValuesEntity = PrizeValuesEntity(
          inventoryMoney: inventoryMoney,
          inventoryBaits: userDoc.docs[0].data()['prizeValues']
              ['inventoryBaits'],
          inventoryXP: userDoc.docs[0].data()['prizeValues']['inventoryXP'],
          lastPrizeValuesUpdateDB: userDoc.docs[0].data()['prizeValues']
              ['lastPrizeValuesUpdateDB']);

      //remove the fish that has been sold eight now
      caughtFish.removeAt(index);
      //update the DB about the sold fish
      FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.docs[0].id)
          .update({
        "caughtFish": caughtFish,
        "prizeValues": prizeValuesEntity.toJson()
      });
      listItems = caughtFish;
      return Right(listItems);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
