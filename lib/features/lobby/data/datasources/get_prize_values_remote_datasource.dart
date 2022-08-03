import 'package:catchfish/features/lobby/domain/entities/prize_values_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class GetPrizeValuesRemoteDatasource {
  Future<PrizeValuesEntity> getPrizeValuesDB(String email) async {
    try {
      var t = await FirebaseFirestore.instance
          .collection("users")
          .where('email', isEqualTo: email)
          .get();

      PrizeValuesEntity prizeValuesEntity = PrizeValuesEntity(
          inventoryMoney: t.docs[0].data()['prizeValues']['inventoryMoney'],
          inventoryBaits: t.docs[0].data()['prizeValues']['inventoryBaits'],
          inventoryXP: t.docs[0].data()['prizeValues']['inventoryXP'],
          lastPrizeValuesUpdateDB: t.docs[0].data()['prizeValues']
              ['lastPrizeValuesUpdateDB']);

      return prizeValuesEntity;
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeee remote getPrizeValuesDB=" + e.toString());
      PrizeValuesEntity prizeValuesEntity = PrizeValuesEntity(
          inventoryMoney: 0,
          inventoryBaits: 0,
          inventoryXP: 0,
          lastPrizeValuesUpdateDB: 0);
      return prizeValuesEntity;
    }
  }

  savePrizeValuesDB(String email, PrizeValuesEntity prizeValuesEntity) async {
    try {
      var t = await FirebaseFirestore.instance
          .collection("users")
          .where('email', isEqualTo: email)
          .get();
      String id = t.docs[0].id;

      await FirebaseFirestore.instance.collection('users').doc(id).update({
        'prizeValues': prizeValuesEntity.toJson(),
      });
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeee=" + e.toString());
    }
  }
}
