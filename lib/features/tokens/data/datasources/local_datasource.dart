import 'package:shared_preferences/shared_preferences.dart';

class LocalDatasource {
  late SharedPreferences _prefs;
  buyTokens() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      String prodID = _prefs.getString(
            "prodID",
          ) ??
          "";

      int inventoryMoney = _prefs.getInt(
            "inventoryMoney",
          ) ??
          0;
      int inventoryBaits = _prefs.getInt(
            "inventoryBaits",
          ) ??
          0;
      int inventoryXP = _prefs.getInt(
            "inventoryXP",
          ) ??
          0;
      if (prodID.contains("product1")) {
        inventoryMoney = inventoryMoney + 10;
      } else if (prodID.contains("product2")) {
        inventoryBaits = inventoryBaits + 10;
      } else if (prodID.contains("product3")) {
        inventoryXP = inventoryXP + 10;
      }
      print("vvvvvvvvvvvvvvvvv=" +
          inventoryMoney.toString() +
          " " +
          inventoryBaits.toString() +
          " " +
          inventoryXP.toString());
      int lastPrizeValuesUpdateDB = DateTime.now().millisecondsSinceEpoch;
      _prefs.setInt("inventoryMoney", inventoryMoney);
      _prefs.setInt("inventoryBaits", inventoryBaits);
      _prefs.setInt("inventoryXP", inventoryXP);
      _prefs.setInt("lastPrizeValuesUpdateDB", lastPrizeValuesUpdateDB);
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeee=" + e.toString());
    }
  }
}
