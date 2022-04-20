import 'package:catchfish/features/fishingShop/data/repositories/fishing_shop_repository_impl.dart';
import 'package:catchfish/features/fishingShop/domain/entities/retreive_shop_items_entity.dart';

class RetreiveShopItemsUsecase {
  Future<List<RetreiveShopItemsEntity>> getItems() async {
    FishingShopRepositoryImpl fishingShopRepositoryImpl =
        FishingShopRepositoryImpl();
    List<RetreiveShopItemsEntity> listItems =
        await fishingShopRepositoryImpl.getItems();
    return listItems;
  }
}
