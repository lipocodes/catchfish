import 'package:catchfish/features/settings/data/repositories/inventory_repository_impl.dart';
import 'package:catchfish/features/settings/domain/entities/inventory_entity.dart';
import 'package:catchfish/features/settings/domain/entities/inventory_screen_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventoryUsecases {
  List<String> ids = [];
  List<String> images = [];
  List<String> items = [];
  List<int> quantities = [];
  late SharedPreferences prefs;

  List localListInventory = [];
  Future<InventoryScreenEntity> getInventoryDB(String email) async {
    ids = [];
    images = [];
    items = [];
    quantities = [];
    InventoryRepositoryImpl inventoryRepositoryImpl = InventoryRepositoryImpl();
    ///////////////////////////////////////////////////////////////////////////
    //if user not logged in
    prefs = await SharedPreferences.getInstance();
    localListInventory = prefs.getStringList("inventory") ?? [];

    final FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      print("aaaaaaaaaaaaaaaaaaa");
      //going over items saved on prefs, looking for items existing only on prefs
      for (int a = 0; a < localListInventory.length; a++) {
        String t = localListInventory[a];
        List<String> l = t.split("^^^");
        ids.add(l[0]);
        images.add(l[1]);
        items.add(l[2]);
        quantities.add(int.parse(l[3]));
      }
    }
    //if user is logged in
    else {
      print("bbbbbbbbbbbbbbbbbbbb");
      InventoryEntity inventoryEntity =
          await inventoryRepositoryImpl.getInventoryDB(email);
      //going over inventory items saved on DB
      for (int a = 0; a < inventoryEntity.listInventory.length; a++) {
        bool isItemFoundOnPref = false;
        String temp = inventoryEntity.listInventory[a];
        List<String> list = temp.split("^^^");
        String idItem = list[0];
        String image = list[1];
        String item = list[2];
        int quantity = int.parse(list[3]);
        //going over inventory saved on prefs to check if this item is there also
        List<String> l = [];
        for (int b = 0; b < localListInventory.length; b++) {
          String temp = localListInventory[b];
          l = temp.split("^^^");
          if (l[0] == idItem) {
            isItemFoundOnPref = true;
            break;
          }
        }
        if (isItemFoundOnPref) {
          ids.add(l[0]);
          images.add(l[1]);
          items.add(l[2]);
          quantities.add(int.parse(l[3]));
        } else {
          //if this item is not found anywhere in prefs
          ids.add(list[0]);
          images.add(image);
          items.add(item);
          quantities.add(quantity);
        }

        //going over items saved on prefs, looking for items existing only on prefs
        for (int a = 0; a < localListInventory.length; a++) {
          String t = localListInventory[a];
          List<String> l = t.split("^^^");
          if (!ids.contains(l[0])) {
            ids.add(l[0]);
            images.add(l[1]);
            items.add(l[2]);
            quantities.add(int.parse(l[3]));
          }
        }
      }
    }

///////////////////////////////////////////////////////////////////////////////
    return InventoryScreenEntity(
        ids: ids, images: images, items: items, quantities: quantities);
  }
}
