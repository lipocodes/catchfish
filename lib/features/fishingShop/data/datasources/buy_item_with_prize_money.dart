import 'package:catchfish/features/fishingShop/data/models/retreive_prize_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyItemWithMoneyPrizeRemoteDatasource {
  Future<RetreivePrizeModel> buyItem(
      String id, String image, String title, double price) async {
    BuyItemWithMoneyPrizeLocalDatasource buyItemWithMoneyPrizeLocalDatasource =
        BuyItemWithMoneyPrizeLocalDatasource();
    int inventoryMoney =
        await buyItemWithMoneyPrizeLocalDatasource.retreiveMoneyPref();
    int inventoryBaits =
        await buyItemWithMoneyPrizeLocalDatasource.retreiveBaitsPref();
    int inventoryXP =
        await buyItemWithMoneyPrizeLocalDatasource.retreiveXPPref();
    int inventoryLastUpdate =
        await buyItemWithMoneyPrizeLocalDatasource.retreiveLastUpdatePref();
    print("aaaaaaaaaaaaaaaaaaaaaaa=" + inventoryMoney.toString());
    print("bbbbbbbbbbbbbbbbbbbb=" + inventoryBaits.toString());
    print("cccccccccccccccccc=" + inventoryXP.toString());
    print("ddddddddddddddddddd=" + inventoryLastUpdate.toString());

    RetreivePrizeModel retreivePrizeEntity = RetreivePrizeModel(
        inventoryMoney: 200,
        inventoryBaits: 190,
        inventoryXP: 180,
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

  updatePrefs(int inventoryMoney, int inventoryBaits, int inventoryXP) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("inventoryMoney", inventoryMoney);
    await prefs.setInt("inventoryBaits", inventoryBaits);
    await prefs.setInt("inventoryXP", inventoryXP);
    await prefs.setInt(
        "lastPrizeValuesUpdatePrefs", DateTime.now().millisecondsSinceEpoch);
  }
}
