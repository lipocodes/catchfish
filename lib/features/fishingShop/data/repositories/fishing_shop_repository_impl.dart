import 'package:catchfish/features/fishingShop/data/datasources/retreive_prize_remote_datasource.dart';
import 'package:catchfish/features/fishingShop/data/datasources/retreive_shop_items_remote_datasource.dart';
import 'package:catchfish/features/fishingShop/data/models/retreive_prize_model.dart';
import 'package:catchfish/features/fishingShop/data/models/retreive_shop_items_models.dart';
import 'package:catchfish/features/fishingShop/domain/entities/retreive_prize_entity.dart';
import 'package:catchfish/features/fishingShop/domain/entities/retreive_shop_items_entity.dart';
import 'package:catchfish/features/fishingShop/domain/repositories/fishing_shop_repository.dart';

class FishingShopRepositoryImpl implements FishingShopRepository {
  @override
  Future<RetreivePrizeModel> getPrize(String email) async {
    RetreivePrizeRemoteDatasource retreivePrizeRemoteDatasource =
        RetreivePrizeRemoteDatasource();
    return await retreivePrizeRemoteDatasource.getPrize(email);
  }

  @override
  Future<List<RetreiveShopItemsEntity>> getItems() async {
    RetreiveShopItemsRemoteDatasource retreiveShopItemsRemoteDatasource =
        RetreiveShopItemsRemoteDatasource();
    List<RetreiveShopItemsModels> listItems2 =
        await retreiveShopItemsRemoteDatasource.getItems();
    List<RetreiveShopItemsEntity> listItems1 = listItems2;
    return listItems1;
  }
}
