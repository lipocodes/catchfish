import 'package:catchfish/features/fishingShop/domain/entities/retreive_prize_entity.dart';

class RetreivePrizeUsecase {
  Future<RetreivePrizeEntity> getPrize() async {
    RetreivePrizeEntity retreivePrizeEntity = RetreivePrizeEntity(
        inventoryMoney: 10, inventoryBaits: 5, inventoryXP: 3);

    return retreivePrizeEntity;
  }
}
