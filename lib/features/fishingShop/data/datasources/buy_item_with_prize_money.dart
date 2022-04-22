import 'package:catchfish/features/fishingShop/data/models/retreive_prize_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyItemWithMoneyPrizeRemoteDatasource {
  Future<RetreivePrizeModel> buyItem(
      String id, String image, String title, double price) async {
    //First we update the shared prefs

    RetreivePrizeModel retreivePrizeEntity = RetreivePrizeModel(
        inventoryMoney: 150,
        inventoryBaits: 140,
        inventoryXP: 130,
        lastPrizeValuesUpdateDB: DateTime.now().millisecondsSinceEpoch);
    return retreivePrizeEntity;
  }
}

class BuyItemWithMoneyPrizeLocalDatasource {
  updatePrefs(int inventoryMoney, int inventoryBaits, int inventoryXP) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("inventoryMoney", inventoryMoney);
    await prefs.setInt("inventoryBaits", inventoryBaits);
    await prefs.setInt("inventoryXP", inventoryXP);
    await prefs.setInt(
        "lastPrizeValuesUpdatePrefs", DateTime.now().millisecondsSinceEpoch);
  }
}
