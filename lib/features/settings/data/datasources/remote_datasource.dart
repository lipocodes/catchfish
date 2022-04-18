import 'package:catchfish/features/settings/data/models/inventory_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteDataSources {
  /*Future<InventoryModel?>*/ getInventoryDB(String email) async {
    try {
      var r = await FirebaseFirestore.instance
          .collection("users")
          .where('email', isEqualTo: email)
          .get();
      List temp = r.docs[0]['inventory'];
      List<String> listInventory = [];
      for (int a = 0; a < temp.length; a++) {
        listInventory.add(temp[a].toString());
      }

      InventoryModel inventoryModel =
          InventoryModel(listInventory: listInventory);
      return inventoryModel;
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeee=" + e.toString());
    }
  }
}
