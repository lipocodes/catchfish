import 'package:catchfish/features/tokens/presentation/blocs/bloc/tokens_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      if (prodID.contains("product4")) {
        inventoryMoney = inventoryMoney + 10;
      } else if (prodID.contains("product5")) {
        inventoryBaits = inventoryBaits + 10;
      } else if (prodID.contains("product6")) {
        inventoryXP = inventoryXP + 10;
      }
      int lastPrizeValuesUpdateDB = DateTime.now().millisecondsSinceEpoch;
      _prefs.setInt("inventoryMoney", inventoryMoney);
      _prefs.setInt("inventoryBaits", inventoryBaits);
      _prefs.setInt("inventoryXP", inventoryXP);
      _prefs.setInt("lastPrizeValuesUpdateDB", lastPrizeValuesUpdateDB);
      final GlobalKey<NavigatorState> navigatorKey =
          GlobalKey<NavigatorState>();
      BuildContext? context = navigatorKey.currentContext;
      if (context != null) {
        BlocProvider.of<TokensBloc>(context).add(UpdatePrizeListEvent(
            inventoryMoney: inventoryMoney,
            inventoryBaits: inventoryBaits,
            inventoryXP: inventoryXP));
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeee=" + e.toString());
    }
  }
}
