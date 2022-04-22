import 'package:catchfish/features/fishingShop/data/datasources/buy_item_with_prize_money.dart';
import 'package:catchfish/features/fishingShop/data/models/retreive_prize_model.dart';
import 'package:catchfish/features/fishingShop/domain/entities/retreive_prize_entity.dart';
import 'package:catchfish/features/fishingShop/domain/repositories/buy_item_with_money_prize.dart';

class BuyItemWithPrizeMoneyImpl implements BuyItemWithPrizeMoney {
  Future<RetreivePrizeEntity> buyItemm(
      String id, String image, String title, int price) async {
    BuyItemWithMoneyPrizeRemoteDatasource
        buyItemWithMoneyPrizeRemoteDatasource =
        BuyItemWithMoneyPrizeRemoteDatasource();
    RetreivePrizeModel retreivePrizeModel =
        await buyItemWithMoneyPrizeRemoteDatasource.buyItem(
            id, image, title, price);
    RetreivePrizeEntity retreivePrizeEntity = retreivePrizeModel;
    return retreivePrizeEntity;
  }
}
