import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/settings/data/models/inventory_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteDataSources {
  Future<InventoryModel> getInventoryDB(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastInventoryUpdateDB = 0;
    try {
      //retreiving  fishingShopcollection  (items for selling) && adding each item to listItemsToSell
      List<String> listItemsToSell = [];
      var q = await FirebaseFirestore.instance.collection("fishingShop").get();
      for (int a = 0; a < q.size; a++) {
        String id = q.docs[a]['id'];
        String image = q.docs[a]['image'];
        int price = q.docs[a]['price'];
        String title = q.docs[a]['title'];
        String subtitle = q.docs[a]['subtitle'];
        String str = id +
            "^^^" +
            image +
            "^^^" +
            price.toString() +
            "^^^" +
            title +
            "^^^" +
            subtitle;
        listItemsToSell.add(str);
      }
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

      InventoryModel inventoryModel = InventoryModel(
          listItemsToSell: listItemsToSell, listInventory: listInventory);
      return inventoryModel;
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeee getInventoryDB()" + e.toString());
      InventoryModel inventoryEntity =
          InventoryModel(listItemsToSell: [], listInventory: []);
      return inventoryEntity;
    }
  }

  Future<Either<Failure, bool>> buyItem(
      String email, int indexItem, int quantity) async {
    try {
      var r = await FirebaseFirestore.instance.collection("fishingShop").get();
      String id = r.docs[indexItem]['id'];
      String image = r.docs[indexItem]['image'];
      String title = r.docs[indexItem]['title'];
      int priceItem = r.docs[indexItem]['price'];
      String purchasedItemDetails =
          id + "^^^" + image + "^^^" + title + "^^^" + priceItem.toString();

      var t = await FirebaseFirestore.instance
          .collection("users")
          .where('email', isEqualTo: email)
          .get();

      int inventoryMoney = t.docs[0]['prizeValues']['inventoryMoney'];
      int inventoryBaits = t.docs[0]['prizeValues']['inventoryBaits'];
      List inventory = t.docs[0]['inventory'];
      inventory.add(purchasedItemDetails);
      //if player is short of money
      if ((priceItem * quantity) > inventoryMoney) {
        return const Right(false);
      } else {
        String id = t.docs[0].id;
        if (title.contains("Bait")) {
          await FirebaseFirestore.instance.collection('users').doc(id).update({
            'prizeValues.inventoryMoney':
                (inventoryMoney - priceItem * quantity),
            'prizeValues.inventoryBaits':
                (inventoryBaits + priceItem * quantity),
            'inventory': inventory,
          });
        }

        return const Right(true);
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeee buyItem()" + e.toString());
      return Left(GeneralFailure());
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
