import 'package:catchfish/features/fishingShop/data/models/retreive_prize_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RetreivePrizeRemoteDatasource {
  Future getPrize(String email) async {
    try {
      var t = await FirebaseFirestore.instance
          .collection("users")
          .where('email', isEqualTo: email)
          .get();

      int inventoryMoney =
          t.docs[0].data()['prizeValues']['inventoryMoney'] ?? 0;
      int inventoryBaits =
          t.docs[0].data()['prizeValues']['inventoryBaits'] ?? 0;
      int inventoryXP = t.docs[0].data()['prizeValues']['inventoryXP'] ?? 0;
      int lastPrizeValuesUpdateDB =
          t.docs[0].data()['prizeValues']['lastPrizeValuesUpdateDB'] ?? 0;

      RetreivePrizeModel retreivePrizeModel = RetreivePrizeModel(
          inventoryMoney: inventoryMoney,
          inventoryBaits: inventoryBaits,
          inventoryXP: inventoryXP,
          lastPrizeValuesUpdateDB: lastPrizeValuesUpdateDB);
      return retreivePrizeModel;
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeee=" + e.toString());
    }
  }
}
