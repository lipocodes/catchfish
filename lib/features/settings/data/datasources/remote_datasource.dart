import 'package:catchfish/features/settings/data/models/inventory_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteDataSources {
  getInventoryDB(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastInventoryUpdateDB = 0;
    try {
      var r = await FirebaseFirestore.instance
          .collection("users")
          .where('email', isEqualTo: email)
          .get();
      List temp = r.docs[0]['inventory'];

      lastInventoryUpdateDB = r.docs[0]['lastInventoryUpdateDB'];
      List<String> listInventory = [];
      for (int a = 0; a < temp.length; a++) {
        listInventory.add(temp[a].toString());
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int lastInventoryUpdatePrefs = prefs.getInt(
            "lastInventoryUpdateDB",
          ) ??
          0;

      if (lastInventoryUpdateDB > lastInventoryUpdatePrefs) {
        LocalDataSources localDataSources = LocalDataSources();
        await localDataSources.updatePrefs(
            lastInventoryUpdateDB, listInventory);
      }
      //if prefs data inventory is newer than DB inventory data
      else if (lastInventoryUpdateDB < lastInventoryUpdatePrefs) {
        List<String> inventory = prefs.getStringList("inventory") ?? [];
        var t = await FirebaseFirestore.instance
            .collection("users")
            .where('email', isEqualTo: email)
            .get();
        String id = t.docs[0].id;
        await FirebaseFirestore.instance.collection('users').doc(id).update({
          'inventory': inventory,
          'lastInventoryUpdateDB': lastInventoryUpdatePrefs,
        });
      }

      InventoryModel inventoryModel =
          InventoryModel(listInventory: listInventory);
      return inventoryModel;
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeee=" + e.toString());
    }
  }
}

class LocalDataSources {
  updatePrefs(int lastInventoryUpdateDB, List<String> listInventory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("lastInventoryUpdateDB", lastInventoryUpdateDB);
    prefs.setStringList("inventory", listInventory);
  }
}
