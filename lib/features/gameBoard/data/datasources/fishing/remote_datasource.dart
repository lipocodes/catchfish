import 'dart:math';

import 'package:catchfish/core/consts/fish.dart';
import 'package:catchfish/core/consts/general.dart';
import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/list_group_model.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/multipleplayer_entity.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/new_player_model.dart';
import 'package:catchfish/features/lobby/domain/entities/prize_values_entity.dart';
import 'package:catchfish/injection_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/consts/general.dart';

class RemoteDatasource {
  List _allPlayers = [];
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

  Future<Either<Failure, bool>> addPlayerToGroup(String groupName) async {
    try {
      //the caller to this function needs to define newPlayerModel
      NewPlayerModel newPlayerModel = sl.get<NewPlayerModel>();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("groups")
          .where('groupName', isEqualTo: groupName)
          .get();

      List listPlayers = querySnapshot.docs[0]['players'];
      if (listPlayers.length == 10) {
        return Left(GeneralFailure());
      }
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

  Future<Either<Failure, bool>> removePlayerFromGroup(
      String groupName, String playerName) async {
    try {
      //get the specific group we know that the player is in
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("groups")
          .where('groupName', isEqualTo: groupName)
          .get();
      List listPlayers = querySnapshot.docs[0]['players'];
      int numberPlayers = querySnapshot.docs[0]['numberPlayers'];
      //going over players @group
      for (int a = 0; a < listPlayers.length; a++) {
        String name = listPlayers[a]['playerName'];
        if (name == playerName) {
          listPlayers.removeAt(a);
          numberPlayers--;
        }
      }
      //if no players remain in the group: delete it. Else: update it.
      if (numberPlayers > 0) {
        FirebaseFirestore.instance
            .collection('groups')
            .doc(querySnapshot.docs[0].id)
            .update({
          "players": listPlayers,
          "numberPlayers": numberPlayers,
        });
      } else {
        FirebaseFirestore.instance
            .collection('groups')
            .doc(querySnapshot.docs[0].id)
            .delete();
      }

      return const Right(true);
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeee removePlayerFromGroup=" + e.toString());
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

  Future<Either<Failure, List>> getPersonalCollection(String email) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      String? uid = "";
      late QuerySnapshot<Map<String, dynamic>> userDoc;
      //if this is me
      if (email.isEmpty) {
        final User? user = auth.currentUser;
        uid = user?.uid;
        if (uid == null) {
          return const Right([]);
        }
        //what is the doc ID of this user
        userDoc = await FirebaseFirestore.instance
            .collection("users")
            .where("uid", isEqualTo: uid)
            .get();
        bool showPersonalCollection =
            userDoc.docs[0].data()['showPersonalCollection'];
        sl
            .get<LocalDatasourcePrefs>()
            .getPersonalCollection(showPersonalCollection);
      } else {
        //what is the doc ID of this user
        userDoc = await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: email)
            .get();
      }

      List personalCollection = userDoc.docs[0].data()['personalCollection'];

      return Right(personalCollection);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> moveToPersonalCollection(int index) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final User? user = auth.currentUser;
      final uid = user?.uid;
      if (uid == null) {
        return const Right(false);
      }
      //what is the doc ID of this user
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();

      //remove the moved fish from array caughtFish
      List caughtFish = userDoc.docs[0].data()['caughtFish'];
      String fishToBeMoved = caughtFish[index];
      List temp = fishToBeMoved.split("^^^");
      temp[1] = "0";
      fishToBeMoved = temp[0] +
          "^^^" +
          temp[1] +
          "^^^" +
          temp[2] +
          "^^^" +
          temp[3] +
          "^^^" +
          temp[4] +
          "^^^" +
          temp[5] +
          "^^^" +
          "incognito@gmail.com";
      caughtFish.removeAt(index);
      List personalCollection = userDoc.docs[0].data()['personalCollection'];
      personalCollection.add(fishToBeMoved);
      FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.docs[0].id)
          .set({
        "caughtFish": caughtFish,
        "personalCollection": personalCollection
      }, SetOptions(merge: true));

      return const Right(true);
    } catch (e) {
      print("eeeeeeeeeeeeeeeeee  moveToPersonalCollection=" + e.toString());
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> sendPriceOfferCollectionFishEvent(
      String emailBuyer,
      String price,
      String emailSeller,
      int fishIndex,
      RemoteDatasource remoteDatasource) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: emailSeller)
          .get();
      List personalCollection = userDoc.docs[0].data()['personalCollection'];
      String relevantFish = personalCollection[fishIndex];
      List temp = relevantFish.split("^^^");
      //comparing existing porce offer to the incoming proce offer
      String existingPriceOffer = temp[1];
      String emailExistingPriceOffer = temp[6];
      if (int.parse(price) > int.parse(existingPriceOffer)) {
        existingPriceOffer = price;
        emailExistingPriceOffer = emailBuyer;
        relevantFish = temp[0] +
            "^^^" +
            existingPriceOffer +
            "^^^" +
            temp[2] +
            "^^^" +
            temp[3] +
            "^^^" +
            temp[4] +
            "^^^" +
            temp[5] +
            "^^^" +
            emailExistingPriceOffer;
        personalCollection[fishIndex] = relevantFish;
        FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.docs[0].id)
            .set({"personalCollection": personalCollection},
                SetOptions(merge: true));
      }

      return const Right(true);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, List<String>>> searchOtherPlayers(String text) async {
    try {
      List<String> relevantPlayers = [];
      //we retreive it from DB only once
      final userDoc =
          await FirebaseFirestore.instance.collection("users").get();
      for (int a = 0; a < userDoc.docs.length; a++) {
        //if this player doesn't allow others view his Personal Collection
        if (userDoc.docs[a].data()['showPersonalCollection'] == false) {
          continue;
        }
        String displayName = userDoc.docs[a].data()['displayName'];

        if (displayName.contains(text)) {
          relevantPlayers.add(userDoc.docs[a].data()['email'] +
              "^^^" +
              userDoc.docs[a].data()['displayName'] +
              "^^^" +
              userDoc.docs[a].data()['photoURL']);
        }
      }
      return Right(relevantPlayers);
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

  Future<Either<Failure, bool>> addBotToGroup(
    String groupName,
  ) async {
    try {
      final groupsDB =
          await FirebaseFirestore.instance.collection("groups").get();
      List<QueryDocumentSnapshot> docs = groupsDB.docs;
      for (int a = 0; a < docs.length; a++) {
        String gName = docs[a]['groupName'];
        //when we find the relevant group on DB
        if (gName == groupName) {
          List listPlayers = docs[a]['players'];
          int len = 5 - listPlayers.length;
          for (int b = 0; b < len; b++) {
            var random = Random();
            int rand1 = random.nextInt(botNames.length) - 1;
            int rand2 = random.nextInt(fishCategoryC.length) - 1;
            NewPlayerModel newPlayerModel = NewPlayerModel(
                playerName: botNames[rand1],
                image: "",
                caughtFish: [fishCategoryC[rand2]],
                timeLastCaughtFish: 0);
            Map map = newPlayerModel.toJson();
            //if this bot already exists, we need to randomize another one
            if (listPlayers.contains(map)) {
              b++;
              continue;
            }
            listPlayers.add(map);
          }

          //important: we update only players field and not numberPlayers, because it's a bot
          await FirebaseFirestore.instance
              .collection("groups")
              .doc(docs[a].id)
              .set({
            "players": listPlayers,
          }, SetOptions(merge: true));
        }
      }
      return const Right(true);
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeeeeeee remote addBotToGroup=" + e.toString());
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
        int numberPlayers = docs[a]['numberPlayers'];
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
          //if we got to have less than 5 players (inc. bots), we add a new bot
          final SharedPreferences prefs = await _prefs;
          bool isItSoloGame = prefs.getBool("isItSoloGame") ?? false;
          prefs.setString("groupName", groupName);
          prefs.setString("yourName", yourName);
          //no need for bots if it's a Solo Game
          if (listPlayers.length < 5 && isItSoloGame == false) {
            addBotToGroup(
              groupName,
            );
          }
          await FirebaseFirestore.instance
              .collection("groups")
              .doc(docs[a].id)
              .set({
            "players": listPlayers,
            "numberPlayers": ++numberPlayers,
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
      var newGroup = {
        'creationTime': DateTime.now().millisecondsSinceEpoch,
        'groupName': groupName,
        "gameStarted": false,
        'players': [],
        "numberPlayers": 0,
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
      //updating user's level value

      int levelPlayer = userDoc.docs[0].data()['level'];
      //updating user's XP value/ Each level promotion deduces a part of XP
      int inventoryBaits =
          userDoc.docs[0].data()['prizeValues']['inventoryBaits'];
      int inventoryMoney =
          userDoc.docs[0].data()['prizeValues']['inventoryMoney'];
      int inventoryXP = userDoc.docs[0].data()['prizeValues']['inventoryXP'];
      int timeStampNow = DateTime.now().millisecondsSinceEpoch;
      List list = detailsFish.split("^^^");
      int fishPrice = int.parse(list[1]);
      inventoryXP += fishPrice;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (levelPlayer == 1 && inventoryXP >= 1000) {
        prefs.setInt("playerLevel", 2);
        levelPlayer = 2;
        inventoryXP -= 1000;
      } else if (levelPlayer == 2 && inventoryXP >= 2000) {
        prefs.setInt("playerLevel", 3);
        levelPlayer = 3;
        inventoryXP -= 2000;
      } else if (levelPlayer == 3 && inventoryXP >= 3000) {
        prefs.setInt("playerLevel", 4);
        levelPlayer = 4;
        inventoryXP -= 3000;
      } else if (levelPlayer == 4 && inventoryXP >= 4000) {
        prefs.setInt("playerLevel", 5);
        levelPlayer = 5;
        inventoryXP -= 4000;
      }
      PrizeValuesEntity prizeValuesEntity = PrizeValuesEntity(
        inventoryMoney: inventoryMoney,
        inventoryBaits: inventoryBaits,
        inventoryXP: inventoryXP,
        lastPrizeValuesUpdateDB: timeStampNow,
      );

      caughtFish = userDoc.docs[0].data()['caughtFish'];

      caughtFish.add(detailsFish + "^^^" + timeStampNow.toString());
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userDoc.docs[0].id)
          .set({
        "caughtFish": caughtFish,
        "prizeValues": prizeValuesEntity.toJson(),
        "level": levelPlayer,
      }, SetOptions(merge: true));
      return const Right(true);
    } catch (e) {
      print("eeeeeeeeeeeeeeeeee=" + e.toString());
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> acceptPriceOfferCollectionFish(
      String emailBuyer,
      String price,
      int fishIndex,
      RemoteDatasource remoteDatasource) async {
    try {
      //what's my uid?
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user?.uid;
      //retreiving my doc @users col
      final myDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();
      //retreiving buyer's doc @users col
      final buyerDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: emailBuyer)
          .get();

      int buyerInventoryMoney =
          buyerDoc.docs[0].data()['prizeValues']['inventoryMoney'];
      if (int.parse(price) > buyerInventoryMoney) {
        return const Right(false);
      }
      /////////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////////
      //changing buyer's inventoryMoney
      buyerInventoryMoney -= int.parse(price);
      //update buyer's inventoryMoney after selling the fish
      PrizeValuesEntity buyerPrizeValuesEntity = PrizeValuesEntity(
          inventoryMoney: buyerInventoryMoney,
          inventoryBaits: buyerDoc.docs[0].data()['prizeValues']
              ['inventoryBaits'],
          inventoryXP: buyerDoc.docs[0].data()['prizeValues']['inventoryXP'],
          lastPrizeValuesUpdateDB: buyerDoc.docs[0].data()['prizeValues']
              ['lastPrizeValuesUpdateDB']);
      //update my inventoryMoney after selling the fish
      int myInventoryMoney =
          myDoc.docs[0].data()['prizeValues']['inventoryMoney'];
      myInventoryMoney += int.parse(price);
      PrizeValuesEntity myPrizeValuesEntity = PrizeValuesEntity(
          inventoryMoney: myInventoryMoney,
          inventoryBaits: myDoc.docs[0].data()['prizeValues']['inventoryBaits'],
          inventoryXP: myDoc.docs[0].data()['prizeValues']['inventoryXP'],
          lastPrizeValuesUpdateDB: myDoc.docs[0].data()['prizeValues']
              ['lastPrizeValuesUpdateDB']);
      //////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////
      //transferring the sold fish from me to buyer
      //my personalCollection
      List myPersonalCollection = myDoc.docs[0].data()['personalCollection'];
      String soldFish = myPersonalCollection[fishIndex];
      List temp = soldFish.split("^^^");
      temp[1] = "0";
      temp[6] = "incognito@gmail.com";
      soldFish = temp[0] +
          "^^^" +
          temp[1] +
          "^^^" +
          temp[2] +
          "^^^" +
          temp[3] +
          "^^^" +
          temp[4] +
          "^^^" +
          temp[5] +
          "^^^" +
          temp[6];
      myPersonalCollection.removeAt(fishIndex);
      //buyer's personalCollection
      List buyerPersonalCollection =
          buyerDoc.docs[0].data()['personalCollection'];
      buyerPersonalCollection.add(soldFish);

      //////////////////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////////////
      FirebaseFirestore.instance
          .collection('users')
          .doc(buyerDoc.docs[0].id)
          .update({
        "prizeValues": buyerPrizeValuesEntity.toJson(),
        "personalCollection": buyerPersonalCollection
      });
      //update me @DB
      FirebaseFirestore.instance
          .collection('users')
          .doc(myDoc.docs[0].id)
          .update({
        "prizeValues": myPrizeValuesEntity.toJson(),
        "personalCollection": myPersonalCollection
      });
      return const Right(true);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  void changeShowCollection(
    String show,
  ) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user?.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();
      FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.docs[0].id)
          .update({
        "showPersonalCollection": show == "Show" ? true : false,
      });
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeee datasource changeShowCollection=" +
          e.toString());
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
      ////////////////////////////////////////////////////////////////////////
      //updating #baits on DB

      int inventoryBaits = prefs.getInt("inventoryBaits") ?? 0;
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user?.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();
      FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.docs[0].id)
          .update({
        "prizeValues.inventoryBaits": inventoryBaits,
      });
      ////////////////////////////////////////////////////////////////////////
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

  Future<Either<Failure, bool>> joinMultiplayerGame() async {
    try {
      bool playerAddedToGroup = false;
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      String displayName = user!.displayName ?? "";
      if (displayName.isEmpty) {
        displayName = DateTime.now().millisecondsSinceEpoch.toString();
      }
      final groupsDB =
          await FirebaseFirestore.instance.collection("groups").get();
      List<QueryDocumentSnapshot> docs = groupsDB.docs;
      //going over groups
      for (int a = 0; a < docs.length; a++) {
        int numberPlayers = docs[a]['numberPlayers'];
        String groupName = docs[a]['groupName'];
        //if this groups has place for additional players
        if (numberPlayers < 10 &&
            playerAddedToGroup == false &&
            groupName.contains("multiple")) {
          //add me to this group
          addUserToGroup(groupName, displayName);
          playerAddedToGroup = true;
        }
      }
      //if player can't be added to an existing group
      if (playerAddedToGroup == false) {
        createNewGroup("multiple_" + displayName, displayName);
      }
      return const Right(true);
    } catch (e) {
      print("eeeeeeeeeeeeeee usecase joinMultiplayerGame=" + e.toString());
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> quitMultiplayerGame(
      {required RemoteDatasource remoteDatasource}) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      String displayName = user!.displayName ?? "";
      if (displayName.isEmpty) {
        displayName = DateTime.now().millisecondsSinceEpoch.toString();
      }
      final groupsDB =
          await FirebaseFirestore.instance.collection("groups").get();
      List<QueryDocumentSnapshot> docs = groupsDB.docs;
      //going over groups
      for (int a = 0; a < docs.length; a++) {
        List players = docs[a]['players'];
        String groupName = docs[a]['groupName'];

        //going over players un group
        for (int b = 0; b < players.length; b++) {
          String playerName = players[b]['playerName'].toString();
          //if we find player's name in a group, remove
          if (playerName == displayName) {
            removePlayerFromGroup(groupName, playerName);
          }
        }
      }
      return const Right(true);
    } catch (e) {
      print("eeeeeeeeeeeeeee usecase quitMultiplayerGame=" + e.toString());
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, MultipleplayerModel>> getUpdateMultiplayerGame(
      {required RemoteDatasource remoteDatasource}) async {
    List playersInGroup = [];
    int creationTime = 0;
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      String displayName = user!.displayName ?? "";
      if (displayName.isEmpty) {
        displayName = DateTime.now().millisecondsSinceEpoch.toString();
      }
      final groupsDB =
          await FirebaseFirestore.instance.collection("groups").get();
      List<QueryDocumentSnapshot> docs = groupsDB.docs;

      //going over groups
      for (int a = 0; a < docs.length; a++) {
        List players = docs[a]['players'];
        String groupName = docs[a]['groupName'];
        creationTime = docs[a]['creationTime'];

        //going over players un group
        for (int b = 0; b < players.length; b++) {
          String playerName = players[b]['playerName'].toString();
          //if we find player's name in a group, add all players of this group to a List
          if (playerName == displayName) {
            for (int c = 0; c < players.length; c++) {
              playersInGroup.add(players[c]['playerName']);
            }
          }
        }
      }

      //we calculate how many seconds we have till gamse starts
      int timeTillStartGame = pendingTimeBeforeStartMultiplePlayerGame -
          (DateTime.now().millisecondsSinceEpoch - creationTime);

      MultipleplayerModel multipleplayerModel = MultipleplayerModel(
          timeTillStartGame: timeTillStartGame, playersInGroup: playersInGroup);

      return Right(multipleplayerModel);
    } catch (e) {
      print(
          "eeeeeeeeeeeeeeeee usecase getUpdateMyltiplayerGame=" + e.toString());
      return Left(GeneralFailure());
    }
  }
}
