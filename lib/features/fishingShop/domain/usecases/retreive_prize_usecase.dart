import 'package:catchfish/features/fishingShop/data/models/retreive_prize_model.dart';
import 'package:catchfish/features/fishingShop/data/repositories/fishing_shop_repository_impl.dart';
import 'package:catchfish/features/fishingShop/domain/entities/retreive_prize_entity.dart';

class RetreivePrizeUsecase {
  Future<RetreivePrizeEntity> getPrize(String email) async {
    FishingShopRepositoryImpl fishingShopRepositoryImpl =
        FishingShopRepositoryImpl();
    RetreivePrizeModel retreivePrizeModel =
        await fishingShopRepositoryImpl.getPrize(email);
    RetreivePrizeEntity retreivePrizeEntity = retreivePrizeModel;
    return retreivePrizeEntity;
  }
}
