import 'package:catchfish/features/fishingShop/data/datasources/retreive_prize_remote_datasource.dart';
import 'package:catchfish/features/fishingShop/data/models/retreive_prize_model.dart';
import 'package:catchfish/features/fishingShop/domain/entities/retreive_prize_entity.dart';
import 'package:catchfish/features/fishingShop/domain/repositories/fishing_shop_repository.dart';

class FishingShopRepositoryImpl implements FishingShopRepository {
  @override
  Future<RetreivePrizeModel> getPrize(String email) async {
    RetreivePrizeRemoteDatasource retreivePrizeRemoteDatasource =
        RetreivePrizeRemoteDatasource();
    return await retreivePrizeRemoteDatasource.getPrize(email);
  }
}
