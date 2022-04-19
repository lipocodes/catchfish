import 'package:catchfish/features/fishingShop/domain/entities/retreive_prize_entity.dart';

class RetreivePrizeModel extends RetreivePrizeEntity {
  RetreivePrizeModel(
      {required int inventoryMoney,
      required int inventoryBaits,
      required int inventoryXP,
      required int lastPrizeValuesUpdateDB})
      : super(
            inventoryMoney: inventoryMoney,
            inventoryBaits: inventoryBaits,
            inventoryXP: inventoryXP,
            lastPrizeValuesUpdateDB: lastPrizeValuesUpdateDB);
}
