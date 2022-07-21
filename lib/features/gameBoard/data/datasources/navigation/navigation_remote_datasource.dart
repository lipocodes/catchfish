import 'package:catchfish/core/consts/daily_prizes.dart';
import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/lobby/domain/entities/prize_values_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavigationRemoteDatasource {
  Future<Either<GeneralFailure, bool>> givePrizeNavigation() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user?.uid;
      //if user is not logged in, return
      if (uid == null) {
        return const Right(false);
      }
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get();
      //attention: this is a Map
      final prizeValues = userDoc.docs[0].data()['prizeValues'];
      PrizeValuesEntity prizes = PrizeValuesEntity(
          inventoryMoney:
              prizeValues["inventoryMoney"] + prizeForSuccessfulNavigation,
          inventoryBaits: prizeValues["inventoryBaits"],
          inventoryXP: prizeValues["inventoryXP"],
          lastPrizeValuesUpdateDB: 0);
      FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.docs[0].id)
          .update({"prizeValues": prizes.toJson()});

      return (const Right(true));
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
