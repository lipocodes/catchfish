import 'package:catchfish/features/fishingShop/domain/entities/retreive_prize_entity.dart';

abstract class FishingShopRepository {
  Future<RetreivePrizeEntity> getPrize(String email);
}
