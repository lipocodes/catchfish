import 'package:catchfish/features/fishingShop/data/models/retreive_prize_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyItemWithMoneyPrizeRemoteDatasource {
  Future<RetreivePrizeModel> buyItem(
      String id, String image, String title, int price) async {
    bool itemExistsListInventory = false;
    BuyItemWithMoneyPrizeLocalDatasource buyItemWithMoneyPrizeLocalDatasource =
        BuyItemWithMoneyPrizeLocalDatasource();
    int inventoryMoney =
        await buyItemWithMoneyPrizeLocalDatasource.retreiveMoneyPref();
    int inventoryBaits =
        await buyItemWithMoneyPrizeLocalDatasource.retreiveBaitsPref();
    int inventoryXP =
        await buyItemWithMoneyPrizeLocalDatasource.retreiveXPPref();
    List<String> listInventory =
        await buyItemWithMoneyPrizeLocalDatasource.retreiveInventoryPref();

    for (int a = 0; a < listInventory.length; a++) {
      String temp = listInventory[a];
      List<String> list = temp.split("^^^");
      if (list[0] == id) {
        int num = int.parse(list[3]);
        num++;
        temp = list[0] +
            "^^^" +
            list[1] +
            "^^^" +
            list[2] +
            "^^^" +
            num.toString();
        listInventory[a] = temp;
        itemExistsListInventory = true;
      }
    }
    //if item is new to  user's inventory
    if (itemExistsListInventory == false) {
      String temp = id + "^^^" + image + "^^^" + title + "^^^" + "1";
      listInventory.add(temp);
    }

    //deduce the item cost from inventoryMoney
    inventoryMoney -= price;
    await buyItemWithMoneyPrizeLocalDatasource.updatePrefs(
        inventoryMoney, inventoryBaits, inventoryXP, listInventory);

    RetreivePrizeModel retreivePrizeEntity = RetreivePrizeModel(
        inventoryMoney: inventoryMoney,
        inventoryBaits: inventoryBaits,
        inventoryXP: inventoryXP,
        lastPrizeValuesUpdateDB: DateTime.now().millisecondsSinceEpoch);
    return retreivePrizeEntity;
  }
}

class BuyItemWithMoneyPrizeLocalDatasource {
  Future<int> retreiveMoneyPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int inventoryMoney = prefs.getInt("inventoryMoney") ?? 0;
    return inventoryMoney;
  }

  Future<int> retreiveBaitsPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int inventoryBaits = prefs.getInt("inventoryBaits") ?? 0;
    return inventoryBaits;
  }

  Future<int> retreiveXPPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int inventoryXP = prefs.getInt("inventoryXP") ?? 0;
    return inventoryXP;
  }

  Future<int> retreiveLastUpdatePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int inventoryLastUpdate = prefs.getInt("lastPrizeValuesUpdateDB") ?? 0;
    return inventoryLastUpdate;
  }

  Future<List<String>> retreiveInventoryPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listInventory = prefs.getStringList("inventory") ?? [];
    return listInventory;
  }

  updatePrefs(int inventoryMoney, int inventoryBaits, int inventoryXP,
      List<String> listInventory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("inventoryMoney", inventoryMoney);
    await prefs.setInt("inventoryBaits", inventoryBaits);
    await prefs.setInt("inventoryXP", inventoryXP);
    await prefs.setInt(
        "lastPrizeValuesUpdatePrefs", DateTime.now().millisecondsSinceEpoch);
    await prefs.setStringList("inventory", listInventory);
  }
}
