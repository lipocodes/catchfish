import 'package:catchfish/features/fishingShop/domain/entities/retreive_prize_entity.dart';

abstract class BuyItemWithPrizeMoney {
  Future<RetreivePrizeEntity> buyItemm(
      String id, String image, String title, double price);
}
